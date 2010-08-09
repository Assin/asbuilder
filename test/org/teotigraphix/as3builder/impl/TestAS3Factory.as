package org.teotigraphix.as3builder.impl
{
import flash.filesystem.File;

import flexunit.framework.Assert;

import org.teotigraphix.as3nodes.api.IAS3Project;
import org.teotigraphix.as3nodes.api.IMethodNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.api.Modifier;

public class TestAS3Factory
{
	[Before]
	public function setUp():void
	{
		
	}
	
	[Test]
	public function test():void
	{
		var temp:File = File.desktopDirectory.resolvePath("tempTest");
		
		var factory:AS3Factory = new AS3Factory();
		var project:IAS3Project = factory.newASProject(temp.nativePath);
		
		var classAFile:ISourceFile = project.newClass("Test");
		
		Assert.assertEquals("Test", classAFile.name);
		Assert.assertEquals("Test.as", classAFile.fileName);
		Assert.assertNotNull(classAFile.compilationNode);
		Assert.assertEquals("", classAFile.compilationNode.packageName);
		Assert.assertStrictlyEquals(classAFile, classAFile.compilationNode.parent);
		Assert.assertNotNull(classAFile.compilationNode.packageNode);
		Assert.assertNotNull(classAFile.compilationNode.typeNode);
		Assert.assertEquals("Test", classAFile.compilationNode.typeNode.name);
		Assert.assertEquals("", classAFile.compilationNode.typeNode.packageName);
		Assert.assertEquals("Test", classAFile.compilationNode.typeNode.qualifiedName);
		
		
		var result:String = BuilderFactory.instance.buildTest(classAFile.compilationNode.node);
		
		//var method:IMethodNode = classA.newMethod("test", Modifier.PUBLIC, "void");
		//metho.addStatement("trace('Hello World')");
		project.write();
	}
}
}