package org.teotigraphix.as3builder.impl
{
import flash.filesystem.File;

import flexunit.framework.Assert;

import org.teotigraphix.as3nodes.api.IAS3Project;
import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.ICompilationNode;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IMethodNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.impl.IdentifierNode;

public class TestAS3Factory
{
	[Before]
	public function setUp():void
	{
		
	}
	
	[Test]
	public function testBasic():void
	{
		var temp:File = File.desktopDirectory.resolvePath("tempTest");
		
		var factory:AS3Factory = new AS3Factory();
		var project:IAS3Project = factory.newASProject(temp.nativePath);
		
		var testFile:ISourceFile = project.newClass("Test");
		
		Assert.assertEquals("Test", testFile.name);
		Assert.assertEquals("Test.as", testFile.fileName);
		Assert.assertNotNull(testFile.compilationNode);
		Assert.assertEquals("", testFile.compilationNode.packageName);
		Assert.assertStrictlyEquals(testFile, testFile.compilationNode.parent);
		Assert.assertNotNull(testFile.compilationNode.packageNode);
		Assert.assertNotNull(testFile.compilationNode.typeNode);
		Assert.assertEquals("Test", testFile.compilationNode.typeNode.name);
		Assert.assertEquals("", testFile.compilationNode.typeNode.packageName);
		Assert.assertEquals("Test", testFile.compilationNode.typeNode.qualifiedName);
		
		assertBuild("package \n{\n    public class Test \n    {\n        \n    }\n}", 
			testFile.compilationNode);
		
		//var method:IMethodNode = classA.newMethod("test", Modifier.PUBLIC, "void");
		//metho.addStatement("trace('Hello World')");
		// project.write();
	}
	
	[Test]
	public function testBasicExtends():void
	{
		var temp:File = File.desktopDirectory.resolvePath("tempTest");
		
		var factory:AS3Factory = new AS3Factory();
		var project:IAS3Project = factory.newASProject(temp.nativePath);
		
		var testFile:ISourceFile = project.newClass("Test");
		var type:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		type.superClass = IdentifierNode.createType("A");
		
		assertBuild("package \n{\n    public class Test extends A \n    {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	
	[Test]
	public function testBasicExtendsImplements():void
	{
		var temp:File = File.desktopDirectory.resolvePath("tempTest");
		
		var factory:AS3Factory = new AS3Factory();
		var project:IAS3Project = factory.newASProject(temp.nativePath);
		
		var testFile:ISourceFile = project.newClass("Test");
		var type:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		type.superClass = IdentifierNode.createType("A");
		type.addImplementation(IdentifierNode.createType("IA"));
		type.addImplementation(IdentifierNode.createType("IB"));
		
		assertBuild("package \n{\n    public class Test extends A implements IA, IB \n    {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	protected function assertBuild(text:String, compilationNode:ICompilationNode):void
	{
		var result:String = BuilderFactory.instance.buildTest(compilationNode.node);
		Assert.assertEquals(text, result);
	}
}
}