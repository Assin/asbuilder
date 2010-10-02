package org.as3commons.asbook.impl
{

import org.as3commons.asblocks.api.IClassType;
import org.as3commons.asblocks.api.IInterfaceType;
import org.as3commons.asblocks.api.IPackage;
import org.as3commons.asblocks.api.IType;
import org.as3commons.asblocks.impl.ASQName;
import org.as3commons.asblocks.parser.api.AS3NodeKind;
import org.as3commons.asbook.api.IASBook;
import org.as3commons.asbook.api.IASBookProcessor;
import org.as3commons.asbook.api.ITypePlaceholder;

/**
 * Processes nodes in the book.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ASBookProcessor implements IASBookProcessor
{
	//--------------------------------------------------------------------------
	//
	//  IASBookProcessor API :: Properties
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
	 * @copy org.as3commons.asbook.api.IASBookProcessor#book
	 */
	public function get book():IASBook
	{
		return _book;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ASBookProcessor(book:IASBook)
	{
		_book = book as ASBook;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IASBookProcessor API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.as3commons.asbook.api.IASBookProcessor#process()
	 */
	public function process():void
	{
		for each (var type:IType in _book.types.getValues())
		{
			if (type is IClassType)
			{
				proccessClassTree(IClassType(type));
				proccessClassImplementations(IClassType(type));
			}
			else if (type is IInterfaceType)
			{
				proccessInterfaceTree(IInterfaceType(type));
			}
		}
	}
	
	/**
	 * @private
	 */
	private function proccessClassTree(type:IClassType):void
	{
		if (type.isSubType)
		{
			_book.superclasses.put(type.qualifiedName, cacheSuperClasses(type));
			
			var superType:IClassType = getType(type.qualifiedSuperClass) as IClassType;
			if (superType != null)
			{
				var list:Vector.<IType> = _book.subclasses.getValue(superType.qualifiedName);
				
				if (list == null)
				{
					list = new Vector.<IType>();
					_book.subclasses.put(superType.qualifiedName, list);
				}
				
				list.push(type);
			}
		}
	}
	
	/**
	 * @private
	 */
	private function proccessClassImplementations(type:IClassType):void
	{
		if (type.implementedInterfaces.length > 0)
		{
			var implementationTypes:Vector.<IType> =
				getTypesFrom(type.qualifiedImplementedInterfaces);
			
			for each (var interfaceType:IType in implementationTypes)
			{
				var sublist:Vector.<IType> =
					_book.implementedinterfaces.getValue(type.qualifiedName);
				
				if (sublist == null)
				{
					sublist = new Vector.<IType>();
					_book.implementedinterfaces.put(type.qualifiedName, sublist);
				}
				
				sublist.push(interfaceType);
				
				if (type is IClassType)
				{
					var clslist:Vector.<IType> =
						_book.interfaceImplementors.getValue(interfaceType.qualifiedName);
					if (clslist == null)
					{
						clslist = new Vector.<IType>();
						_book.interfaceImplementors.put(interfaceType.qualifiedName, clslist);
					}
					
					clslist.push(type);
				}
			}
		}
	}
	
	/**
	 * @private
	 */
	private function proccessInterfaceTree(type:IType):void
	{
		if (type is IInterfaceType)
		{
			_book.superInterfaces.put(type.qualifiedName, cacheSuperInterfaces(type));
		}
	}
	
	/**
	 * @private
	 */
	private function cacheSuperClasses(element:IType):Vector.<IType>
	{
		var result:Vector.<IType> = new Vector.<IType>();
		_cacheSuperClasses(element, result);
		return result;
	}
	
	/**
	 * @private
	 */
	private function _cacheSuperClasses(element:IType, 
										result:Vector.<IType>):void
	{
		if (element is ITypePlaceholder)
			return;
		
		var ctype:IClassType = IClassType(element);
		
		if (ctype.superClass == null)
			return;
		
		var selement:IType = getType(ctype.qualifiedSuperClass) as IType;
		if (selement != null)
		{
			result.push(selement);
			_cacheSuperClasses(selement, result);
		}
	}
	
	/**
	 * @private
	 */
	private function cacheSuperInterfaces(element:IType):Vector.<IType>
	{
		var result:Vector.<IType> = new Vector.<IType>();
		_cacheSuperInterfaces(element, result);
		return result;
	}
	
	/**
	 * @private
	 */
	private function _cacheSuperInterfaces(element:IType, 
										   result:Vector.<IType>):void
	{
		var superTypes:Vector.<IType> = getTypesFrom(
			IInterfaceType(element).qualifiedSuperInterfaces);
		
		for each (var superType:IType in superTypes)
		{
			result.push(superType);
			
			var sublist:Vector.<IType> =
				_book.subInterfaces.getValue(superType.qualifiedName);
			
			if (sublist == null)
			{
				sublist = new Vector.<IType>();
				_book.subInterfaces.put(superType.qualifiedName, sublist);
			}
			
			sublist.push(element);
		}
	}
	
	/**
	 * @private
	 */
	private function getType(qualifiedName:String):IType
	{
		return book.access.getType(qualifiedName);
	}
	
	/**
	 * @private
	 */
	private function getTypesFrom(qnames:Vector.<String>):Vector.<IType>
	{
		var result:Vector.<IType> = new Vector.<IType>();
		if (qnames == null)
			return result;
		
		for each (var qname:String in qnames)
		{
			result.push(getType(qname));
		}
		return result;
	}
}
}