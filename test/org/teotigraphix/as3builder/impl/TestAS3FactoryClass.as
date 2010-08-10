package org.teotigraphix.as3builder.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
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
		
		assertBuild("package {\n    /**\n     * A class comment. \n     */\n    " +
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
			"documentation.</p> \n     */\n    public class Test {\n        \n    }\n}", 
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
		
		classType.comment.addDocTag("author", "Jane Doe");
		classType.comment.addDocTag("author", "John Doe");
		
		assertBuild("package {\n    /**\n     * A class comment.\n     * \n     * " +
			"<p>Long description documentation.</p> \n     * \n     * " +
			"@author Jane Doe\n     * @author John Doe\n     */\n    " +
			"public class Test {\n        \n    }\n}", 
			testFile.compilationNode);
	}
}
}