package events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Asfel
	 */
	public class UIWindowsScope 
	{
		
		public static const SHOW_CLAN_WINDOW:Event = new Event("showClanWindow", false, false);
		public static const SHOW_SHOP_WINDOW:Event = new Event("showShopWindow", false, false);
		public static const SHOW_INVENTORY_WINDOW:Event = new Event("showInvewntoryWindow", false, false);
		
	}

}