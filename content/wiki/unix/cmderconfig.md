+++
title = "cmder config"
draft = false
tags = [
    "unix",
    "shellconfig",
    "cmder"
]
date = "2017-06-09"
+++
# Cmder user-profile.cmd

```bash
;= @echo off
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;= Add aliases below here
e.=explorer .
gl=git log --oneline --all --graph --decorate  $*
ls=ls --show-control-chars -F --color $*
pwd=cd
clear=cls
history=cat "%CMDER_ROOT%\config\.history"
unalias=alias /d $1
vi=vim $*
cmderr=cd /d "%CMDER_ROOT%"
checkout=SET argument=$* $t SET filepath=%argument:Modules/=% $t mkdir "c:\Sources\%filepath%" $t svn checkout https://websvn.prato.be:8443/svn/$* "c:\Sources\%filepath%"
update=svn update "c:\Sources\$*\trunk"
startvs=start "C:\Sources\$*\trunk\$*.sln" /D "C:\Sources\$*\trunk"
ga=git add -A
gs=git status
gc=git commit -m "$*"
gp=git push -u origin $*
```