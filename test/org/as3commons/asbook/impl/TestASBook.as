package org.as3commons.asbook.impl
{

import org.as3commons.asblocks.IASProject;
import org.as3commons.asblocks.api.IClassType;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IFunctionType;
import org.as3commons.asblocks.api.IInterfaceType;
import org.as3commons.asblocks.api.IType;
import org.as3commons.asbook.api.IASBook;
import org.as3commons.asbook.api.IASBookAccess;
import org.as3commons.asbook.api.ICompilationPackage;
import org.as3commons.asbook.api.ITypeNodePlaceholder;
import org.as3commons.asbuilder.impl.ASBuilderFactory;
import org.flexunit.Assert;

public class TestASBook
{
	private static var TEST_SRC:String = "C:\\dev\\workspace\\opensource\\asbuilder-tests\\src-resource";
	
	private static var factory:ASBuilderFactory;
	
	private static var project:IASProject;
	
	private static var book:IASBook;
	
	private static var access:IASBookAccess;
	
	[BeforeClass]
	public static function setUp():void
	{
		factory = new ASBuilderFactory();
		
		project = factory.newEmptyASProject(".");
		project.addClassPath(TEST_SRC);
		
		project.readAll();
		
		book = factory.newASBook(project);
		book.process();
		access = book.access;
	}
	
	[Test]
	public function testBasicStart():void
	{
		Assert.assertEquals(1, project.classPathEntries.length);
		Assert.assertEquals(15, project.compilationUnits.length); 
	}
	
	[Test]
	public function test_types():void
	{
		var types:Vector.<IType> = access.types;
		var result:Array = sortOn(types, "name");
		
		Assert.assertEquals(15, types.length);
		
		Assert.assertEquals("ADefaultPackageClass", result[0].name);
		Assert.assertEquals("ATestClass", result[1].name);
		Assert.assertEquals("ClassA", result[2].name);
		Assert.assertEquals("ClassB", result[3].name);
		Assert.assertEquals("ClassC", result[4].name);
		Assert.assertEquals("ClassD", result[5].name);
		Assert.assertEquals("ClassE", result[6].name);
		Assert.assertEquals("DefaultDesktopSplash", result[7].name);
		Assert.assertEquals("ICoreInterface", result[8].name);
		Assert.assertEquals("IInterfaceA", result[9].name);
		Assert.assertEquals("IInterfaceB", result[10].name);
		Assert.assertEquals("RestrictedClass", result[11].name);
		Assert.assertEquals("TestProject", result[12].name);
		Assert.assertEquals("TypeClass", result[13].name);
		Assert.assertEquals("functionA", result[14].name);
	}
	
	[Test]
	public function test_classes():void
	{
		var classes:Vector.<IClassType> = access.classes;
		var result:Array = sortOn(classes, "name");
		
		Assert.assertEquals(11, classes.length);
		
		Assert.assertEquals("ADefaultPackageClass", result[0].name);
		Assert.assertEquals("ATestClass", result[1].name);
		Assert.assertEquals("ClassA", result[2].name);
		Assert.assertEquals("ClassB", result[3].name);
		Assert.assertEquals("ClassC", result[4].name);
		Assert.assertEquals("ClassD", result[5].name);
		Assert.assertEquals("ClassE", result[6].name);
		Assert.assertEquals("DefaultDesktopSplash", result[7].name);
		Assert.assertEquals("RestrictedClass", result[8].name);
		Assert.assertEquals("TestProject", result[9].name);
		Assert.assertEquals("TypeClass", result[10].name);
	}
	
	[Test]
	public function test_interfaces():void
	{
		var interfaces:Vector.<IInterfaceType> = access.interfaces;
		var result:Array = sortOn(interfaces, "name");
		
		Assert.assertEquals(3, interfaces.length);
		
		Assert.assertEquals("ICoreInterface", result[0].name);
		Assert.assertEquals("IInterfaceA", result[1].name);
		Assert.assertEquals("IInterfaceB", result[2].name);
	}
	
	[Test]
	public function test_functions():void
	{
		var functions:Vector.<IFunctionType> = access.functions;
		var result:Array = sortOn(functions, "name");
		
		Assert.assertEquals(1, functions.length);
		
		Assert.assertEquals("functionA", result[0].name);
	}
	
	[Test]
	public function test_packages():void
	{
		var packages:Vector.<ICompilationPackage> = access.packages;
		var result:Array = sortOn(packages, "name");
		
		Assert.assertEquals(6, packages.length);
		
		Assert.assertEquals(null, result[0].name);
		Assert.assertEquals("org.example.core", result[1].name);
		Assert.assertEquals("org.example.core.restricted", result[2].name);
		Assert.assertEquals("org.example.impl", result[3].name);
		Assert.assertEquals("org.example.interfaces", result[4].name);
		Assert.assertEquals("org.example.util", result[5].name);
	}
	
	[Test]
	public function test_getCompilationUnit():void
	{
		var unit:ICompilationUnit = access.getCompilationUnit("org.example.core.ClassA");
		
		Assert.assertEquals("org.example.core", unit.packageName);
		Assert.assertEquals("ClassA", unit.typeName);
		Assert.assertEquals("org.example.core.ClassA", unit.qname.qualifiedName);
	}
	
	[Test]
	public function test_getTypes():void
	{
		var vtypes:Vector.<IType> = null;
		var types:Array = null;
		
		vtypes = access.getTypes("org.example.core");
		types = sortOn(vtypes, "name");
		
		Assert.assertNotNull(types);
		Assert.assertEquals(6, types.length);
		
		Assert.assertEquals("org.example.core.ATestClass", types[0].qualifiedName);
		Assert.assertEquals("org.example.core.ClassA", types[1].qualifiedName);
		Assert.assertEquals("org.example.core.ClassB", types[2].qualifiedName);
		Assert.assertEquals("org.example.core.ClassC", types[3].qualifiedName);
		Assert.assertEquals("org.example.core.ICoreInterface", types[4].qualifiedName);
		Assert.assertEquals("org.example.core.functionA", types[5].qualifiedName);
		
		vtypes = access.getTypes("org.example.impl");
		types = sortOn(vtypes, "name");
		
		Assert.assertNotNull(types);
		Assert.assertEquals(3, types.length);
		
		Assert.assertEquals("org.example.impl.ClassE", types[0].qualifiedName);
		Assert.assertEquals("org.example.impl.DefaultDesktopSplash", types[1].qualifiedName);
		Assert.assertEquals("org.example.impl.TypeClass", types[2].qualifiedName);
	}
	
	[Test]
	public function test_getCompilationPackage():void
	{
		var collection:ICompilationPackage = null;
		
		collection = access.getCompilationPackage(null); // toplevel (default)
		Assert.assertNotNull(collection);
		Assert.assertEquals(null, collection.name);
		Assert.assertEquals(2, collection.compilationUnits.length);
		
		collection = access.getCompilationPackage("org.example.core");
		Assert.assertNotNull(collection);
		Assert.assertEquals("org.example.core", collection.name);
		Assert.assertEquals(6, collection.compilationUnits.length);
		
		collection = access.getCompilationPackage("org.example.core.restricted");
		Assert.assertNotNull(collection);
		Assert.assertEquals("org.example.core.restricted", collection.name);
		Assert.assertEquals(1, collection.compilationUnits.length);
		
		collection = access.getCompilationPackage("org.example.impl");
		Assert.assertNotNull(collection);
		Assert.assertEquals("org.example.impl", collection.name);
		Assert.assertEquals(3, collection.compilationUnits.length);
		
		collection = access.getCompilationPackage("org.example.interfaces");
		Assert.assertNotNull(collection);
		Assert.assertEquals("org.example.interfaces", collection.name);
		Assert.assertEquals(2, collection.compilationUnits.length);
		
		collection = access.getCompilationPackage("org.example.util");
		Assert.assertNotNull(collection);
		Assert.assertEquals("org.example.util", collection.name);
		Assert.assertEquals(1, collection.compilationUnits.length);
	}
	
	[Test]
	public function test_getType():void
	{
		var type:IType = access.getType("org.example.core.ClassA");
		Assert.assertNotNull(type);
		Assert.assertEquals("ClassA", type.name);
		Assert.assertEquals("org.example.core", type.packageName);
		Assert.assertEquals("org.example.core.ClassA", type.qualifiedName);
		
		type = access.getType("org.example.Fake");
		Assert.assertNotNull(type);
		Assert.assertTrue((type is ITypeNodePlaceholder));
		Assert.assertEquals("Fake", type.name);
		Assert.assertEquals("org.example", type.packageName);
		Assert.assertEquals("org.example.Fake", type.qualifiedName);
	}
	
	[Test]
	public function test_hasType():void
	{
		Assert.assertTrue(access.hasType("org.example.core.ClassA"));
		Assert.assertFalse(access.hasType("my.domain.Fake"));
	}
	
	[Test]
	public function test_getInnerTypes():void
	{
		// TODO UNIT TEST not implemented
	}
	
	//--------------------------------------------------------------------------
	//
	//  IClassTypeNode
	//
	//--------------------------------------------------------------------------
	
	[Test]
	public function test_getSuperClasses():void
	{
		var element1:IClassType = access.findClassType("org.example.core.ClassA");
		var element2:IClassType = access.findClassType("org.example.core.ClassB");
		var element3:IClassType = access.findClassType("org.example.core.ClassC");
		
		var supers1:Vector.<IType> = access.getSuperClasses(element1);
		Assert.assertNotNull(supers1);
		Assert.assertEquals(1, supers1.length);
		
		Assert.assertEquals("EventDispatcher", supers1[0].name);
		Assert.assertEquals("flash.events", supers1[0].packageName);
		Assert.assertEquals("flash.events.EventDispatcher", supers1[0].qualifiedName);
		Assert.assertEquals("EventDispatcher", supers1[0].name);
		Assert.assertEquals("flash.events", supers1[0].packageName);
		Assert.assertEquals("flash.events.EventDispatcher", supers1[0].qualifiedName);
		
		var supers2:Vector.<IType> = access.getSuperClasses(element2);
		Assert.assertNotNull(supers2);
		Assert.assertEquals(2, supers2.length);
		Assert.assertEquals("org.example.core.ClassA", supers2[0].qualifiedName);
		Assert.assertEquals("flash.events.EventDispatcher", supers2[1].qualifiedName);
		
		var supers3:Vector.<IType> = access.getSuperClasses(element3);
		Assert.assertNotNull(supers3);
		Assert.assertEquals(3, supers3.length);
		Assert.assertEquals("org.example.core.ClassB", supers3[0].qualifiedName);
		Assert.assertEquals("org.example.core.ClassA", supers3[1].qualifiedName);
		Assert.assertEquals("flash.events.EventDispatcher", supers3[2].qualifiedName);
	}
	
	[Test]
	public function test_getSubClasses():void
	{
		var element1:IClassType = access.findClassType("org.example.core.ClassA");
		var element2:IClassType = access.findClassType("org.example.core.ClassB");
		
		var subs1:Vector.<IType> = access.getSubClasses(element1);
		var types:Array = sortOn(subs1, "qualifiedName");
		
		Assert.assertNotNull(subs1);
		Assert.assertEquals(3, subs1.length);
		Assert.assertEquals("org.example.core.ATestClass", types[0].qualifiedName);
		Assert.assertEquals("org.example.core.ClassB", types[1].qualifiedName);
		Assert.assertEquals("org.example.util.ClassD", types[2].qualifiedName);
	}
	
	[Test]
	public function test_getImplementedInterfaces():void
	{
		var element1:IClassType = access.findClassType("org.example.core.ClassA");
		var element2:IClassType = access.findClassType("org.example.util.ClassD");
		
		var imps1:Vector.<IType> = access.getImplementedInterfaces(element1);
		Assert.assertNotNull(imps1);
		Assert.assertEquals(2, imps1.length);
		Assert.assertEquals("org.example.interfaces.IInterfaceA", imps1[0].qualifiedName);
		Assert.assertEquals("org.example.core.ICoreInterface", imps1[1].qualifiedName);
		
		var imps2:Vector.<IType> = access.getImplementedInterfaces(element2);
		Assert.assertNotNull(imps2);
		Assert.assertEquals(1, imps2.length);
		Assert.assertEquals("org.example.interfaces.IInterfaceA", imps2[0].qualifiedName);
	}
	
	[Test]
	public function test_getInterfaceImplementors():void
	{
		var element1:IInterfaceType = access.findInterfaceType("org.example.interfaces.IInterfaceA");
		var element2:IInterfaceType = access.findInterfaceType("org.example.core.ICoreInterface");
		
		Assert.assertEquals("org.example.interfaces.IInterfaceA", element1.qualifiedName);
		Assert.assertEquals("org.example.core.ICoreInterface", element2.qualifiedName);
		
		var imps1:Vector.<IType> = access.getInterfaceImplementors(element1);
		Assert.assertNotNull(imps1);
		Assert.assertEquals(2, imps1.length);
		Assert.assertEquals("org.example.util.ClassD", imps1[0].qualifiedName);
		Assert.assertEquals("org.example.core.ClassA", imps1[1].qualifiedName);
		
		var imps2:Vector.<IType> = access.getInterfaceImplementors(element2);
		Assert.assertNotNull(imps2);
		Assert.assertEquals(1, imps2.length);
		Assert.assertEquals("org.example.core.ClassA", imps2[0].qualifiedName);
	}
	
	[Test]
	public function test_getSuperInterfaces():void
	{
		var element1:IInterfaceType = access.findInterfaceType("org.example.interfaces.IInterfaceA");
		var element2:IInterfaceType = access.findInterfaceType("org.example.interfaces.IInterfaceB");
		var element3:IInterfaceType = access.findInterfaceType("org.example.core.ICoreInterface");
		
		var sups1:Vector.<IType> = access.getSuperInterfaces(element1);
		Assert.assertNotNull(sups1);
		Assert.assertEquals(1, sups1.length);
		Assert.assertEquals("flash.events.IEventDispatcher", sups1[0].qualifiedName);
		
		var sups2:Vector.<IType> = access.getSuperInterfaces(element2);
		Assert.assertNotNull(sups2);
		Assert.assertEquals(0, sups2.length);
		
		var sups3:Vector.<IType> = access.getSuperInterfaces(element3);
		Assert.assertNotNull(sups3);
		Assert.assertEquals(2, sups3.length);
		Assert.assertEquals("org.example.interfaces.IInterfaceA", sups3[0].qualifiedName);
		Assert.assertEquals("org.example.interfaces.IInterfaceB", sups3[1].qualifiedName);
	}
	
	[Test]
	public function test_getSubInterfaces():void
	{
		var element1:IInterfaceType = access.findInterfaceType("org.example.interfaces.IInterfaceA");
		var element2:IInterfaceType = access.findInterfaceType("org.example.interfaces.IInterfaceB");
		var element3:IInterfaceType = access.findInterfaceType("org.example.core.ICoreInterface");
		
		var subs1:Vector.<IType> = access.getSubInterfaces(element1);
		Assert.assertNotNull(subs1);
		Assert.assertEquals(1, subs1.length);
		Assert.assertEquals("org.example.core.ICoreInterface", subs1[0].qualifiedName);
		
		var subs2:Vector.<IType> = access.getSubInterfaces(element2);
		Assert.assertNotNull(subs2);
		Assert.assertEquals(1, subs2.length);
		Assert.assertEquals("org.example.core.ICoreInterface", subs2[0].qualifiedName);
		
		var subs3:Vector.<IType> = access.getSubInterfaces(element3);
		Assert.assertNull(subs3);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Converts vector to an array
	 * @param	vector:*	vector to be converted
	 * @return	Array		converted array
	 */
	public static function vectorToArray(vector:*):Array
	{
		var n:int = vector.length; var a:Array = new Array();
		for(var i:int = 0; i < n; i++) a[i] = vector[i];
		return a;
	}
	/**
	 * Converts vector to an array and sorts it by a certain fieldName, options
	 * for more info @see Array.sortOn
	 * @param	vector:*			the source vector
	 * @param	fieldName:Object	a string that identifies a field to be used as the sort value
	 * @param	options:Object		one or more numbers or names of defined constants
	 */
	public static function sortOn(vector:*, fieldName:Object, options:Object  = null):Array
	{
		return vectorToArray(vector).sortOn(fieldName, options);
	}
}
}