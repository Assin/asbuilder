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

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

import nochump.util.zip.ZipEntry;
import nochump.util.zip.ZipFile;

import org.as3commons.asblocks.impl.ASQName;
import org.as3commons.asblocks.impl.IResourceRoot;

/**
 * An SWC implementation of the <code>IResourceRoot</code> API.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class SWCResourceRoot implements IResourceRoot
{
	//--------------------------------------------------------------------------
	//
	//  Public Class :: Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	public static var SWC_CATALOG_NS:String = "http://www.adobe.com/flash/swccatalog/9";
	
	/**
	 * @private
	 */
	public static var SWC_CATALOG_NAME:String = "catalog.xml";
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var zip:ZipFile;
	
	//--------------------------------------------------------------------------
	//
	//  IResourceRoot API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  definitions
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _definitions:Vector.<ASQName>;
	
	/**
	 * The <code>ASQName</code> definition Vector.
	 */
	public function get definitions():Vector.<ASQName>
	{
		return _definitions;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function SWCResourceRoot(swcPath:String)
	{
		_definitions = new Vector.<ASQName>();
		
		var scripts:XMLList = readCatalog(swcPath);
		for each (var script:XML in scripts)
		{
			//var type:String = script.def;
			//type = type.replace(":", ".");
			//_definitions.push(new ASQName(type));
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function readCatalog(swcPath:String):XMLList
	{
		var file:File = new File(swcPath);
		var stream:FileStream = new FileStream();
		stream.open(file, FileMode.READ);
		
		zip = new ZipFile(stream);
		var entry:ZipEntry = zip.getEntry(SWC_CATALOG_NAME);
		var data:ByteArray = zip.getInput(entry);
		
		stream.close();
		
		var ns:Namespace = new Namespace(SWC_CATALOG_NS);
		default xml namespace = ns;
		
		var xml:XML = new XML(data);
		var scripts:XMLList = xml.libraries.library..script;
		return scripts;
	}
	
	/**
	 * @private
	 */
	private function readQName(script:XML):ASQName
	{
		//var type:String = script.def.@id;
		//type = type.replace(":", ".");
		return null;//new ASQName(type);
	}
}
}