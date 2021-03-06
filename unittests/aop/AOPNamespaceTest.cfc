﻿<!---
   Copyright 2010 Mark Mandel
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at
       http://www.apache.org/licenses/LICENSE-2.0
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
 --->

<cfcomponent hint="Tests for aop namespace xml config of AOP" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup method" access="public" returntype="any" output="false">
	<cfscript>
    </cfscript>
</cffunction>

<cffunction name="testReverseAnnotationAdvisor" hint="test simple reverse advice with a annotation based advisor" access="public" returntype="void" output="false">
	<cfscript>
		var factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/aop-namespace-advisor.xml"));

		var local = {};

		local.proxy = factory.getBean("hello");

		local.value = local.proxy.sayHello();
		assertEquals("hello", local.value);

		assertEquals(reverse("Goodbye"), local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(local.string, local.proxy.sayHello(local.string));
    </cfscript>
</cffunction>

<cffunction name="testReverseAspect" hint="test simple reverse advice with an Aspect" access="public" returntype="void" output="false">
	<cfscript>
		var factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/aop-namespace-aspect.xml"));

		var local = {};

		local.proxy = factory.getBean("hello");

		local.value = local.proxy.sayHello();
		assertEquals("hello", local.value);

		assertEquals(reverse("Goodbye"), local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(local.string, local.proxy.sayHello(local.string));

		local.proxy = factory.getBean("helloNotWork");

		local.value = local.proxy.sayHello();
		assertEquals("hello", local.value);

		local.value = local.proxy.sayGoodbye();
		assertEquals("Goodbye", local.proxy.sayGoodbye());
    </cfscript>
</cffunction>

<cffunction name="testGetAspectByid" hint="test retrieving aspects by their ID" access="public" returntype="void" output="false">
	<cfscript>
		var factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/aop-namespace-aspect.xml"));

		var local = {};

		local.reverseAdvice = factory.getBean("reverseAdvice");

		debug(local.reverseAdvice);

		local.afterReturnStorage = factory.getBean("afterReturnStorage");

		debug(local.afterReturnStorage);
    </cfscript>
</cffunction>

<cffunction name="testBeforeAspect" hint="tests the before aspect" access="public" returntype="void" output="false">
	<cfscript>
		var factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/aop-namespace-aspect.xml"));
		var local = {};

		local.proxy = factory.getBean("hello");
		local.storeArguments = factory.getBean("storage");

		assertFalse(local.storeArguments.hasArgs());

		local.value = local.proxy.sayHello();

		assertTrue(local.storeArguments.hasArgs());
		assertTrue(structIsEmpty(local.storeArguments.getArgs()));

		local.proxy.sayHello("hello");

		local.args = { 1="hello" };

		local.storedArgs = local.storeArguments.getArgs();

		//something weird is going on in the .toString that mxunit uses
		//assertEquals(local.args, local.storeArguments.getArgs());
		assertEquals(structKeyList(local.args), structKeyList(local.storedArgs));

		for(local.key in local.storedArgs)
		{
			assertEquals(local.args[local.key], local.storedArgs[local.key]);
		}
    </cfscript>
</cffunction>

<cffunction name="testReturnAspect" hint="tests returning aspects" access="public" returntype="void" output="false">
	<cfscript>
		var factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/aop-namespace-aspect.xml"));
		var local = {};

		local.proxy = factory.getBean("hello");
		local.storeArguments = factory.getBean("storage");

		assertFalse(local.storeArguments.hasReturn());

		local.value = local.proxy.sayHello();

		assertEquals("hello", local.value);

		assertTrue(local.storeArguments.hasReturn());
		assertEquals("hello", local.storeArguments.getReturn());

		local.value = local.proxy.sayGoodbye();

		assertEquals(reverse("Goodbye"), local.value);
		assertEquals(reverse("Goodbye"), local.storeArguments.getReturn());
    </cfscript>
</cffunction>

<cffunction name="testExceptionAspect" hint="tests exception aspects" access="public" returntype="void" output="false">
	<cfscript>
		var factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/aop-namespace-aspect.xml"));
		var local = {};

		local.proxy = factory.getBean("hello");
		local.storage = factory.getBean("storage");

		assertFalse(local.storage.hasException());

		try
		{
			local.proxy.sayHello("exceptionFoo");
		}
		catch(exceptionFoo exc)
		{
			assertTrue(local.storage.hasException());
			assertEquals(exc.message, local.storage.$getException().message);
			assertEquals(exc.type, local.storage.$getException().type);
		}
    </cfscript>
</cffunction>

<cffunction name="testExceptionAdvisor" hint="tests exception aspects" access="public" returntype="void" output="false">
	<cfscript>
		var factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/aop-namespace-aspect.xml"));
		var local = {};

		local.proxy = factory.getBean("hello");
		local.storage = factory.getBean("exceptionStorage");

		try
		{
			local.proxy.sayHello("exceptionFoo");
		}
		catch(exceptionFoo exc)
		{
			assertEquals(exc.message, local.storage.$getException().message);
			assertEquals(exc.type, local.storage.$getException().type);
		}
    </cfscript>
</cffunction>

<cffunction name="testNotBeforeAspect" hint="tests the before aspect" access="public" returntype="void" output="false">
	<cfscript>
		var factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/aop-namespace-aspect.xml"));
		var local = {};

		local.proxy = factory.getBean("hello");
		local.storeArguments = factory.getBean("Notstorage");

		assertFalse(local.storeArguments.hasArgs());

		local.proxy.sayHello();

		assertFalse(local.storeArguments.hasArgs());
    </cfscript>
</cffunction>

<cffunction name="testNotReturnAspect" hint="tests returning aspects" access="public" returntype="void" output="false">
	<cfscript>
		var factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/aop-namespace-aspect.xml"));
		var local = {};

		local.proxy = factory.getBean("hello");
		local.storeArguments = factory.getBean("notStorage");

		assertFalse(local.storeArguments.hasReturn());

		local.proxy.sayHello();

		assertFalse(local.storeArguments.hasReturn());
    </cfscript>
</cffunction>

<cffunction name="testNotExceptionAspect" hint="tests exception aspects" access="public" returntype="void" output="false">
	<cfscript>
		var factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/aop-namespace-aspect.xml"));
		var local = {};

		local.proxy = factory.getBean("hello");
		local.storage = factory.getBean("notstorage");

		assertFalse(local.storage.hasException());

		try
		{
			local.proxy.sayHello("exceptionFoo");
		}
		catch(exceptionFoo exc)
		{
			assertFalse(local.storage.hasException());
		}
    </cfscript>
</cffunction>

<cffunction name="testReverseFromFactoryAspect" hint="test simple reverse advice with an Aspect" access="public" returntype="void" output="false">
	<cfscript>
		var factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/aop-namespace-aspect.xml"));

		var local = {};

		local.proxy = factory.getBean("hello-from-factory");

		local.value = local.proxy.sayHello();
		assertEquals("hello", local.value);

		assertEquals(reverse("Goodbye"), local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(local.string, local.proxy.sayHello(local.string));
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>