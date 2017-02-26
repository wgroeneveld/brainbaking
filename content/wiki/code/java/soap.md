+++
title = "soap"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "java",
    "soap"
]
date = "2013-03-12"
+++
# code:java >> Soap 

### Een simpele SOAP Client maken als Unit Test 

```java
    @Test
    public void processManageCustomers() throws Exception {
        URL url = new URL("http://localhost:8888/bla");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        setSOAPPostHeaders(conn);
        IOUtils.copy(new FileInputStream(new File("src/test/resources/example.xml")), conn.getOutputStream());

        String result = IOUtils.toString(conn.getInputStream());
        assertThat(result).contains("<return>something</return>");
    }

    private void setSOAPPostHeaders(HttpURLConnection conn) throws ProtocolException {
        conn.setRequestProperty("Content-Type", "text/xml; charset=utf-8");
        conn.setRequestProperty("SOAPAction", "");
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setDoInput(true);
    }
```

Gebruik makende van `apache commons`

### Endpoint URL met JAX-WS goed zetten 

Twee mogelijkheden:

ofwel zit de URL juist op de server in de WSDL, in dat geval kan je de gegenereerde Service aanmaken met een url naar de remote WSDL:

```java
BlaService service = new BlaService(new URL("http://server.com/soapaction?wsdl"), new QName("namespace.com", "localpart"));
service.getPort().doStuff();
```

Deze gaat van de wsdl dit uitlezen:

```xml
<wsdl:definitions xmlns######"http:*schemas.xmlsoap.org/wsdl/" xmlns:Port_0"http:*www.x.com/endpoint/" ... />
```

Als dat verkeerd geconfigureerd staat heb je nog een tweede mogelijkheid, via property `BindingProvider.ENDPOINT_ADDRESS_PROPERTY`:

```java
try { 
            EmployeeServiceService service = new EmployeeServiceService();
            EmployeeService port = service.getEmployeeServicePort();

            BindingProvider bp = (BindingProvider)port;
            bp.getRequestContext().put(BindingProvider.ENDPOINT_ADDRESS_PROPERTY, "http://server1.grallandco.com:8282/HumanRessources/EmployeeServiceService");

            Employee emp = port.getEmployee(123);
// continue doing stuff
```

Zie http://tugdualgrall.blogspot.be/2009/02/jax-ws-how-to-configure-service-end_17.html

### Logging enablen voor Sun JAX-WS 

Gemakkelijke methode :met een JVM argument: `-Dcom.sun.xml.ws.transport.http.client.HttpTransportPipe.dump="true"`

Moeilijke methode: met een `HandlerResolver` die tussen de chain in hangt (weet niet meer precies hoe dat moet, op te zoeken)

### Multipart SOAP Stub server maken 

#### Response opbouwen 

Zie http://www.java2s.com/Open-Source/Java-Document/Groupware/hipergate/com/oreilly/servlet/MultipartResponse.java.htm

Aandachtspuntjes:

  1. content type in de HEADER meesturen (niet als `servlet output stream.println()`): `multipart/related`
  2. Per part moet "Content-Id" meegestuurd worden. Voor een binair stuk moet dat dan overeenkomen met de HREF dat in uw SOAP XML envelop zit:
  3. Binaire gegevens gewoon als byte array wegscvhrijven met `stream.write()`, maar vergeet niet content type op dit part op `application/octet-stream` te zetten.

```xml
<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">
   <S:Body>
      <ns4:HistoriekPdfResponse xmlns:ns4######"s/historiek" xmlns:ns3"http:/ices/uitnodiging" xmlns:ns2######"http:/itnodiging" xmlns"http://www.dd.be/historiek">
         <ns4:Pdf>
            <Include href######"cid:0ba9135c-8663-4346-89b1-770c64383499@example.jaxws.sun.com" xmlns"http://www.w3.org/2004/08/xop/include"/>
         </ns4:Pdf>
      </ns4:HistoriekPdfResponse>
   </S:Body>
</S:Envelope>
```

Hierboven is de content id 0ba91... zonder "cid". 