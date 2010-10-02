package org.as3commons.asbook.api
{

import org.as3commons.asblocks.api.ICompilationUnit;

public interface ICompilationPackage
{
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get name():String;
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get filePath():String;
	
	//----------------------------------
	//  compilationUnits
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get compilationUnits():Vector.<ICompilationUnit>;
	
	function add(unit:ICompilationUnit):void;
	
	function remove(unit:ICompilationUnit):void;
}
}