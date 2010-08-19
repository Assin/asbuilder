package org.teotigraphix.as3builder.impl
{

import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.api.ITypeNode;

public class TestAS3FactoryPackage extends TestAS3FactoryBase
{
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
		var file:ISourceFile = project.newClass("my.domain.Test");
		var typeNode:ITypeNode = file.compilationNode.typeNode;
		
		assertBuild("package my.domain {\n    public class Test {\n        \n    }\n}", 
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
	 *     public function MyClass():void {
	 *     }
	 * }
	*/
	public function testTypeImports():void
	{
		var file:ISourceFile = project.newFunction("my.domain.MyClass");
		var packageNode:IPackageNode = file.compilationNode.packageNode;
		var typeNode:ITypeNode = file.compilationNode.typeNode;
		
		packageNode.newImport("my.other.Class");
		packageNode.newImport("my.IInterface");
		packageNode.newImport("my.other.thing.over.There");
		
		assertBuild("package my.domain {\n    import my.other.Class;\n    " +
			"import my.IInterface;\n    import my.other.thing.over.There;\n    " +
			"public function MyClass():void {\n    }\n}", 
			file.compilationNode);
	}
}
}