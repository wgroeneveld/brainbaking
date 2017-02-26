+++
title = "mfc"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "c",
    "mfc"
]
date = "2013-12-12"
+++
# MFC 

:exclamation: MFC en AFX [is hetzelfde](http://en.wikipedia.org/wiki/Microsoft_Foundation_Class_Library):

> One interesting quirk of MFC is the use of "Afx" as the prefix for many functions, macros and the standard precompiled header name "stdafx.h". During early development what became MFC was called "Application Framework Extensions" and abbreviated "Afx". The name Microsoft Foundation Classes (MFC) was adopted too late in the release cycle to change these references

### Strings in MFC 

Gebruik `CString` - werkt niet op non-win32 omgevingen.

##### Formatting 

Formatten kan bijvoorbeeld met `string.Format(_T("%s in %d"), otherString, otherDecimal);`

:exclamation: Om een string te intialiseren en toe te kennen moet je wel de `_T` macro gebruiken

##### Substringen 

`Find` is hetzelfde als `indexOf` in andere talen. 

```c++
CString HostServiceProxy::GetCouponFromResponseString(CString response)
{
	CString couponKey ###### _T("Coupon");
	CString couponPart = response.Mid(response.Find(couponKey) + couponKey.GetLength());

	return couponPart.Left(couponPart.Find(_T(";")));
}
```

### Resource handling 

Icons en images worden opgeslagen in .rc files die als resources in de code gekoppeld kunnen worden aan bijvoorbeeld een `CButton`. Hoe? 

```c
	HANDLE hImage = ::LoadImage(AfxGetResourceHandle(), MAKEINTRESOURCE(resourceId), IMAGE_ICON, 16, 15, LR_DEFAULTCOLOR);
	if(hImage ###### NULL)
		ASSERT(FALSE);	

	HICON image = static_cast<HICON>(hImage);
```

`HICON` is van `WinDef.h` en `::LoadImage` zit op `WinUser.h`. Zie [MSDN doc](http://msdn.microsoft.com/en-us/library/windows/desktop/ms648045(v=vs.85).aspx) voor LoadImage. 

######= De juiste resource handle vastkrijgen ######=

Als je een MFC DLL maakt, gaat `AfxGetResourceHandle()` verwijzen naar de resource handle van uw DLL zelf. Als je dus resources wil vastpakken van een andere DLL heb je pech. Als je geen MFC DLL maakt kan je dit aanpassen met ` AFX_MANAGE_STATE(AfxGetStaticModuleState( ))`. **Dit gooit echter linking errors** ( error LNK2005: _DllMain@12 already defined) indien je dit vanuit een MFC DLL aanroept - dan is dit niet nodig. 

Meer uitleg hierover: zie http://support.microsoft.com/kb/161589

:exclamation: de Afx resource handle kan **altijd** gewijzigd worden door leuke dingen te doen als:

```c
	HINSTANCE old = AfxGetResourceHandle();
	AfxSetResourceHandle(GetModuleHandle("andereModule"));
```

Gebruik daarom best `::GetModuleHandle(char*)` bij `::LoadImage`. 

######= Resources op het juiste moment terug vrijgeven ######=

Resources worden meestal gewrapped in kleine objectjes die bij de constructor de resource alloceren en bij de destructor deze terug vrijgeven in plaats van in `try { ... }` zoiets te moeten doen in Java. Dit pattern is [RAII](http://en.wikipedia.org/wiki/Resource_Acquisition_Is_Initialization) of "Resource Acquisition Is Initialization". Voorbeeld:

```c
template<class TObject>
class RAIIObject
{
public:
	explicit RAIIObject(const TObject& obj) : m_Object(obj) {}
	RAIIObject() {}
	~RAIIObject() {ReleaseObject();}
	RAIIObject<TObject>& operator######(const TObject& obj) {if(&obj ! &m_Object) {ReleaseObject(); m_Object = obj;} return *this;}
	RAIIObject<TObject>& operator######(const RAIIObject<TObject>& obj) {if(&obj ! this) {ReleaseObject(); m_Object = obj;} return *this;}
	TObject& GetObject() {return m_Object;}
	const TObject& GetObject() const {return m_Object;}
	operator TObject&() {return m_Object;}
	operator const TObject&() const {return m_Object;}
private:
	void ReleaseObject();
	TObject m_Object;
};

template<> inline void RAIIObject<HICON>::ReleaseObject() {::DestroyIcon(m_Object); m_Object = NULL;}
template<> inline void RAIIObject<CBrush>::ReleaseObject() {m_Object.DeleteObject();}
template<> inline void RAIIObject<CBitmap>::ReleaseObject() {m_Object.DeleteObject();}
template<> inline void RAIIObject<CFont>::ReleaseObject() {m_Object.DeleteObject();}
template<> inline void RAIIObject<CMenu>::ReleaseObject() {m_Object.DestroyMenu();}
```