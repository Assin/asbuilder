package org.as3commons.asbook.impl
{

import com.ericfeminella.collections.HashMap;
import com.ericfeminella.collections.IMap;

import org.as3commons.asblocks.IASProject;
import org.as3commons.asblocks.IASWalker;
import org.as3commons.asblocks.api.IClassType;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IField;
import org.as3commons.asblocks.api.IFunctionType;
import org.as3commons.asblocks.api.IInterfaceType;
import org.as3commons.asblocks.api.IMethod;
import org.as3commons.asblocks.api.IPackage;
import org.as3commons.asblocks.api.IScriptNode;
import org.as3commons.asblocks.parser.api.AS3NodeKind;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asbook.api.IASBook;
import org.as3commons.asbook.api.IASBookAccess;
import org.as3commons.asbook.api.IASBookProcessor;
import org.as3commons.asbook.api.ICompilationPackage;
import org.as3commons.asbuilder.impl.ASBuilderFactory;

/**
 * The concrete implementation of the <code>IASBook</code> API.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ASBook implements IASBook
{
	private var _project:IASProject;
	
	/**
	 * @private
	 */
	private var _processor:IASBookProcessor;
	
	/**
	 * @private
	 */
	private var walker:IASWalker;
	
	/**
	 * @private
	 */
	internal var packages:IMap = new HashMap(); // ICompilationPackage
	
	/**
	 * @private
	 */
	internal var units:IMap = new HashMap(); // ICompilationUnit
	
	/**
	 * A full IType of all types in the current book (class, interface, function).
	 */
	internal var types:IMap = new HashMap(); // IType
	
	/**
	 * @private
	 */
	internal var classes:IMap = new HashMap(); // IType
	
	/**
	 * @private
	 */
	internal var interfaces:IMap = new HashMap(); // IType
	
	/**
	 * @private
	 */
	internal var functions:IMap = new HashMap(); // IType
	
	/**
	 * @private
	 */
	internal var superclasses:IMap = new HashMap(); // IClassType
	
	/**
	 * @private
	 */
	internal var subclasses:IMap = new HashMap(); // IClassType
	
	/**
	 * @private
	 */
	internal var implementedinterfaces:IMap = new HashMap(); // IInterfaceType
	
	/**
	 * @private
	 */
	internal var interfaceImplementors:IMap = new HashMap(); // IClassType
	
	/**
	 * @private
	 */
	internal var superInterfaces:IMap = new HashMap(); // IInterfaceType
	
	/**
	 * @private
	 */
	internal var subInterfaces:IMap = new HashMap(); // IInterfaceType
	
	/**
	 * @private
	 */
	internal var placeholders:IMap = new HashMap(); // IType
	
	/**
	 * @private
	 */
	internal var fields:IMap = new HashMap(); // IField
	
	/**
	 * @private
	 */
	internal var methods:IMap = new HashMap(); // IMethod
	
	protected function get factory():ASBuilderFactory
	{
		if (!_project)
			return null;
		
		return _project.factory as ASBuilderFactory;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IASBook API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  access
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _access:IASBookAccess;
	
	/**
	 * @copy org.as3commons.asbook.api.IASBook#access
	 */
	public function get access():IASBookAccess
	{
		return _access;
	}
	
	/**
	 * @private
	 */	
	public function set access(value:IASBookAccess):void
	{
		_access = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ASBook(project:IASProject)
	{
		super();
		
		_project = project;
		
		_processor = factory.newASBookProccessor(this);
		_access = factory.newASBookAccess(this);
		walker = factory.newASBookWalker(this);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IASBook API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.as3commons.asbook.api.IASBook#addCompilationUnit()
	 */
	public function addCompilationUnit(unit:ICompilationUnit):void
	{
		var packageName:String = unit.packageName;
		var cpackage:ICompilationPackage = packages.getValue(packageName);
		if (!cpackage)
		{
			cpackage = new CompilationPackage(packageName, null);
			packages.put(packageName, cpackage);
		}
		cpackage.add(unit);
		units.put(unit.qname.qualifiedName, unit);
	}
	
	/**
	 * @private
	 */
	internal function addPackage(element:IPackage):void
	{
		
	}
	
	/**
	 * @private
	 */
	internal function addClass(element:IClassType):void
	{
		types.put(element.qualifiedName, element);
		classes.put(element.qualifiedName, element);
	}
	
	/**
	 * @private
	 */
	internal function addInterface(element:IInterfaceType):void
	{
		types.put(element.qualifiedName, element);
		interfaces.put(element.qualifiedName, element);
	}
	
	/**
	 * @private
	 */
	internal function addFunction(element:IFunctionType):void
	{
		types.put(element.qualifiedName, element);
		functions.put(element.qualifiedName, element);
	}
	
	/**
	 * @private
	 */
	internal function addField(element:IField):void
	{
		// need the compilation unit or type.
		var unit:ICompilationUnit = getCompilationUnit(element);
		// if (element.documentation.hasDocTag("private"))
		var name:String = unit.qname.qualifiedName;
		var list:Vector.<IField> = fields.getValue(name);
		if (!list)
		{
			list = new Vector.<IField>();
			fields.put(name, list);
		}
		list.push(element);
	}
	
	/**
	 * @private
	 */
	internal function addMethod(element:IMethod):void
	{
		// need the compilation unit or type.
		var unit:ICompilationUnit = getCompilationUnit(element);
		// if (element.documentation.hasDocTag("private"))
		var name:String = unit.qname.qualifiedName;
		var list:Vector.<IMethod> = methods.getValue(name);
		if (!list)
		{
			list = new Vector.<IMethod>();
			methods.put(name, list);
		}
		list.push(element);
	}
	
	private function getCompilationUnit(element:IScriptNode):ICompilationUnit
	{
		var ast:IParserNode = element.node;
		while (ast)
		{
			if (ast.isKind(AS3NodeKind.COMPILATION_UNIT))
			{
				for each (var unit:ICompilationUnit in units.getValues())
				{
					if (unit.node === ast)
						return unit;
				}
			}
			ast = ast.parent;
		}
		return null;
	}
	
	/**
	 * @copy org.as3commons.asbook.api.IASBook#process()
	 */
	public function process():void
	{
		walker.walkProject(_project);
		
		_processor.process();
	}
}
}