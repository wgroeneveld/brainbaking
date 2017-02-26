+++
title = "win32specifics"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "c",
    "win32specifics"
]
date = "2013-12-12"
+++
# code:c >> Win32 API specifics 

#### Get Loaded DLL info from given process 

huidig proces: `GetCurrentProcessId()` - dit is een `HANDLE`. 

```c++
CString ExceptionHandler::GetLoadedDllInfo() const
{
	CString dlls = _T("");
	HANDLE process = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, GetCurrentProcessId());
	if(process ###### NULL)
	{
		return dlls;
	}

	 HMODULE hMods[1024];
	 DWORD cbNeeded;
	 BOOL modules = EnumProcessModules(process, hMods, sizeof(hMods), &cbNeeded);
	 if(!modules)
	 {
		 return dlls;
	 }

	for (int i = 0; i < (cbNeeded / sizeof(HMODULE)); i++)
	{
		TCHAR szModName[MAX_PATH];

		if (GetModuleFileNameEx(process, hMods[i], szModName, sizeof(szModName) / sizeof(TCHAR)))
		{
			dlls.Format(_T("%s, %s"), dlls, szModName);
		}
	}

	CloseHandle(process);
	return dlls;
}
```

Hiervoor moet je `#include <psapi.h>` includen én de psapi.lib file mee linken! Zie [EnumProcessModules MSDN](http://msdn.microsoft.com/en-us/library/windows/desktop/ms682631(v=vs.85).aspx).