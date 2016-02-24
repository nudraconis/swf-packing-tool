package tests 
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import ru.crazypanda.core.utils.MathUtils;
	import swfdata.atlas.AtlasDrawer;
	import swfdata.atlas.AtlasDrawerUtils;
	import swfdata.atlas.BitmapTextureAtlas;
	import swfdata.atlas.TextureTransform;

	public class TestDrawingPaddingCalculating extends Sprite
	{

		/**
		 * Суть теста в том что есть шейп, его дефайн находится в смещении в + или - по x или y. Т.е там область 
		 * абсолютно прозрачная и мы не хотим ее рисовать в атлас, поэтмоу нужно эту область вычеслить и запомнить
		 * Для этого к имеющемуся дефинишену шейпа его X, Y мы добавляем смещение по левому и верхнему краю.
		 * 
		 * В тесте мы берем заданный в sample = ... спрайт, предполагая что в нем лежит лишь один шейп. Шейп
		 * рисуется в атлас, с права мы видим как он нарисован в баунд чекере, с лева мы видим оригиалньый спрайт в 0, 0
		 * и нарисованый шейп под ним в 0, 0 + смещение - они должны совпадать визуально, если не совпадают значит косяк
		 * 
		 * NOTE: нужно убрать в дравере очищение баунд чекера boundChecker.fillRect(bitmapBoundRect, 0); для визуализации
		 */
		public function TestDrawingPaddingCalculating() 
		{
			//NOTE: данные калкьуляции долнжы соотвествовать тем что есть в ShapeLibrary.drawToAtlas
			var padding:int = 0;
			var targetAtlas:BitmapTextureAtlas = new BitmapTextureAtlas(1024, 1024, padding);
			var atlasDrawer:AtlasDrawer = new AtlasDrawer(targetAtlas, 1, padding);
			
			var sample:Sprite = new lake1110000;
			var sampleShape:Shape = sample.getChildAt(0) as Shape;
			var shapeBounds:Rectangle = sampleShape.getBounds(sample);
			//Создаем семпл и извлекаем из него шейп и баунд
			
			var testScaleX:Number = 1;
			var testScaleY:Number = 1;
			
			//Рисуем шейп в атлас и получаем новый баунд
			var boundRectnagle:Rectangle = atlasDrawer.addShape(0, sampleShape, sampleShape.getBounds(sample), new TextureTransform(testScaleX, testScaleY, shapeBounds.x, shapeBounds.y));
			
			//Задаем баунд для шейпа из атласа
			shapeBounds.width = boundRectnagle.width;
			shapeBounds.height = boundRectnagle.height;
			
			shapeBounds.x = boundRectnagle.x;
			shapeBounds.y = boundRectnagle.y;
			
			//Шейп из атласа отображается на сцене
			var newView:Bitmap = new Bitmap(targetAtlas.atlasData);
			addChild(newView);
			
			//Баунд чекер отображется на сцене
			var powerOf2Size:int = AtlasDrawerUtils.getBestPowerOf2(Math.max(shapeBounds.width + 40, shapeBounds.height + 20));
			var checkerIndex:int = MathUtils.logBase(powerOf2Size, 2);
			
			var checkerView:Bitmap = new Bitmap(AtlasDrawerUtils.boundCheckers[checkerIndex]);
			addChild(checkerView);
			
			//Семпл отображается на сцене по верх шейпа из атласа
			addChild(sample);
			
			checkerView.x = 100;
			checkerView.bitmapData.floodFill(1, 1, 0xFFFF0000);
			
			
			sample.x = 0;
			sample.y = 0;
			sample.scaleX = testScaleX;
			sample.scaleY = testScaleY;
			sample.alpha = 0.8;
			
			newView.x = shapeBounds.x;
			newView.y = shapeBounds.y;
			
			trace(boundRectnagle);
			//нарисуем баунды шейпа чтобы посомтреть верны ли они
			//NOTE: шейп долежн быть вписан в баунд
			var boundsView:Shape = new Shape();
			addChild(boundsView);
			
			boundsView.graphics.lineStyle(1, 0x0000FF);
			boundsView.graphics.drawRect(boundRectnagle.x, boundRectnagle.y, boundRectnagle.width, boundRectnagle.height);
			
			this.scaleX = this.scaleY = 4;
		}
		
	}

}