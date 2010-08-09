package org.teotigraphix.as3book.impl
{

import org.teotigraphix.as3book.api.IAS3Book;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.impl.NodeFactory;
import org.teotigraphix.as3parser.utils.FileUtil;

public class AbstractElementTest
{
	protected var numPackages:int = 6;
	protected var numClasses:int = 8;
	protected var numInterfaces:int = 3;
	protected var numFunctions:int = 1;
	
	protected static var book:IAS3Book;
	
	protected static var classPath:String = "C:\\dev\\workspace\\opensource\\as3builder-framework-tests\\src";
	
	protected static var ADefaultPackageClass:String = classPath + "\\ADefaultPackageClass.as";
	protected static var RestrictedClass:String = classPath + "\\org\\example\\core\\restricted\\RestrictedClass.as";
	protected static var ClassA:String = classPath + "\\org\\example\\core\\ClassA.as";
	protected static var functionA:String = classPath + "\\org\\example\\core\\functionA.as";
	protected static var ICoreInterface:String = classPath + "\\org\\example\\core\\ICoreInterface.as";
	protected static var ClassB:String = classPath + "\\org\\example\\core\\ClassB.as";
	protected static var ClassC:String = classPath + "\\org\\example\\core\\ClassC.as";
	protected static var ClassD:String = classPath + "\\org\\example\\util\\ClassD.as";
	protected static var ClassE:String = classPath + "\\org\\example\\impl\\ClassE.as";
	protected static var TypeClass:String = classPath + "\\org\\example\\impl\\TypeClass.as";
	protected static var InterfaceA:String = classPath + "\\org\\example\\interfaces\\IInterfaceA.as";
	protected static var InterfaceB:String = classPath + "\\org\\example\\interfaces\\IInterfaceB.as";
	protected static var TestProject:String = classPath + "\\TestProject.mxml";
	
	[Before]
	public function setUp():void
	{
		//book = BookFactory.instance.createBook();
	}
	
	protected static function parse(filePath:String):ISourceFile
	{
		var data:String = FileUtil.readFile(filePath);
		
		var file:ISourceFile = NodeFactory.instance.
			createSourceFile(data, filePath, classPath);
		
		file.buildAst();
		
		return file;
	}
}
}