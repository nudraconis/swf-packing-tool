package events 
{
	import flash.events.Event;
	
	public class SystemMenuEvent extends Event 
	{
		public static const OPEN_SWF:String = "openSWF";
		public static const OPEN_ANIMATION:String = "openAnimation";
		public static const SAVE_ANIMATION:String = "saveAnimation";
		
		
		public function SystemMenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
		override public function clone():Event 
		{
			return new SystemMenuEvent(type, bubbles, cancelable);
		}
	}

}