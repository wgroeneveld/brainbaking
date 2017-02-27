+++
title = "vaadin"
draft = false
tags = [
    "code",
    "java",
    "vaadin"
]
date = "2013-03-12"
+++
# Vaadin 7 

## Javascript uitvoeren in de frontent 

```java
@JavaScript({ "https://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js", "js_label.js" })
public class JsLabel extends AbstractJavaScriptComponent {

	public JsLabel(String xhtml) {
		getState().xhtml = xhtml;
	}

	@Override
	protected JsLabelState getState() {
		return (JsLabelState) super.getState();
	}

	public static class JsLabelState extends JavaScriptComponentState {
		public String xhtml;
	}

}
```

en bijbehorende js_label.js file - plaats in `src/main/resources` onder zelfde subdir als package van java file...

```javascript
be_vdab_nonstop_presentation_form_JsLabel = function() {
  var e = this.getElement();
	
  this.onStateChange = function() {
    jQuery(e).html(this.getState().xhtml); 
  }
}
```


## MainUI 

```java
@PreserveOnRefresh
@Theme("yourTheme")
public class MainUI extends UI {
	@Override
	protected final void init(VaadinRequest request) {
		setNavigator(new MyNavigator(this));
		initDefaultScreen();
		getNavigator().navigate();
	}

	private void initDefaultScreen() {
		getNavigator().addView("", BlahScherm.class);
	}

	public void refresh() {
		Component content = getContent();
		setContent(new VerticalLayout());
		setContent(content);
	}

}
```

Waarbij `BlahScherm` `View` implementeert (extends `CustomComponent`)

Parameters van de URL afhalen en afhankelijk daarvan ergens naar navigeren kan gebeuren in `MyNavigator` die extends `Navigator`. In de constructor `addView()` aanroepen (keyvalue pair)

## Utilities om in componenten te zoeken 

```java
public class VaadinUtilties {

	public static <T extends AbstractComponent> T findComponentWithin(HasComponents otherComponent, Class<T> componentClass, String id) {
		return findOnly(otherComponent, componentClass, metId(id));
	}

	public static <E extends Component> E findOnly(HasComponents container, final Class<E> componentClass, Predicate<? super E> predicate) {
		return getOnlyElement(filter(findAll(container, componentClass), predicate));
	}

	public static <E extends Component> E findOnly(HasComponents container, final Class<E> componentClass) {
		return findOnly(container, componentClass, alwaysTrue());
	}

	public static <E extends Component> Set<E> findAll(HasComponents container, Class<E> componentClass) {
		if (container instanceof CustomField) {
			initCustomField((CustomField<?>) container);
		}
		Set<E> result = newHashSet(filter(container, componentClass));
		for (HasComponents subContainer : filter(container, HasComponents.class)) {
			result.addAll(findAll(subContainer, componentClass));
		}
		return result;
	}

	public static void initCustomField(CustomField<?> customField) {
		customField.iterator().next();
	}

	public static boolean isVisibleOnScreen(Component component) {
		return component.isVisible() && parentIsVisible(component);
	}

	private static boolean parentIsVisible(Component component) {
		if (component.getParent() ###### null) {
			return true;
		} else {
			return isVisibleOnScreen(component.getParent());
		}
	}

	public static Predicate<Component> metCaption(final String caption) {
		return new Predicate<Component>() {
			public boolean apply(Component component) {
				return StringUtils.equals(component.getCaption(), caption);
			}
		};
	}

	public static Predicate<Component> captionContains(final String caption) {
		return new Predicate<Component>() {
			public boolean apply(Component component) {
				return StringUtils.contains(component.getCaption(), caption);
			}
		};
	}

	public static Predicate<Label> value(final String value) {
		return new Predicate<Label>() {
			public boolean apply(Label label) {
				return StringUtils.equals(label.getValue(), value);
			}
		};
	}

	public static Predicate<Label> valueContains(final String value) {
		return new Predicate<Label>() {
			public boolean apply(Label label) {
				return StringUtils.contains(label.getValue(), value);
			}
		};
	}

	public static Predicate<Component> metId(final String id) {
		return new Predicate<Component>() {
			public boolean apply(Component component) {
				return StringUtils.equals(component.getId(), id);
			}
		};
	}

}

```