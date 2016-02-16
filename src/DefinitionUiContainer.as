package 
{
	import debug.debugUi.AnimationView;
	import swfdata.DisplayObjectData;
	import swfdata.FrameData;
	import swfdata.MovieClipData;
	import swfdata.SpriteData;
	import ui.UIComponent;
	
	/**
	 * ...
	 * @author 
	 */
	public class DefinitionUiContainer extends UIComponent 
	{
		
		private var __yy:Number = 5;
		private var __xx:Number = 5;
		
		public function DefinitionUiContainer() 
		{
			super();
			
		}
		
		public function buildControls(sprite:DisplayObjectData):void 
		{
			removeComponents();
			__yy = 0;
			__xx = 0;
			
			var spriteAsContainer:SpriteData = sprite as SpriteData;
			
			if (!spriteAsContainer)
				return;
				
			var level:int = 0;
			if (spriteAsContainer is MovieClipData)
			{
				addAnimationView(spriteAsContainer as MovieClipData, level++);
				
			}
			
			showContainer(spriteAsContainer, level);			
		}
		
		private function showContainer(spriteAsContainer:SpriteData, level:int):void
		{
			var currentDisplayObjects:Vector.<DisplayObjectData>;
			
			if (spriteAsContainer is MovieClipData)
			{
				var frame:FrameData = (spriteAsContainer as MovieClipData).timeline.currentFrameData();
				currentDisplayObjects = frame.displayObjects;
			}
			else
				currentDisplayObjects = spriteAsContainer.displayObjects;
				
			for (var i:int = 0; i < currentDisplayObjects.length; i++)
			{
				if (currentDisplayObjects[i] is MovieClipData)
				{
					addAnimationView(currentDisplayObjects[i] as MovieClipData, level);
				}
				
				if (currentDisplayObjects[i] is SpriteData)
				{
					showContainer(currentDisplayObjects[i] as SpriteData, level+1);
				}
			}
		}
		
		private function addAnimationView(spriteAsMovieClip:MovieClipData, level:int):void 
		{
			if (spriteAsMovieClip.framesCount < 2)
				return;
				
			var animationView:AnimationView = new AnimationView(spriteAsMovieClip);
			addComponent(animationView);
			
			animationView.y = __yy;
			animationView.x = level * 15;
			
			__yy += 20 //animationView.height;
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
		}
	}
}