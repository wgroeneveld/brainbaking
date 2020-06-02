---
title: Visual Studio 2012 for Eclipse users
bigimg: /img/Visual Studio 2012 for Eclipse users.jpg
date: '2013-10-14'
subtitle: Trying to fill the gap of missing features in VStudio.
tags: [ 'visual studio', 'eclipse']
---

When switching over to a new editor and new language, I can sometimes get frustrated by missing features I got (very) attached to. This excludes the obvious difference in shortcut keys. 

### Shortcuts and refactoring tools  ###

One plugin to rule them all: [ReSharpner](http://www.jetbrains.com/resharper/). This productivity tool brings back the incredible development speed to the Visual Studio platform. You can almost map the eclipse (or IntelliJ, since they guys from JetBrains developed it) keys to the ReSharpner keys. If you're used to quickly refactor out variables, introduce classes from parameters or create test classes, you'll be in heaven. 

The following shortcuts can be mapped (you're welcome):


| **Eclipse shortcut** | **ReSharpner shortcut** | **description**  |
|-----------------------------------|------------|--------|
| CTRL+D	 | CTRL+L	 | remove line |
| ALT+DOWN	 | CTRL+D	 | duplicate line |
| CTRL+SPACE (CTRL+ENTER)	 | CTRL+SPACE (TAB)	 | code completion, select in combobox |
| ALT+SHIFT+UP/DOWN	 | CTRL+ALT+LEFT/RIGHT	 | Extend/Shrink selection |
| CTRL+SHIFT+/	 | CTRL+ALT+/	 | commend line |
| CTRL+SHIFT+1	 | ALT+ENTER	 | quick fix |
| ALT+UP/DOWN	 | CTRL+SHIFT+ALT+UP/DOWN	 | move line |
| CTRL+SHIFT+O	 | CTRL+E, (C)/F	 | organize imports (and format etc, F = silent) |
| CTRL+F11	 | CTRL+U, U	 | rerun last |
| CTRL+O	 | ALT+\	 | Go to file member |
| CTRL+SHIFT+G	 | CTRL+SHIFT+ALT+F12 (SHIFT+F12)	 | find usages |
| F3	 | F12	 | go to definition |
| CTRL+SHIFT+.	 | SHIFT+ALT+PGDN	 | go to next error |
| CTR+,	 | SHIFT+ALT+PGUP	 | go to previous error |
| ALT+SHIFT+I	 | CTRL+R, I	 | inline variable |
| ALT+SHIFT+R	 | CTRL+R, R	 | rename |
| ALT+SHIFT+M	 | CTRL+R, M	 | extract method |
| ALT+SHIFT+C	 | CTRL+R, S	 | change method signature |
| CTRL+SHIFT+B	 | F9	 | toggle breakpoint |
| CTRL+M	 | SHIFT+ALT+ENTER	 | toggle full screen mode |
|-----------------------------------|------------|--------|

Other interesting links:

  - [Default keymap PDF overview](http://www.jetbrains.com/resharper/docs/ReSharper70DefaultKeymap_IDEA_scheme.pdf)
  - [IntelliJ keymap PDF overview](http://www.jetbrains.com/resharper/docs/ReSharper70DefaultKeymap_IDEA_scheme.pdf)

### Comparing files with each other   ###
 
Simply comparing two files within the editor can be a pain - the easiest way to do it in Eclipse is just select both files, rightclick and select "compare". No such option here. You can compare a file with a previous version from TFS, but not two physically different files, weird. Install [VSCommands](http://vscommands.squaredinfinity.com/) and that problem is also solved:
 
![compare files in vstudio](../compare_files_vstudio2012.png)


It uses the built-in VS2012 comparison window, which is quite nice.
