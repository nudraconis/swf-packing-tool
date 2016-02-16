package events 
{
	import broadcasting.Scope;
	import flash.events.Event;

	public class PlayerControllerScope extends Scope
	{
		public static const SHOT:BulletEvent = new BulletEvent("clickPlayEvent", false, false, null);
	}
}