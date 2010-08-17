package org.teotigraphix.as3builder.impl
{

import org.teotigraphix.as3nodes.api.Access;
import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.impl.IdentifierNode;

public class TestAS3FactoryClass extends TestAS3FactoryBase
{
	[Test]
	/*
	* package {
	*     public class Test {
	*         
	*     }
	* }
	*/
	public function testBasicClass():void
	{
		var testFile:ISourceFile = project.newClass("Test");
		
		assertBuild("package {\n    public class Test {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	[Test]
	/*
	* package my.domain {
	*     public class Test {
	*         
	*     }
	* }
	*/
	public function testPackageClass():void
	{
		var testFile:ISourceFile = project.newClass("my.domain.Test");
		
		assertBuild("package my.domain {\n    public class Test {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public final class Test {
	*         
	*     }
	* }
	*/
	public function testBasicFinalClass():void
	{
		var testFile:ISourceFile = project.newClass("Test");
		var classType:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		classType.isFinal = true; 
		
		assertBuild("package {\n    public final class Test {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	/*
	* package {
	*     public dynamic class Test {
	*         
	*     }
	* }
	*/
	public function testBasicDynamicClass():void
	{
		var testFile:ISourceFile = project.newClass("Test");
		var classType:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		classType.isDynamic = true;
		
		assertBuild("package {\n    public dynamic class Test {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public class Test extends A {
	*         
	*     }
	* }
	*/
	public function testBasicClassExtends():void
	{
		var testFile:ISourceFile = project.newClass("Test");
		var type:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		type.superClass = IdentifierNode.createType("A");
		
		assertBuild("package {\n    public class Test extends A {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public class Test extends A implements IA, IB {
	*         
	*     }
	* }
	*/
	public function testBasicClassExtendsImplements():void
	{
		var testFile:ISourceFile = project.newClass("Test");
		var type:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		type.superClass = IdentifierNode.createType("A");
		type.addImplementation(IdentifierNode.createType("IA"));
		type.addImplementation(IdentifierNode.createType("IB"));
		
		assertBuild("package {\n    public class Test extends A implements IA, IB {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     [Bindable]
	*     public class Test {
	*         
	*     }
	* }
	*/
	public function testBasicClassMetaData():void
	{
		var testFile:ISourceFile = project.newClass("Test");
		var type:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		
		var metaData:IMetaDataNode = type.newMetaData("Bindable");
		
		assertBuild("package {\n    [Bindable]\n    public class Test {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     [DefaultProperty("dataProvider")]
	*     public class Test {
	*         
	*     }
	* }
	*/
	public function testBasicClassMetaDataWithParameter():void
	{
		var testFile:ISourceFile = project.newClass("Test");
		var type:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		
		var metaData:IMetaDataNode = type.newMetaData("DefaultProperty");
		metaData.addParameter("\"dataProvider\"");
		
		assertBuild("package {\n    [DefaultProperty(\"dataProvider\")]\n    " +
			"public class Test {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     [Event(name="myEvent",type="flash.events.Event")]
	*     public class Test {
	*         
	*     }
	* }
	*/
	public function testBasicClassMetaDataWithNamedParameters():void
	{
		var testFile:ISourceFile = project.newClass("Test");
		var type:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		
		var metaData:IMetaDataNode = type.newMetaData("DefaultProperty");
		metaData.addNamedParameter("name", "\"myEvent\"");
		metaData.addNamedParameter("type", "\"flash.events.Event\"");
		
		assertBuild("package {\n    [DefaultProperty(name=\"myEvent\"," +
			"type=\"flash.events.Event\")]\n    public class Test {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     /~~
	*      ~ A class comment.
	*      ~/
	*     public class Test {
	*         
	*     }
	* }
	*/
	public function testBasicCommentClass():void
	{
		var testFile:ISourceFile = project.newClass("Test");
		var classType:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		classType.description = "A class comment.";
		
		assertBuild("package {\n    /**\n     * A class comment.\n     */\n    " +
			"public class Test {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     /~~
	*      ~ A class comment.
	*      ~ 
	*      ~ <p>Long description documentation.</p>
	*      ~/
	*     public class Test {
	*         
	*     }
	* }
	*/
	public function testShortLongCommentClass():void
	{
		var testFile:ISourceFile = project.newClass("Test");
		var classType:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		classType.description = "A class comment.\n <p>Long description documentation.</p>";
		
		assertBuild("package {\n    /**\n     * A class comment.\n     * \n     * <p>Long description " +
			"documentation.</p>\n     */\n    public class Test {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     /~~
	*      ~ A class comment.
	*      ~ 
	*      ~ <p>Long description documentation.</p>
	*      ~ 
	*      ~ @author Jane Doe
	*      ~ @author John Doe
	*      ~/
	*     public class Test {
	*         
	*     }
	* }
	*/
	public function testShortLongDocTagsCommentClass():void
	{
		var testFile:ISourceFile = project.newClass("Test");
		var classType:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		classType.description = "A class comment.\n <p>Long description documentation.</p>";
		
		classType.comment.newDocTag("author", "Jane Doe");
		classType.comment.newDocTag("author", "John Doe");
		
		assertBuild("package {\n    /**\n     * A class comment.\n     * \n     * " +
			"<p>Long description documentation.</p>\n     * \n     * " +
			"@author Jane Doe\n     * @author John Doe\n     */\n    " +
			"public class Test {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	[Test]
	/**
	 * package my.package 
	 * {
	 *     [Bindable]
	 *     /~~
	 *      ~ @private 
	 *      ~/
	 *     public class Test
	 *     {
	 * 
	 *         public static const MY_CONSTANT:String = "value";
	 *         
	 *         public var myAttribute:String = null;
	 *         
	 *         public function get myAccessor():String 
	 *         {
	 *             return null;
	 *         }
	 *         
	 *         public function set myAccessor(value:String):void 
	 *         {
	 *         }
	 *         
	 *         public function myMethod():String
	 *         {
	 *         }
	 *     }
	 * }
 	*/
	public function testMembersConfig():void
	{
		var testFile:ISourceFile = project.newClass("my.package.Test");
		var classType:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		
		classType.newDocTag("private");
		classType.newMetaData("Bindable");
		classType.newConstant("MY_CONSTANT", Modifier.PUBLIC, IdentifierNode.createType("String"), "\"value\"");
		classType.newAttribute("myAttribute", Modifier.PUBLIC, IdentifierNode.createType("String"), "null");
		classType.newAccessor("myAccessor", Modifier.PUBLIC, Access.READ, IdentifierNode.createType("String"));
		classType.newAccessor("myAccessor", Modifier.PUBLIC, Access.WRITE, IdentifierNode.createType("String"));
		classType.newMethod("myMethod", Modifier.PUBLIC, IdentifierNode.createType("String"));
		
		BuilderFactory.breakPackageBracket = true;
		BuilderFactory.breakTypeBracket = true;
		BuilderFactory.breakBlockBracket = true;
		BuilderFactory.newlinesBeforeMembers = 1;
		
		assertBuild("package my.package \n{\n    [Bindable]\n    /**\n     * " +
			"@private \n     */\n    public class Test \n    {\n        \n        " +
			"public static const MY_CONSTANT:String = \"value\";\n        \n        " +
			"public var myAttribute:String = null;\n        \n        " +
			"public function get myAccessor():String \n        {\n            " +
			"return null;\n        }\n        \n        " +
			"public function set myAccessor(value:String):void \n        {\n        " +
			"}\n        \n        public function myMethod():String \n        " +
			"{\n        }\n    }\n}", 
			testFile.compilationNode);
		
		BuilderFactory.newlinesBeforeMembers = 0;
		BuilderFactory.breakPackageBracket = false;
		BuilderFactory.breakTypeBracket = false;
		BuilderFactory.breakBlockBracket = false;
	}
}
}