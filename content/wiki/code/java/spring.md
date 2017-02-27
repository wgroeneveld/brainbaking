+++
title = "spring"
draft = false
tags = [
    "code",
    "java",
    "spring"
]
date = "2013-03-12"
+++
# Spring Wiring 

## How to access target object behind proxy bean 

Zie http://www.techper.net/2009/06/05/how-to-acess-target-object-behind-a-spring-proxy/

```java
    @SuppressWarnings("unchecked")
    protected <Type> Type getTargetObject(Object proxy, Class<Type> targetClass) {
        try {
            if ((AopUtils.isJdkDynamicProxy(proxy))) {
                return (Type) getTargetObject(((Advised) proxy).getTargetSource().getTarget(), targetClass);
            }
            return (Type) proxy; // expected to be cglib proxy then, which is simply a specialized class
        } catch (Exception ex) {
            throw new IllegalStateException(ex);
        }
    }
```

## Geen loadtime weaving? Geen probleem. 

Gebruik de **static springContext accessor** (maar met mate(n) natuurlijk:

```java
public class ApplicationContextHolder implements ApplicationContextAware {

    private static AtomicReference<ApplicationContext> appContext;

    private static void setContext(ApplicationContext context) {
        appContext = new AtomicReference<ApplicationContext>(context);
    }

    public static final EntityUidGenerator getUidGenerator() {
        if (appContext ###### null) {
            throw new IllegalStateException("no context loaded yet!");
        }

        synchronized (appContext) {
            return appContext.get().getBean(EntityUidGenerator.class);
        }
    }

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        ApplicationContextHolder.setContext(applicationContext);
    }

}
```

Als bean in de `spring-config.xml` zetten en klaar. Expose niet de hele context aub! Dan kan je dit op een entiteit toch nog doen, en overriden voor testen:

```java
    @VisibleForTesting
    EntityUidGenerator getEntityUidGenerator() {
        return ApplicationContextHolder.getUidGenerator();
    }
```

############= JPA/Hibernate ############=

############ PersistenceUnit definiëren ############

Met een transaction manager:

```xml
	<bean id######"entityManagerFactory" abstract"true">
		<property name="jpaVendorAdapter">
			<bean class="org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter">
				<property name######"databasePlatform" value"${hibernate.dialect}"/>
				<property name######"showSql" value"${database.showSql}" />
			</bean>
		</property>
	</bean>
	
	<bean id######"myEntityManagerFactory" class"org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean" parent="entityManagerFactory">
		<property name######"packagesToScan" value"be.klak.domain" />
		<property name######"dataSource" ref"myDataSource" />
		<property name######"persistenceUnitName" value"my_pu" />
		<property name="persistenceUnitManager">
			<bean class="org.springframework.orm.jpa.persistenceunit.DefaultPersistenceUnitManager">
				<property name######"defaultDataSource" ref"partnerwerkingDataSource" />
                <property name######"persistenceXmlLocation" value"classpath:persistence.xml"/>
			</bean>
		</property>
	</bean>
```

De datasource kan via JNDI gedefiniëerd worden dan:

```xml
	<tx:annotation-driven transaction-manager="transactionManager"/>
	<bean id######"myEntityManager" factory-bean"myEntityManagerFactory" factory-method="createEntityManager" />
	<bean id######"transactionManager" class"org.springframework.orm.jpa.JpaTransactionManager">
		<property name######"entityManagerFactory" ref"myEntityManagerFactory" />
	</bean>
	
	<jee:jndi-lookup id######"myDataSource" jndi-name"jdbc/myDataSource" resource-ref="true" />
```

Daarna kan je de `entityManager` injecteren in Java:

```java
	@PersistenceContext(unitName = "vdab_partnerwerking_pu")
	protected EntityManager entityManager;
```

######= Werken zonder een persistence.xml ######=

Vanaf **Spring 3.1** en JPA kan je via de factory `packagesToScan` property aangeven ipv via een `persistenceUnitManager` te werken - meer info en context: zie http://www.baeldung.com/2011/12/13/the-persistence-layer-with-spring-3-1-and-jpa/

```xml
	<bean id######"myEntityManagerFactory" class"org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean" parent="entityManagerFactory">
		<property name######"packagesToScan" value"be.klak.domain" />
		<property name######"dataSource" ref"myDataSource" />
	</bean>
```

Vergeet niet de `unitName` van de `PersistenceContext` annotatie af te halen dan.

############ JPA Annotaties en Hibernate HBMs samen gebruiken ############

Een manier om de Hibernate session factory uit de JPA entity manager te prullen:

```java
((org.hibernate.ejb.HibernateEntityManager) entityManagerFactory.createEntityManager()).getSession().getSessionFactory();
```

In Spring config:

```xml
    <bean id######"entityManagerFactory" class"org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean">
        <property name######"dataSource" ref"hospesDS" />
        <property name######"persistenceUnitName" value"hospesPersistenceUnit" />
        <property name="jpaVendorAdapter">
            <bean class="org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter" />
        </property>
        <property name="jpaPropertyMap">
            <map>
                <entry key######"hibernate.dialect" value"org.hibernate.dialect.Oracle9iDialect" />
            </map>
        </property>
    </bean>

    <bean id######"hibernateEntityManager" factory-bean"entityManagerFactory" factory-method######"createEntityManager" class"org.hibernate.ejb.HibernateEntityManager" />
    <bean id######"hibernateSession" factory-bean"hibernateEntityManager" factory-method="getSession" />
    <bean id######"mySessionFactory" factory-bean"hibernateSession" factory-method="getSessionFactory">
        <property name="mappingJarLocations">
            <list>
                <value>classpath:/be/y/persistence/mapping/x.hbm</value>               
            </list>
        </property>     
    </bean>
```