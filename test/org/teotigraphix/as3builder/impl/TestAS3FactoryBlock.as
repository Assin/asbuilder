package org.teotigraphix.as3builder.impl
{

import org.teotigraphix.as3blocks.api.IExpressionNode;
import org.teotigraphix.as3nodes.api.IMethodNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3blocks.api.IfStatementNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.impl.IdentifierNode;

public class TestAS3FactoryBlock extends TestAS3FactoryBase
{
	
	[Test]
	/*
	* package {
	*     public class Test {
	*         public function testMethod():String {
	*         }
	*     }
	* }
	*/
	public function testBasic():void
	{
		var testClassFile:ISourceFile = project.newClass("Test");
		var typeNode:ITypeNode = testClassFile.compilationNode.typeNode;
		
		var method:IMethodNode = typeNode.newMethod(
			"testMethod", Modifier.PUBLIC, IdentifierNode.createType("String"));
		
		
		var expr:IExpressionNode// = method.newIf("test()");
		
		//var ifStatement:IfStatementNode = method.newIf(expr);
		//ifStatement.addStatement("trace('test succeeded')");
		//ifStatement.elseBlock.addStatement("trace('test failed')");
		
		
		
		
		
		
		
		//assertBuild("package {\n    public class Test {\n        public function " +
		//	"testMethod():String {\n        }\n    }\n}", 
		//	testClassFile.compilationNode);
	}
}
}