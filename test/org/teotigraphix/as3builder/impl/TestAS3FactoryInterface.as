package org.teotigraphix.as3builder.impl
{

import org.teotigraphix.as3nodes.api.IInterfaceTypeNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.impl.IdentifierNode;

public class TestAS3FactoryInterface extends TestAS3FactoryBase
{
	[Test]
	/*
	* package {
	*     public interface ITest {
	*    
	*     }
	* }
	*/
	public function testBasicInterface():void
	{
		var testInterfaceFile:ISourceFile = project.newInterface("ITest");
		
		assertBuild("package {\n    public interface ITest {\n        \n    }\n}", 
			testInterfaceFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public interface ITest extends IA, IB {
	*         
	*     }
	* }
	*/
	public function testBasicInterfaceExtends():void
	{
		var testInterfaceFile:ISourceFile = project.newInterface("ITest");
		var type:IInterfaceTypeNode = testInterfaceFile.compilationNode.typeNode as IInterfaceTypeNode;
		type.addSuperInterface(IdentifierNode.createType("IA"));
		type.addSuperInterface(IdentifierNode.createType("IB"));
		
		assertBuild("package {\n    public interface ITest extends IA, IB {\n        \n    }\n}", 
			testInterfaceFile.compilationNode);
	}
}
}