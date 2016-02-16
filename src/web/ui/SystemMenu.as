package web.ui 
{
	import events.SystemMenuEvent;
	import events.SystemMenuScope;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ui.TextButton;
	import ui.UIComponent;
	
	public class SystemMenu extends UIComponent 
	{
		private var openSWFButton:TextButton;
		private var openAnimationButton:TextButton;
		private var saveAnimationButton:TextButton;
		
		public function SystemMenu() 
		{
			super();
			
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			openSWFButton.addEventListener(MouseEvent.CLICK, onOpenSWFClick);
			openAnimationButton.addEventListener(MouseEvent.CLICK, onAnimationOpenClick);
			saveAnimationButton.addEventListener(MouseEvent.CLICK, onSaveAnimationClick);
		}
		
		private function onSaveAnimationClick(e:MouseEvent):void 
		{
			broadcast(SystemMenuScope, new SystemMenuEvent(SystemMenuEvent.SAVE_ANIMATION));
		}
		
		private function onAnimationOpenClick(e:MouseEvent):void 
		{
			broadcast(SystemMenuScope, new SystemMenuEvent(SystemMenuEvent.OPEN_ANIMATION));
		}
		
		private function onOpenSWFClick(e:MouseEvent):void 
		{
			broadcast(SystemMenuScope, new SystemMenuEvent(SystemMenuEvent.OPEN_SWF));
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			openSWFButton = new TextButton("Open\nSWF", 90, 35);
			openAnimationButton = new TextButton("Open\nAnimation", 90, 35);
			saveAnimationButton = new TextButton("Save\nAnimation", 90, 35);
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			addComponent(openSWFButton);
			addComponent(openAnimationButton);
			addComponent(saveAnimationButton);
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
			
			openSWFButton.x = 0;
			openSWFButton.y = 0;
			
			openAnimationButton.x = openSWFButton.x + openSWFButton.width + 2;
			
			saveAnimationButton.x = openAnimationButton.x + openAnimationButton.width + 2;
		}
		
	}
}