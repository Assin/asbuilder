package org.teotigraphix.as3builder.impl
{

import flash.filesystem.File;

import flexunit.framework.Assert;

import org.teotigraphix.as3nodes.api.IAS3Project;
import org.teotigraphix.as3nodes.api.ICompilationNode;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IMethodNode;
import org.teotigraphix.as3nodes.api.IParameterNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.impl.IdentifierNode;

public class TestAS3FactoryMethod extends TestAS3FactoryBase
{
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
	*     public interface ITest {
	*         function testMethod():String;
	*     }
	* }
	*/
	public function testBasicInterfaceMethod():void
	{
		var testClassFile:ISourceFile = project.newInterface("ITest");
		var typeNode:ITypeNode = testClassFile.compilationNode.typeNode;
		
		var method:IMethodNode = typeNode.newMethod(
			"testMethod", Modifier.PUBLIC, IdentifierNode.createType("String"));
		
		assertBuild("package {\n    public interface ITest {\n        function " +
			"testMethod():String;\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	 * package {
	 *     public class Test {
	 *         /~~
	 *          ~ A test method. 
	 *          ~/
	 *         public function testMethod():String {
	 *         }
	 *     }
	 * }
	 */
	public function testBasicClassMethodWithComment():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:ITypeNode = testClassFile.compilationNode.typeNode;
		
		var method:IMethodNode = typeNode.newMethod(
			"testMethod", Modifier.PUBLIC, IdentifierNode.createType("String"));
		method.description = "A test method.";
		
		assertBuild("package {\n    public class Test {\n        /**\n         * " +
			"A test method. \n         */\n        public function " +
			"testMethod():String {\n        }\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public interface Test {
	*         /~~
	*          ~ A test method. 
	*          ~/
	*         function testMethod():String;
	*     }
	* }
	*/
	public function testBasicInterfaceMethodWithComment():void
	{
		var testClassFile:ISourceFile = project.newInterface("ITest");
		var typeNode:ITypeNode = testClassFile.compilationNode.typeNode;
		
		var method:IMethodNode = typeNode.newMethod(
			"testMethod", Modifier.PUBLIC, IdentifierNode.createType("String"));
		method.description = "A test method.";
		
		assertBuild("package {\n    public interface ITest {\n        /**\n         * " +
			"A test method. \n         */\n        function " +
			"testMethod():String;\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	 * package {
	 *     public class Test {
	 *         /~~
	 *          ~ A test method.
	 *          ~ 
	 *          ~ <p>Long description.</p> 
	 *          ~ 
	 *          ~ @since 1.0
	 *          ~ @return A String indicating success
	 *          ~/
	 *         public function testMethod():String {
	 *         }
	 *     }
	 * }
	*/
	public function testBasicClassMethodWithCommentAndDocTags():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:ITypeNode = testClassFile.compilationNode.typeNode;
		
		var method:IMethodNode = typeNode.newMethod(
			"testMethod", Modifier.PUBLIC, IdentifierNode.createType("String"));
		method.description = "A test method.\n <p>Long description.</p>";
		method.addDocTag("since", "1.0");
		method.addReturnDescription("A String indicating success.");
		
		assertBuild("package {\n    public class Test {\n        /**\n         " +
			"* A test method.\n         * \n         * <p>Long description.</p> " +
			"\n         * \n         * @since 1.0\n         * @return A String " +
			"indicating success.\n         */\n        public function " +
			"testMethod():String {\n        }\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	 * package {
	 *     public class Test {
	 *         /~~
	 *          ~ @param arg0 An argument at 0
	 *          ~ @return A String indicating success.
	 *          ~/
	 *         public function testMethod(arg0:String):String {
	 *         }
	 *     }
	 * }
	 */
	public function testBasicClassMethodWithParamTags():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:ITypeNode = testClassFile.compilationNode.typeNode;
		
		var method:IMethodNode = typeNode.newMethod(
			"testMethod", Modifier.PUBLIC, IdentifierNode.createType("String"));
		var param:IParameterNode = method.addParameter("arg0", IdentifierNode.createType("String"));
		//method.description = "A test method.\n <p>Long description.</p>";
		//method.addDocTag("since", "1.0");
		param.description = "An argument at 0";
		method.addReturnDescription("A String indicating success.");
		
		assertBuild("package {\n    public class Test {\n        /**\n         " +
			"* @param arg0 An argument at 0\n         * @return " +
			"A String indicating success.\n         */\n       " +
			" public function testMethod(arg0:String):String {\n        }\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/**
	 * 
	 * package {
	 *     public class Test {
	 *         /~~
	 *          ~ A test method.
	 *          ~ 
	 *          ~ <p>Long description.</p> 
	 *          ~ 
	 *          ~ @since 1.0
	 *          ~ @param arg0 An argument at 0
	 *          ~ @return A String indicating success.
	 *          ~/
	 *         public function testMethod(arg0:String):String {
	 *         }
	 *     }
	 * }
	*/
	public function testBasicClassMethodWithDescParamReturnTags():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:ITypeNode = testClassFile.compilationNode.typeNode;
		
		var method:IMethodNode = typeNode.newMethod(
			"testMethod", Modifier.PUBLIC, IdentifierNode.createType("String"));
		var param:IParameterNode = method.addParameter("arg0", IdentifierNode.createType("String"));
		method.description = "A test method.\n <p>Long description.</p>";
		method.addDocTag("since", "1.0");
		param.description = "An argument at 0";
		method.addReturnDescription("A String indicating success.");
		
		assertBuild("package {\n    public class Test {\n        /**\n         " +
			"* A test method.\n         * \n         * " +
			"<p>Long description.</p> \n         * \n         * @since 1.0\n " +
			"        * @param arg0 An argument at 0\n         * @return A " +
			"String indicating success.\n         */\n        public function " +
			"testMethod(arg0:String):String {\n        }\n    }\n}", 
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
		
		var method:IMethodNode = typeNode.newMethod(
			"testMethod", Modifier.PUBLIC, IdentifierNode.createType("String"));
		var param:IParameterNode = method.addParameter("arg0", IdentifierNode.createType("String"));
		
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
	
	[Test]
	/*
	* package {
	*     public interface Test {
	*         function testMethod(arg0:String, arg1:int, ...arg2):String;
	*     }
	* }
	*/
	public function testBasicInterfaceMethodWithMulitpleArgs():void
	{
		var testClassFile:ISourceFile = project.newInterface("ITest");
		var typeNode:ITypeNode = testClassFile.compilationNode.typeNode;
		
		var method:IMethodNode = typeNode.newMethod(
			"testMethod", Modifier.PUBLIC, IdentifierNode.createType("String"));
		method.addParameter("arg0", IdentifierNode.createType("String"));
		method.addParameter("arg1", IdentifierNode.createType("int"));
		method.addRestParameter("arg2");
		
		assertBuild("package {\n    public interface ITest {\n        " +
			"function testMethod(arg0:String, arg1:int, ...arg2):String;\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public class Test {
	*         public function testMethod(arg0:String = ''):String {
	*         }
	*     }
	* }
	*/
	public function testClassMethodWithArgAndInit():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:ITypeNode = testClassFile.compilationNode.typeNode;
		
		var method1:IMethodNode = typeNode.newMethod(
			"testMethod", Modifier.PUBLIC, IdentifierNode.createType("String"));
		method1.addParameter("arg0", IdentifierNode.createType("String"), "''");
		
		assertBuild("package {\n    public class Test {\n        public function " +
			"testMethod(arg0:String = ''):String {\n        }\n    }\n}", 
			testClassFile.compilationNode);
	}
}
}