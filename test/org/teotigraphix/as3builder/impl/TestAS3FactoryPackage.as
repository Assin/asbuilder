package org.teotigraphix.as3builder.impl
{

import org.osmf.metadata.IIdentifier;
import org.teotigraphix.as3nodes.api.Access;
import org.teotigraphix.as3nodes.api.IAccessorNode;
import org.teotigraphix.as3nodes.api.IAttributeNode;
import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.IConstantNode;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.IMethodNode;
import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3nodes.api.IParameterNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.impl.AS3SourceFile;
import org.teotigraphix.as3nodes.impl.IdentifierNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.utils.ASTUtil;

public class TestAS3FactoryPackage extends TestAS3FactoryBase
{
	[Test]
	/*
	 * /~~
	 *  ~ This is a package level block comment.
	 *  ~/
	 * package my.domain {
	 *     public class MyClass {
	 *         
	 *     }
	 * }
	*/
	public function testBlockComment():void
	{
		var file:ISourceFile = project.newClass("my.domain.MyClass");
		var typeNode:ITypeNode = file.compilationNode.typeNode;
		file.compilationNode.packageNode.newBlockComment("This is a package level block comment.", false);
		
		assertBuild("/**\n * This is a package level block comment.\n */" +
			"\npackage my.domain {\n    public class MyClass {\n        \n    }\n}", 
			file.compilationNode);
	}
	
	[Test]
	/*
	* package my.domain {
	*     public class Test {
	*         
	*     }
	* }
	*/
	public function testClass():void
	{
		var file:ISourceFile = project.newClass("my.domain.MyClass");
		var typeNode:ITypeNode = file.compilationNode.typeNode;
		
		assertBuild("package my.domain {\n    public class MyClass {\n        \n    }\n}", 
			file.compilationNode);
	}
	
	[Test]
	/*
	* package my.domain {
	*     public interface ITest {
	*         
	*     }
	* }
	*/
	public function testInterface():void
	{
		var file:ISourceFile = project.newInterface("my.domain.ITest");
		var typeNode:ITypeNode = file.compilationNode.typeNode;
		
		assertBuild("package my.domain {\n    public interface ITest {\n        \n    }\n}", 
			file.compilationNode);
	}
	
	[Test]
	/*
	 * package my.domain {
	 *     public function myFunction():void {
	 *     }
	 * }
	 */
	public function testFunction():void
	{
		var file:ISourceFile = project.newFunction("my.domain.myFunction");
		var typeNode:ITypeNode = file.compilationNode.typeNode;
		
		assertBuild("package my.domain {\n    public function myFunction():void {\n    }\n}", 
			file.compilationNode);
	}
	
	[Test]
	/*
	 * package my.domain {
	 *     import my.other.Class;
	 *     import my.IInterface;
	 *     import my.other.thing.over.There;
	 *     public class MyClass {
	 *         
	 *     }
	 * }
	*/
	public function testTypeImports():void
	{
		var file:ISourceFile = project.newClass("my.domain.MyClass");
		var packageNode:IPackageNode = file.compilationNode.packageNode;
		var typeNode:ITypeNode = file.compilationNode.typeNode;
		
		packageNode.newImport("my.other.Class");
		packageNode.newImport("my.IInterface");
		packageNode.newImport("my.other.thing.over.There");
		
		assertBuild("package my.domain {\n    import my.other.Class;\n    " +
			"import my.IInterface;\n    import my.other.thing.over.There;\n    " +
			"public class MyClass {\n        \n    }\n}", 
			file.compilationNode);
	}
	
	[Test]
	/*
	 * package my.domain {
	 *     include '../my/include/File.as'
	 *     include '../my/other/include/File.as'
	 *     public class MyClass {
 	 *        
	 *     }
	 * }
	*/
	public function testTypeIncludes():void
	{
		var file:ISourceFile = project.newClass("my.domain.MyClass");
		var packageNode:IPackageNode = file.compilationNode.packageNode;
		var typeNode:ITypeNode = file.compilationNode.typeNode;
		
		packageNode.newInclude("../my/include/File.as");
		packageNode.newInclude("../my/other/include/File.as");
		
		assertBuild("package my.domain {\n    include '../my/include/File.as'\n    " +
			"include '../my/other/include/File.as'\n    public class MyClass {\n" +
			"        \n    }\n}", 
			file.compilationNode);
	}
	
	[Test]
	/*
	 * package my.domain {
	 *     use namespace mx_internal;
	 *     use namespace flash_proxy;
	 *     public class MyClass {
	 *         
	 *     }
	 * }
	 */
	public function testTypeUses():void
	{
		var file:ISourceFile = project.newClass("my.domain.MyClass");
		var packageNode:IPackageNode = file.compilationNode.packageNode;
		var typeNode:ITypeNode = file.compilationNode.typeNode;
		
		packageNode.newUse("mx_internal");
		packageNode.newUse("flash_proxy");
		
		assertBuild("package my.domain {\n    use namespace mx_internal;\n    " +
			"use namespace flash_proxy;\n    public class MyClass {\n        " +
			"\n    }\n}", 
			file.compilationNode);
	}
	
	[Test]
	/*
	* package my.domain {
	*     use namespace mx_internal;
	*     use namespace flash_proxy;
	*     public class MyClass {
	*         
	*     }
	* }
	*/
	public function testFull():void
	{
		// create the file
		var file:ISourceFile = project.newClass("my.domain.MyClass");
		var packageNode:IPackageNode = file.compilationNode.packageNode;
		var typeNode:IClassTypeNode = packageNode.typeNode as IClassTypeNode;
		// add a package block comment
		packageNode.newBlockComment("A package block comment.", false);
		// add imports
		packageNode.newImport("my.api.IInterfaceA");
		packageNode.newImport("my.api.IInterfaceB");
		packageNode.newImport("my.domain.sub.SubTest");
		packageNode.newImport("mx.core.mx_internal");
		// add and include
		packageNode.newInclude("../som/folder/includeFile.as");
		// addd a use namepsace
		packageNode.newUse("mx_internal");
		// make class dynamic
		typeNode.isDynamic = true;
		// add a superclass
		typeNode.superClass = IdentifierNode.createType("ClassA");
		// add implementors
		typeNode.addImplementation(IdentifierNode.createType("IInterfaceA"));
		typeNode.addImplementation(IdentifierNode.createType("IInterfaceB"));
		// add a [Bindable] meta to class
		typeNode.newMetaData("Bindable");
		// add a style
		var style:IMetaDataNode = typeNode.newMetaData("Style");
		style.addNamedStringParameter("name", "myStyle");
		style.addNamedStringParameter("type", "Number");
		style.addNamedStringParameter("inherit", "no");
		// add a comment to the style
		style.description = "A new style.";
		style.newDocTag("see", "#style:theOtherStyle");
		// add a class description
		typeNode.description = "A groovy class generated by as3builder-framework!";
		typeNode.newDocTag("author", "Michael Schmalle");
		typeNode.newDocTag("date", "08-19-2010");

		// add a constant
		var constant:IConstantNode = typeNode.newConstant("MY_CONSTANT", Modifier.PUBLIC, 
			IdentifierNode.createType("String"), "\"value\"");
		constant.description = "My constant.";
		
		// add an attribute
		var attribute:IAttributeNode = typeNode.newAttribute("myAttribute", Modifier.PROTECTED, 
			IdentifierNode.createType("IModel"), "null");
		attribute.description = "My attribute.";
		attribute.newDocTag("private");
		attribute.newMetaData("Inject");
		
		// add an accessor
		var vo:IIdentifierNode = IdentifierNode.createType("ValueObject");
		var getter:IAccessorNode = typeNode.newAccessor(
			"myProperty", Modifier.PUBLIC, Access.READ, vo);
		getter.description = "A property.";
		getter.newMetaData("Bindable");
		var inject:IMetaDataNode = getter.newMetaData("Inject");
		inject.addNamedStringParameter("source", "model.property");
		var setter:IAccessorNode = typeNode.newAccessor(
			"myProperty", Modifier.PUBLIC, Access.WRITE, vo);
		setter.newDocTag("private");
		
		// add constructor
		var constructor:IMethodNode = typeNode.newMethod("MyClass", Modifier.PUBLIC, null);
		constructor.description = "Constructor.";
		
		// add a method
		var method:IMethodNode = typeNode.newMethod(
			"myMethod", Modifier.PUBLIC, IdentifierNode.createType("void"));
		method.description = "Mediates a Swiz framework [Mediate] tag.";
		var param:IParameterNode = method.newParameter(
			"data", IdentifierNode.createType("Object"), "null");
		method.newDocTag("param", "data A mediated data object");
		var mediate:IMetaDataNode = method.newMetaData("Mediate");
		mediate.addNamedStringParameter("event", "MyEvent.DATA_CHANGE");
		method.addReturnDescription("Returns nothing.");
		
		//BuilderFactory.newlinesBeforeMembers = 1;
		//BuilderFactory.breakPackageBracket = true;
		//BuilderFactory.breakTypeBracket = true;
		//BuilderFactory.breakBlockBracket = true;
		
		//assertBuild("package my.domain {\n    use namespace mx_internal;\n    " +
		//	"use namespace flash_proxy;\n    public class MyClass {\n        " +
		//	"\n    }\n}", 
		//	file.compilationNode);
		
		//BuilderFactory.newlinesBeforeMembers = 0;
		//BuilderFactory.breakPackageBracket = false;
		//BuilderFactory.breakTypeBracket = false;
		//BuilderFactory.breakBlockBracket = false;
	}
	
	
	[Test]
	public function testBasicParseMethod():void
	{
		var code:String =
			"package my.domain {" +
			"public class UnitTest {" +
			"protected const MY_CONSTANT:int = 42;" +
			"[Test]public function testMethod1():void{}" +
			"[Test]public function testMethod2():void{}" +
			"[Test]public function testMethod3():void{}" +
			"}}"
		
		var file:AS3SourceFile = new AS3SourceFile(new SourceCode(code, ""));
		file.buildAst();
		
		var typeNode:ITypeNode = file.compilationNode.typeNode;
		var method:IMethodNode = typeNode.getMethod("testMethod2");
		method.description = "See, this editing a string with code is fun!";
		method.newDocTag("author", "Yeah me");
		var meta:IMetaDataNode = method.getMetaData("Test");
		meta.description = "Just in case you didn't know, I unit test.";
		
		typeNode.removeMethod(typeNode.getMethod("testMethod1"));
		typeNode.newMetaData("TestSuite");
		
		typeNode.description = "Class documentation is good also, but I am lazy!"
		
		var result:String = BuilderFactory.instance.buildFile(file);
		
		//assertBuild("package {\n    public class Test {\n        public function " +
		//	"testMethod():String {\n        }\n    }\n}", 
		//	sourceNode.compilationNode);
	}
}
}