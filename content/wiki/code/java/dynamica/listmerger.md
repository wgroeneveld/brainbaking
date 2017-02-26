+++
title = "listmerger"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "java",
    "dynamica",
    "listmerger"
]
date = "2013-03-12"
+++
# code:java:dynamica >> Listmerger 

```java
public final class ListMerger<ItemType, ItemTypeAfterConversion> {

    private final Function<ItemType, ItemTypeAfterConversion> itemConverterFn;

    public ListMerger() {
        this.itemConverterFn = identityFn();
    }

    public ListMerger(Function<ItemType, ItemTypeAfterConversion> itemConverterFn) {
        this.itemConverterFn = itemConverterFn;
    }

    private Function<ItemType, ItemTypeAfterConversion> identityFn() {
        return new Function<ItemType, ItemTypeAfterConversion>() {

            @SuppressWarnings("unchecked")
            @Override
            public ItemTypeAfterConversion apply(ItemType input) {
                return (ItemTypeAfterConversion) input;
            }
        };
    }

    public final void mergeLists(List<? extends ItemType> oldList, List<? extends ItemType> newList, ListMergable<ItemType> mergable) {
        List<ItemTypeAfterConversion> oldTransformed = new ArrayList<ItemTypeAfterConversion>(transform(oldList, itemConverterFn));
        List<ItemTypeAfterConversion> newTransformed = new ArrayList<ItemTypeAfterConversion>(transform(newList, itemConverterFn));

        for (ItemType item : new ArrayList<ItemType>(oldList)) {
            if (!newTransformed.contains(itemConverterFn.apply(item))) {
                mergable.itemHasBeenRemoved(item);
            } else {
                mergable.itemHasBeenChangedInOldList(item);
            }
        }
        for (ItemType item : new ArrayList<ItemType>(newList)) {
            if (!oldTransformed.contains(itemConverterFn.apply(item))) {
                mergable.itemHasBeenAdded(item);
            } else {
                mergable.itemHasBeenChangedInNewList(item);
            }
        }
    }
}
```

En de test:

```java
public class ListMergerTest {

    private AtomicInteger integer = null;
    private AtomicInteger amount = null;

    @Before
    public void setUp() {
        this.integer = new AtomicInteger();
        this.amount = new AtomicInteger(0);
    }

    @Test
    public void noItemsChanged() {
        new ListMerger<Integer, Long>(intToLongFn()).mergeLists(Lists.newArrayList(1, 3), Lists.newArrayList(1, 3), new ListMergable<Integer>() {

            @Override
            public void itemHasBeenRemoved(Integer item) {
                throw new UnsupportedOperationException();
            }

            @Override
            public void itemHasBeenChangedInOldList(Integer item) {
                amount.set(amount.get() + 1);
            }

            @Override
            public void itemHasBeenChangedInNewList(Integer item) {
            }

            @Override
            public void itemHasBeenAdded(Integer item) {
                throw new UnsupportedOperationException();
            }
        });

        assertThat(amount.get()).isEqualTo(2);
    }

    @Test
    public void itemHasBeenAddedUsingIdentity() {
        new ListMerger<Integer, Integer>().mergeLists(Lists.newArrayList(1, 3), Lists.newArrayList(1, 2, 3), new ListMergable<Integer>() {

            @Override
            public void itemHasBeenRemoved(Integer item) {
                throw new UnsupportedOperationException();
            }

            @Override
            public void itemHasBeenChangedInOldList(Integer item) {
            }

            @Override
            public void itemHasBeenChangedInNewList(Integer item) {
            }

            @Override
            public void itemHasBeenAdded(Integer item) {
                integer.set(item);
                amount.set(amount.get() + 1);
            }
        });

        assertThat(amount.get()).isEqualTo(1);
        assertThat(integer.get()).isEqualTo(2);
    }

    @Test
    public void itemHasBeenAdded() {
        new ListMerger<Integer, Long>(intToLongFn()).mergeLists(Lists.newArrayList(1, 3), Lists.newArrayList(1, 2, 3), new ListMergable<Integer>() {

            @Override
            public void itemHasBeenRemoved(Integer item) {
                throw new UnsupportedOperationException();
            }

            @Override
            public void itemHasBeenChangedInOldList(Integer item) {
            }

            @Override
            public void itemHasBeenChangedInNewList(Integer item) {
            }

            @Override
            public void itemHasBeenAdded(Integer item) {
                integer.set(item);
                amount.set(amount.get() + 1);
            }
        });

        assertThat(amount.get()).isEqualTo(1);
        assertThat(integer.get()).isEqualTo(2);
    }

    @Test
    public void itemHasBeenRemovedUsingIdentity() {
        new ListMerger<Integer, Integer>().mergeLists(Lists.newArrayList(1, 3), Lists.newArrayList(1), new ListMergable<Integer>() {

            @Override
            public void itemHasBeenRemoved(Integer item) {
                integer.set(item);
                amount.set(amount.get() + 1);
            }

            @Override
            public void itemHasBeenChangedInOldList(Integer item) {
            }

            @Override
            public void itemHasBeenChangedInNewList(Integer item) {
            }

            @Override
            public void itemHasBeenAdded(Integer item) {
                throw new UnsupportedOperationException();
            }
        });

        assertThat(amount.get()).isEqualTo(1);
        assertThat(integer.get()).isEqualTo(3);
    }

    @Test
    public void itemHasBeenRemoved() {
        new ListMerger<Integer, Long>(intToLongFn()).mergeLists(Lists.newArrayList(1, 2, 3), Lists.newArrayList(1, 3), new ListMergable<Integer>() {

            @Override
            public void itemHasBeenRemoved(Integer item) {
                integer.set(item);
                amount.set(amount.get() + 1);
            }

            @Override
            public void itemHasBeenChangedInOldList(Integer item) {
            }

            @Override
            public void itemHasBeenChangedInNewList(Integer item) {
            }

            @Override
            public void itemHasBeenAdded(Integer item) {
                throw new UnsupportedOperationException();
            }
        });

        assertThat(amount.get()).isEqualTo(1);
        assertThat(integer.get()).isEqualTo(2);
    }

    private Function<Integer, Long> intToLongFn() {
        return new Function<Integer, Long>() {

            @Override
            public Long apply(Integer input) {
                return new Long(input);
            }
        };
    }
}
```

Voorbeeld van gebruik:

```java
        final List<Location> removedLocations = new ArrayList<Location>();
        final List<Location> addedLocations = new ArrayList<Location>();
        new ListMerger<Location, Location>().mergeLists(oldLocations, carpark.getLocations(), new ListMergable<Location>() {

            @Override
            public void itemHasBeenAdded(Location item) {
                addedLocations.add(item);
            }

            @Override
            public void itemHasBeenRemoved(Location item) {
                removedLocations.add(item);
            }

            @Override
            public void itemHasBeenChangedInOldList(Location item) {
            }

            @Override
            public void itemHasBeenChangedInNewList(Location item) {
            }

        });
        if (!removedLocations.isEmpty()) {
            crmImportGatewayService.forDeletion().sendCarparkLocations(carpark, removedLocations);
        }
        if (!addedLocations.isEmpty()) {
            crmImportGatewayService.forCreation().sendCarparkLocations(carpark, addedLocations);
        }

```