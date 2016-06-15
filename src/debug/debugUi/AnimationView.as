package debug.debugUi 
{
	import debugUi.AnimationView;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import swfdata.DisplayObjectData;
	import swfdata.MovieClipData;
	import ui.UIComponent;
	
	public class AnimationView extends UIComponent 
	{
		private static const textFormat:TextFormat = new TextFormat("Courier New", 14);
		
		private var animationName:TextField;
		private var animationTimeline:TextField;
		
		public var animationData:DisplayObjectData;
		
		public function AnimationView(animationData:DisplayObjectData) 
		{
			this.animationData = animationData;
			width = 250;
			height = 20;
			
			super();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightClick);
			addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, onMiddleClick);
			addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
		}
		
		private function onWheel(e:MouseEvent):void 
		{
			var delta:int = -1;
			if (e.delta > 0)
				delta = 1;
				
			if (e.shiftKey)
				delta *= 5;
				
			if(animationData is MovieClipData)
				(animationData as MovieClipData).advanceFrame(delta);
		}
		
		private function onMiddleClick(e:MouseEvent):void 
		{
			
		}
		
		private function onRightClick(e:MouseEvent):void 
		{
			
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			if (animationData is MovieClipData)
			{
				if ((animationData as MovieClipData).timeline.isPlaying)
					(animationData as MovieClipData).stop();
				else
					(animationData as MovieClipData).play();
			}
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			animationName = new TextField();
			animationTimeline = new TextField();
		}
		
		override protected function configureChildren():void 
		{
			super.configureChildren();
			
			animationName.defaultTextFormat = textFormat;
			animationName.autoSize = TextFieldAutoSize.LEFT;
			animationName.text = "Anim name";
			animationName.selectable = animationName.mouseEnabled = false;
			
			animationTimeline.defaultTextFormat = textFormat;
			animationTimeline.autoSize = TextFieldAutoSize.LEFT;
			animationTimeline.text = "999/999"
			
			
			
			
			animationTimeline.selectable = animationTimeline.mouseEnabled = false;
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			addChild(animationName);
			addChild(animationTimeline);
		}
		
		public function draw():void
		{
			if (animationData.name)
			{
				animationName.text = animationData.name;
			}
			else if (animationData.prototype && animationData.prototype.name)
			{
				animationName.text = animationData.prototype.name;
			}
			else
			{
				if(animationData.libraryLinkage)
					animationName.text = animationData.libraryLinkage;
				else
				{
					if (animationData.prototype && animationData.prototype.libraryLinkage)
						animationName.text = animationData.prototype.libraryLinkage;
					else
						animationName.text = getClassName(animationData) + " " + animationData.characterId + " " + animationData.depth;
				}
			}
				
			if(animationData is MovieClipData)
				animationTimeline.text = (animationData as MovieClipData).currentFrame + "/" + (animationData as MovieClipData).framesCount;
			else
				animationTimeline.text = "";
			
			graphics.clear();
			graphics.lineStyle(0.8, 0xCCCCFF);
			graphics.beginFill(0xCCCCCC, 0.01);
			
			graphics.drawRect(0, 0, width, height);
			
			graphics.beginFill(0xCCCCFF, 0.6);
			
			if(animationData is MovieClipData)
				graphics.drawRect(0, 0, width *  ((animationData as MovieClipData).currentFrame / (animationData as MovieClipData).framesCount), height);
			
			layoutChildren();
		}
		
		override public function update():void 
		{
			super.update();
			
			draw();
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
			
			animationName.x = 2;
			animationTimeline.x = _width - animationTimeline.width - 2;
		}
	}
}