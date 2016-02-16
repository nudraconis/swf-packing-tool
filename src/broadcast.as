package  
{
	import broadcasting.BroadcastingManager;
	import flash.events.Event;
	
	public function broadcast(scope:Class, e:Event):void
	{
		BroadcastingManager.instance.dispatch(scope, e);
	}
}