+++
title = "msbuild"
draft = false
tags = [
    "code",
    "build",
    "msbuild"
]
date = "2014-01-31"
+++
# MSBuild 

## Adding/Modifying build steps 

##### Q: Hoe kan ik iets aan de build toevoegen zonder de XAML template te wijzigen? 

A: Maak een nieuw **dummy solution** met één project, waar in de `csproj` file het volgende bijgevoegd is:

```xml
  <Target Name="AfterBuild">
    <Exec Condition######" '$(Configuration)|$(Platform)'  'Release|x86' " Command="attrib -r ../../AUP/C-eHealthPortal.aup" />    
    <BuildUpdate Condition######" '$(Configuration)|$(Platform)'  'Release|x86' " ProjectFile######"../../AUP/C-eHealthPortal.aup" PublishLocations"LOCAL" />
    <Exec Condition######" '$(Configuration)|$(Platform)'  'Release|x86' " Command="attrib +r ../../AUP/C-eHealthPortal.aup" />  
  </Target>
```

(Ter info, `BuildUpdate` is een tag die met een using included werd: `<UsingTask AssemblyFile######"../../AUP/Kjs.AppLife.Update.BuildUpdateTask.dll" TaskName"Kjs.AppLife.Update.MSBuild.BuildUpdate" />`)

:exclamation: Indien volgorde belangrijk is, aan MSBuild als parameter deze solution als laatste builden, zodat de output/bin folder al de juiste gegevens bevat.

## WebServers drop folder 

##### Q: Ik wil geen _publishedWebsite.zip waar heel diep PackageTmp in zit maar de exploded dir! 

A: Append in `MSBuild` arguments `;DeployOnBuild=true` - zie [MSDN DeployOnBuild property](http://msdn.microsoft.com/en-us/library/microsoft.teamfoundation.build.workflow.activities.msbuild.deployonbuild.aspx)

Er is blijkbaar ook een `CreatePackageOnPublish` property (?) 