+++
title = "signing"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "csharp",
    "signing"
]
date = "2014-07-11"
+++
# Signing 

#### Compile fouten: 'cannot import the following key file' 

```
C:<br/>Windows<br/>Microsoft.NET<br/>Framework<br/>v4.0.30319<br/>Microsoft.Common.targets(2455, 5): error MSB3325: Cannot import the following key file: ign.pfx. The key file may be password protected. To correct this, try to import the certificate again or manually install the certificate to the Strong Name CSP with the following key container name: VS_KEY_0E36C1B21D0EBCA4
```

Oplossen door met `sntool` te registreren en die container naam aan te maken (VS_KEY_...)

#### Assemblies signen 

Properties -> Signing -> Sign the assembly aanvinken. Choose a strong name key file... (browse)

#### Friend classes & signed assemblies 

In `AssemblyInfo.cs` ook de public key meegeven van de friend assembly:

```csharp
[assembly: InternalsVisibleTo("ServiceLayer.UnitTest, PublicKey=00240000048000002a51cadd46bbd321cda4e67d2...c125d7eb")]
```

##### De public key opvragen van een assembly 

Met `sn.exe`, geïnstalleerd onder uw .NET SDK dir, bijvoorbeeld `C:<br/>Program Files (x86)<br/>Microsoft SDKs<br/>Windows<br/>v7.0A<br/>Bin`

`sn -Tp [assembly.dll]` uitvoeren. Of de sign file vastnemen en deze uitlezen. Zie [MSDN Strong Name Tool help](http://msdn.microsoft.com/en-us/library/k5b5tt23(v=vs.110).aspx).