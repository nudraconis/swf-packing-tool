package tests 
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TestGCBitch extends Sprite 
	{
		private var theBitchArray:Vector.<BitchObject> = new Vector.<BitchObject>(500000, true);
		private var bitcpObject:BitchObject = new BitchObject();
		public function TestGCBitch() 
		{
			super();
			
			var t:Timer = new Timer(1000, 1);
			t.start();
			t.addEventListener(TimerEvent.TIMER_COMPLETE, onStart);
		}
		
		private function onStart(e:TimerEvent):void 
		{
			
			for (var i:int = 0; i < 500000; i++)
			{
				theBitchArray[i] = new BitchObject();
			}
		}
		
	}

}