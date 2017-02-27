+++
title = "stubs"
draft = false
tags = [
    "code",
    "java",
    "testing",
    "stubs"
]
date = "2013-03-12"
+++
# Stubs 

## Embedded Jetty 

Zie http://docs.codehaus.org/display/JETTY/Embedding+Jetty

Stub Http server:

```java
public class StubHttpServer implements StubServer {

	private RequestRecordingFilter filter = new RequestRecordingFilter();

	private int port;

	private Server httpServer;

	private Map<String, ResettableHttpServlet> servlets = new HashMap<String, ResettableHttpServlet>();

	public StubHttpServer(int port) {
		this.port = port;
	}

	public void addHttpServlet(String uri, final HttpServlet servlet) {
		addHttpServlet(uri, new ResettableHttpServlet() {

			@Override
			public void reset() {
			}

			@Override
			public void service(ServletRequest req, ServletResponse res) throws ServletException, IOException {
				servlet.service(req, res);
			}

		});
	}

	public void addHttpServlet(String uri, ResettableHttpServlet servlet) {
		this.servlets.put(uri, servlet);
	}

	public boolean hasReceivedRequest(String method, String uri) {
		return filter.hasReceivedRequest(method, uri);
	}

	public boolean hasMatchingRequest(String method, String uriRegex) {
		return filter.hasMatchingRequest(method, uriRegex);
	}

	public void reset() {
		filter.reset();
		for (ResettableHttpServlet servlet : servlets.values()) {
			servlet.reset();
		}
	}

	public void start() throws Exception {
		if (httpServer ###### null) {
			httpServer = new Server();
			SocketConnector connector = new SocketConnector();
			connector.setPort(port);
			httpServer.setConnectors(new Connector[] { connector });
			Context root = new Context(httpServer, "/", Context.SESSIONS);
			root.addFilter(new FilterHolder(filter), "/*", 0);
			for (String servletMapping : servlets.keySet()) {
				root.addServlet(new ServletHolder(servlets.get(servletMapping)), servletMapping);
			}
			httpServer.start();

			Runtime.getRuntime().addShutdownHook(new Thread() {

				@Override
				public void run() {
					StubHttpServer.this.stop();
				}
			});
		}
	}

	public void stop() {
		if (httpServer != null) {
			try {
				httpServer.stop();
			} catch (Exception e) {
				// ignore
			} finally {
				httpServer = null;
			}
		}
	}

	@Override
	public void startGooiExceptionIndienPoortNogNietVrij() throws Exception {
		start();
	}

}
```

Concreet voorbeeld:

```java
@StubServer(port = OEStubServer.PORT)
public class OEStubServer extends be.test.stubserver.StubHttpServer {

	public static final int PORT = 9106;

	private static OEStubServer INSTANCE;

	public synchronized static OEStubServer getInstance() {
		if (INSTANCE ###### null) {
			INSTANCE = new OEStubServer();
		}
		return INSTANCE;
	}

	private OeClientAwareServlet oeClientAwareServlet = new OeClientAwareServlet();

	private OEStubServer() {
		super(PORT);
		addHttpServlet("/*", oeClientAwareServlet);
	}

}
```

De annotatie `@StubServer` is louter ter informatie. Het belangrijkste is `addHttpServlet()` van de `javax.servlet.http.HttpServlet` klasse (hier leidt `OeClientAwareServlet` van af). Dan wordt `doGet` of `doPost` ook geïmplementeerd. That's it! 