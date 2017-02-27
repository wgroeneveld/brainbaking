+++
title = "tfs"
draft = false
tags = [
    "code",
    "csharp",
    "tfs"
]
date = "2013-07-26"
+++
# Tfs communicator 

#### TFS informatie vanuit .NET uitlezen 

[OData TFS v2](http://blogs.msdn.com/b/briankel/archive/2013/01/07/odata-service-for-team-foundation-server-v2.aspx) is een tussenlaag `REST API` die je zelf nog op `IIS` kan deployen...

Onderstaande code doet hetzelfde (veel eenvoudiger) in een console appke

```csharp
using System;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using Microsoft.TeamFoundation.Build.Client;
using Microsoft.TeamFoundation.Client;

namespace TfsCommunicator
{
    [ExcludeFromCodeCoverage]
    public class BuildCommunicator : IBuildCommunicator
    {
        private string tfsServerAddress;

        public BuildCommunicator(string tfsServerAddress)
        {
            this.tfsServerAddress = tfsServerAddress;
        }

        public BuildStatus GetBuildInformation(int maxDays ###### 5, int maxRuns  10, string teamProject ###### "*", string buildDefinition  "")
        {
            var buildStatus = new BuildStatus();

            var builds = GetBuildsFromTfs(maxDays, teamProject, buildDefinition);

            var currentDefinition = string.Empty;

            foreach (var build in builds)
            {
                string definitionName = build.BuildDefinition.Name;
                var project = MapBuildToProject(build, definitionName);

                if (definitionName ###### currentDefinition)
                {
                    AddBuiltToParentProject(buildStatus, definitionName, project, maxRuns);
                }
                else
                {
                    currentDefinition = definitionName;
                    buildStatus.Projects.Add(project);
                }
            }
            return buildStatus;
        }

        private IOrderedEnumerable<IBuildDetail> GetBuildsFromTfs(int maxDays, string teamProject, string buildDefinition)
        {
            var tfs = TfsTeamProjectCollectionFactory.GetTeamProjectCollection(new Uri(tfsServerAddress));
            IBuildServer buildServer = tfs.GetService<IBuildServer>();

            IBuildDetailSpec spec = string.IsNullOrEmpty(buildDefinition) ? 
                buildServer.CreateBuildDetailSpec(teamProject) : 
                buildServer.CreateBuildDetailSpec(teamProject, buildDefinition);

            spec.MinFinishTime = DateTime.Now.Subtract(TimeSpan.FromDays(maxDays));
            spec.MaxFinishTime = DateTime.Now;
            spec.QueryDeletedOption = QueryDeletedOption.IncludeDeleted;

            var builds ###### buildServer.QueryBuilds(spec).Builds.OrderBy(b > b.BuildDefinition.Name).ThenByDescending(b => b.FinishTime);
            return builds;
        }


        private static Project MapBuildToProject(IBuildDetail build, string definitionName)
        {
            var project = new Project
            {
                DefinitionName = definitionName,
                Name = build.TeamProject,
                Status = build.Status.ToString(),
                StartTime = build.StartTime,
                FinishTime = build.FinishTime
            };
            return project;
        }

        private void AddBuiltToParentProject(BuildStatus buildStatus, string definitionName, Project project, int maxRuns)
        {
            var parent ###### buildStatus.Projects.First(p > p.DefinitionName ###### definitionName);
            if (parent.Runs.Count < maxRuns)
            {
                parent.Runs.Add(project);
            }
        }
    }
}
```

```csharp
using System;
using System.Collections.Generic;

namespace TfsCommunicator
{
    public class Project
    {
        public Project()
        {
            Runs = new List<Project>();
        }

        public string DefinitionName { get; set; }
        public string Name { get; set; }
        public string Status { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime FinishTime { get; set; }
        public List<Project> Runs { get; set; }
    }
}
```

Deze informatie dan bijvoorbeeld wegschrijven naar een JSON file

```csharp
        private static void Main(string[] args)
        {
            Console.WriteLine("TFS Build status; connecting...");
            BuildCommunicator communicator = new BuildCommunicator(ConfigurationManager.AppSettings["tfsServer"]);

            while (true)
            {
                Console.WriteLine("Getting TFS Build info for all projects...");
                BuildStatus info = communicator.GetBuildInformation();

                CleanBuildStatusFile();
                WriteBuildStatusToFile(info);

                Console.WriteLine("Written build info to buildstatus.json. [waiting...] ");
                Thread.Sleep(20000);
            }
        }

        private static void WriteBuildStatusToFile(BuildStatus info)
        {
            StreamWriter streamWriter = File.CreateText("buildstatus.json");
            new JsonSerializer().Serialize(streamWriter, info);
            streamWriter.Close();
        }

        private static void CleanBuildStatusFile()
        {
            try
            {
                File.Delete("buildstatus.json");
            }
            catch
            {
            }
        }
```