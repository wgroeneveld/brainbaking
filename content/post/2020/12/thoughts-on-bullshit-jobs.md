---
title: "Thoughts on Bullshit Jobs"
date: '2020-12-20'
subtitle: "Remarks on David Graeber's 2013 Work Rant"
tags:
  - jobs
  - academia
categories:
  - braindump
---

In 2013, David Graeber, a professor of Anthropology, published an essay on the phenomenon of Bullshit Jobs in [Strike! Magazine](https://www.strike.coop/bullshit-jobs/). This work was further expanded in his 2018 book [Bullshit Jobs: A Theory](https://www.goodreads.com/book/show/34466958-bullshit-jobs). I've read the latter, but highly recommend everyone to read the former instead, as it much more concisely summarizes the essence. 

### Defining a bullshit job

What's a bullshit job, you ask? I'm pretty sure everybody instinctively knows what a bullshit job entails, but just to be clear, David provides a working definition: _a bullshit job is a form of paid employment that is so completely pointless, unnecessary, or pernicious that even the employee cannot justify its existence even though, as part of the conditions of employment, the employee feels obliged to pretend that is not the case_. Since then, it has been expanded by others to also include, among others, a [monetary theory](https://austingmackell.medium.com/explaining-bullshit-jobs-with-monetary-theory-11be9bb99d35).

> A bullshit job is paid employment that is so completely pointless that even the employee cannot justify its existence.

You know, the sort of very useful governmental paper pushing that is required when registering a travel passport, making a complaint, or trying to convince your bank employee that no, you're not going to take that extra insurance. There are obvious examples, but as I read the book, and as David also admitted, very large portions of virtually _any job_ contain bullshit parts. And bullshit percentages are increasing at an alarming rate. 

There's also a theory on why society does not object to bullshit jobs. According to Graeber, social value and pay are inversely correlated: hospital cleaners and garbage collectors contribute to our social structure, but barely get paid anything, while corporate lawyers effectively hurt our social culture, and get a paid royal amount for doing so. There seem to be papers on the discussion of jobs and their (perceived?) social value, of which a few are referenced in the book. 

<script type='text/javascript' src='/js/amcharts4core.js'></script>
<script type='text/javascript' src='/js/amcharts4charts.js'></script>
<script type='text/javascript' src='/js/amcharts4animated.js'></script>

This is a summary of the social value breakdown, found in a 2017 study, categorized by jobs ([Taxation and the Allocation of Talent](https://www.journals.uchicago.edu/doi/abs/10.1086/693393?casa_token=46Fn4qTkh1cAAAAA:aR3HQynt1SCG2WjPx1eh2GSkxaciKEmGYgIrmB9te230mEyN2MCBGzpjzBLseSGfmRKPMQUl4ow) by Lockwoot et al.):

<div id="jobdiv" style="width: 100%; height: 500px"></div>

<script>
am4core.ready(function() {

am4core.useTheme(am4themes_animated);

function createChart(divid, data) {
    var chart = am4core.create(divid, am4charts.XYChart);
    chart.data = data;

    chart.padding(40, 40, 40, 40);

    var categoryAxis = chart.yAxes.push(new am4charts.CategoryAxis());
    categoryAxis.renderer.grid.template.location = 0;
    categoryAxis.dataFields.category = "config";
    categoryAxis.renderer.inversed = true;
    categoryAxis.renderer.grid.template.disabled = true;
    //categoryAxis.renderer.minGridDistance = 100;
    categoryAxis.renderer.minWidth = 120;

    var valueAxis = chart.xAxes.push(new am4charts.ValueAxis());
    //valueAxis.min = 0;

    var series = chart.series.push(new am4charts.ColumnSeries());
    series.dataFields.categoryY = "config";
    series.dataFields.valueX = "val";
    series.tooltipText = "{valueX.value}"
    series.columns.template.strokeOpacity = 0;
    series.columns.template.column.cornerRadiusBottomRight = 5;
    series.columns.template.column.cornerRadiusTopRight = 5;

    var labelBullet = series.bullets.push(new am4charts.LabelBullet())
    labelBullet.label.horizontalCenter = "left";
    labelBullet.fontSize = 20;
    labelBullet.label.dx = 5;
    labelBullet.label.fill = am4core.color("white");
    labelBullet.label.text = "{values.valueX.workingValue}";
    labelBullet.locationX = 1;

    categoryAxis.sortBySeries = series;

    var columnTemplate = series.columns.template;
    columnTemplate.adapter.add("fill", function(fill, target) {
      return am4core.color("#018660")
    })
}

createChart("jobdiv", [{
      "config": "researchers",
      "val": 9
    }, {
      "config": "schoolteachers",
      "val": 1
    }, {
      "config": "engineers",
      "val": 0.2
    }, {
      "config": "consultants, IT professionals",
      "val": 0
    }, {
      "config": "lawyers",
      "val": -0.2
    }, {
      "config": "advertisers, marketing",
      "val": -0.3
    }, {
      "config": "managers",
      "val": -0.8
    }, {
      "config": "financial sector",
      "val": -1.5
    }]
    );

}); // end am4core.ready()
</script>

### Bullshit in the software engineering industry

In my [a decade in the industry](/post/2018/10/a-decade-in-the-industry/) post, I reflect on ten years as an agile software developer working for various privately held companies. After reading bullshit jobs, a lot of _'shit'_ I've done there can be easily categorized as bullshit:

- Meetings: standups, sprint plannings, retrospectives, ...
- A favorite of mine: filling in timesheets
- ...

Let's be honest. A lot of 'Scrum Best Practices' are totally bullshit. We never adhered to the indicated planning. We never did anything else in retros except complain. Every standup goes like this: "I did x yesterday. Today same". Although admittedly, it is not the practice but the person and the company who is to blame. Still, we're not finished, the worst is yet to come:

- Implement features that are never used;
- Fix bugs that someone else breaks the same day;
- Work on something for months that you know will be canceled. Receive an e-mail that confirms it's trashed;
- Writing business reports that are never read;
- ...

A social value of `0`, according to the above graph, is in my opinion dependent on what kind of software you're creating. In general, being a software developer for a large company does not necessarily entail virtuous behavior, nor does it mean finding meaning. So I quit and joined the academic world to teach undergraduates how to do a bullshit job.

### Bullshit in computing academia

Now that I'm an academic, I'm not particularly better off. In fact, if I look around and see what professors are doing and what David talks about, it's a lot worse. Like I [previously wrote](/post/2020/02/agile-academia), e-mail is the main communication channel now, and a lot of _bullshit mail_ prevents me from actually doing what I'm supposed to be doing. Luckily, as a PhD researcher, most of the bullshit is off-loaded to the professors:

- Meetings, meetings more meetings: at faculty, department, campus, ... level;
- Writing 20-page long documents to hopefully get a grant, knowing you won't;
- Various hideous administrative tasks;
- ...

> These _'strategic vision documents'_ aren't going to write themselves, you know!

The supply and demand of administrative services has risen up to `+240%` between 1985 and 2005 (p. 161), meaning both industry and academia are heavily burdened by paper pushing. These _'strategic vision documents'_ aren't going to write themselves, you know! David admits that his tenure as a professor in reality entails that about `50%` of his job is total and utter bullshit (p. 263). That is not something to look forward to.

The question is, is a professor a schoolteacher (social value `+1`), a researcher (social value `+9`), or a manager (`-0.8`)? Furthermore, I've read a lot of published research that can be safely called bullshit. Simply reducing a job or even entire sector to a financial number to see if it adds or subtracts from the economy overall seems to be bullshit too.

### Coping with bullshit jobs 

The book contains hilarious statements from various people who invented ways to do whatever they want, without raising suspicion. In a bullshit job, it is important to act like you're busy, when in fact, you're not. Or you might be busy, but doing meaningless stuff instead of what _should_ be be keeping you busy. 

- There's a guy who installed [Lynx](http://lynx.browser.org), the command-line browser. This makes him look like an expert scripting away at a terminal, when in fact he's editing Wikipedia articles all day;
- Someone managed to squeeze his work into one day a week. The rest of the week, he's 'working from home' - meaning learning quantum physics;
- Spending an unusual amount of time in the bathroom;
- ...

It is both funny and painful to read. The question on why we put up with 'managerial feudalism', as David calls it, still remains. For instance, why would David himself (or myself?) not quit his academic position and focus on writing books and essays instead? There, a lot of bullshit dropped in an instant. I guess status still plays a big role that is all too briefly mentioned in the book. I do not believe that researchers in general provide more to society than IT consultants. I could write software that helps elderly people accessing multimedia. Or I could write a meaningless paper about the non-existence of vampires (yes, it has been done). Which one would you call bullshit?

I'm unsure on what to do with this information. Although not exactly new to me, it is still saddening to see the breadth and depth of bullshit jobs in our society. Maybe we should start asking ourselves if we are willing to put up with this? Life's too short, cut the crap! Find a way to disconnect 'work' from 'revenue' and try to free yourself to pursue more worthwhile things. 

Such as baking bread, for instance.
