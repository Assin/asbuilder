package org.teotigraphix.as3builder.impl
{
import org.teotigraphix.as3nodes.api.IAttributeNode;
import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.impl.IdentifierNode;

public class TestAS3FactoryAttribute extends TestAS3FactoryBase
{
	
	[Test]
	/*
	* package {
	*     public class Test {
	*         public var testAttribute:String;
	*     }
	* }
	*/
	public function testBasicClassAttribute():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:IClassTypeNode = testClassFile.compilationNode.typeNode as IClassTypeNode;
		 
		var attribute:IAttributeNode = typeNode.newAttribute(
			"testAttribute", Modifier.PUBLIC, IdentifierNode.createType("String"), "null");
		
		assertBuild("package {\n    public class Test {\n        public function " +
			"testAttribute:String {\n        }\n    }\n}", 
			testClassFile.compilationNode);
	}
}
}