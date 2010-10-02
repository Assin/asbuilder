package org.as3commons.asbook.impl
{

import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asbook.api.ICompilationPackage;

public class CompilationPackage implements ICompilationPackage
{
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _name:String;
	
	/**
	 * doc
	 */
	public function get name():String
	{
		return _name;
	}
	
	//----------------------------------
	//  filePath
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _filePath:String;
	
	/**
	 * doc
	 */
	public function get filePath():String
	{
		return _filePath;
	}
	
	//----------------------------------
	//  compilationUnits
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _compilationUnits:Vector.<ICompilationUnit>;
	
	/**
	 * doc
	 */
	public function get compilationUnits():Vector.<ICompilationUnit>
	{
		return _compilationUnits;
	}

	
	public function CompilationPackage(name:String, filePath:String)
	{
		_name = name;
		_filePath = filePath;
	}
	
	public function add(unit:ICompilationUnit):void
	{
		if (!_compilationUnits)
		{
			_compilationUnits = new Vector.<ICompilationUnit>();
		}
		_compilationUnits.push(unit);
	}
	
	public function remove(unit:ICompilationUnit):void
	{
		
	}
}
}