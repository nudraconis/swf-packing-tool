package web 
{
	import flash.display.Stage;
	import ui.logging.LoggView;
	import ui.UIComponent;
	import web.ui.SystemMenu;
	
	public class WebUIContainer extends UIComponent 
	{
		private var stage:Stage;
	
		private var consoleView:LoggView;
		private var systemMenu:SystemMenu;
		
		public function WebUIContainer(stageWidth:int, stageHeight:int, stage:Stage) 
		{
			this.stage = stage;
			this.width = stageWidth;
			this.height = stageHeight;
			
			super();	
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			consoleView = new LoggView(width, height / 5);
			systemMenu = new SystemMenu();
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			addComponent(consoleView);
			addComponent(systemMenu);
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
			
			consoleView.y = height - consoleView.height;
		}
		
	}

}