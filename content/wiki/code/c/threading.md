+++
title = "threading"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "c",
    "threading"
]
date = "2013-12-02"
+++
# Threading 

Handige links:

  1. [Thread synchronization for beginners](http://www.codeproject.com/Articles/7953/Thread-Synchronization-for-Beginners)

## Thread-safe Singleton pattern 

Bijna onmogelijk in C++ < v11 blijkbaar? 

Onderstaand voorbeeld gebruikt Win32 code (`WaitForSingleObject`) en een mutex om te wachten:

```c++
#pragma once
#include <WinBase.h>

class AddinProcessService 
{
    static AddinProcessService *singletonInstance;
	AddinProcessService() : m_coupon(_T("")), m_hostServiceAddress(_T("")) {}

  public:

	inline const CString& GetHostServiceAddress() const
	{
		return m_hostServiceAddress;
	}
	inline const CString& GetCoupon() const
	{
		return m_coupon;
	}
	inline void SetCoupon(CString coupon)
	{
		m_coupon = coupon;
	}
	inline void SetHostServiceAddress(CString address) 
	{
		m_hostServiceAddress = address;
	}

    static AddinProcessService* getSingletonInstance()
    {
		static volatile int initialized = 0;
		static HANDLE mtx;

		if (!initialized)
		{
    		if (!mtx)
    		{
    			HANDLE mymtx;
    			mymtx = CreateMutex(NULL, 0, NULL);
    			if (InterlockedCompareExchangePointer(&mtx, mymtx, NULL) != NULL)
    				CloseHandle(mymtx);
    		}

    		WaitForSingleObject(mtx, 0);
    		if (!initialized)
    		{
    			libInitInternal();
    			initialized = 1;
    		}
    		ReleaseMutex(mtx);
		}
		return singletonInstance;
    };

private:
	CString m_hostServiceAddress;
	CString m_coupon;

	static void libInitInternal()
	{
		singletonInstance = new AddinProcessService();
	}
};

```

:exclamation: Vergeet niet in de cpp file uw singletonInstance pointer te declareren, anders krijg je linker errors: `AddinProcessService* AddinProcessService::singletonInstance;`

In UNIX kan men [pthreads](https://computing.llnl.gov/tutorials/pthreads/) gebruiken, ongeveer op deze manier:

```c++
static Foo &getInst()
{
  static Foo *inst = NULL;
  if(inst ###### NULL)
  {
    pthread_mutex_lock(&mutex);
    if(inst ###### NULL)
      inst = new Foo(...);
    pthread_mutex_unlock(&mutex);
  }
  return *inst;    
}
```

Dan kan je `#ifdef WIN32` gebruiken om te switchen tussen beide implementaties.

############ C++ 11 multithreading ############

Vanaf C++ 11 zijn multithreads 100% native supported, dit wil zeggen dat manueel locken met een `mutex` overbodig wordt. Bovenstaande singleton kan gereduceerd worden tot (merk het **static** keyword op, dat is het belangrijkste voor de autolock):

```c++
static Singleton& get(){
  static Singleton instance;
  return instance;
}
```

Voor meer info, zie http://stackoverflow.com/questions/11711920/how-to-implement-multithread-safe-singleton-in-c11-without-using-mutex