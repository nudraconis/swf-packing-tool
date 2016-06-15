package external.keyboard 
{
	import flash.utils.Dictionary;
	
	public class KeyboardListenersList 
	{
		private var listsStore:Object = { };
		
		public function KeyboardListenersList() 
		{
			
		}
		
		public function getListenersList(listenerIdent:uint):Dictionary
		{
			return listsStore[listenerIdent];
		}
		
		public function registerListener(listenerIdent:uint, listener:Function):void
		{
			var currentList:Dictionary = listsStore[listenerIdent];
			
			if (currentList == null)
			{
				currentList = new Dictionary();
				listsStore[listenerIdent] = currentList;
			}
			
			currentList[listener] = listener;
		}
		
		public function unregisterListener(listenerIdent:uint, listener:Function):void
		{
			var currentList:Dictionary = listsStore[listenerIdent];
			
			if (currentList != null)
			{
				delete currentList[listener];
			}
		}
		
	}

}