package org.as3commons.asbuilder.impl
{

import flash.filesystem.File;

import org.as3commons.asblocks.impl.ASQName;
import org.as3commons.asblocks.impl.IResourceRoot;

public class SourceFolderResourceRoot implements IResourceRoot
{
	private var directoryPath:String;
	
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
		if (!_definitions)
		{
			var dir:File = new File(directoryPath);
			var result:Array = [];
			if (!dir.exists)
			{
				throw new Error("");
			}
			
			loadQNames(dir, result);
			
			_definitions = toQNames(result);
		}
		
		return _definitions;
	}
	
	public function SourceFolderResourceRoot(directoryPath:String)
	{
		this.directoryPath = directoryPath;
	}
	
	private function toQNames(list:Array):Vector.<ASQName>
	{
		var result:Vector.<ASQName> = new Vector.<ASQName>();
		
		var len:int = list.length;
		for (var i:int = 0; i < len; i++)
		{
			var qname:ASQName = fileToASQName(File(list[i]));
			if (qname)
			{
				result.push(qname);
			}
		}
		
		return result;
	}
	
	private function fileToASQName(file:File):ASQName
	{
		var filePath:String = file.nativePath;
		var typeName:String = filePath.replace(directoryPath + File.separator, "");
		typeName = typeName.replace(/\\/g, '.');
		typeName = typeName.replace("." + file.extension, "");
		var qname:ASQName = new ASQName(typeName);
		qname.filePath = file.nativePath;
		return qname;
	}
	
	private function loadQNames(directory:File, result:Array):void
	{
		var files:Array = directory.getDirectoryListing();
		
		var len:int = files.length;
		for (var i:int = 0; i < len; i++)
		{
			var sub:File = File(files[i]);
			if (sub.isDirectory)
			{
				loadQNames(sub, result);
			}
			else
			{
				result.push(sub);
			}
		}
	}
}
}