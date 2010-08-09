package org.teotigraphix.as3builder.impl
{

import flash.filesystem.File;

import flexunit.framework.Assert;

import org.teotigraphix.as3nodes.api.IAS3Project;
import org.teotigraphix.as3nodes.api.ICompilationNode;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IMethodNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.impl.IdentifierNode;

public class TestAS3FactoryMethod
{
	protected var factory:AS3Factory;
	
	protected var project:IAS3Project;
	
	[Before]
	public function setUp():void
	{
		var output:File = File.desktopDirectory.resolvePath("tempTest");
		
		factory = new AS3Factory();
		project = factory.newASProject(output.nativePath);
	}
	
	[Test]
	/*
	 * package {
	 *     public class Test {
	 *         public function testMethod():String {
	 *         }
	 *     }
	 * }
	 */
	public function testBasicClassMethod():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:ITypeNode = testClassFile.compilationNode.typeNode;
		
		var method:IMethodNode = typeNode.newMethod(
			"testMethod", Modifier.PUBLIC, IdentifierNode.createType("String"));
		
		assertBuild("package {\n    public class Test {\n        public function " +
			"testMethod():String {\n        }\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public class Test {
	*         public static function testMethod():String {
	*         }
	*     }
	* }
	*/
	public function testBasicClassStaticMethod():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:ITypeNode = testClassFile.compilationNode.typeNode;
		
		var method:IMethodNode = typeNode.newMethod(
			"testMethod", Modifier.PUBLIC, IdentifierNode.createType("String"));
		method.isStatic = true;
		
		assertBuild("package {\n    public class Test {\n        public static function " +
			"testMethod():String {\n        }\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	 * package {
	 *     public class Test {
	 *         public function Test() {
	 *         }
	 *     }
	 * }
	 */
	public function testBasicClassConstructor():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:ITypeNode = testClassFile.compilationNode.typeNode;
		
		var method:IMethodNode = typeNode.newMethod(
			"Test", Modifier.PUBLIC, null);
		
		assertBuild("package {\n    public class Test {\n        " +
			"public function Test() {\n        }\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	 * package {
	 *     public class Test {
	 *         mx_internal function mxInternalMethod():MyClass {
	 *         }
	 *     }
	 * }
	 */
	public function testBasicClassNamespaceMethod():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:ITypeNode = testClassFile.compilationNode.typeNode;
		
		var mx:Modifier = Modifier.create("mx_internal");
		
		var method:IMethodNode = typeNode.newMethod(
			"mxInternalMethod", mx, IdentifierNode.createType("my.domain.MyClass"));
		
		assertBuild("package {\n    public class Test {\n        " +
			"mx_internal function mxInternalMethod():MyClass {\n        }\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	 * package {
	 *     public class Test {
	 *         public function testMethodOne():String {
	 *         }
	 *         protected function testMethodTwo():int {
	 *         }
	 *     }
	 * }
	 */
	public function testBasicMultipleClassMethod():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:ITypeNode = testClassFile.compilationNode.typeNode;
		
		var method1:IMethodNode = typeNode.newMethod(
			"testMethodOne", Modifier.PUBLIC, IdentifierNode.createType("String"));
		
		var method2:IMethodNode = typeNode.newMethod(
			"testMethodTwo", Modifier.PROTECTED, IdentifierNode.createType("int"));
		
		assertBuild("package {\n    public class Test {\n        " +
			"public function testMethodOne():String {\n        }\n        " +
			"protected function testMethodTwo():int {\n        }\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	 * package {
	 *     public class Test {
	 *         public function testMethod(arg0:String):String {
	 *         }
	 *     }
	 * }
	 */
	public function testBasicClassMethodWithArg():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:ITypeNode = testClassFile.compilationNode.typeNode;
		
		var method1:IMethodNode = typeNode.newMethod(
			"testMethod", Modifier.PUBLIC, IdentifierNode.createType("String"));
		method1.addParameter("arg0", IdentifierNode.createType("String"));
		
		assertBuild("package {\n    public class Test {\n        public function " +
			"testMethod(arg0:String):String {\n        }\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	 * package {
	 *     public class Test {
	 *         public function testMethod(arg0:String, arg1:int, ...arg2):String {
	 *         }
	 *     }
	 * }
	 */
	public function testBasicClassMethodWithMulitpleArgs():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:ITypeNode = testClassFile.compilationNode.typeNode;
		
		var method1:IMethodNode = typeNode.newMethod(
			"testMethod", Modifier.PUBLIC, IdentifierNode.createType("String"));
		method1.addParameter("arg0", IdentifierNode.createType("String"));
		method1.addParameter("arg1", IdentifierNode.createType("int"));
		method1.addRestParameter("arg2");
		
		assertBuild("package {\n    public class Test {\n        public function " +
			"testMethod(arg0:String, arg1:int, ...arg2):String {\n        }\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	protected function assertBuild(text:String, compilationNode:ICompilationNode):void
	{
		var result:String = BuilderFactory.instance.buildTest(compilationNode.node);
		Assert.assertEquals(text, result);
	}
}
}