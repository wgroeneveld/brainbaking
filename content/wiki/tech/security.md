+++
title = "security"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "tech",
    "security"
]
date = "2015-07-14"
+++
# tech >> Security 

## OpenSSL 


##### Conversie certificaten 

PFX naar PEM: `openssl pkcs12 -in [.pfx] -out [.pem]`

##### PKCS7 signing van bestanden 

`openssl smime -sign -in [tosignfile] -signer [privatekeyfile] -passin [passw] -outform PEM -out [outfile]`

Paar dingen om op te letten:

  1. infile moet in UTF-8 encoded zonder UTF-8 identifier weggeschreven zijn. In C# bvb zo `File.WriteAllText(inFile, data, new UTF8Encoding(false));`
  2. privatekeyfile moet een PEM bestand zijn
  3. output door openssl bevat begin en eind PKCS7 notaties, plus newlines op het laatste. Als die wegmoeten, replacen! 

Voorbeeld om enkel signed data uit te halen:

```csharp
                return signed
                    .Replace("-----BEGIN PKCS7-----", "")
                    .Replace("-----END PKCS7-----", "")
                    .TrimStart('<br/>r', '<br/>n')
                    .TrimEnd('<br/>r', '<br/>n');
```
