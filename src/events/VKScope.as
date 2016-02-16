package events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Asfel
	 */
	public class VKScope 
	{
		public static const REQUEST_FRIENDS_MENU:Event = new Event("requestFriendsMenu", false, false);
		public static const REQUEST_FRIENDS_INFO:Event = new Event("requestFriendsInfo", false, false);
		static public const FRIENDS_DATA_LOADED:Event = new Event("friendsDataLoaded", false, false);
	}

}