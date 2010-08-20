package org.teotigraphix.as3builder.impl
{

import flash.filesystem.File;

import flexunit.framework.Assert;

import org.teotigraphix.as3nodes.api.IAS3Project;
import org.teotigraphix.as3nodes.api.ICompilationNode;
import org.teotigraphix.as3nodes.impl.AS3Factory;

public class TestAS3FactoryBase
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
	
	protected function assertBuild(text:String, compilationNode:ICompilationNode):void
	{
		var result:String = BuilderFactory.instance.build(compilationNode.node);
		Assert.assertEquals(text, result);
	}
}
}