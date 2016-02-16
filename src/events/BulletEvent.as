package events 
{
	import flash.events.Event;
	import game.actors.Actor;
	
	public class BulletEvent extends Event 
	{
		public var owner:Actor;
		
		public function BulletEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, owner:Actor=null) 
		{
			super(type, bubbles, cancelable);
			this.owner = owner;
			
		}
		
		override public function clone():Event 
		{
			return new BulletEvent(type, bubbles, cancelable, owner);
		}
	}

}