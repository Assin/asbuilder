package org.as3commons.asbuilder.impl
{

import flash.events.Event;

public class ASBuilderProjectEvent extends Event
{
	public static const PARSE_PROGRESS:String = "progress";
	
	public static const PARSE_COMPLETE:String = "complete";
	
	public var current:int;
	
	public var total:int;
	
	public function ASBuilderProjectEvent(type:String, current:int, total:int)
	{
		super(type);
		
		this.current = current;
		this.total = total;
	}
}
}