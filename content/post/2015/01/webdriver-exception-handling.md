---
title: Webdriver Exception Handling
date: '2015-01-14'
subtitle: What should you do when something goes wrong with your scenario tests
aliases:
    - /post/webdriver-exception-handling/
bigimg: /img/Webdriver Exception Handling.jpg
tags: [ 'unit testing', 'CSharp', 'webdriver', 'scenario testing' ]
---

As the previous post indicated, we're trying to stabilize our scenario tests created with WebDriver. One of the things we did was trying to capture as much data as possible if something goes wrong. Something like a typical `ElementNotFoundException`, or the less common `StaleElementException` (detached from DOM after evaluation) - these things can be hard to trace if you don't run the tests locally. We also stumbled upon the "it works on my machine" problem - tests succeeding on one development machine but not on the other - mostly related due to timing issues.

So, what should you do when something goes wrong? 

- capture what happened! (screenshot)
- capture what happened! (exception stacktrace logging)
- capture what happened! (serverside logging)

WebDriver has a `GetScreenshot()` method you can use to dump an image to a file on exception. We used a bit of pointcut magic using PostSharp to automagically handle every exception without manually having to write each `try { }` clause.

        WebDriver().GetScreenshot().SaveAsFile(fileName + ".png", ImageFormat.Png);

After saving the image, we also capture the exception and some extra serverside logging:

            File.WriteAllText(fileName + ".txt",
                "-- Resolved URL: " + ScenarioFixture.Instance.ResolveHostAndPort() + Environment.NewLine +
                "-- Actual URL: " + ScenarioFixture.Instance.Driver.Url + Environment.NewLine +
                "-- Exception Message: " + ex.Message + Environment.NewLine +
                "-- Stacktrace: " + Environment.NewLine + ex.StackTrace + Environment.NewLine + Environment.NewLine +
                "-- Service log: " + Environment.NewLine + ReadServiceLogFromDeployedApp());

Because the webservice is deployed somewhere else (scenario tests run againsst the nightly build IIS webserver), we need to access the logfiles using a ´GET´ call, done with RestSharp:

        private static string ReadServiceLogFromDeployedApp()
        {
            var restClient = new RestClient(ScenarioFixture.Instance.ResolveHostAndPort());
            var restRequest = new RestRequest("log/servicelog.txt");
            restRequest.AddHeader("Content-Type", "text/plain");
            restRequest.AddHeader("Accept", "text/plain");
            var response = restClient.Execute(restRequest);
            return response.Content;
        }

Now, to easily access those files (the screenshot and the written log for each failing test), we wrap the exception in another exception containing a direct link to both files. That enables every developer to simply browse to the failing test on our CI env (teamcity) and simply click on the link! 

To be able to do that, combined with the pointcut, implement the `OnException()` hook and call the above code:

    [Serializable]
    [ScenarioExceptionAspect(AttributeExclude = true)]
    public class ScenarioExceptionAspect : OnMethodBoundaryAspect
    {
        public override void OnException(MethodExecutionArgs args)
        {
            var exceptionFileName = Directory.GetCurrentDirectory() + @"/" + WebDriverExceptionHandler.Handle(args.Exception);

            exceptionFileName = exceptionFileName.Replace(@"C:", @"file://teamcity/c$");
            exceptionFileName = exceptionFileName.Replace(@"\", @"/");

            throw new Exception("Scenario test failed"
                + Environment.NewLine
                + " -- Screenshot: " + exceptionFileName + ".png"
                + Environment.NewLine
                + " -- Log: " + exceptionFileName + ".txt", args.Exception);
        }
    }

This introduces one more problem: what if you want to trigger an exception, something like `ExpectedException(typeof(InvalidArgumentException))`? We'll still end up in our aspect and we'll take a screenshot and dump everything. We fixed this by taking a peek at the live stacktrace. I know it's far from ideal, but it serves it's purpose and works pretty well for the moment. 

        private static bool ExpectedSomeException(StackTrace trace)
        {
            const int arbitraryMaxDepthToLookForAttribs = 5;
            for (var stackElements = 1; stackElements <= arbitraryMaxDepthToLookForAttribs; stackElements++)
            {
                if (AnyExpectedExceptionInAttribute(trace, stackElements))
                {
                    return true;
                }
            }
            return false;
        }
        private static bool AnyExpectedExceptionInAttribute(StackTrace trace, int stackElements)
        {
            var callingMethod = trace.GetFrame(stackElements).GetMethod();
            var anyExpectedExceptionAttrib = callingMethod.GetCustomAttributes(typeof(ExpectedExceptionAttribute), true).Any();
            return anyExpectedExceptionAttrib;
        }


Every instance of a new `StackTrace` element will contain all stack data from that point on, so create one in the onException method, otherwise remember to look "deeper" or further into the stack itself. Yes we could solve that using recursion instead of with an arbitrary number of elements inside a for loop, but we were trying to solve something else and this stood in the way so naturally the reaction was to not invest too much time.

What's the outcome? This:

> Test(s) failed. System.Exception : Scenario test failed
> -- Screenshot: file://teamcity/c$/buildagents/buildAgentOne/work/10dbfc9caad025f8/Proj/ScenarioTests/bin/Debug/ex-15-01-14-15-56-02.png
> -- Log: file://teamcity/c$/buildagents/buildAgentOne/work/10dbfc9caad025f8/Proj/ScenarioTests/bin/Debug/ex-15-01-14-15-56-02.txt
>  ----> System.Exception : Root menu could not be opened after 10 tries?
>   at Proj.ScenarioTests.ScenarioExceptionAspect.OnException(MethodExecutionArgs args) in c:\buildagents\buildAgentOne\work\10dbfc9caad025f8\Proj\Proj.ScenarioTests\ScenarioExceptionAttributeHandler.cs:line 36
> ...
