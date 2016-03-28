package  
{
	import com.genome2d.Genome2D;
	import com.genome2d.textures.GTexture;
	import flash.geom.Matrix;
	import flash.geom.Point;
	//import ru.crazypanda.tile_engine.core.WorldGeometry;
	import swfdata.Rectagon;
	
	/**
	 * Берем полигон из четырех вершин, поворачиваем его на 45 градусов и сплющиваем по горизонтали в двое
	 * далее растягиваем полигон указывая его рзамер и по его бордерам ставим прямоугольники с репит-текстурой
	 * 
	 * @author 
	 */
	public class BackgroundBorder 
	{
		private static const TILE_SIZE:Number = 32//WorldGeometry.RECT_WIDTH;
		private static const RAD_90:Number = Math.PI / 2;
		
		private var cachedMatrices:Vector.<Matrix> = new Vector.<Matrix>(4, true);
		private var matricesInvalidateFlags:Vector.<Boolean> = new Vector.<Boolean>(4, true);
		
		private var borderRectagon:Rectagon;
		
		private var texture:GTexture
		
		private var size:int;
		
		private var lastDeltaX:Number = 0;
		private var lastDeltaY:Number = 0;
		
		public function BackgroundBorder(texture:GTexture, size:int) 
		{
			//TODO: можно вообще все одной геометрией генерировать, полигоном правда в геноме это слегка упорото
			this.size = size;
			this.texture = texture;
			
			initialize();
		}
		
		private function initialize():void 
		{
			cachedMatrices[0] = new Matrix();
			cachedMatrices[1] = new Matrix();
			cachedMatrices[2] = new Matrix();
			cachedMatrices[3] = new Matrix();
			
			var transform:Matrix = new Matrix();
			transform.rotate(-Math.PI / 4);
			transform.scale(1, 0.5);
			
			borderRectagon = new Rectagon( -size / 2 * TILE_SIZE, -size / 2 * TILE_SIZE, size * TILE_SIZE, size * TILE_SIZE, transform);
			
			if(size != 0)
				borderRectagon.applyTransform();
		}
		
		/**
		 * Размер в еденицах тейлах причем с учетом что тейлы квадраты, а не что то там т.е скорее всгео это будет
		 * rect.width
		 * 
		 * @param	size
		 */
		public function setSize(size:Number):void
		{
			this.size = size;
			borderRectagon.setTo( -size / 2 * TILE_SIZE, -size / 2 * TILE_SIZE, size * TILE_SIZE, size * TILE_SIZE);
			
			invalidateCache();
		}
		
		public function draw(deltaX:Number, deltaY:Number):void
		{	
			var invalidateFlag:Boolean = deltaX != lastDeltaX || deltaY != lastDeltaY; 
			
			lastDeltaX = deltaX;
			lastDeltaY = deltaY;
			
			if (invalidateFlag)
				invalidateCache();
				
			validateMatrices();
			
			drawBorder(0);
			drawBorder(1);
			drawBorder(2);
			drawBorder(3);
		}
		
		private function invalidateCache():void 
		{
			matricesInvalidateFlags[0] = false;
			matricesInvalidateFlags[1] = false;
			matricesInvalidateFlags[2] = false;
			matricesInvalidateFlags[3] = false;
		}
		
		private function drawBorder(index:int):void
		{
			var drawingMatrix:Matrix = cachedMatrices[index];
			//Village.context.drawMatrix(texture, drawingMatrix.a, drawingMatrix.b, drawingMatrix.c, drawingMatrix.d, drawingMatrix.tx, drawingMatrix.ty);
			Genome2D.g2d_instance.g2d_context.drawMatrix(texture, drawingMatrix.a, drawingMatrix.b, drawingMatrix.c, drawingMatrix.d, drawingMatrix.tx, drawingMatrix.ty);
		}
		
		private function validateMatrices():void
		{
			if (matricesInvalidateFlags[0] == false)
				calculateMatrix(0, borderRectagon.resultTopLeft, 		borderRectagon.resultTopRight, 		-3);
			
			if (matricesInvalidateFlags[1] == false)
				calculateMatrix(1, borderRectagon.resultTopRight, 		borderRectagon.resultBottomRight, 	-3);
			
			if (matricesInvalidateFlags[2] == false)
				calculateMatrix(2, borderRectagon.resultBottomRight, 	borderRectagon.resultBottomLeft, 	 3);
			
			if (matricesInvalidateFlags[3] == false)
				calculateMatrix(3, borderRectagon.resultBottomLeft, 		borderRectagon.resultTopLeft, 	 3);
		}
		
		 /**
		 * Выставляет прямоугольник с текстурой правой стороной в точке А левой стороной в точке Б, растягивает до нжуных разеров и поворачивает
		 * 
		 * @param	pointA
		 * @param	pointB
		 * @param	delta - волшебный параметр чтобы уменьшить наложение текстур друг на друга в левом и правом краю. По сути нжуно было бы на углах отдельную текстуру использовать
		 */
		private function calculateMatrix(index:int, pointA:Point, pointB:Point, delta:Number):void
		{
			var distance:Number = (Point.distance(pointA, pointB)) / 32;
				
			texture.g2d_uScale = distance; //не нужно отдельно хранить т.к все дистансы будут одинаковы
			
			var drawingMatrix:Matrix = cachedMatrices[index];
			
			drawingMatrix.identity();
			
			drawingMatrix.tx = -16;
			drawingMatrix.ty = -16;
			drawingMatrix.scale(distance, 1);
			
			var angle:Number = -FastMath.angle(pointA.x, pointA.y, pointB.x, pointB.y) + RAD_90;
			drawingMatrix.rotate(angle);
			
			drawingMatrix.tx += lastDeltaX + pointA.x;
			drawingMatrix.ty += lastDeltaY + pointA.y + delta;
			
			matricesInvalidateFlags[index] = true;
		}
	}
}