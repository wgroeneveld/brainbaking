+++
title = "webflow"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "jsp",
    "webflow"
]
date = "2013-03-12"
+++
# Spring Webflow 

## Pitfalls rond flow xml declaraties 

Gelieve in het geval van "problemen" de volgende checklist te raadplegen:

  1. bind = false
  2. `setupForm` gedaan? Anders worden `PropertyEditors` niet correct gebruikt
  3. `resetForm` leegmaken gui model
  4. scope opgeven in model attribute 
  5. in action: `setFormObjectName`/`setFormObjectScope` en indien `resetForm` ook `setFormObjectClass`
  6. Ajax requets: `vac_ajax_request` op true zetten -> anders geen fragments
  7. Ajax: extend van `AbstractWebflowAjaxAction` Te combineren met `setFormObjectName` stap
  8. nestedPartialPage tag -> `commandName` ofwel hardcoded ofwel als var vanuit tiles meegegeven

## AbstractWebflowAjaxAction 

```java

package be.oei.webmvc;

import org.springframework.validation.BindingResult;
import org.springframework.validation.DataBinder;
import org.springframework.validation.Errors;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.webflow.action.FormAction;
import org.springframework.webflow.action.FormObjectAccessor;
import org.springframework.webflow.core.collection.MutableAttributeMap;
import org.springframework.webflow.execution.Event;
import org.springframework.webflow.execution.RequestContext;
import org.springframework.webflow.execution.ScopeType;
import org.springframework.webflow.execution.View;

public abstract class AbstractWebFlowAjaxAction extends FormAction {

	protected static final String COMMAND_NAME = "commandName";
	protected static final String ERRORS_PREFIX = BindingResult.MODEL_KEY_PREFIX;

	@Override
	protected final Object getFormObject(RequestContext context) throws Exception {
		String formObjectName = getFormObjectName();
		ScopeType formObjectScope = getFormObjectScope();
		Object result = null;
		if (formObjectName != null) {
			result = formObjectScope.getScope(context).get(formObjectName);
		}
		if (result ###### null) {
			result = ((MutableAttributeMap) context.getFlowScope().get("viewScope")).get("currentFormObject");
		}
		if (result ###### null) {
			result = context.getFlowScope().get("currentFormObject");
		}
		if (result ###### null) {
			result = super.getFormObject(context);
		}
		return result;
	}

	protected final String commandNameFromRequest(RequestContext context) {
		return context.getRequestParameters().get(COMMAND_NAME);
	}

	@Override
	public Event bindAndValidate(RequestContext context) throws Exception {
		Event result = super.bindAndValidate(context);
		initFragmentToRender(context);
		return result;
	}

	@Override
	public Event bind(RequestContext context) throws Exception {
		Event result = super.bind(context);
		this.initFragmentToRender(context);
		return result;
	}

	@Override
	protected DataBinder createBinder(RequestContext context, Object formObject) throws Exception {
		DataBinder binder = new WebDataBinder(formObject, commandNameFromRequest(context));
		if (getMessageCodesResolver() != null) {
			binder.setMessageCodesResolver(getMessageCodesResolver());
		}
		initBinder(context, binder);
		registerPropertyEditors(context, binder);
		return binder;
	}

	@Override
	protected FormObjectAccessor getFormObjectAccessor(final RequestContext context) {
		final String commandNameFromRequest = commandNameFromRequest(context);
		return new FormObjectAccessor(context) {
			@Override
			public Errors getFormErrors(String formObjectName, ScopeType scopeType) {
				return super.getFormErrors(commandNameFromRequest, scopeType);
			}

			@Override
			public Object getFormObject(String formObjectName, @SuppressWarnings("rawtypes") Class formObjectClass, ScopeType scopeType) {
				return super.getFormObject(commandNameFromRequest, formObjectClass, scopeType);
			}

			@Override
			public Object getFormObject(String formObjectName, ScopeType scopeType) {
				return super.getFormObject(commandNameFromRequest, scopeType);
			}

			@Override
			public Object getCurrentFormObject(ScopeType scopeType) {
				return super.getFormObject(getCurrentFormObjectName(), scopeType);
			}

			@Override
			public Errors getCurrentFormErrors(ScopeType scopeType) {
				return super.getFormErrors(getCurrentFormObjectName(), scopeType);
			}

			@Override
			public void putFormObject(Object formObject, String formObjectName, ScopeType scopeType) {
				super.putFormObject(formObject, commandNameFromRequest, scopeType);
			}

			@Override
			public void putFormErrors(Errors errors, ScopeType scopeType) {
				scopeType.getScope(context).put(ERRORS_PREFIX + commandNameFromRequest, errors);
				setCurrentFormErrors(errors, scopeType);
			}

		};
	}

	protected void initFragmentToRender(RequestContext context) {
		context.getFlashScope().put(View.RENDER_FRAGMENTS_ATTRIBUTE, new String[] { fragmentToRender() });
		context.getFlashScope().put(COMMAND_NAME, commandNameFromRequest(context));
	}

	protected abstract String fragmentToRender();

}
```