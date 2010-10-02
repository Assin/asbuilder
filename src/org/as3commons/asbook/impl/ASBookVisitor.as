package org.as3commons.asbook.impl
{

import org.as3commons.asblocks.IASProject;
import org.as3commons.asblocks.api.IClassType;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IField;
import org.as3commons.asblocks.api.IFunctionType;
import org.as3commons.asblocks.api.IInterfaceType;
import org.as3commons.asblocks.api.IMethod;
import org.as3commons.asblocks.api.IPackage;
import org.as3commons.asblocks.api.IScriptNode;
import org.as3commons.asblocks.api.IType;
import org.as3commons.asblocks.visitor.NullASVisitor;
import org.as3commons.asbook.api.IASBook;

// IASProject [outputLocation]
//   - ICompilationUnit [filePath]
//     - IPackage 
//       - IType [filePath/qualifiedName]
//         - IField 
//         - IMethod

public class ASBookVisitor extends NullASVisitor
{
	protected var book:ASBook;
	
	protected var currentProject:IASProject;
	
	protected var projectKey:String;
	
	protected var currentType:IType;
	
	public function ASBookVisitor(book:IASBook)
	{
		super();
		
		this.book = book as ASBook;
	}
	
	public static function toLink(element:IScriptNode):String
	{
		if (element is IASProject)
		{
			return IASProject(element).outputLocation;
		}
		else if (element is ICompilationUnit)
		{
			return ICompilationUnit(element).sourceCode.filePath;
		}
		return null;
	}
	
	override public function visitProject(element:IASProject):void
	{
		currentProject = element;
		projectKey = currentProject.outputLocation;
	}
	
	override public function visitPackage(element:IPackage):void
	{
		book.addPackage(element);
	}
	
	override public function visitCompilationUnit(element:ICompilationUnit):void
	{
		book.addCompilationUnit(element);
	}
	
	override public function visitType(element:IType):void
	{
		currentType = element;
	}
	
	override public function visitClass(element:IClassType):void
	{
		book.addClass(element);
	}
	
	override public function visitInterface(element:IInterfaceType):void
	{
		book.addInterface(element);
	}
	
	override public function visitFunction(element:IFunctionType):void
	{
		book.addFunction(element);
	}
	
	override public function visitField(element:IField):void
	{
		book.addField(element);
	}
	
	override public function visitMethod(element:IMethod):void
	{
		book.addMethod(element);
	}
}
}