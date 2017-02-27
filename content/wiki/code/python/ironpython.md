+++
title = "ironpython"
draft = false
tags = [
    "code",
    "python",
    "ironpython"
]
date = "2014-03-07"
+++
# IronPython 

Interessante links:
  * [Iron Python In Action - Dark corners](http://www.voidspace.org.uk/ironpython/dark-corners.shtml)
  * [IronPython .NET Integration documentation](http://ironpython.net/documentation/dotnet/)
  * [Python Tools for Visual Studio](https://pytools.codeplex.com/)

### C#/Python interop 

#### C# in Python 

##### Overerving 

In Python C# klassen over laten erven gaat zonder meer. Constructors werken **niet** via `_ _init_ _` maar via new:

> The __init__ method is the Python initializer method. It is an instance method and so receives the instance as the first argument, which by convention is called self. If you want to override the .NET constructor (responsible for creating the instance) then from Python you override the __new__ class method.

```python
import clr
clr.AddReference('System.Windows.Forms')

from System.Windows.Forms import (
    Application, Form
)


class MainForm(Form):

    def __new__(cls, text):
        instance = Form.__new__(cls)
        instance.Text = text

        return instance

app = MainForm('Hello World')
Application.Run(app)
```

#### Python in C# 

##### De script engine manueel firen 

```csharp
 using IronPython;  
 using IronPython.Modules;  
 using System.Text;  

 public class ScriptExample {  
     [MenuItem("Python/HelloWorld")]  
     public static void ScriptTest()  
     {  
         // create the engine  
         var ScriptEngine = IronPython.Hosting.Python.CreateEngine();  
         // and the scope (ie, the python namespace)  
         var ScriptScope = ScriptEngine.CreateScope();  
         // execute a string in the interpreter and grab the variable  
         string example ###### "output  'hello world'";  
         var ScriptSource = ScriptEngine.CreateScriptSourceFromString(example);  
         ScriptSource.Execute(ScriptScope);  
         string came_from_script = ScriptScope.GetVariable<string>("output");  
         // Should be what we put into 'output' in the script.  
         Debug.Log(came_from_script);              
     }  
 }  
```

Via [Embedding IronPython in Unity](http://techartsurvival.blogspot.ca/2013/12/embedding-ironpython-in-unity-tech-art.html).

### Visual Studio Integration 

<img style='float: left; width: direct&800 |px;' src='/img//code/python/ide.png'>

Installeer IronPython & Python tools for VS. File -> New Project -> IronPython Application. 

##### References leggen 

References voor het python project zijn niet voldoende, je moet ook het **Search Paths** mapje updaten, kan enkel op dll toegevoegd worden. 

Vanaf dan kan je via `clr` de imports doen zoals `using` in C#:

```python
import clr
clr.AddReferenceByName('Wizards')
from Wizards import *
# use some class from the Wizards namespace below.
```

##### Unit testen uitvoeren 

:exclamation: MSTest & Test Explorer werkt automatisch en herkent alle testen - ReSharpner werkt niet meer. Een test python file uitvoeren kan ook met F5 (file als startup file), en `unittest.main()` erbij plaatsen. 