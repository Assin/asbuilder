package org.teotigraphix.asbuilder.impl
{
import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IClassType;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IMethod;
import org.as3commons.asblocks.api.Visibility;
import org.as3commons.asblocks.utils.ASTUtil;

public class TestASBuilderProject
{
	[Test]
	/**
	 * package {
	 * 	public class Test {
	 * 		public function test():void {
	 * 			trace('Hello world');
	 * 		}
	 * 	}
	 * }
	 */
	public function test_basicExample():void
	{
		var data:String = "package {\n" +
			"	public class Test {\n" +
			"		public function test():void {\n" +
			"			trace('Hello world1');\n" +
			"			trace('Hello world2');\n" +
			"		}\n" +
			"	}\n" +
			"}"
		
		var factory:ASBuilderFactory = new ASBuilderFactory();
		var project:ASBuilderProject = factory.newEmptyASProject(".") as ASBuilderProject;
		var unit:ICompilationUnit = project.newClass("Test");
		var clazz:IClassType = unit.typeNode as IClassType;
		clazz.newMetaData("Test");
		var method:IMethod = clazz.newMethod("test", Visibility.PUBLIC, "void");
		method.addStatement("trace('Hello world1')");
		method.addStatement("trace('Hello world2')");
		project.writeAll();
		
		var u:ICompilationUnit = factory.newParser().parseString(data);
		
		var result1:String = ASTUtil.convert(unit.node, false);
		var result2:String = ASTUtil.convert(u.node, false);
		
		CodeMirror.assertReflection(factory, unit);
	}
}
}