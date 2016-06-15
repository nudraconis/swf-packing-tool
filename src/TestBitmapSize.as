package 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class TestBitmapSize extends Sprite
	{
		
		public function TestBitmapSize() 
		{
			var bmp:BitmapData = new BitmapData(1024, 1024, true, 0x0);
			
			bmp.fillRect(new Rectangle((1024 - 256) / 2, (1024 - 256) / 2, 256, 256), 0xFFFF0000);
			
			var ba:ByteArray = bmp.getPixels(bmp.rect);
			
			trace(ba.length);
			ba.deflate();
			trace(ba.length);
		}
		
	}

}