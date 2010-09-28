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

import org.as3commons.asblocks.ASFactory;
import org.as3commons.asblocks.IASParser;
import org.as3commons.asblocks.api.IClassPathEntry;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.impl.ASProject;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.utils.FileUtil;
import org.as3commons.mxmlblocks.IMXMLParser;

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
		if (location == ".")
		{
			location = File.applicationStorageDirectory.nativePath;
		}
		
		var file:File = new File(location);
		file = file.resolvePath(fileName);
		
		var stream:FileStream = new FileStream();
		stream.open(file, FileMode.WRITE);
		
		var code:SourceCode = new SourceCode(null, file.nativePath);
		factory.newWriter().write(code, unit);
		stream.writeUTFBytes(code.code);
		stream.close();
	}
	
	
	public function readAll():void
	{
		var asparser:IASParser = factory.newParser();
		var mxmlparser:IMXMLParser = factory.newMXMLParser();
		
		var files:Array = [];
		
		for each (var element:IClassPathEntry in classPathEntries)
		{
			readFiles(new File(element.filePath), files);
			for each (var file:File in files)
			{
				var sourceCode:SourceCode = new SourceCode(
					FileUtil.readFile(file.nativePath), file.nativePath);
				if (file.extension == "as")
				{
					try
					{
						addCompilationUnit(asparser.parse(sourceCode));
					}
					catch (e:Error)
					{
						trace(e.message);
					}
				}
				else if (file.extension == "mxml")
				{
					try
					{
						addCompilationUnit(mxmlparser.parse(sourceCode, element));
					}
					catch (e:Error)
					{
						trace(e.message);
					}
				}
			}
		}
	}
	
	protected function readFiles(directory:File, result:Array = null):Array
	{
		if (result == null)
			result = [];
		
		var directories:Array = directory.getDirectoryListing();
		for each (var file:File in directories)
		{
			if (file.isDirectory)
			{
				result = readFiles(file, result);
			}
			else if (file.extension == "as" || file.extension == "mxml")
			{
				result.push(file);
			}
		}
		
		return result;
	}
}
}