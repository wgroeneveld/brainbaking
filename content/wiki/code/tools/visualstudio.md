+++
title = "visualstudio"
draft = false
tags = [
    "code",
    "tools",
    "visualstudio"
]
date = "2014-06-19"
+++
# Visual Studio 

### Handige plugins 

  * http://www.codemaid.net/ - auto-cleanup on save, integratie resharper
  * [code/tools/resharper]({{< relref "wiki/code/tools/resharper.md" >}})

### Debugging 

#### PDB files auto-resolven: remote SymbolSource enablen 

Zie [Using SymbolSource](http://www.symbolsource.org/Public/Wiki/Using)

  1. Go to Tools -> Options -> Debugger -> General.
  2. Uncheck “Enable Just My Code (Managed only)”.
  3. Uncheck “Enable .NET Framework source stepping”. Yes, it is misleading, but if you don't, then Visual Studio will ignore your custom server order (see further on) and only use it's own servers.
  4. Check “Enable source server support”.
  5. Uncheck “Require source files to exactly match the original version”
  6. Go to Tools -> Options -> Debugger -> Symbols.
  7. Select a folder for the local symbol/source cache. You may experience silent failures in getting symbols if it doesn't exist or is read-only for some reason.
  8. Add symbol servers under “Symbol file (.pdb) locations”. Pay attention to the correct order, because some servers may contain symbols for the same binaries: with or without sources. We recommend the following setup:
    * http://referencesource.microsoft.com/symbols
    * http://srv.symbolsource.org/pdb/Public or the authenticated variant (see above)
    * http://srv.symbolsource.org/pdb/MyGet or the authenticated variant (see above)
    * (other symbol servers with sources)
    * http://msdl.microsoft.com/download/symbols
    * (other symbol servers without sources)
