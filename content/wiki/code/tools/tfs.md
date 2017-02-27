+++
title = "tfs"
draft = false
tags = [
    "code",
    "tools",
    "tfs"
]
date = "2014-01-31"
+++
# Team Foundation Server 

## Changing the default check-in action 

By default worden work items op "resolved" gezet. Dit is meestal geen gewenst gedrag. **Niet automatisch oplosbaar**: zie http://www.codesmartnothard.com/2013/02/09/ChangingTheDefaultCheckInOptionToAssociateInTFS2012.aspx

Voor items op state "new" kan je deze key wijzigen in registry: `HKEY_CURRENT_USER<br/>Software<br/>Microsoft<br/>VisualStudio<br/>**11.0**<br/>TeamFoundation<br/>SourceControl<br/>Behavior @ResolveAsDefaultCheckinAction = "False"`

## Find latest work items 

Hoe kan ik mijn laatste "Related work item" terug ophalen om aan de in te checken changeset dezelfde items te koppelen? <br/><br/>

Custom query toevoegen: zie http://robertgreiner.com/2011/04/how-to-get-your-entire-work-item-history-in-tfs/

```
Changed By Contains @Me
And Revised Date >= @Today - 30
```