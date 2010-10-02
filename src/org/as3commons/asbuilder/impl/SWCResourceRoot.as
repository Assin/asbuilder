package org.as3commons.asbuilder.impl
{

import deng.fzip.FZip;
import deng.fzip.FZipEvent;
import deng.fzip.FZipFile;

import flash.filesystem.File;
import flash.net.URLRequest;

import org.as3commons.asblocks.impl.ASQName;
import org.as3commons.asblocks.impl.IResourceRoot;

public class SWCResourceRoot implements IResourceRoot
{
	//----------------------------------
	//  definitions
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _definitions:Vector.<ASQName>;
	
	/**
	 * doc
	 */
	public function get definitions():Vector.<ASQName>
	{
		return _definitions;
	}
	
	private var zip:FZip;
	
	public function SWCResourceRoot(fileName:String)
	{
		zip = new FZip();
		
		var request:URLRequest = new URLRequest(fileName);
		
		zip.load(request);
		zip.addEventListener(FZipEvent.FILE_LOADED, onFileLoaded);
	}
	
	private function onFileLoaded(event:FZipEvent):void
	{
		trace("");
		var file:FZipFile = zip.getFileByName("catalog.xml");
		var f:File = new File()
		
	}
}
}