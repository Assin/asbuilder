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

import org.as3commons.asblocks.api.ICompilationUnit;

/**
 * The <strong>IASBook</strong> interface creates a simple model contract for
 * client's of the book.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IASBook
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Returns the <code>IAS3BookAccessor</code> assigned to the book.
	 * 
	 * <p>This instance has all the public access to the book members.</p>
	 */
	function get access():IASBookAccess;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Adds a <code>ICompilationUnit</code> to the book.
	 * 
	 * <p>This is the main entrance for a compilation unit to be added to the book.
	 * When an node is added, it's children are recursively added to the book
	 * also.</p>
	 * 
	 * @param unit The ICompilationUnit element.
	 */
	function addCompilationUnit(unit:ICompilationUnit):void;
	
	/**
	 * Processes the <code>ICompilationNode</code> instances placed in the
	 * book.
	 * 
	 * <p>This method needs to be called when all parsing is finished and all
	 * compilation elements have been added.</p>
	 */
	function process():void;
}
}