+++
title = "oledb"
draft = false
tags = [
    "code",
    "db",
    "oledb"
]
date = "2014-02-27"
+++
# Oledb 

## Named parameter problem 

Blijkbaar werkt `OleDbCommand` nooit met named parameters, maar is de **volgorde van toevoegen** zeer belangrijk. In De query zelf worden '?' tekens gebruikt om een parameter aan te duiden. Dit is zeer vervelend, en maakt het abstraheren van de DB laag moeilijk - andere DB providers staan bijvoorbeeld `@parameter` toe, waarbij de naam wel uitmaakt. Hoe lossen we dat op?

#### Convert named parameters into positional ones 

Hocus pocus: (zie ook http://stackoverflow.com/questions/2407685/oledbparameters-and-parameter-names etc)

```csharp
        public static OleDbCommand ConvertNamedParametersToPositionalParameters(OleDbCommand command)
        {
            // OleDb does NOT use named parameters, but we want them! (uses '?')
            var newParameters = new List<OleDbParameter>();

            command.CommandText ###### Regex.Replace(command.CommandText, "(@<br/><br/>w*)", match >
            {
                var parameter ###### command.Parameters.OfType<OleDbParameter>().FirstOrDefault(a > a.ParameterName ###### match.Groups[1].Value);
                if (parameter != null)
                {
                    var parameterIndex = newParameters.Count;

                    var newParameter = command.CreateParameter();
                    newParameter.OleDbType = parameter.OleDbType;
                    newParameter.ParameterName = "param_" + match + "_" + parameterIndex.ToString();
                    newParameter.Value = parameter.Value;

                    newParameters.Add(newParameter);
                }

                return "?";
            });

            command.Parameters.Clear();
            command.Parameters.AddRange(newParameters.ToArray());
            return command;
        }
```

######= Gewenste Resultaat ######=

Maakt het mogelijk om dit te doen:

  * `SELECT * FROM TABLE WHERE column ###### @name1 AND column2  @name2`
  * voeg aan command `new OleDbParameter("@name1", value)` toe
  * wordt automagically vervangen door vorige method (kan als extension gebruikt worden)

:exclamation: In [code/db/sqlite]({{< relref "wiki/code/db/sqlite.md" >}}) wordt dit by default ondersteund... 