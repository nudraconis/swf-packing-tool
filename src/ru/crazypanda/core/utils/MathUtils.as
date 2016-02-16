////////////////////////////////////////////////////////////////////////////////
//
//  © 2015 CrazyPanda LLC
//
////////////////////////////////////////////////////////////////////////////////

package ru.crazypanda.core.utils {
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class MathUtils {

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		public static function getRnd(min:Number, max:Number, provider:Function):Number {
			return provider.apply(null, null) * (max - min) + min;
		}

		/**
		 * Беззнаковое округление вниз.
		 */
		public static function unsignedFloor(value:Number):Number {
			return sign(value) * Math.floor(Math.abs(value));
		}

		/**
		 * Беззнаковое округление до ближайшего целого.
		 */
		public static function unsignedRound(value:Number):Number {
			return sign(value) * Math.round(Math.abs(value));
		}

		/**
		 * Беззнаковое округление вверх.
		 */
		public static function unsignedCeil(value:Number):Number {
			return sign(value) * Math.ceil(Math.abs(value));
		}

		public static function sign(val:Number):int {
			if (val != val || val == Infinity || val == -Infinity || val == 0) return 0;
				return val > 0 ? 1 :-1;
		}

		public static function max(arr:Array): Number {
			var maxVal:Number = NaN;
			var tmp:Number;

			for (var i:int = 0; i < arr.length; i++){
				if (arr[i] is Number) tmp = arr[i];
				else if (arr[i] is Array) tmp = max(arr[i]);
				if ((isNaN(maxVal) || tmp > maxVal) && !isNaN(tmp)) maxVal = tmp;
			}

			return maxVal;
		}

		public static function min(arr:Array): Number {
			var minVal:Number = NaN;
			var tmp:Number;

			for (var i:int = 0; i < arr.length; i++){
				if (arr[i] is Number) tmp = arr[i];
				else if (arr[i] is Array) tmp = min(arr[i]);
				if ((isNaN(minVal)|| tmp < minVal) && !isNaN(tmp)) minVal = tmp;
			}

			return minVal;
		}

		public static function getAngleViaTwoPoints(p1:Point, p2:Point):Number {
			var dx :Number = p2.x - p1.x;
			var dy :Number = p2.y - p1.y;
			var ang:Number = Math.atan(dy / dx);
			if (dx < 0) ang += Math.PI;
			if (ang > Math.PI) ang -= 2 * Math.PI;
			return ang;
		}

		[Deprecated (replacement="Point.distance()")]
		public static function distance(p1:Point, p2:Point):Number {
			return MathUtils.distanceByCoords(p1.x, p1.y, p2.x, p2.y);
		}

		public static function distanceByCoords(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			var dx:Number = x1 - x2;
			var dy:Number = y1 - y2;
			return Math.sqrt((dx * dx) + (dy * dy));
		}
		
		public static function logBase(num:Number, base:Number = Math.E):Number {
			return Math.log(num) / Math.log(base);
		}
		
		/**
		 * Возвращает ближайшее расстояние от края прямоугольника до точки
		 * @param rectangle
		 * @param point
		 * @return
		 */
		public static function distanceToRect(rectangle:Rectangle, point:Point):Number {
			var tl:Point = rectangle.topLeft;
			var br:Point = rectangle.bottomRight;
			var tr:Point = new Point(br.x, tl.y);
			var bl:Point = new Point(tl.x, br.y);
			return Math.min(Point.distance(tl, point), Point.distance(tr, point), Point.distance(bl, point), Point.distance(br, point));
		}
		
		[Inline]
		public static function factorial(n:Number):Number {
			var r:Number = 1;
			for (var i:Number = 2; i <= n; ++i)
				r *= i;
				
			return r; 
		}

		/**
		 * Возвращает результат применения геометрического преобразования, представленного объектом Matrix в заданной точке. (описание спизжено из Matrix.transformPoint
		 */
		public static function transformPoint(matrix:Matrix, x:Number, y:Number, noDelta:Boolean = false, result:Point = null):Point {
			result ||= new Point();
			var dx:Number = noDelta ? 0 : matrix.tx;
			var dy:Number = noDelta ? 0 : matrix.ty;
			result.x = matrix.a * x + matrix.c * y + dx;
			result.y = matrix.d * y + matrix.b * x + dy;
			return result;
		}
		
		public static function transformRectangle(matrix:Matrix, rectangle:Rectangle):Rectangle {
			
			//var a:Number = rectangle.x;
			//var b:Number = rectangle.y;
			//var c:Number = rectangle.right;
			//var d:Number = rectangle.bottom;
			rectangle.x = matrix.a * rectangle.x + matrix.c * rectangle.y + matrix.tx;
			rectangle.y = matrix.d * rectangle.y + matrix.b * rectangle.x + matrix.ty;
			
			
			return rectangle;
		}
		
		/**
		 * То же саоме что matrix.concat() но в итоге не нужен клон матрици от исходной
		 * 
		 * @param	matrixA
		 * @param	matrixB
		 * @param	dest
		 */
		[Inline]
		public static function concatMatrices(matrixA:Matrix, matrixB:Matrix, dest:Matrix):void
		{
			var a:Number = matrixA.a * matrixB.a + matrixA.b * matrixB.c;
			var b:Number = matrixA.a * matrixB.b + matrixA.b * matrixB.d;
			
			var c:Number = matrixA.c * matrixB.a + matrixA.d * matrixB.c;
			var d:Number = matrixA.c * matrixB.b + matrixA.d * matrixB.d;
			
			var tx:Number = matrixA.tx * matrixB.a + matrixA.ty * matrixB.c + matrixB.tx;
			var ty:Number = matrixA.tx * matrixB.b + matrixA.ty * matrixB.d + matrixB.ty;
			
			dest.a = a;
			dest.b =  b;
			dest.c = c;
			dest.d = d;
			dest.tx = tx;
			dest.ty = ty;
		}
		
		public static function rectangleUnion(rect:Rectangle, toUnion:Rectangle):void
		{
			if (rect.width == 0 || rect.height == 0) 
			{
				rect.setTo(toUnion.x, toUnion.y, toUnion.width, toUnion.height);
				return;
			} 
			else if (toUnion.width == 0 || toUnion.height == 0) 
			{
				return;
			}
			
			var x0:Number = rect.x > toUnion.x ? toUnion.x : rect.x;
			var x1:Number = rect.right < toUnion.right ? toUnion.right : rect.right;
			var y0:Number = rect.y > toUnion.y ? toUnion.y : rect.y;
			var y1:Number = rect.bottom < toUnion.bottom ? toUnion.bottom : rect.bottom;
			
			rect.setTo(x0, y0, x1 - x0, y1 - y0);
			
		}
	}
}