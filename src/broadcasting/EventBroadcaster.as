package broadcasting 
{
	import flash.events.EventDispatcher;

	public class EventBroadcaster extends EventDispatcher
	{
		public var scope:Class;
		
		public function EventBroadcaster(scope:Class) 
		{
			this.scope = scope;
			
		}
		
	}

}