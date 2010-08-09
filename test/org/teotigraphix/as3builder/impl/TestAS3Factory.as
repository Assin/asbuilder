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
	
	[Test]
	/*
	 * package {
	 *     public class Test {
	 *         
	 *     }
	 * }
	 */
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
		
		assertBuild("package {\n    public class Test {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     public final class Test {
	*         
	*     }
	* }
	*/
	public function testBasicFinalClass():void
	{
		var testFile:ISourceFile = project.newClass("Test");
		var classType:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		classType.isFinal = true; 
		
		assertBuild("package {\n    public final class Test {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	[Test]
	/*
	* package {
	*     /~~
	*      ~ A class comment. 
	*      ~/
	*     public class Test {
	*         
	*     }
	* }
	*/
	public function testBasicCommentClass():void
	{
		var testFile:ISourceFile = project.newClass("Test");
		var classType:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		classType.description = "A class comment.";
		
		assertBuild("package {\n    /**\n     * A class comment. \n     */\n    public class Test {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	[Test]
	/*
	 * package {
	 *     /~~
	 *      ~ A class comment.
	 *      ~ 
	 *      ~ <p>Long description documentation.</p> 
	 *      ~/
	 *     public class Test {
	 *         
	 *     }
	 * }
	 */
	public function testShortLongCommentClass():void
	{
		var testFile:ISourceFile = project.newClass("Test");
		var classType:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		classType.description = "A class comment.\n <p>Long description documentation.</p>";
		
		assertBuild("package {\n    /**\n     * A class comment.\n     * \n     * <p>Long description " +
			"documentation.</p> \n     */\n    public class Test {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	[Test]
	/*
	 * package {
	 *     /~~
	 *      ~ A class comment.
	 *      ~ 
	 *      ~ <p>Long description documentation.</p> 
	 *      ~ 
	 *      ~ @author Jane Doe
	 *      ~ @author John Doe
	 *      ~/
	 *     public class Test {
	 *         
	 *     }
	 * }
	 */
	public function testShortLongDocTagsCommentClass():void
	{
		var testFile:ISourceFile = project.newClass("Test");
		var classType:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		classType.description = "A class comment.\n <p>Long description documentation.</p>";
		
		classType.comment.addDocTag("author", "Jane Doe");
		classType.comment.addDocTag("author", "John Doe");
		
		assertBuild("package {\n    /**\n     * A class comment.\n     * \n     * " +
			"<p>Long description documentation.</p> \n     * \n     * " +
			"@author Jane Doe\n     * @author John Doe\n     */\n    " +
			"public class Test {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	/*
	* package {
	*     public dynamic class Test {
	*         
	*     }
	* }
	*/
	public function testBasicDynamicClass():void
	{
		var testFile:ISourceFile = project.newClass("Test");
		var classType:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		classType.isDynamic = true;
		
		assertBuild("package {\n    public dynamic class Test {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	[Test]
	/*
	 * package {
	 *     public class Test extends A {
	 *         
	 *     }
	 * }
	 */
	public function testBasicClassExtends():void
	{
		var testFile:ISourceFile = project.newClass("Test");
		var type:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		type.superClass = IdentifierNode.createType("A");
		
		assertBuild("package {\n    public class Test extends A {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	[Test]
	/*
	 * package {
	 *     public class Test extends A implements IA, IB {
	 *         
	 *     }
	 * }
	 */
	public function testBasicClassExtendsImplements():void
	{
		var testFile:ISourceFile = project.newClass("Test");
		var type:IClassTypeNode = testFile.compilationNode.typeNode as IClassTypeNode;
		type.superClass = IdentifierNode.createType("A");
		type.addImplementation(IdentifierNode.createType("IA"));
		type.addImplementation(IdentifierNode.createType("IB"));
		
		assertBuild("package {\n    public class Test extends A implements IA, IB {\n        \n    }\n}", 
			testFile.compilationNode);
	}
	
	protected function assertBuild(text:String, compilationNode:ICompilationNode):void
	{
		var result:String = BuilderFactory.instance.buildTest(compilationNode.node);
		Assert.assertEquals(text, result);
	}
}
}