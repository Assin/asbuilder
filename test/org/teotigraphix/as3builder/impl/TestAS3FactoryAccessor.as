package org.teotigraphix.as3builder.impl
{

import org.teotigraphix.as3nodes.api.IAccessorNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.impl.IdentifierNode;

public class TestAS3FactoryAccessor extends TestAS3FactoryBase
{
	
	[Test]
	/*
	* package {
	*     public class Test {
	*         public function get testProperty():String {
	*             return null;
	*         }
	*     }
	* }
	*/
	public function testBasicClassAccessor():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:ITypeNode = testClassFile.compilationNode.typeNode;
		
		var accessor:IAccessorNode = typeNode.newAccessor(
			"testProperty", Modifier.PUBLIC, "read", IdentifierNode.createType("String"));
		
		//assertBuild("package {\n    public class Test {\n        public function " +
		//	"testMethod():String {\n        }\n    }\n}", 
		//	testClassFile.compilationNode);
	}
}
}