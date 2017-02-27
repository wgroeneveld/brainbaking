+++
title = "git"
draft = false
tags = [
    "code",
    "tools",
    "git"
]
date = "2013-03-12"
+++
# Git 

### Van een remote branch changes binnen halen 

Stel: ik heb een fork gemaakt maar wil van de "upstream" de veranderingen binnen halen:

```
git remote add upstream git://github.com/user/bla.git
git fetch upstream
git merge upstream/master
```

En dan eventueel merge conflicten oplossen. 

### Stap-voor-stap 

setup git voor *windows*: volg instructies op http://help.github.com/win-set-up-git/

#### Stap-voor-stap SSH 

  1. Installeer `cygwin` met de volgende packages:
    1. `ssh` en varianten
    2. `git`
    3. `corkscrew` voor proxy indien nodig
  2. genereer voor uw pc public `ssh` keys met `ssh-keygen -t rsa -C "[email]"`
  3. Kopieer de public key in `~/.ssh/id_rsa.pub` en voeg dit aan uw profiel op github.com toe hier: https://github.com/account/ssh
  4. Zet de ssh proxy indien nodig - zie onder
  5. Test connectie met `ssh -T git@github.com`

#### Stap-voor-stap Git 

  1. Set username & email:
    1. `git config --global user.name "[name]"`
    2. `git config --global user.email "[email]"`
  2. Set github user & github token - terug te inden op github account settings:
    1. `git config --global github.user [user]` zonder quotes
    2. `git config --global github.token [token]` zonder quotes

Kleurtjes toevoegen aan de git shell (rood/groen voor unstaged/staged files): `git config --global color.ui true`

### In-depth guide 

#### Links en resources 

  * http://progit.org/book/
  * http://www.github.com/

#### Basisconfiguratie .gitignore 

Zie https://github.com/github/gitignore

#### Conflict resolutie 

<img style='float: left; width:  |px;' src='/img//code/tools/trees.png'>

##### Outgoing changes resetten en een pull doen 

> `git reset --hard`

En daarna

> `git pull`

:exclamation: een harde reset uitvoeren op het verkeerde moment kan u van de main branch afhalen: zie http://blog.plover.com/prog/git-reset.html

##### A tale of three trees 

Git gebruikt intern als version control systeem 3 trees: head, index & work. <br/><br/>
Als conflicten auto-merged kunnen worden met een `pull` komt dit rechtstreeks in uw lokale repository. Anders moet je mergen met `git mergetool -y`.

Na de merge moet je lokaal committen - dit zijn dan de wijzigingen die van de remote repository gepulled werden. 

Meer informatie & uitleg op:
  * http://www.infoq.com/presentations/A-Tale-of-Three-Trees
  * http://progit.org

#### Configuratie SSH 

SSH proxy definiëren: create `config` file in `~/.ssh`:

```
ProxyCommand /usr/bin/corkscrew proxy.x.be 8080 %h %p
```

:exclamation: **Opgelet** `corkscrew` ook nog downloaden (cygwin opgelet)

#### Configuratie GIT 

Alle configuratie flags kunnen aangepast worden met `git config --global [key] [value]`.

  * Een proxy definieren: key `http.proxy`

#### Het verschil zien tussen de lokale gecommite gegevens en de remote  

Indien reeds van unstaged -> staged -> committed gegaan, voor de `git push` te doen, wat is het verschil??

Enkel zichtbaar via `git log`, dan het detail daarvan proberen te raadplegen met `git show [begin hashtag logentry]]`. 

#### Merge tool configureren  

  * download kdiff3 (http://kdiff3.sourceforge.net/)
  * configure git mergetool:
    1. git config --global merge.tool kdiff3
    2. git config --global mergetool.kdiff3.path "C:<br/>Program Files (x86)<br/>KDiff3<br/>kdiff3.exe"
    3. git config --global mergetool.trustexitcode false
  * use mergetool: git mergetool -y

#### Cheat sheet  

##### Een repository initieel aanmaken 

Gegeven: een project directory waar men een repository van wil maken.

^ Actie     ^ Commando ^
| *initieel aanmaken nodige git bestanden* | `git init` |
| *remote repository toevoegen* | `git add origin [url]` |

Bij een `git add` commando zou de url in geval van *github* zoiets kunnen zijn:

> `git@github.com:jefklak/jasmine-sync-flow.git`

##### Een remote repository lokaal plaatsen 

In een bepaalde root directory (maakt subdir automatisch aan):

> `git clone git@github.com:jefklak/jasmine-junit-runner.git`

Om dan zaken *upstream* te pushen kan je `git remote add upstream [url]]` en `git push upstream` gebruiken. 

##### State veranderen aan een repository 

*Altijd eerst lokaal committen*, dán die snapshot pushen naar de remote server! 

^ Actie     ^ Commando ^
| *files toevoegen om te committen* | `git add [dir]/*` |
| *te committen status bekijken* | `git status` |
| *change committen* | `git commit -a -m [msg]` |
| *gecommitte snapshot pushen (naar master)* | `git push` |
| *gecommitte snapshot pushen (naar x)* | `git push -u origin x` |