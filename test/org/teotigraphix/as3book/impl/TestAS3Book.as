package org.teotigraphix.as3book.impl
{

import flash.filesystem.File;

import flexunit.framework.Assert;

import org.teotigraphix.as3book.api.IAS3Book;
import org.teotigraphix.as3book.api.IAS3BookAccessor;
import org.teotigraphix.as3nodes.api.IAccessorNode;
import org.teotigraphix.as3nodes.api.IAttributeNode;
import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.IConstantNode;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IInterfaceTypeNode;
import org.teotigraphix.as3nodes.api.IMethodNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.api.ISourceFilePackage;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.ITypeNodePlaceholder;
import org.teotigraphix.as3nodes.impl.NodeFactory;
import org.teotigraphix.as3nodes.impl.SourceFile;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.utils.FileUtil;

public class TestAS3Book extends AbstractElementTest
{
	private var classA:ISourceFile;
	
	private var accessor:IAS3BookAccessor;
	
	
	[BeforeClass]
	public static function initTest():void
	{
		book = BookFactory.instance.createBook();
		
		book.addSourceFile(parse(ClassA));
		book.addSourceFile(parse(functionA));
		book.addSourceFile(parse(ADefaultPackageClass));
		book.addSourceFile(parse(RestrictedClass));
		book.addSourceFile(parse(ClassB));
		book.addSourceFile(parse(ClassC));
		book.addSourceFile(parse(ClassD));
		book.addSourceFile(parse(ClassE));
		book.addSourceFile(parse(ICoreInterface));
		book.addSourceFile(parse(InterfaceA));
		book.addSourceFile(parse(InterfaceB));
		book.addSourceFile(parse(TypeClass));
		book.addSourceFile(parse(TestProject));
		
		book.process();
	}

	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		accessor = book.access;
	}

	
	//--------------------------------------------------------------------------
	//
	//  ICompilationPackage
	//
	//--------------------------------------------------------------------------
	
	[Test]
	public function test_render_AllPackages_AllClasses():void
	{
		// "All Packages" frame
		//var cpackages:Vector.<ISourceFileCollection> = accessor.sourceFileCollections;
		
		var sfiles:Array = sortOn(accessor.sourceFilePackages, "name");
		
		Assert.assertEquals(6, sfiles.length);
		
		Assert.assertEquals("", sfiles[0].name); // toplevel
		Assert.assertEquals("org.example.core", sfiles[1].name);
		Assert.assertEquals("org.example.core.restricted", sfiles[2].name);
		Assert.assertEquals("org.example.impl", sfiles[3].name);
		Assert.assertEquals("org.example.interfaces", sfiles[4].name);
		Assert.assertEquals("org.example.util", sfiles[5].name);
		
		var ctypes:Array = sortOn(accessor.classTypes, "name");
		
		Assert.assertEquals(9, ctypes.length);
		Assert.assertEquals("ADefaultPackageClass", ctypes[0].name);
		Assert.assertEquals("ClassA", ctypes[1].name);
		Assert.assertEquals("ClassB", ctypes[2].name);
		Assert.assertEquals("ClassC", ctypes[3].name);
		Assert.assertEquals("ClassD", ctypes[4].name);
		Assert.assertEquals("ClassE", ctypes[5].name);
		Assert.assertEquals("RestrictedClass", ctypes[6].name);
		Assert.assertEquals("TestProject", ctypes[7].name);
		Assert.assertEquals("TypeClass", ctypes[8].name);
		
		var itypes:Array = sortOn(accessor.interfaceTypes, "name");
		
		Assert.assertEquals(3, itypes.length);
		Assert.assertEquals("ICoreInterface", itypes[0].name);
		Assert.assertEquals("IInterfaceA", itypes[1].name);
		Assert.assertEquals("IInterfaceB", itypes[2].name);
		
		var ftypes:Array = sortOn(accessor.functionTypes, "name");
		
		Assert.assertEquals(1, ftypes.length);
		Assert.assertEquals("functionA", ftypes[0].name);
		
		// "All Classes" frame
		var types:Array = sortOn(accessor.types, "name");
		
		Assert.assertEquals(13, types.length);
		Assert.assertEquals("ADefaultPackageClass", types[0].name);
		Assert.assertEquals("ClassA", types[1].name);
		Assert.assertEquals("ClassB", types[2].name);
		Assert.assertEquals("ClassC", types[3].name);
		Assert.assertEquals("ClassD", types[4].name);
		Assert.assertEquals("ClassE", types[5].name);
		Assert.assertEquals("ICoreInterface", types[6].name);
		Assert.assertEquals("IInterfaceA", types[7].name);
		Assert.assertEquals("IInterfaceB", types[8].name);
		Assert.assertEquals("RestrictedClass", types[9].name);
		Assert.assertEquals("TestProject", types[10].name);
		Assert.assertEquals("TypeClass", types[11].name);
		Assert.assertEquals("functionA", types[12].name);
	}
	
	[Test]
	public function test_getTypes():void
	{
		var vtypes:Vector.<ITypeNode> = null;
		var types:Array = null;
		
		vtypes = accessor.getTypes("org.example.core");
		types = sortOn(vtypes, "name");
		
		Assert.assertNotNull(types);
		Assert.assertEquals(5, types.length);
		
		Assert.assertEquals("org.example.core.ClassA", types[0].qualifiedName);
		Assert.assertEquals("org.example.core.ClassB", types[1].qualifiedName);
		Assert.assertEquals("org.example.core.ClassC", types[2].qualifiedName);
		Assert.assertEquals("org.example.core.ICoreInterface", types[3].qualifiedName);
		Assert.assertEquals("org.example.core.functionA", types[4].qualifiedName);
		
		vtypes = accessor.getTypes("org.example.impl");
		types = sortOn(vtypes, "name");
		
		Assert.assertNotNull(types);
		Assert.assertEquals(2, types.length);
		
		Assert.assertEquals("org.example.impl.ClassE", types[0].qualifiedName);
		Assert.assertEquals("org.example.impl.TypeClass", types[1].qualifiedName);
	}
	
	[Test]
	public function test_getSourceFileCollection():void
	{
		var collection:ISourceFilePackage = null;
		
		collection = accessor.getSourceFilePackage(""); // toplevel (default)
		Assert.assertNotNull(collection);
		Assert.assertEquals("", collection.name);
		
		collection = accessor.getSourceFilePackage("org.example.core");
		Assert.assertNotNull(collection);
		Assert.assertEquals("org.example.core", collection.name);
		
		collection = accessor.getSourceFilePackage("org.example.core.restricted");
		Assert.assertNotNull(collection);
		Assert.assertEquals("org.example.core.restricted", collection.name);
		
		collection = accessor.getSourceFilePackage("org.example.impl");
		Assert.assertNotNull(collection);
		Assert.assertEquals("org.example.impl", collection.name);
		
		collection = accessor.getSourceFilePackage("org.example.interfaces");
		Assert.assertNotNull(collection);
		Assert.assertEquals("org.example.interfaces", collection.name);
		
		collection = accessor.getSourceFilePackage("org.example.util");
		Assert.assertNotNull(collection);
		Assert.assertEquals("org.example.util", collection.name);
	}
	
	[Test]
	public function test_sourceFilePackages():void
	{
		Assert.assertNotNull(accessor.sourceFilePackages);
		Assert.assertEquals(numPackages, accessor.sourceFilePackages.length);
	}
	
	[Test]
	public function test_getType():void
	{
		var type:ITypeNode = accessor.getType("org.example.core.ClassA");
		Assert.assertNotNull(type);
		Assert.assertEquals("ClassA", type.name);
		Assert.assertEquals("org.example.core", type.packageName);
		Assert.assertEquals("org.example.core.ClassA", type.qualifiedName);
		
		type = accessor.getType("org.example.Fake");
		Assert.assertNotNull(type);
		Assert.assertTrue((type is ITypeNodePlaceholder));
		Assert.assertEquals("Fake", type.name);
		Assert.assertEquals("org.example", type.packageName);
		Assert.assertEquals("org.example.Fake", type.qualifiedName);
	}
	
	[Test]
	public function test_hasType():void
	{
		Assert.assertTrue(accessor.hasType("org.example.core.ClassA"));
		Assert.assertFalse(accessor.hasType("my.domain.Fake"));
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
		var element1:IClassTypeNode = accessor.findClassType("org.example.core.ClassA");
		var element2:IClassTypeNode = accessor.findClassType("org.example.core.ClassB");
		var element3:IClassTypeNode = accessor.findClassType("org.example.core.ClassC");
		
		var supers1:Vector.<ITypeNode> = accessor.getSuperClasses(element1);
		Assert.assertNotNull(supers1);
		Assert.assertEquals(1, supers1.length);
		
		Assert.assertEquals("EventDispatcher", supers1[0].name);
		Assert.assertEquals("flash.events", supers1[0].packageName);
		Assert.assertEquals("flash.events.EventDispatcher", supers1[0].qualifiedName);
		Assert.assertEquals("EventDispatcher", supers1[0].uid.localName);
		Assert.assertEquals("flash.events", supers1[0].uid.packageName);
		Assert.assertEquals("flash.events.EventDispatcher", supers1[0].uid.qualifiedName);
		
		var supers2:Vector.<ITypeNode> = accessor.getSuperClasses(element2);
		Assert.assertNotNull(supers2);
		Assert.assertEquals(2, supers2.length);
		Assert.assertEquals("org.example.core.ClassA", supers2[0].qualifiedName);
		Assert.assertEquals("flash.events.EventDispatcher", supers2[1].qualifiedName);
		
		var supers3:Vector.<ITypeNode> = accessor.getSuperClasses(element3);
		Assert.assertNotNull(supers3);
		Assert.assertEquals(3, supers3.length);
		Assert.assertEquals("org.example.core.ClassB", supers3[0].qualifiedName);
		Assert.assertEquals("org.example.core.ClassA", supers3[1].qualifiedName);
		Assert.assertEquals("flash.events.EventDispatcher", supers3[2].qualifiedName);
	}
	
	[Test]
	public function test_getSubClasses():void
	{
		var element1:IClassTypeNode = accessor.findClassType("org.example.core.ClassA");
		var element2:IClassTypeNode = accessor.findClassType("org.example.core.ClassB");
		
		var subs1:Vector.<ITypeNode> = accessor.getSubClasses(element1);
		Assert.assertNotNull(subs1);
		Assert.assertEquals(2, subs1.length);
		Assert.assertEquals("org.example.core.ClassB", subs1[0].qualifiedName);
		Assert.assertEquals("org.example.util.ClassD", subs1[1].qualifiedName);
	}
	
	[Test]
	public function test_getImplementedInterfaces():void
	{
		var element1:IClassTypeNode = accessor.findClassType("org.example.core.ClassA");
		var element2:IClassTypeNode = accessor.findClassType("org.example.util.ClassD");
		
		var imps1:Vector.<ITypeNode> = accessor.getImplementedInterfaces(element1);
		Assert.assertNotNull(imps1);
		Assert.assertEquals(2, imps1.length);
		Assert.assertEquals("org.example.interfaces.IInterfaceA", imps1[0].qualifiedName);
		Assert.assertEquals("org.example.core.ICoreInterface", imps1[1].qualifiedName);
		
		var imps2:Vector.<ITypeNode> = accessor.getImplementedInterfaces(element2);
		Assert.assertNotNull(imps2);
		Assert.assertEquals(1, imps2.length);
		Assert.assertEquals("org.example.interfaces.IInterfaceA", imps2[0].qualifiedName);
	}
	
	[Test]
	public function test_getInterfaceImplementors():void
	{
		var element1:IInterfaceTypeNode = accessor.findInterfaceType("org.example.interfaces.IInterfaceA");
		var element2:IInterfaceTypeNode = accessor.findInterfaceType("org.example.core.ICoreInterface");
		
		Assert.assertEquals("org.example.interfaces.IInterfaceA", element1.toLink());
		Assert.assertEquals("org.example.core.ICoreInterface", element2.toLink());
		
		var imps1:Vector.<ITypeNode> = accessor.getInterfaceImplementors(element1);
		Assert.assertNotNull(imps1);
		Assert.assertEquals(2, imps1.length);
		Assert.assertEquals("org.example.core.ClassA", imps1[0].qualifiedName);
		Assert.assertEquals("org.example.util.ClassD", imps1[1].qualifiedName);
		
		var imps2:Vector.<ITypeNode> = accessor.getInterfaceImplementors(element2);
		Assert.assertNotNull(imps2);
		Assert.assertEquals(1, imps2.length);
		Assert.assertEquals("org.example.core.ClassA", imps2[0].qualifiedName);
	}
	
	[Test]
	public function test_getSuperInterfaces():void
	{
		var element1:IInterfaceTypeNode = accessor.findInterfaceType("org.example.interfaces.IInterfaceA");
		var element2:IInterfaceTypeNode = accessor.findInterfaceType("org.example.interfaces.IInterfaceB");
		var element3:IInterfaceTypeNode = accessor.findInterfaceType("org.example.core.ICoreInterface");
		
		var sups1:Vector.<ITypeNode> = accessor.getSuperInterfaces(element1);
		Assert.assertNotNull(sups1);
		Assert.assertEquals(1, sups1.length);
		Assert.assertEquals("flash.events.IEventDispatcher", sups1[0].qualifiedName);
		
		var sups2:Vector.<ITypeNode> = accessor.getSuperInterfaces(element2);
		Assert.assertNotNull(sups2);
		Assert.assertEquals(0, sups2.length);
		
		var sups3:Vector.<ITypeNode> = accessor.getSuperInterfaces(element3);
		Assert.assertNotNull(sups3);
		Assert.assertEquals(2, sups3.length);
		Assert.assertEquals("org.example.interfaces.IInterfaceA", sups3[0].qualifiedName);
		Assert.assertEquals("org.example.interfaces.IInterfaceB", sups3[1].qualifiedName);
	}
	
	[Test]
	public function test_getSubInterfaces():void
	{
		var element1:IInterfaceTypeNode = accessor.findInterfaceType("org.example.interfaces.IInterfaceA");
		var element2:IInterfaceTypeNode = accessor.findInterfaceType("org.example.interfaces.IInterfaceB");
		var element3:IInterfaceTypeNode = accessor.findInterfaceType("org.example.core.ICoreInterface");
		
		var subs1:Vector.<ITypeNode> = accessor.getSubInterfaces(element1);
		Assert.assertNotNull(subs1);
		Assert.assertEquals(1, subs1.length);
		Assert.assertEquals("org.example.core.ICoreInterface", subs1[0].qualifiedName);
		
		var subs2:Vector.<ITypeNode> = accessor.getSubInterfaces(element2);
		Assert.assertNotNull(subs2);
		Assert.assertEquals(1, subs2.length);
		Assert.assertEquals("org.example.core.ICoreInterface", subs2[0].qualifiedName);
		
		var subs3:Vector.<ITypeNode> = accessor.getSubInterfaces(element3);
		Assert.assertNull(subs3);
	}
	
	[Test]
	public function test_getConstants():void
	{
		var element1:IClassTypeNode = accessor.findClassType("org.example.core.ClassA");
		var element2:IClassTypeNode = accessor.findClassType("org.example.core.ClassB");
		var element3:IClassTypeNode = accessor.findClassType("org.example.core.ClassC");
		var element4:IClassTypeNode = accessor.findClassType("org.example.impl.ClassE");
		var element5:IClassTypeNode = accessor.findClassType("org.example.impl.TypeClass");
		
		var members1:Vector.<IConstantNode> = accessor.getConstants(element1, null, false);
		Assert.assertNotNull(members1);
		Assert.assertEquals(3, members1.length);
		Assert.assertEquals("aPrivateStaticConst", members1[0].name);
		Assert.assertEquals("aProtectedStaticConst", members1[1].name);
		Assert.assertEquals("aPublicStaticConst", members1[2].name);
		
		var members2:Vector.<IConstantNode> = accessor.getConstants(element2, null, false);
		Assert.assertNotNull(members2);
		Assert.assertEquals(0, members2.length);
		
		var members3:Vector.<IConstantNode> = accessor.getConstants(element2, null, true);
		Assert.assertNotNull(members3);
		Assert.assertEquals(2, members3.length); // 2 Inherited constants
		Assert.assertEquals("aProtectedStaticConst", members3[0].name);
		Assert.assertEquals("aPublicStaticConst", members3[1].name);
		
		var members4:Vector.<IConstantNode> = accessor.getConstants(element3, null, true);
		Assert.assertNotNull(members4);
		Assert.assertEquals(3, members4.length); // 2 Inherited constants 1
		Assert.assertEquals("aClassCPublicStaticConst", members4[0].name);
		Assert.assertEquals("aProtectedStaticConst", members4[1].name);
		Assert.assertEquals("aPublicStaticConst", members4[2].name);
		
		var members5:Vector.<IConstantNode> = accessor.getConstants(element4, null, true);
		Assert.assertNotNull(members5);
		Assert.assertEquals(6, members5.length); // 4 Inherited constants 1
		Assert.assertEquals("MY_EVENT", members5[0].name);
		Assert.assertEquals("aClassEPublicStaticConst", members5[1].name);
		Assert.assertEquals("aClassEPrivateStaticConst", members5[2].name);
		Assert.assertEquals("aClassDPublicStaticConst", members5[3].name);
		Assert.assertEquals("aProtectedStaticConst", members5[4].name);
		Assert.assertEquals("aPublicStaticConst", members5[5].name);
		
		var members6:Vector.<IConstantNode> = accessor.getConstants(element5, null, true);
		Assert.assertNotNull(members6);
		Assert.assertEquals(2, members6.length); // 4 Inherited constants 1
		
		var type:IIdentifierNode = members6[0].type;
		Assert.assertEquals("ClassA", type.localName);
		Assert.assertEquals("org.example.core", type.packageName);
		Assert.assertEquals("org.example.core.ClassA", type.qualifiedName);
	}
	
	[Test]
	public function test_getAttributes():void
	{
		var element1:IClassTypeNode = accessor.findClassType("org.example.core.ClassA");
		var element2:IClassTypeNode = accessor.findClassType("org.example.core.ClassB");
		var element3:IClassTypeNode = accessor.findClassType("org.example.core.ClassC");
		
		var members1:Vector.<IAttributeNode> = accessor.getAttributes(element1, null, false);
		Assert.assertNotNull(members1);
		Assert.assertEquals(5, members1.length);
		Assert.assertEquals("aProtectedVar", members1[0].name);
		Assert.assertEquals("org.example.core.ClassA#attribute:aProtectedVar", members1[0].qualifiedName);
		Assert.assertEquals("aPublicVar", members1[1].name);
		Assert.assertEquals("org.example.core.ClassA#attribute:aPublicVar", members1[1].qualifiedName);
		Assert.assertEquals("aPublicStaticVar", members1[2].name);
		Assert.assertEquals("org.example.core.ClassA#attribute:aPublicStaticVar", members1[2].qualifiedName);
		Assert.assertEquals("aMxInternalVar", members1[3].name);
		Assert.assertEquals("org.example.core.ClassA#attribute:aMxInternalVar", members1[3].qualifiedName);
		Assert.assertEquals("aVectorVar", members1[4].name);
		Assert.assertEquals("org.example.core.ClassA#attribute:aVectorVar", members1[4].qualifiedName);
		
		var members2:Vector.<IAttributeNode> = accessor.getAttributes(element2, null, false);
		Assert.assertNotNull(members2);
		Assert.assertEquals(0, members2.length);
		
		var members3:Vector.<IAttributeNode> = accessor.getAttributes(element3, null, false);
		Assert.assertNotNull(members3);
		Assert.assertEquals(1, members3.length);
		Assert.assertEquals("anotherVar", members3[0].name);
		Assert.assertEquals("org.example.core.ClassC#attribute:anotherVar", members3[0].qualifiedName);
		
		var members4:Vector.<IAttributeNode> = accessor.getAttributes(element3, null, true);
		Assert.assertNotNull(members4);
		Assert.assertEquals(6, members4.length);
		Assert.assertEquals("anotherVar", members4[0].name);
		Assert.assertEquals("aProtectedVar", members4[1].name);
		Assert.assertEquals("aPublicVar", members4[2].name);
		Assert.assertEquals("aPublicStaticVar", members4[3].name);
		Assert.assertEquals("aMxInternalVar", members4[4].name);
		Assert.assertEquals("aVectorVar", members4[5].name);
	}
	
	[Test]
	public function test_getAccessors():void
	{
		var element1:IClassTypeNode = accessor.findClassType("org.example.core.ClassA");
		var element2:IClassTypeNode = accessor.findClassType("org.example.core.ClassB");
		var element3:IClassTypeNode = accessor.findClassType("org.example.core.ClassC");
		var element4:IClassTypeNode = accessor.findClassType("org.example.util.ClassD");
		
		var element6:IInterfaceTypeNode = accessor.findInterfaceType("org.example.interfaces.IInterfaceA");
		var element7:IInterfaceTypeNode = accessor.findInterfaceType("org.example.interfaces.IInterfaceB");
		var element8:IInterfaceTypeNode = accessor.findInterfaceType("org.example.core.ICoreInterface");
		
		var members1:Vector.<IAccessorNode> = accessor.getAccessors(element1, null, false);
		Assert.assertNotNull(members1);
		Assert.assertEquals(6, members1.length);
		Assert.assertEquals("aPrivateGetSetAccessor", members1[0].name);
		Assert.assertTrue(members1[0].isReadWrite);
		Assert.assertEquals("aPrivateGetAccessor", members1[1].name);
		Assert.assertTrue(members1[1].isReadOnly);
		Assert.assertEquals("aCoreAccessor", members1[2].name);
		Assert.assertTrue(members1[2].isReadWrite);
		Assert.assertEquals("name", members1[3].name);
		Assert.assertTrue(members1[3].isReadOnly);
		Assert.assertEquals("id", members1[4].name);
		Assert.assertTrue(members1[4].isReadOnly);
		Assert.assertEquals("aPrivateSetAccessor", members1[5].name);
		Assert.assertTrue(members1[5].isWriteOnly);
		
		// Interface tests
		var members7:Vector.<IAccessorNode> = accessor.getAccessors(element6, null, false);
		Assert.assertNotNull(members7);
		Assert.assertEquals(1, members7.length);
		Assert.assertEquals("name", members7[0].name);
		Assert.assertTrue(members7[0].isReadOnly);
		
		var members10:Vector.<IAccessorNode> = accessor.getAccessors(element8, null, true);
		Assert.assertNotNull(members10);
		Assert.assertEquals(3, members10.length);
		Assert.assertEquals("aCoreAccessor", members10[0].name);
		Assert.assertTrue(members10[0].isReadWrite);
		Assert.assertEquals("name", members10[1].name);
		Assert.assertTrue(members10[1].isReadOnly);
		Assert.assertEquals("id", members10[2].name);
		Assert.assertTrue(members10[2].isReadOnly);
	}
	
	[Test]
	public function test_getMethods():void
	{
		var element1:IClassTypeNode = accessor.findClassType("org.example.core.ClassA");
		var element2:IClassTypeNode = accessor.findClassType("org.example.core.ClassB");
		var element3:IClassTypeNode = accessor.findClassType("org.example.core.ClassC");
		var element4:IClassTypeNode = accessor.findClassType("org.example.util.ClassD");
		
		var members1:Vector.<IMethodNode> = accessor.getMethods(element1, null, false);
		Assert.assertNotNull(members1);
		Assert.assertEquals(5, members1.length);
		Assert.assertEquals("ClassA", members1[0].name);
		Assert.assertEquals("aPrivateMethod", members1[1].name);
		Assert.assertEquals("aProtectedMethod", members1[2].name);
		Assert.assertEquals("aPublicMethod", members1[3].name);
		Assert.assertEquals("aPublicStaticMethod", members1[4].name);
		
		var members7:Vector.<IMethodNode> = accessor.getMethods(element4, null, true);
		Assert.assertNotNull(members7);
		Assert.assertEquals(6, members7.length);
		Assert.assertEquals("ClassD", members7[0].name);
		Assert.assertEquals("protectedMethod", members7[1].name);
		Assert.assertEquals("privateUtilMethod", members7[2].name);
		Assert.assertEquals("aProtectedMethod", members7[3].name);
		Assert.assertEquals("aPublicMethod", members7[4].name);
		Assert.assertEquals("aPublicStaticMethod", members7[5].name);
	}
	
	[Test]
	public function test_getAllMetadataByName():void
	{
		
	}
	
	[Test]
	public function test_getMetadatas():void
	{
		
	}
	
	[Test]
	public function test_getStyles():void
	{
		
	}
	
	[Test]
	public function test_getEvents():void
	{
		
	}
	
	[Test]
	public function test_getEffects():void
	{
		
	}
	
	[Test]
	public function test_getSkinStates():void
	{
		
	}
	
	[Test]
	public function test_getBindableOfClass():void
	{
		
	}
	
	private function toArray(vector:Vector):Array
	{
		return null;
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