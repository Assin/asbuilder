package org.teotigraphix.as3builder.impl
{
import flash.filesystem.File;

import flexunit.framework.Assert;

import org.teotigraphix.as3nodes.api.IAS3Project;
import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.ICompilationNode;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IInterfaceTypeNode;
import org.teotigraphix.as3nodes.api.IMethodNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.impl.IdentifierNode;

public class TestAS3Factory
{
	protected var factory:AS3Factory;
	
	protected var project:IAS3Project;
	
	[Before]
	public function setUp():void
	{
		var output:File = File.desktopDirectory.resolvePath("tempTest");
		
		factory = new AS3Factory();
		project = factory.newASProject(output.nativePath);
	}
	
	[Test]
	public function testBasicInterface():void
	{
		var testInterfaceFile:ISourceFile = project.newInterface("ITest");
		
		assertBuild("package \n{\n    public interface ITest \n    {\n        \n    }\n}", 
			testInterfaceFile.compilationNode);
	}
	
	[Test]
	public function testBasicInterfaceExtends():void
	{
		var testInterfaceFile:ISourceFile = project.newInterface("ITest");
		var type:IInterfaceTypeNode = testInterfaceFile.compilationNode.typeNode as IInterfaceTypeNode;
		type.addSuperInterface(IdentifierNode.createType("IA"));
		type.addSuperInterface(IdentifierNode.createType("IB"));
		
		assertBuild("package \n{\n    public interface ITest extends IA, IB \n    {\n        \n    }\n}", 
			testInterfaceFile.compilationNode);
	}
	
	[Test]
	public function testBasicClass():void
	{
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
	public function testBasicClassExtends():void
	{
		var testFile:ISourceFile = project.newClass("Test");
		var type:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		type.superClass = IdentifierNode.createType("A");
		
		assertBuild("package \n{\n    public class Test extends A \n    {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	
	[Test]
	public function testBasicClassExtendsImplements():void
	{
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