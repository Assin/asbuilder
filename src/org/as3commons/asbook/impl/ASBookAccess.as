package org.as3commons.asbook.impl
{

import org.as3commons.asblocks.api.IClassType;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IFunctionType;
import org.as3commons.asblocks.api.IInterfaceType;
import org.as3commons.asblocks.api.IType;
import org.as3commons.asbook.api.IASBook;
import org.as3commons.asbook.api.IASBookAccess;
import org.as3commons.asbook.api.ICompilationPackage;

/**
 * Concrete implementation of the <code>IASBookAccessor</code> api.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ASBookAccess implements IASBookAccess
{
	//--------------------------------------------------------------------------
	//
	//  IAS3BookAccessor API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  book
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _book:ASBook;
	
	/**
	 * @copy org.as3commons.asbook.api.IASBookAccess#book
	 */
	public function get book():IASBook
	{
		return _book;
	}
	
	//----------------------------------
	//  packages
	//----------------------------------
	
	/**
	 * @copy org.as3commons.asbook.api.IASBookAccess#packages
	 */
	public function get packages():Vector.<ICompilationPackage>
	{
		var result:Vector.<ICompilationPackage> = new Vector.<ICompilationPackage>();
		
		for each (var element:ICompilationPackage in _book.packages.getValues())
		{
			result.push(element);
		}
		
		return result;
	}
	
	//----------------------------------
	//  units
	//----------------------------------
	
	/**
	 * @copy org.as3commons.asbook.api.IASBookAccess#units
	 */
	public function get units():Vector.<ICompilationUnit>
	{
		var result:Vector.<ICompilationUnit> = new Vector.<ICompilationUnit>();
		
		for each (var element:ICompilationPackage in _book.units.getValues())
		{
			result.push(element);
		}
		
		return result;
	}
	
	//----------------------------------
	//  types
	//----------------------------------
	
	/**
	 * @copy org.as3commons.asbook.api.IASBookAccess#types
	 */
	public function get types():Vector.<IType>
	{
		var result:Vector.<IType> = new Vector.<IType>();
		
		for each (var element:IType in _book.types.getValues())
		{
			result.push(element);
		}
		
		return result;
	}
	
	//----------------------------------
	//  classes
	//----------------------------------
	
	/**
	 * @copy org.as3commons.asbook.api.IASBookAccess#classes
	 */
	public function get classes():Vector.<IClassType>
	{
		var result:Vector.<IClassType> = new Vector.<IClassType>();
		
		for each (var element:IClassType in _book.classes.getValues())
		{
			result.push(element);
		}
		
		return result;
	}
	
	//----------------------------------
	//  interfaces
	//----------------------------------
	
	/**
	 * @copy org.as3commons.asbook.api.IASBookAccess#interfaces
	 */
	public function get interfaces():Vector.<IInterfaceType>
	{
		var result:Vector.<IInterfaceType> = new Vector.<IInterfaceType>();
		
		for each (var element:IInterfaceType in _book.interfaces.getValues())
		{
			result.push(element);
		}
		
		return result;
	}
	
	//----------------------------------
	//  functions
	//----------------------------------
	
	/**
	 * @copy org.as3commons.asbook.api.IASBookAccess#functions
	 */
	public function get functions():Vector.<IFunctionType>
	{
		var result:Vector.<IFunctionType> = new Vector.<IFunctionType>();
		
		for each (var element:IFunctionType in _book.functions.getValues())
		{
			result.push(element);
		}
		
		return result;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ASBookAccess(book:IASBook)
	{
		_book = book as ASBook;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IASBookAccess API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.as3commons.asbook.api.IASBookAccess#getCompilationPackage()
	 */
	public function getCompilationPackage(packageName:String):ICompilationPackage
	{
		var result:ICompilationPackage = _book.packages.getValue(packageName);
		return result;
	}
	
	/**
	 * @copy org.as3commons.asbook.api.IASBookAccess#getCompilationUnit()
	 */
	public function getCompilationUnit(qualifiedName:String):ICompilationUnit
	{
		var result:ICompilationUnit = _book.units.getValue(qualifiedName);
		return result;
	}
	
	/**
	 * @copy org.as3commons.asbook.api.IASBookAccess#findType()
	 */
	public function findType(qualifiedName:String):IType
	{
		var type:IType = _book.types.getValue(qualifiedName);
		return type;
	}
	
	/**
	 * @copy org.as3commons.asbook.api.IASBookAccess#getType()
	 */
	public function getType(qualifiedName:String):IType
	{
		var type:IType = findType(qualifiedName);
		if (type != null)
			return type;
		
		if (_book.placeholders.containsKey(qualifiedName))
			return _book.placeholders.getValue(qualifiedName);
		
		type = new TypePlaceholderNode(qualifiedName);
		
		_book.placeholders.put(qualifiedName, type);
		
		return type;
	}
	
	/**
	 * @copy org.as3commons.asbook.api.IASBookAccess#getTypes()
	 */
	public function getTypes(packageName:String):Vector.<IType>
	{
		var result:Vector.<IType> = new Vector.<IType>();
		
		for each (var element:IType in _book.types.getValues())
		{
			if (element.packageName == packageName)
			{
				result.push(element);
			}
		}
		
		return result;
	}
	
	/**
	 * @copy org.as3commons.asbook.api.IASBookAccess#hasType()
	 */
	public function hasType(qualifiedName:String):Boolean
	{
		return findType(qualifiedName) != null;
	}
	
	/**
	 * @copy org.as3commons.asbook.api.IASBookAccess#findClassType()
	 */
	public function findClassType(qualifiedName:String):IClassType
	{
		return findType(qualifiedName) as IClassType;
	}
	
	/**
	 * @copy org.as3commons.asbook.api.IASBookAccess#findInterfaceType()
	 */
	public function findInterfaceType(qualifiedName:String):IInterfaceType
	{
		return findType(qualifiedName) as IInterfaceType;
	}
	
	/**
	 * @copy org.as3commons.asbook.api.IASBookAccess#findFunctionType()
	 */
	public function findFunctionType(qualifiedName:String):IFunctionType
	{
		return findType(qualifiedName) as IFunctionType;
	}
	
	//----------------------------------
	//  Class
	//----------------------------------
	
	/**
	 * @copy org.as3commons.asbook.api.IASBookAccess#getSuperClasses()
	 */
	public function getSuperClasses(element:IType):Vector.<IType>
	{
		return _book.superclasses.getValue(element.qualifiedName);
	}
	
	/**
	 * @copy org.as3commons.asbook.api.IASBookAccess#getSubClasses()
	 */
	public function getSubClasses(element:IType):Vector.<IType>
	{
		return _book.subclasses.getValue(element.qualifiedName);
	}
	
	/**
	 * @copy org.teotigraphix.as3book.api.IAS3BookAccessor#getImplementedInterfaces()
	 */
	public function getImplementedInterfaces(element:IType):Vector.<IType>
	{
		return _book.implementedinterfaces.getValue(element.qualifiedName);
	}
	
	/**
	 * @copy org.teotigraphix.as3book.api.IAS3BookAccessor#getInterfaceImplementors()
	 */
	public function getInterfaceImplementors(element:IType):Vector.<IType>
	{
		return _book.interfaceImplementors.getValue(element.qualifiedName);
	}
	
	/**
	 * @copy org.teotigraphix.as3book.api.IAS3BookAccessor#getSuperInterfaces()
	 */
	public function getSuperInterfaces(element:IType):Vector.<IType>
	{
		return _book.superInterfaces.getValue(element.qualifiedName);
	}
	
	/**
	 * @copy org.teotigraphix.as3book.api.IAS3BookAccessor#getSubInterfaces()
	 */
	public function getSubInterfaces(element:IType):Vector.<IType>
	{
		return _book.subInterfaces.getValue(element.qualifiedName);
	}
	
}
}