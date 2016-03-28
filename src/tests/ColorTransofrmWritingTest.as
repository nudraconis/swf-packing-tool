package tests 
{
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.utils.ByteArray;
	import swfDataExporter.BitOperator;
	
	public class ColorTransofrmWritingTest extends Sprite 
	{
		
		public function ColorTransofrmWritingTest() 
		{
			super();
			
			var ba:ByteArray = new ByteArray();
			var bitOperator:BitOperator = new BitOperator(ba);
			
			bitOperator.writeColorTransform(new ColorTransform(1, 2, 3, 4, 15, 30, 45, 75));
			
			ba.position = 0;
			
			trace(bitOperator.readColorTransform());
		}
	}
}