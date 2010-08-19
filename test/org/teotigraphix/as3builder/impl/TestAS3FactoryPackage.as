package org.teotigraphix.as3builder.impl
{

import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.api.ITypeNode;

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
}
}