package web 
{
	import events.FileSystemEvent;
	import events.FileSystemScope;
	import events.SceneEvent;
	import flash.display.Stage;
	import ui.logging.LoggView;
	import ui.UIComponent;
	import ui.overheat.AutomatedHeatBar;
	import ui.overheat.FpsHeat;
	import web.ui.SystemMenu;
	
	public class WebUIContainer extends UIComponent 
	{
		private var stage:Stage;
	
		private var consoleView:LoggView;
		private var systemMenu:SystemMenu;
		
		private var scene:TestScene;
		private var cpuHeat:AutomatedHeatBar;
		
		public function WebUIContainer(stageWidth:int, stageHeight:int, stage:Stage) 
		{
			this.stage = stage;
			this.width = stageWidth;
			this.height = stageHeight;
			
			super();	
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			describe(FileSystemScope, new SceneEvent("showScene"), onShowSceneContent);
		}
		
		private function onShowSceneContent(e:SceneEvent):void 
		{
			scene.show(e.library, e.atlas);
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			scene = new TestScene();
			cpuHeat = new AutomatedHeatBar(200, 5, new FpsHeat(stage.frameRate));
			
			consoleView = new LoggView(width, height / 5);
			systemMenu = new SystemMenu();
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			addComponent(consoleView);
			addComponent(systemMenu);
			addComponent(cpuHeat);
			addChild(scene);
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
			
			cpuHeat.x = 0;
			cpuHeat.y = consoleView.y - cpuHeat.height;
			consoleView.y = height - consoleView.height;
			scene.y = systemMenu.height + 2;
		}
		
	}

}