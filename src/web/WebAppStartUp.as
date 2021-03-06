package web 
{
	import broadcasting.BroadcastingManager;
	import events.FileSystemScope;
	import events.SystemMenuScope;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class WebAppStartUp extends Sprite 
	{
		private var mainUiContainer:WebUIContainer;
		
		public function WebAppStartUp() 
		{
			super();
			
			initialize();
		}
		
		private function initialize():void 
		{
			stage.align = "TL";
			stage.scaleMode = "noScale";
			
			BroadcastingManager.instance.registerScope(SystemMenuScope);
			BroadcastingManager.instance.registerScope(FileSystemScope);
			
			new FileManagerController();
			
			mainUiContainer = new WebUIContainer(stage.stageWidth, stage.stageHeight, stage);
			addChild(mainUiContainer);
			
			addEventListener(Event.ENTER_FRAME, onUpdate);
			
			print("start up");
		}
		
		private function onUpdate(e:Event):void 
		{
			mainUiContainer.update();
		}
	}
}