+++
title = "reflectie"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "java",
    "reflectie"
]
date = "2013-03-12"
+++
# Reflectie, Classpath scanning etc 

### Oplijsten van fields die enkel boolean en true zijn  

```java
	public static String listTrueBooleanFields(Object object) {
		List<String> parts = Lists.newArrayList();
		try {
			for (Field field : object.getClass().getDeclaredFields()) {
				boolean accessibleFlag = field.isAccessible();
				field.setAccessible(true);
				if (isTrueBooleanField(object, field)) {
					parts.add(makeCamelCaseNatural(field.getName()));
				}
				field.setAccessible(accessibleFlag);
			}
		} catch (Exception ex) {
			throw new RuntimeException(ex);
		}

		return StringUtils.join(parts, ", ");
	}

	private static boolean isTrueBooleanField(Object object, Field field) throws IllegalAccessException {
		return isBoolean(field) && (Boolean) field.get(object);
	}

	private static boolean isBoolean(Field field) {
		return Boolean.class.isAssignableFrom(field.getType()) || boolean.class.isAssignableFrom(field.getType());
	}
```

### Nieuwe instantie van een klasse met default constructor 

```java
public class ReflectionUtils {

	public static <T> T createNewInstanceOf(Class<T> classToCreate) {
		try {
			Constructor<T> noArgConstructor = classToCreate.getDeclaredConstructor();

			boolean accessibleFlag = noArgConstructor.isAccessible();
			noArgConstructor.setAccessible(true);

			T newInstance = noArgConstructor.newInstance();

			noArgConstructor.setAccessible(accessibleFlag);
			return newInstance;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
}
```

### Class files vinden in bepaalde packages 

#### Met Spring 

Met hulp van spring classes zoals `org.springframework.core.io.support.ResourcePatternResolver` en `org.springframework.core.type.classreading.MetadataReaderFactory`:

```java
			String packageSearchPath = ResourcePatternResolver.CLASSPATH_ALL_URL_PREFIX +
					ClassUtils.convertClassNameToResourcePath(basePackage) + "/" + this.resourcePattern;
			Resource[] resources = this.resourcePatternResolver.getResources(packageSearchPath);

			for (int i = 0; i < resources.length; i++) {
				Resource resource = resources[i];
				MetadataReader metadataReader = this.metadataReaderFactory.getMetadataReader(resource);
				if (isCandidateComponent(metadataReader)) {
					Class<?> clazz = null;
					try {
						clazz = Class.forName(metadataReader.getClassMetadata().getClassName());
					} catch (ClassNotFoundException e) {
						e.printStackTrace();
					}
					candidates.add(clazz);
				}
			}
```

`CLASSPATH_ALL_URL_PREFIX` is **`"classpath*:"`**.

De `isCandidateComponent` method accepteert of verwerpt een item afhankelijk van de metadata met hulp van de spring interface `org.springframework.core.type.filter.TypeFilter`:

```java
		for (TypeFilter tf : this.includeFilters) {
			if (tf.match(metadataReader, this.metadataReaderFactory)) {
				return true;
			}
		}
```

Het is ook mogelijk om een "default" filter te voorzien die alles include: `new RegexPatternTypeFilter(Pattern.compile(".*"));`. 

##### Subtypes van een bepaalde klasse vinden 

Kan ook met de bovenstaande code (de `ClassPathScanningCandidateComponentProvider` dus):

```java
	public <T> Set<Class<?>> getSubTypesOf(Class<T> type) {
		ClassPathScanningCandidateComponentProvider provider = new ClassPathScanningCandidateComponentProvider(false);
		provider.addIncludeFilter(new AssignableTypeFilter(type));
		Set<Class<?>> candidateSubtypes = provider.findCandidateComponents(getPackageToScan());
		candidateSubtypes.remove(type);
		return candidateSubtypes;
	}
```

##### get only concrete subclasses 

In combinatie met bovenstaande method:

```java
	public <T> Set<Class<?>> getConcreteSubTypesOf(Class<T> type) {
		Set<Class<?>> result = new HashSet<Class<?>>();
		for (Class<?> aClass : getSubTypesOf(type)) {
			if (isConcrete(aClass)) {
				result.add(aClass);
			}
		}
		return result;
	}

	private boolean isConcrete(Class<?> aClass) {
		return !Modifier.isAbstract(aClass.getModifiers());
	}
```

#### Zonder Spring 

Gebruik http://code.google.com/p/reflections/ -

```java
Reflections reflections = new Reflections("my.project.prefix");
Set<Class<? extends SomeClassOrInterface>> subTypes = reflections.getSubTypesOf(SomeClassOrInterface.class);
```

#### Alles zelf doen? 

Slecht idee, enige optie is alle class files van het classpath als files behandelen, `Class.forName` gebruiken om classes in te laden (**slecht idee**) en `instanceof` ofzoiets gebruiken. Bytecode scanning gebeurt door de twee bovenstaanden, maar is niet triviaal zelf te doen.

