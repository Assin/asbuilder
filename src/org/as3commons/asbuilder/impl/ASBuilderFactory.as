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

package org.as3commons.asbuilder.impl
{

import org.as3commons.asblocks.ASFactory;
import org.as3commons.asblocks.IASProject;
import org.as3commons.asblocks.IASVisitor;
import org.as3commons.asblocks.IASWalker;
import org.as3commons.asblocks.impl.ASWalker;
import org.as3commons.asbook.api.IASBook;
import org.as3commons.asbook.api.IASBookAccess;
import org.as3commons.asbook.api.IASBookProcessor;
import org.as3commons.asbook.impl.ASBook;
import org.as3commons.asbook.impl.ASBookAccess;
import org.as3commons.asbook.impl.ASBookProcessor;
import org.as3commons.asbook.impl.ASBookVisitor;

/**
 * An Adobe AIR implementation of the <code>ASFactory</code> API.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ASBuilderFactory extends ASFactory
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ASBuilderFactory()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override public function newEmptyASProject(outputLocation:String):IASProject
	{
		var result:IASProject = new ASBuilderProject(this);
		result.outputLocation = outputLocation;
		return result;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	public function newASBook(project:IASProject):IASBook
	{
		return new ASBook(project);
	}
	
	/**
	 * @private
	 */
	public function newASBookProccessor(book:IASBook):IASBookProcessor
	{
		return new ASBookProcessor(book);
	}
	
	/**
	 * @private
	 */
	public function newASBookAccess(book:IASBook):IASBookAccess
	{
		return new ASBookAccess(book);
	}
	
	/**
	 * @private
	 */
	public function newASBookVisitor(book:IASBook):IASVisitor
	{
		return new ASBookVisitor(book);
	}
	
	/**
	 * @private
	 */
	public function newASBookWalker(book:IASBook):IASWalker
	{
		return new ASWalker(newASBookVisitor(book));
	}
}
}