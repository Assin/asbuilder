package org.teotigraphix.as3builder.impl
{

import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.IConstantNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.impl.IdentifierNode;

public class TestAS3FactoryConstant extends TestAS3FactoryBase
{
	[Test]
	/*
	* package {
	*     public class Test {
	*          static const testAttribute = null;
	*     }
	* }
	*/
	public function testBasic():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:IClassTypeNode = testClassFile.compilationNode.typeNode as IClassTypeNode;
		
		var constant:IConstantNode = typeNode.newConstant(
			"MY_CONSTANT", null, null, "null");
		
		assertBuild("package {\n    public class Test {\n        " +
			"static const MY_CONSTANT = null;\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public class Test {
	*         public static const MY_CONSTANT = null;
	*     }
	* }
	*/
	public function testBasicConstant():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:IClassTypeNode = testClassFile.compilationNode.typeNode as IClassTypeNode;
		
		var constant:IConstantNode = typeNode.newConstant(
			"MY_CONSTANT", Modifier.PUBLIC, null, "null");
		
		assertBuild("package {\n    public class Test {\n        " +
			"public static const MY_CONSTANT = null;\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public class Test {
	*         public static const MY_CONSTANT:String = "test";
	*     }
	* }
	*/
	public function testBasicConstantType():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:IClassTypeNode = testClassFile.compilationNode.typeNode as IClassTypeNode;
		
		var constant:IConstantNode = typeNode.newConstant(
			"MY_CONSTANT", Modifier.PUBLIC, IdentifierNode.createType("String"), "\"test\"");
		
		assertBuild("package {\n    public class Test {\n        " +
			"public static const MY_CONSTANT:String = \"test\";\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public class Test {
	*         [MetaDataConstant]
	*         public static const MY_CONSTANT:String = "test";
	*     }
	* }
	*/
	public function testBasicConstantMetaDataType():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:IClassTypeNode = testClassFile.compilationNode.typeNode as IClassTypeNode;
		
		var constant:IConstantNode = typeNode.newConstant(
			"MY_CONSTANT", Modifier.PUBLIC, IdentifierNode.createType("String"), "\"test\"");
		constant.newMetaData("MetaDataConstant");
		
		assertBuild("package {\n    public class Test {\n        " +
			"[MetaDataConstant]\n" +
			"        public static const MY_CONSTANT:String = \"test\";\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public class Test {
	*         mx_internal static const MY_CONSTANT:String = "test";
	*     }
	* }
	*/
	public function testBasiConstantNamespaceType():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:IClassTypeNode = testClassFile.compilationNode.typeNode as IClassTypeNode;
		
		var constant:IConstantNode = typeNode.newConstant(
			"MY_CONSTANT", Modifier.create("mx_internal"), IdentifierNode.createType("String"), "\"test\"");
		
		assertBuild("package {\n    public class Test {\n        " +
			"mx_internal static const MY_CONSTANT:String = \"test\";\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public class Test {
	*         /~~
	*          ~ A comment.
	*          ~ 
	*          ~ <p>Lond desc.</p>
	*          ~/
	*         public static const MY_CONSTANT:String = "test";
	*     }
	* }
	*/
	public function testBasicConstantWithComment():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:IClassTypeNode = testClassFile.compilationNode.typeNode as IClassTypeNode;
		
		var constant:IConstantNode = typeNode.newConstant(
			"MY_CONSTANT", Modifier.PUBLIC, IdentifierNode.createType("String"), "\"test\"");
		constant.description = "A comment.\n <p>Lond desc.</p>";
		
		assertBuild("package {\n    public class Test {\n        /**\n         " +
			"* A comment.\n         * \n         * <p>Lond desc.</p>\n" +
			"         */\n        public static const MY_CONSTANT:String = \"test\";\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public class Test {
	*         [MetaDataConstant]
	*         /~~
	*          ~ A comment.
	*          ~ 
	*          ~ <p>Lond desc.</p>
	*          ~/
	*         public static const MY_CONSTANT:String = "test";
	*     }
	* }
	*/
	public function testBasicConstantWithMetaDataAndComment():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:IClassTypeNode = testClassFile.compilationNode.typeNode as IClassTypeNode;
		
		var constant:IConstantNode = typeNode.newConstant(
			"MY_CONSTANT", Modifier.PUBLIC, IdentifierNode.createType("String"), "\"test\"");
		constant.newMetaData("MetaDataConstant");
		constant.description = "A comment.\n <p>Lond desc.</p>";
		
		assertBuild("package {\n    public class Test {\n        [MetaDataConstant]\n" +
			"        /**\n         * A comment.\n         * \n         " +
			"* <p>Lond desc.</p>\n         */\n        " +
			"public static const MY_CONSTANT:String = \"test\";\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public class Test {
	*         /~~
	*          ~ A comment.
	*          ~ 
	*          ~ <p>Lond desc.</p>
	*          ~ 
	*          ~ @private 
	*          ~ @author Jane Doe
	*          ~/
	*         public static const MY_CONSTANT:String = "test";
	*     }
	* }
	*/
	public function testBasicConstantWithCommentAndDocTags():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:IClassTypeNode = testClassFile.compilationNode.typeNode as IClassTypeNode;
		
		var constant:IConstantNode = typeNode.newConstant(
			"MY_CONSTANT", Modifier.PUBLIC, IdentifierNode.createType("String"), "\"test\"");
		constant.description = "A comment.\n <p>Lond desc.</p>";
		constant.newDocTag("private");
		constant.newDocTag("author", "Jane Doe");
		
		assertBuild("package {\n    public class Test {\n        /**\n         " +
			"* A comment.\n         * \n         * <p>Lond desc.</p>\n" +
			"         * \n         * @private \n         * @author Jane Doe\n" +
			"         */\n        public static const MY_CONSTANT:String = \"test\";\n    }\n}", 
			testClassFile.compilationNode);
	}
}
}