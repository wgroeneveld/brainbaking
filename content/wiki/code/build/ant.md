+++
title = "ant"
draft = false
tags = [
    "code",
    "build",
    "ant"
]
date = "2013-03-12"
+++
# Ant scripts etc 

### JSP files precompilen met tomcat lib 

```xml
<project name######"vac Precompilatie" default"precompile-all" basedir=".">

	<taskdef classname######"org.apache.jasper.JspC"  name"jasper">
		<!-- -Dorg.apache.el.parser.SKIP_IDENTIFIER_CHECK=true -->
		<classpath id="jasperpath">
			```et
				 <include name="*.jar"/>
			</fileset>

			```et
				 <include name="*.jar"/>
			</fileset>
		</classpath>
	</taskdef>
	
	<target name="precompile-all">
		<mkdir dir="target/jsp" />
		<jasper 
			validatexml="false" 
			uriroot="target/vac"
			outputdir="target/jsp" />
	</target>

</project>
```

Als ge dit bovenstaande gebruikt, jasper als dep. toevoegen (`org.apache.tomcat jasper 6.0.3x`)