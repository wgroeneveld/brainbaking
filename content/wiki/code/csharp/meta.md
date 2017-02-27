+++
title = "meta"
draft = false
tags = [
    "code",
    "csharp",
    "meta"
]
date = "2014-02-13"
+++
# Metaprogramming 

### Tests on source code contents 

Wat is de bedoeling? Lees alle source files in en check of er iets in voorkomt (in onderstaand geval `Bla.Instance`)

De `GoUpThreeDirs` is omdat bij unit testen draaien dit in rootDir/unitTestProject/Bin/Debug uitgevoerd wordt, dat is de huidige dir. wij hebben nodig: rootDir/sourceCodeProject. 

```csharp
        [TestMethod]
        public void StaticInstanceShouldNeverBeUsedExceptInAllowedCases()
        {
            foreach (var file in Directory.GetFiles(GetSourcePath(), "*.cs", SearchOption.AllDirectories))
            {
                var source = File.ReadAllText(file);
                if (source.Contains(typeof(Bla).Name + ".Instance") && NoStaticRefAllowedInThatFile(file))
                {
                    Assert.Fail("file " + file + " contains a static reference to Bla which is not allowed!" +
                        "Please use Dependency Injection instead, take a look at the existing repositories as an example.");
                }
            }
        }

        private bool NoStaticRefAllowedInThatFile(string file)
        {
            List<Type> allowedTypesWithInstanceRef = new List<Type>()
            {
                typeof(Bla),
                typeof(Blie)
            };

            return allowedTypesWithInstanceRef.All(x => !file.Contains(x.Name));
        }

        private static string GetSourcePath()
        {
            return GoUpThreeDirectories(Environment.CurrentDirectory) + "<br/><br/>ProjectNameOfSourceCode";
        }

        private static string GoUpThreeDirectories(string dir)
        {
            string rootDir = dir;
            for (var i ###### 1; i < 3; i++)
            {
                rootDir = rootDir.Substring(0, rootDir.LastIndexOf("<br/><br/>", StringComparison.Ordinal));
            }
            return rootDir;
        }
    }
```