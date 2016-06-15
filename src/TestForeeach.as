package 
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import swfdata.dataTags.SwfPackerTag;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TestForeeach extends Sprite 
	{
		private var object:Dictionary = new Dictionary();
		private var vecc:Vector.<SwfPackerTag> = new Vector.<SwfPackerTag>(360000, true);
		private var vecc2:Vector.<SwfPackerTag> = new Vector.<SwfPackerTag>(360000, true);
		
		public function TestForeeach() 
		{
			super();
			
			for (var i:int = 0; i < 360000; i++)
			{
				object["randomKey" + i + Math.random() * i] = new SwfPackerTag();
			}
			
			var t:Timer = new Timer(1000, 1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, onStart);
			t.start();
			
			var t2:Timer = new Timer(1500, 1);
			t2.addEventListener(TimerEvent.TIMER_COMPLETE, onReverseStart);
			t2.start();
		}
		
		private function onStart(e:TimerEvent):void 
		{
			var index:int = 0;
			for each(var tag:SwfPackerTag in object)
			{
				vecc[index++] = tag;
			}
			
			
		}
		
		private function onReverseStart(e:TimerEvent):void 
		{
			for (var i:int = 0; i < 360000; i++)
			{
				if(vecc[i] != null)
					vecc2[i] = vecc[i];
			}
		}
		
	}

}