package broadcasting 
{
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class BroadcastingManager 
	{
		public static var __instance:BroadcastingManager;
		
		public static function get instance():BroadcastingManager 
		{
			if (!__instance)
				__instance = new BroadcastingManager();
			
			return __instance;
		}
		
		private var broadcasters:Dictionary = new Dictionary();
		
		public function BroadcastingManager() 
		{
			
		}
		
		public function removeEventListener(scope:Class, type:String, handler:Function):void
		{
			var theScope:Object = broadcasters[scope];
			
			if (!theScope)
				throw new Error("Broadcasting scope " + scope + ", is not defined");
				
			theScope.removeEventListener(type, handler);
		}
		
		public function addListener(scope:Class, type:String, handler:Function, priority:int = 0):void
		{
			var theScope:Object = broadcasters[scope];
			
			if (!theScope)
				throw new Error("Broadcasting scope " + scope + ", is not defined");
				
			trace("Info: add broadcaster listener", scope, "event", type);
			theScope.addEventListener(type, handler, false, priority);
		}
		
		public function registerScope(scope:Class):void
		{
			trace("Info: register broadcaster scope", scope);
			broadcasters[scope] = new EventBroadcaster(scope);
		}
		
		public function dispatch(scope:Class, event:Event):void
		{
			var eventBroadcaster:EventBroadcaster = broadcasters[scope];
			trace("Info: broadcast event scope =", scope, "event", event.type, eventBroadcaster.hasEventListener(event.type));
			eventBroadcaster.dispatchEvent(event);
		}
		
		
		
	}

}