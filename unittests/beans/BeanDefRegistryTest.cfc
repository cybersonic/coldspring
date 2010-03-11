﻿<cfcomponent extends="coldspring.unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup method" access="public" returntype="void" output="false">
	<cfscript>
		var beanCache = createObject("component", "coldspring.beans.factory.BeanCache").init();

		instance.registry = createObject("component", "coldspring.beans.BeanDefinitionRegistry").init(beanCache);
    </cfscript>
</cffunction>

<cffunction name="testContains" hint="testing the contains" access="public" returntype="void" output="false">
	<cfscript>
		var beanDef = createObject("coldspring.beans.support.CFCBeanDefinition").init("foo", "Foo", instance.registry);

		assertFalse(instance.registry.containsBeanDefinition("foo"));

		instance.registry.registerBeanDefinition(beanDef);

		assertTrue(instance.registry.containsBeanDefinition("foo"));

		assertFalse(instance.registry.containsBeanDefinition("foo2"));

		instance.registry.removeBeanDefinition("foo");

		assertFalse(instance.registry.containsBeanDefinition("foo"));
    </cfscript>
</cffunction>

<cffunction name="testCount" hint="testing the contains" access="public" returntype="void" output="false">
	<cfscript>
		var beanDef = createObject("coldspring.beans.support.CFCBeanDefinition").init("foo", "Foo", instance.registry);

		assertEquals(0, instance.registry.getBeanDefinitionCount());

		instance.registry.registerBeanDefinition(beanDef);

		assertEquals(1, instance.registry.getBeanDefinitionCount());

		beanDef = createObject("coldspring.beans.support.CFCBeanDefinition").init("foo2", "Foo", instance.registry);

		instance.registry.registerBeanDefinition(beanDef);

		assertEquals(2, instance.registry.getBeanDefinitionCount());

		instance.registry.removeBeanDefinition("foo");

		assertEquals(1, instance.registry.getBeanDefinitionCount());
    </cfscript>
</cffunction>

<cffunction name="testGetNames" hint="test getting the bean def names" access="public" returntype="void" output="false">
	<cfscript>
		var beanDef = createObject("coldspring.beans.support.CFCBeanDefinition").init("foo", "Foo", instance.registry);
		var names = [];

		assertEquals(names, instance.registry.getBeanDefinitionNames());

		instance.registry.registerBeanDefinition(beanDef);

		names = ["foo"];
		assertEquals(names, instance.registry.getBeanDefinitionNames());

		beanDef = createObject("coldspring.beans.support.CFCBeanDefinition").init("foo2", "Foo", instance.registry);
		instance.registry.registerBeanDefinition(beanDef);

		names = ["foo2", "foo"];
		assertEquals(names, instance.registry.getBeanDefinitionNames());

		instance.registry.removeBeanDefinition("foo");

		names = ["foo2"];
		assertEquals(names, instance.registry.getBeanDefinitionNames());
    </cfscript>
</cffunction>


<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>