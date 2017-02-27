+++
title = "sublime"
draft = false
tags = [
    "code",
    "tools",
    "sublime"
]
date = "2014-06-19"
+++
# Sublime Text protips 

<img style='width: |px;' src='/img//code/tools/subl_plugins.png'>

## Handige links 

  * **Keyb shortcuts** voor **mac**: http://docs.sublimetext.info/en/latest/reference/keyboard_shortcuts_osx.html
  * Tips voor **python devs** ea: http://opensourcehacker.com/2012/05/11/sublime-text-2-tips-for-python-and-web-developers/

## Must-have plugins 

Installeren via [Sublime Package Control](http://wbond.net/sublime_packages/package_control)

  1. [SublimeLinter](https://github.com/SublimeLinter/SublimeLinter) - linting in verschillende talen (ook CoffeeScript)
  2. [SublimeCodeIntel](https://github.com/Kronuz/SublimeCodeIntel) - autocompletion in verschillende talen. Werkt zoals in eclipse, gebruik `ctrl+shift+space` voor box te triggeren. 
  3. [git](https://github.com/kemayo/sublime-text-2-git/wiki)
  4. [jsFormat](https://github.com/jdc0589/JsFormat) (mapt by default op `cmd+alt+F`, heb het remapped naar eclipse equiv. `cmd+shift+F`)
  5. [FilterLines](https://github.com/davidpeckham/FilterLines) om door logging te ploegen - greplike in subl.

## (user) configuratie 

Hoofddocumentatie: http://docs.sublimetext.info/en/latest/reference/settings.html

In `JSON` formaat, zie `ctrl+shift+P`: `Preferences: Settings - User`. Proxy definiëren:

```javascript
{
	"debug": true,

	"http_proxy": "vdabproxy.vdab.be:8080",
	"https_proxy": "vdabproxy.vdab.be:8080"
}
```

Dit werkt niet als je `Package Control` nog moet installeren aangezien de settings specifiek hiervoor zijn.<br/><br/>
Plugin manueel in plugin dir slepen. 

## Development in Sublime 

### Build Systems 

CTRL+B (menu build) werkt door een `.sublime-build` file met configuratie voor de batch die in (onder windows `C:<br/>Users<br/>bkwog<br/>AppData<br/>Roaming<br/>Sublime Text 2<br/>Packages<br/>[lang]`) uw package dir leven. Een voorbeeld van zo'n file voor ruby, by default:

```
{
	"cmd": ["ruby", "$file"],
	"file_regex": "^(...*?):([0-9]*):?([0-9]*)",
	"selector": "source.ruby"
}
```

Syntax: http://docs.sublimetext.info/en/latest/file_processing/build_systems.html

Zie ook [Adding custom build systems for popular tools and languages](http://addyosmani.com/blog/custom-sublime-text-build-systems-for-popular-tools-and-languages/) - bijvoorbeeld grunt etc. 

### Ruby development 

[Efficiency with Sublime text and Ruby](http://thunderboltlabs.com/blog/2013/11/19/efficiency-with-sublime-text-and-ruby/)

### Python development 

#### Must have plugins 

  * PyLint voor code checking
  * autocompletion: [jedi](http:*screamingatmyscreen.com/2013/9/sublime-text-as-python-ide-jedi/) of [Anaconda](https:*sublime.wbond.net/packages/Anaconda) zijn de beste specifiek voor Python.
  * Voor checkins: Git & GitGutter

Voor Jedi moet je uw project file aanmaken (& Project -> Add Folder to Project ... base dir kiezen): ziet er bijvoorbeeld zo uit

```javascript
{
	"folders":
	[
		{
			"path": "/D/Github/polyglata/01_calculatestring/python"
		}
	]
}
```

Dan kan de autocompleter alles terug vinden. Handige shortcuts: `CTRL+SHIFT+G` goto/find definition. `ALT+SHIFT+F`: find all references. 

#### Building etc 

Kan ook de `SublimeREPL` gebruiken, en dan deze in een window langs uw code plaatsen. Keyboard shortcuts zoals `CTRL+SHIFT+, F` kopiëren heel de file naar de REPL om te evalueren. De huidige file builden met **CTRL+B** (Tools -> Build System -> Python).