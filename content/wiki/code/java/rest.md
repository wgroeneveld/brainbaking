+++
title = "rest"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "java",
    "rest"
]
date = "2013-05-22"
+++
# Rest Calls plegen met Java 

## Jersey 

:exclamation: **User Guide**: http://jersey.java.net/nonav/documentation/latest/user-guide.html

### Server 

##### maven 

```xml
		<dependency>
			<groupId>com.sun.jersey</groupId>
			<artifactId>jersey-server</artifactId>
			<version>1.17</version>
		</dependency>
		<dependency>
			<groupId>com.sun.jersey</groupId>
			<artifactId>jersey-json</artifactId>
			<version>1.17</version>
		</dependency>
		<dependency>
			<groupId>com.sun.jersey</groupId>
			<artifactId>jersey-servlet</artifactId>
			<version>1.17</version>
		</dependency>
```

`jersey-json` is niet nodig als je geen `JSON` wil gebruiken. `jersey-servlet` ook niet als je geen Servlet 2.x gebruikt. 

##### servlet 2.x config 

Dit moet in `web.xml`:

```xml
	<servlet>
		<servlet-name>jersey-serlvet</servlet-name>
		<servlet-class>com.sun.jersey.spi.container.servlet.ServletContainer</servlet-class>
		<init-param>
			<param-name>com.sun.jersey.config.property.packages</param-name>
			<param-value>be.klak.package</param-value>
		</init-param>
		<init-param>
			<param-name>com.sun.jersey.api.json.POJOMappingFeature</param-name>
			<param-value>true</param-value>
		</init-param>		
		<load-on-startup>1</load-on-startup>
	</servlet>
	<servlet-mapping>
		<servlet-name>jersey-serlvet</servlet-name>
		<url-pattern>/rest/*</url-pattern>
	</servlet-mapping>
```

:exclamation: Om Jersey samen met google app engine te kunnen gebruiken, moet je ook dit nog toevoegen:

```xml
		<!-- prevents classes that use reflection which is not allowed in GAE -->
		<init-param>
			<param-name>com.sun.jersey.config.feature.DisableWADL</param-name>
			<param-value>true</param-value>
		</init-param>
```

Zie http://stackoverflow.com/questions/14305035/jersey-setup-on-app-engine 

##### voorbeeld 

```java
@Path("/gc")
public class Controller {

	@GET
	@Path("/path")
	@Produces(APPLICATION_JSON)
	public List<Pojo> getStuff() {
		return stuffRepo().getAll();
	}

	@POST
	@Consumes(MediaType.TEXT_PLAIN)
	@Path("/bla/receive")
	public Response received(String data) {
		return ok().build();
	}
```

waarbij `ok()` op `javax.ws.rs.Response` zit. 

### Client 

##### maven 

```xml
		<dependency>
			<groupId>com.sun.jersey</groupId>
			<artifactId>jersey-client</artifactId>
			<version>1.17</version>
		</dependency>
```

##### voorbeeld 

`com.sun.jersey.api.client.Client` client:

```java
		Client.create()
				.resource(getGatecontrolServer() + "/rest/gc/houses/receive")
				.type(TEXT_PLAIN)
				.post("request body data");
```

### Header control (bvb caching) 

Kan via een filter factory die je meegeeft aan de init params van de servlet in web.xml:

```xml
		<init-param>
			<param-name>com.sun.jersey.spi.container.ResourceFilters</param-name>
			<param-value>be.klak.rest.CacheFilterFactory</param-value>
		</init-param>
</xml>

```java
public class CacheFilterFactory implements ResourceFilterFactory {

	@Override
	public List<ResourceFilter> create(AbstractMethod am) {
		if (hasNoCacheAnnotationOnClass(am) != null) {
			return Collections.<ResourceFilter> singletonList(new CacheResponseFilter());
		}

		return new ArrayList<>();
	}

	private CacheControlHeaderNoCache hasNoCacheAnnotationOnClass(AbstractMethod am) {
		return am.getResource().getResourceClass().getAnnotation(CacheControlHeaderNoCache.class);
	}

	private static class CacheResponseFilter implements ResourceFilter, ContainerResponseFilter {

		@Override
		public ContainerRequestFilter getRequestFilter() {
			return null;
		}

		@Override
		public ContainerResponseFilter getResponseFilter() {
			return this;
		}

		@Override
		public ContainerResponse filter(ContainerRequest request, ContainerResponse response) {
			response.getHttpHeaders().putSingle(HttpHeaders.CACHE_CONTROL, "no-cache");
			return response;
		}
	}
}
```

Annotatie ziet er zo uit:

```java
@Retention(RetentionPolicy.RUNTIME)
@Target({ ElementType.TYPE, ElementType.METHOD })
public @interface CacheControlHeaderNoCache {
}
```

Vanaf dan kan je die gewoon op een resource klasse plakken, zoals `@Produces` en `@Consumes`. 
