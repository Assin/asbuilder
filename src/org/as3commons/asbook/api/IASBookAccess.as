////////////////////////////////////////////////////////////////////////////////
// Copyright 2010 Michael Schmalle - Teoti Graphix, LLC
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software 
// distributed under the License is distributed on an "AS IS" BASIS, 
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and 
// limitations under the License
// 
// Author: Michael Schmalle, Principal Architect
// mschmalle at teotigraphix dot com
////////////////////////////////////////////////////////////////////////////////

package org.as3commons.asbook.api
{

import org.as3commons.asblocks.api.IClassType;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IFunctionType;
import org.as3commons.asblocks.api.IInterfaceType;
import org.as3commons.asblocks.api.IType;

/**
 * The <strong>IASBookAccessor</strong> interface is used to access the
 * <code>IASBook</code> implementation with detailed knowledge
 * of modifiers, doctags etc that can affect collections.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IASBookAccess
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  book
	//----------------------------------
	
	/**
	 * The <code>IASBook</code> implementation model.
	 */
	function get book():IASBook;
	
	//----------------------------------
	//  packages
	//----------------------------------
	
	/**
	 * All public packages that hold compilation units.
	 * 
	 * @see org.as3commons.asblocks.api.ICompilationUnit
	 */
	function get packages():Vector.<ICompilationPackage>;
	
	//----------------------------------
	//  units
	//----------------------------------
	
	/**
	 * All public compilation units.
	 * 
	 * @see org.as3commons.asblocks.api.ICompilationPackage
	 */
	function get units():Vector.<ICompilationUnit>;
	
	//----------------------------------
	//  types
	//----------------------------------
	
	/**
	 * All <code>AS3NodeKind.CLASS</code>, <code>AS3NodeKind.INTERFACE</code>
	 * or <code>AS3NodeKind.FUNCTION</code> type elements.
	 * 
	 * @see org.as3commons.asblocks.api.IClassType
	 * @see org.as3commons.asblocks.api.IInterfaceType
	 * @see org.as3commons.asblocks.api.IFunctionType
	 */
	function get types():Vector.<IType>;
	
	//----------------------------------
	//  classes
	//----------------------------------
	
	/**
	 * All <code>AS3NodeKind.CLASS</code> type elements.
	 * 
	 * @see org.as3commons.asblocks.api.IClassType
	 */
	function get classes():Vector.<IClassType>;
	
	//----------------------------------
	//  interfaces
	//----------------------------------
	
	/**
	 * All <code>AS3NodeKind.INTERFACE</code> type elements.
	 * 
	 * @see org.as3commons.asblocks.api.IInterfaceType
	 */
	function get interfaces():Vector.<IInterfaceType>;
	
	//----------------------------------
	//  functions
	//----------------------------------
	
	/**
	 * All <code>AS3NodeKind.FUNCTION</code> type elements.
	 * 
	 * @see org.as3commons.asblocks.api.IFunctionType
	 */
	function get functions():Vector.<IFunctionType>;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Returns the <code>ICompilationPackage</code> for the passed package name.
	 * 
	 * @param packageName The String package name.
	 * @return The packages <code>ICompilationPackage</code>.
	 */
	function getCompilationPackage(packageName:String):ICompilationPackage;
	
	/**
	 * Returns the <code>ICompilationUnit</code> for the passed <code>IType</code>.
	 * 
	 * @param qualifiedName .
	 * @return The <code>IType</code>'s <code>ICompilationUnit</code>.
	 */
	function getCompilationUnit(qualifiedName:String):ICompilationUnit;
	
	/**
	 * Returns all <code>IType</code>s for the packageName, 
	 * if the qname does not exists, the method returns <code>null</code>.
	 * 
	 * @param qualifiedName The String qualifiedName.
	 * @return <code>IType</code> or <code>null</code>.
	 */
	function getTypes(packageName:String):Vector.<IType>;
	
	/**
	 * Returns an <code>IType</code> for the qualifiedName, 
	 * if the qname does not exists, the method returns <code>null</code>.
	 * 
	 * @param qualifiedName The String qualifiedName.
	 * @return <code>IType</code> or <code>null</code>.
	 */
	function findType(qualifiedName:String):IType;
	
	/**
	 * Uses <code>findType()</code>, if the method returns null, this method will
	 * create an <code>TypeNodePlaceholder</code> and return it.
	 * 
	 * @param qualifiedName The String qualifiedName.
	 * @return <code>IType</code> or <code>TypePlaceholderNode</code>.
	 */
	function getType(qualifiedName:String):IType;
	
	/**
	 * Returns whether the book contains an <code>IType</code> instance
	 * matching the qualifiedName.
	 * 
	 * @param qualifiedName The String qualifiedName.
	 * @return A Boolean indicating whether the <code>IType</code> exists.
	 */
	function hasType(qualifiedName:String):Boolean;
	
	/**
	 * Returns an <code>IClassType</code> for the qualifiedName, 
	 * if the qualifiedName does not exist, the method returns <code>null</code>.
	 * 
	 * @param qualifiedName The String qualifiedName.
	 * @return <code>IClassType</code> or <code>null</code>.
	 */
	function findClassType(qualifiedName:String):IClassType;
	
	/**
	 * Returns an <code>IInterfaceType</code> for the qualifiedName, 
	 * if the qualifiedName does not exist, the method returns <code>null</code>.
	 * 
	 * @param qualifiedName The String qualifiedName.
	 * @return <code>IInterfaceType</code> or <code>null</code>.
	 */
	function findInterfaceType(qualifiedName:String):IInterfaceType;
	
	/**
	 * Returns an <code>IFunctionType</code> for the qualifiedName, 
	 * if the qualifiedName does not exist, the method returns <code>null</code>.
	 * 
	 * @param qualifiedName The String qualifiedName.
	 * @return <code>IFunctionType</code> or <code>null</code>.
	 */
	function findFunctionType(qualifiedName:String):IFunctionType;
	
	//----------------------------------
	//  Class
	//----------------------------------
	
	/**
	 * Returns all superclasses of an <code>IType</code>.
	 * 
	 * @param node An <code>IType</code>.
	 * @return Vector of <code>IType</code> superclasses.
	 */
	function getSuperClasses(node:IType):Vector.<IType>;
	
	/**
	 * Returns all subclasses of an <code>IType</code>.
	 * 
	 * @param node An <code>IType</code>.
	 * @return Vector of <code>IType</code> subclasses.
	 */
	function getSubClasses(node:IType):Vector.<IType>;
	
	/**
	 * Returns all <code>IType</code> interface implementations.
	 * 
	 * @param node An <code>IType</code>.
	 * @return Vector of <code>IType</code> implementations.
	 */
	function getImplementedInterfaces(node:IType):Vector.<IType>;
	
	//----------------------------------
	//  Interface
	//----------------------------------
	
	/**
	 * Returns all <code>IType</code> interface implementations.
	 * 
	 * @param node An <code>IType</code>.
	 * @return Vector of <code>IType</code> implementations.
	 */
	function getInterfaceImplementors(node:IType):Vector.<IType>;
	
	/**
	 * Returns all <code>IType</code> superinterfaces.
	 * 
	 * @param node An <code>IType</code>.
	 * @return Vector of <code>IType</code> superinterfaces.
	 */
	function getSuperInterfaces(node:IType):Vector.<IType>;
	
	/**
	 * Returns all <code>IType</code> subinterfaces.
	 * 
	 * @param node An <code>IType</code>.
	 * @return Vector of <code>IType</code> subinterfaces.
	 */
	function getSubInterfaces(node:IType):Vector.<IType>;
	
}
}