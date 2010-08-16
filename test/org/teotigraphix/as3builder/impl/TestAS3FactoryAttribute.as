package org.teotigraphix.as3builder.impl
{

import org.teotigraphix.as3nodes.api.IAttributeNode;
import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.impl.IdentifierNode;

public class TestAS3FactoryAttribute extends TestAS3FactoryBase
{
	[Test]
	/*
	* package {
	*     public class Test {
	*         var testAttribute;
	*     }
	* }
	*/
	public function testBasic():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:IClassTypeNode = testClassFile.compilationNode.typeNode as IClassTypeNode;
		
		var attribute:IAttributeNode = typeNode.newAttribute(
			"testAttribute", null, null);
		
		assertBuild("package {\n    public class Test {\n        " +
			"var testAttribute;\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public class Test {
	*         public var testAttribute;
	*     }
	* }
	*/
	public function testBasicAttribute():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:IClassTypeNode = testClassFile.compilationNode.typeNode as IClassTypeNode;
		
		var attribute:IAttributeNode = typeNode.newAttribute(
			"testAttribute", Modifier.PUBLIC, null);
		
		assertBuild("package {\n    public class Test {\n        " +
			"public var testAttribute;\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public class Test {
	*         public var testAttribute:String;
	*     }
	* }
	*/
	public function testBasicAttributeType():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:IClassTypeNode = testClassFile.compilationNode.typeNode as IClassTypeNode;
		
		var attribute:IAttributeNode = typeNode.newAttribute(
			"testAttribute", Modifier.PUBLIC, IdentifierNode.createType("String"));
		
		assertBuild("package {\n    public class Test {\n        " +
			"public var testAttribute:String;\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public class Test {
	*         [Bindable]
	*         [Inject(source="dataProvider.model")]
	*         public var testAttribute:String;
	*     }
	* }
	*/
	public function testBasicAttributeMetaDataType():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:IClassTypeNode = testClassFile.compilationNode.typeNode as IClassTypeNode;
		
		var attribute:IAttributeNode = typeNode.newAttribute(
			"testAttribute", Modifier.PUBLIC, IdentifierNode.createType("String"));
		attribute.newMetaData("Bindable");
		var inject:IMetaDataNode = attribute.newMetaData("Inject");
		inject.addNamedStringParameter("source", "dataProvider.model");
		
		assertBuild("package {\n    public class Test {\n        " +
			"[Bindable]\n        [Inject(source=\"dataProvider.model\")]\n" +
			"        public var testAttribute:String;\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public class Test {
	*         mx_internal var testAttribute:String;
	*     }
	* }
	*/
	public function testBasicAttributeNamespaceType():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:IClassTypeNode = testClassFile.compilationNode.typeNode as IClassTypeNode;
		
		var attribute:IAttributeNode = typeNode.newAttribute(
			"testAttribute", Modifier.create("mx_internal"), IdentifierNode.createType("String"));
		
		assertBuild("package {\n    public class Test {\n        " +
			"mx_internal var testAttribute:String;\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public class Test {
	*         public static var testAttribute:String;
	*     }
	* }
	*/
	public function testBasicAttributeStaticType():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:IClassTypeNode = testClassFile.compilationNode.typeNode as IClassTypeNode;
		
		var attribute:IAttributeNode = typeNode.newAttribute(
			"testAttribute", Modifier.PUBLIC, IdentifierNode.createType("String"));
		attribute.addModifier(Modifier.STATIC);
		
		assertBuild("package {\n    public class Test {\n        " +
			"public static var testAttribute:String;\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public class Test {
	*         public var testAttribute:String = null;
	*     }
	* }
	*/
	public function testBasicAttributeWithPrimary():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:IClassTypeNode = testClassFile.compilationNode.typeNode as IClassTypeNode;
		
		var attribute:IAttributeNode = typeNode.newAttribute(
			"testAttribute", Modifier.PUBLIC, IdentifierNode.createType("String"), "null");
		
		assertBuild("package {\n    public class Test {\n        " +
			"public var testAttribute:String = null;\n    }\n}", 
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
	 *         public var testAttribute:String = null;
	 *     }
	 * }
	 */
	public function testBasicAttributeWithComment():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:IClassTypeNode = testClassFile.compilationNode.typeNode as IClassTypeNode;
		
		var attribute:IAttributeNode = typeNode.newAttribute(
			"testAttribute", Modifier.PUBLIC, IdentifierNode.createType("String"), "null");
		attribute.description = "A comment.\n <p>Lond desc.</p>";
		
		assertBuild("package {\n    public class Test {\n        /**\n         " +
			"* A comment.\n         * \n         * <p>Lond desc.</p>\n" +
			"         */\n        public var testAttribute:String = null;\n    }\n}", 
			testClassFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public class Test {
	*         [Bindable]
	*         /~~
	*          ~ A comment.
	*          ~ 
	*          ~ <p>Lond desc.</p>
	*          ~/
	*         public var testAttribute:String = null;
	*     }
	* }
	*/
	public function testBasicAttributeWithMetaDataAndComment():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:IClassTypeNode = testClassFile.compilationNode.typeNode as IClassTypeNode;
		
		var attribute:IAttributeNode = typeNode.newAttribute(
			"testAttribute", Modifier.PUBLIC, IdentifierNode.createType("String"), "null");
		attribute.newMetaData("Bindable");
		attribute.description = "A comment.\n <p>Lond desc.</p>";
		
		assertBuild("package {\n    public class Test {\n        [Bindable]\n" +
			"        /**\n         * A comment.\n         * \n         " +
			"* <p>Lond desc.</p>\n         */\n        " +
			"public var testAttribute:String = null;\n    }\n}", 
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
	 *         public var testAttribute:String = null;
	 *     }
	 * }
	 */
	public function testBasicAttributeWithCommentAndDocTags():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:IClassTypeNode = testClassFile.compilationNode.typeNode as IClassTypeNode;
		
		var attribute:IAttributeNode = typeNode.newAttribute(
			"testAttribute", Modifier.PUBLIC, IdentifierNode.createType("String"), "null");
		attribute.description = "A comment.\n <p>Lond desc.</p>";
		attribute.newDocTag("private");
		attribute.newDocTag("author", "Jane Doe");
		
		assertBuild("package {\n    public class Test {\n        /**\n         " +
			"* A comment.\n         * \n         * <p>Lond desc.</p>\n" +
			"         * \n         * @private \n         * @author Jane Doe\n" +
			"         */\n        public var testAttribute:String = null;\n    }\n}", 
			testClassFile.compilationNode);
	}
}
}