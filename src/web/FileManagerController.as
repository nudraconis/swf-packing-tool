package web 
{
	import events.SystemMenuEvent;
	import events.SystemMenuScope;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	/**
	 * ...
	 * @author ...
	 */
	public class FileManagerController 
	{
		
		public function FileManagerController() 
		{
			initialize();
		}
		
		private function initialize():void 
		{
			describe(SystemMenuScope, new SystemMenuEvent(SystemMenuEvent.OPEN_SWF), onOpenSWF);
			describe(SystemMenuScope, new SystemMenuEvent(SystemMenuEvent.OPEN_ANIMATION), onOpenAnimation);
			describe(SystemMenuScope, new SystemMenuEvent(SystemMenuEvent.SAVE_ANIMATION), onSaveAnimation);
		}
		
		private function onSaveAnimation(e:Event):void 
		{
			
		}
		
		private function onOpenAnimation(e:Event):void 
		{
			
		}
		
		private function onOpenSWF(e:Event):void 
		{
			var fr:FileReference = new FileReference();
			fr.browse([new FileFilter("swf file with animation", "*.swf", "*.swf")]);
		}
		
	}

}