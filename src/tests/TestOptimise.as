package tests 
{

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import swfdata.DisplayObjectData;
	import swfdata.FrameData;
	import swfdata.MovieClipData;
	import swfdata.SpriteData;
	import swfdata.swfdata_inner;
	import swfdata.Timeline;
	
	use namespace swfdata_inner;
	
	public class TestOptimise extends Sprite 
	{
		private var container:MovieClipData;
		
		
		public function TestOptimise() 
		{
			super();
			
			var t:Timer = new Timer(1000, 1);
			t.start();
			t.addEventListener(TimerEvent.TIMER_COMPLETE, onStart);
		}
		
		private function onStart2(e:TimerEvent):void 
		{
			var vec:Vector.<int> = new Vector.<int>();
			
			for (var i:int = 0; i < 3600000; i++)
			{
				vec[vec.length] = i;
			}
		}
		
		private function onStart(e:TimerEvent):void 
		{
			container = new MovieClipData( -1, 10);
			container.addFrame(new FrameData(0, null, 360000));
			container.addFrame(new FrameData(0, null, 360000));
			container.addFrame(new FrameData(0, null, 360000));
			container.addFrame(new FrameData(0, null, 360000));
			
			
			
			var currentFrame:FrameData = container.currentFrameData;
			var displayObjects:Vector.<DisplayObjectData>  = currentFrame.displayObjects;
			
			
			var spriteData:SpriteData = new SpriteData()
			
			for (var i:int = 0; i < 3600000; i++)
				displayObjects[i] = spriteData;
				
			currentFrame.displayObjectsCount = 3600000;
		}
		
	}

}