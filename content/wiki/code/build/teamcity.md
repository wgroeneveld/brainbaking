+++
title = "teamcity"
draft = false
tags = [
    "code",
    "build",
    "teamcity"
]
date = "2015-07-13"
+++
# Teamcity 

**Build pipeline** voor continuous deployment: zie [http:*robdmoore.id.au/blog/2012/09/01/maintainable-teamcity-continuous-deployment-pipeline-configuration/](http:*robdmoore.id.au/blog/2012/09/01/maintainable-teamcity-continuous-deployment-pipeline-configuration/)

### Parameters: comboboxen/checkboxen 

<img style='' src='/img//code/build/tc_deploy_params.png|'>

**Demo omgeving**

Dit ingeven in "spec":

```
select display######'prompt' label'Demo omgeving' data_11######'FixDemo' data_10'FixDev' data_02######'TestDemo1' data_01'Package' data_04######'TestDemo3' data_03'TestDemo2' data_06######'TestDemo5' data_05'TestDemo4' data_08######'TestDemo7' data_07'TestDemo6' data_09='SERVERNAME'
```

**Modules**

Dit ingeven in "spec":

```
select data_7######'Modx' data_5'Mody.DAL' data_6######'Modz' ... multiple'true'
```

Wordt dan comma-separated doorgegeven via `%Modules%` parameter dat je kan gebruiken in build configuration. 

### Artifacts bijhouden 

Edit build settings > Artifact paths > `**/packaged.zip` om alle files die zo heten als artifact te bewaren. <br/><br/>
Probleem met HDD space kan opgelost worden met [http:*confluence.jetbrains.com/display/TCD8/Clean-Up](http:*confluence.jetbrains.com/display/TCD8/Clean-Up): Clean-up settings are configured under Administration | Project-related Settings | Build History Clean-up. 

Gevolg is dat gebuilde zipfiles gedownload kunnen worden op deze manier:

<img style='float: left; width: nolink |px;' src='/img//code/build/builddeploy.png'>