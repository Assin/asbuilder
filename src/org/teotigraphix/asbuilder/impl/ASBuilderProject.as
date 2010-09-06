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

package org.teotigraphix.asbuilder.impl
{

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.asblocks.ASFactory;
import org.teotigraphix.asblocks.api.ICompilationUnit;
import org.teotigraphix.asblocks.impl.ASProject;
import org.teotigraphix.asblocks.utils.FileUtil;

/**
 * An Adobe AIR implementation of the <code>IASProject</code> API.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ASBuilderProject extends ASProject
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ASBuilderProject(factory:ASFactory)
	{
		super(factory);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function write(location:String, unit:ICompilationUnit):void
	{
		var fileName:String = FileUtil.fileNameFor(unit);
		var file:File = new File(location);
		file = file.resolvePath(fileName);
		
		var stream:FileStream = new FileStream();
		stream.open(file, FileMode.WRITE);
		
		var code:SourceCode = new SourceCode(null, file.nativePath);
		factory.newWriter().write(code, unit);
		stream.writeUTFBytes(code.code);
		stream.close();
	}
}
}