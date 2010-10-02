package org.as3commons.asbook.impl
{

import org.as3commons.asblocks.api.Visibility;
import org.as3commons.asblocks.impl.ASQName;
import org.as3commons.asblocks.impl.TypeNode;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asbook.api.ITypePlaceholder;

public class TypePlaceholderNode extends TypeNode implements ITypePlaceholder
{
	private var qname:ASQName;
	
	override public function get name():String
	{
		return qname.localName;
	}
	
	override public function get packageName():String
	{
		return qname.packageName;
	}
	
	override public function get qualifiedName():String
	{
		return qname.qualifiedName;
	}
	
	override public function get visibility():Visibility
	{
		return Visibility.PUBLIC;
	}
	
	public function TypePlaceholderNode(qualifiedName:String)
	{
		super(null);
		
		qname = new ASQName(qualifiedName);
	}
}
}