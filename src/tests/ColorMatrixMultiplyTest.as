package tests
{
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix3D;
	
	public class ColorMatrixMultiplyTest extends Sprite 
	{
		
		public function ColorMatrixMultiplyTest() 
		{
			super();
			
			var objectA:Sprite = createObject();
			addChild(objectA);
			
			var objectB:Sprite = createObject();
			addChild(objectB);
			objectB.x += 52
			
			var objectC:Sprite = createObject();
			addChild(objectC);
			objectC.x += 104;
			
			var objectF:Sprite = createObject();
			//addChild(objectF);
			objectF.x += 156;
			
			var objectG:Sprite = createObject();
			//addChild(objectG);
			objectG.x += 208;
			
			var objectD:Sprite = createObject();
			var containerD:Sprite = new Sprite();
			addChild(containerD);
			containerD.addChild(objectD);
			objectD.y += 52
			
			var objectE:Sprite = createObject();
			var containerE:Sprite = new Sprite();
			//addChild(containerE);
			//containerE.addChild(objectE);
			objectE.y += 52
			objectE.x += 52
	
			
			var matrix1:ColorMatrix = new ColorMatrix(new <Number>[
									0.5703125, 0, 0, 0, 0,
									0, 0.5703125, 0, 0, 110,
									0, 0, 0.5703125, 0, 0,
									0, 0, 0, 1, 0
								])
								
			var matrix2:ColorMatrix = new ColorMatrix(new <Number>[
									0, 0, 0, 0, 255,
									0, 0, 0, 0, 0,
									0, 0, 0, 0, 0,
									0, 0, 0, 1, 0
								 ])
								 
			 					
			var matrix4:ColorMatrix = new ColorMatrix(new <Number>[
									1, 0, 0, 0, 100,
									0, 1, 0, 0, 100,
									0, 0, 1, 0, 100,
									0, 0, 0, 1, 0
								 ])
								 
								
			var matrix5:ColorMatrix = new ColorMatrix(new <Number>[
									1, 0, 0, 0, 0,
									0, 1, 0, 0, 0,
									0, 0, 1, 0, -90,
									0, 0, 0, 1, 0
								 ])
								 
			
			var matrix3:ColorMatrix = new ColorMatrix();/*(new <Number>[
									0.5703125 * 0, 0, 0, 0, 255 * 0.5703125,
									0, 0.5703125 * 0, 0, 0, 110,
									0, 0, 0.5703125 * 0, 0, 0,
									0, 0, 0, 1, 0
								])*/
								
			//matrix3.concat(matrix2.matrix);
			//matrix3.concat(matrix4.matrix);
			//matrix3.concat(matrix1.matrix);
			
			//matrix3.premultiply(matrix1.matrix);
			
			matrix5.matrix = matrix1.matrix;
			trace(matrix5.matrix);
			matrix5.concat(matrix4.matrix);
			trace(matrix5.matrix);
			
			matrix3.concat(matrix5.matrix);
			matrix3.concat(matrix2.matrix);
			//matrix3.premultiply(matrix5.matrix);
			
			//0,0,0,0,145.4296875,0,0,0,0,167.03125,0,0,0,0,57.03125,0,0,0,1,0
			
			//matrix3.concat(matrix2.matrix);
			//matrix3.concat(matrix4.matrix);
			//matrix3.concat(matrix5.matrix);
			

			trace(matrix3.matrix);
			
			//extendMatrix(matrix1);
			//extendMatrix(matrix2);
			//extendMatrix(matrix3);
			
			//traceMatrix(matrix3);
								 
			objectA.filters = [matrix1.filter];
			objectB.filters = [matrix2.filter];
			objectC.filters = [matrix3.filter];
			//objectF.filters = [matrix4.filter];
			//objectG.filters = [matrix5.filter];
			objectD.filters = [matrix2.filter, matrix4.filter, matrix1.filter];
			//objectE.filters = [matrix1.filter, matrix2.filter, matrix4.filter, matrix5.filter];
		}
		
		private function traceMatrix(matrix1:Array):void 
		{
			var row:String = "";
			for (var i:int = 0; i < 4; i++)
			{
				for (var j:int = 0; j < 5; j++)
				{
					row += matrix1[i * 5 + j] + ", ";
				}
				
				trace(row);
				row = "";
			}
		}
		
		private function extendMatrix(matrix:Array):void 
		{
			matrix.insertAt(4, -100);
			matrix.insertAt(9, 0);
			matrix.insertAt(14, 0);
			matrix.insertAt(matrix.length , 0);
		}
		
		public function matrixMultiply(a:Array, b:Array, c:Array):Array
		{
			for (var i:int = 0 ; i < 4; i++)
			{
				var indexModificator:int = i * 4;
				
				c[0 + indexModificator] = a[0 + indexModificator] * b[0] + a[1 + indexModificator] * b[4] + a[2 + indexModificator] * b[8] + a[3 + indexModificator] * b[12];
				
				c[1 + indexModificator] = a[0 + indexModificator] * b[1] + a[1 + indexModificator] * b[5] + a[2 + indexModificator] * b[9] + a[3 + indexModificator] * b[13];
				
				c[2 + indexModificator] = a[0 + indexModificator] * b[2] + a[1 + indexModificator] * b[6] + a[2 + indexModificator] * b[10] + a[3 + indexModificator] * b[14];
				
				c[3 + indexModificator] = a[0 + indexModificator] * b[3] + a[1 + indexModificator] * b[7] + a[2 + indexModificator] * b[11] + a[3 + indexModificator] * b[15];
			}
			
			return c;
		}
		
		public function toArray(vec:Object):Array
		{
			var a:Array = [];
			
			for (var i:int = 0; i < vec.length; i++)
			{
				a[i] = vec[i];
			}
			
			return a;
		}
		
		private function createObject():Sprite 
		{
			var sprite:Sprite = new Sprite();
			
			sprite.graphics.beginFill(0x0);
			sprite.graphics.drawRect(0, 0, 50, 50);
			sprite.graphics.endFill();
			
			return sprite;
		}
		
	}

}