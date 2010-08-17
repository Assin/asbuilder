package org.teotigraphix.as3builder.impl
{

import org.teotigraphix.as3nodes.api.Access;
import org.teotigraphix.as3nodes.api.IAccessorNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.impl.IdentifierNode;

public class TestAS3FactoryAccessor extends TestAS3FactoryBase
{
	
	[Test]
	/*
	 * package {
	 *     public class Test {
	 *         public function get testProperty1():String {
	 *             return null;
	 *         }
	 *         public function set testProperty1(value:String):void {
	 *         }
	 *     }
	 * }
	 */
	public function testBasicClassAccessor():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:ITypeNode = testClassFile.compilationNode.typeNode;
		
		var accessor:IAccessorNode;
		
		accessor = typeNode.newAccessor(
			"testProperty1", Modifier.PUBLIC, Access.READ, IdentifierNode.createType("String"));
		
		assertBuild("package {\n    public class Test {\n        " +
			"public function get testProperty1():String {\n            " +
			"return null;\n        }\n    }\n}", 
			testClassFile.compilationNode);
		
		accessor = typeNode.newAccessor(
			"testProperty1", Modifier.PUBLIC, Access.WRITE, IdentifierNode.createType("String"));
		
		assertBuild("package {\n    public class Test {\n        " +
			"public function get testProperty1():String {\n            " +
			"return null;\n        }\n        public function set testProperty1(" +
			"value:String):void {\n        }\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/**
	 * 
	 * package my.domain {
	 *     public class Test {
	 *         /~~
	 *          ~ A comment.
	 *          ~ 
	 *          ~ @see my.other.Class
	 *          ~/
	 *         public function get testProperty1():String {
	 *             return null;
	 *         }
	 *         /~~
	 *          ~ @private 
	 *          ~/
	 *         public function set testProperty1(value:String):void {
	 *         }
	 *     }
	 * }
	*/
	public function testComplex():void
	{
		var testClassFile:ISourceFile = project.newClass("my.domain.Test");
		var typeNode:ITypeNode = testClassFile.compilationNode.typeNode;
		
		var accessor:IAccessorNode;
		
		accessor = typeNode.newAccessor(
			"testProperty1", Modifier.PUBLIC, Access.READ, IdentifierNode.createType("String"));
		accessor.description = "A comment.";
		accessor.comment.newDocTag("see", "my.other.Class");
		
		accessor = typeNode.newAccessor(
			"testProperty1", Modifier.PUBLIC, Access.WRITE, IdentifierNode.createType("String"));
		accessor.comment.newDocTag("private");
		
		assertBuild("package my.domain {\n    public class Test {\n        " +
			"/**\n         * A comment.\n         * \n         * " +
			"@see my.other.Class\n         */\n        public " +
			"function get testProperty1():String {\n            " +
			"return null;\n        }\n        /**\n         " +
			"* @private \n         */\n        public function set " +
			"testProperty1(value:String):void {\n        }\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public class Test {
	*         public function get testProperty1():int|uint|Number {
	*             return -1;
	*         }
	*     }
	* }
	*/
	public function testBasicIntUnitNumber():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:ITypeNode = testClassFile.compilationNode.typeNode;
		
		var accessor:IAccessorNode;
		
		accessor = typeNode.newAccessor(
			"testProperty1", Modifier.PUBLIC, Access.READ, IdentifierNode.createType("int"));
		
		assertBuild("package {\n    public class Test {\n        " +
			"public function get testProperty1():int {\n            " +
			"return -1;\n        }\n    }\n}", 
			testClassFile.compilationNode);
		typeNode.removeAccessor(accessor);
		
		accessor = typeNode.newAccessor(
			"testProperty1", Modifier.PUBLIC, Access.READ, IdentifierNode.createType("uint"));
		
		assertBuild("package {\n    public class Test {\n        " +
			"public function get testProperty1():uint {\n            " +
			"return -1;\n        }\n    }\n}", 
			testClassFile.compilationNode);
		typeNode.removeAccessor(accessor);
		
		accessor = typeNode.newAccessor(
			"testProperty1", Modifier.PUBLIC, Access.READ, IdentifierNode.createType("Number"));
		
		assertBuild("package {\n    public class Test {\n        " +
			"public function get testProperty1():Number {\n            " +
			"return -1;\n        }\n    }\n}", 
			testClassFile.compilationNode);
	}
}
}