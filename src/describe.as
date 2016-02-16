package  
{
	import broadcasting.BroadcastingManager;
	import flash.events.Event;
	
	public function describe(scope:Class, event:Event, handler:Function, priority:int = 0):void
	{
		BroadcastingManager.instance.addListener(scope, event.type, handler, priority);
	}
	
	
}