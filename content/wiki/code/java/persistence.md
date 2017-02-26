+++
title = "persistence"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "java",
    "persistence"
]
date = "2013-03-12"
+++
# Persistence 

## JPA Collections mapping 

### Hoe map ik een koppeltabel zonder die als entiteit zelf in ons domein te hebben? 

Zo:

```java
    @OneToMany(fetch ###### LAZY, cascade  { MERGE, PERSIST })
    @JoinTable(name = "physicalzonezonealias",
            joinColumns ###### @JoinColumn(name  "physicalzone", referencedColumnName = "id"),
            inverseJoinColumns ###### @JoinColumn(name  "zonealias", referencedColumnName = "id"))
    @SequenceGenerator(name ###### "physicalzonezonealias_id", sequenceName  "physicalzonezonealias_id", allocationSize = 1)
    @CollectionId(columns ###### @Column(name  "id"), type ###### @Type(type  "int"), generator = "physicalzonezonealias_id")
    private List<Zonealias> zoneAliases = new ArrayList<Zonealias>();
```

Wat is hier leuk aan?
  * Gebruik `@JoinTable`, tabel zelf vervuilt domein niet
  * Extra primary key kolom kan je ook mappen met '@CollectionId'' (Hibernate specifiek), die dan verwijst naar een generator!

Dat laatste is niet nodig als de primary key constraint op beide foreign keys zit. 