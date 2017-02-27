+++
title = "utils"
draft = false
tags = [
    "code",
    "java",
    "utils"
]
date = "2013-03-12"
+++
# Utility methods 

## SetUtils 

```java
public class SetUtil {

	public static <T> Set<T> asSet(T... elements) {
		return new HashSet<T>(Arrays.asList(elements));
	}

	public static <T> boolean bevat(Set<T> someSet, Predicate<T> predicate) {
		return !Sets.filter(someSet, predicate).isEmpty();
	}

	public static <E> Set<E> cast(Set<?> someSet, Class<E> classToCastTo) {
		Set<E> newSet = new LinkedHashSet<E>();
		for (Object object : someSet) {
			newSet.add(classToCastTo.cast(object));
		}
		return newSet;
	}
}
```

## ListUtils 

```java
public class ListUtil {

	public static <T> List<T> sort(Collection<T> collection, Comparator<? super T> comparator) {
		List<T> toSort = new ArrayList<T>(collection);
		Collections.sort(toSort, comparator);
		return toSort;
	}

	public static boolean bevatDubbels(List<?> aList) {
		return Sets.newHashSet(aList).size() != aList.size();
	}

	public static <T> List<T> cast(List<?> aList, Class<T> clazz) {
		List<T> result = new ArrayList<T>();
		for (Object obj : aList) {
			result.add(clazz.cast(obj));
		}
		return result;
	}

}

```
