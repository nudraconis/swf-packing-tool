package paralax 
{
	import flash.geom.Point;
	import swfdata.SpriteData;
	/**
	 * ...
	 * @author 
	 */
	public class ParalaxLayer 
	{
		public var sprite:SpriteData;
		
		public function ParalaxLayer(sprite:SpriteData) 
		{
			this.sprite = sprite;
			
		}
		
		public function placePlanes(p1:Point, p2:Point, p3:Point, p4:Point, p5:Point):void
		{
			sprite.displayObjects[0].transform.tx = p1.x;
			sprite.displayObjects[0].transform.ty = p1.y;
			
			sprite.displayObjects[1].transform.tx = p2.x;
			sprite.displayObjects[1].transform.ty = p2.y;
			
			sprite.displayObjects[2].transform.tx = p3.x;
			sprite.displayObjects[2].transform.ty = p3.y;
			
			sprite.displayObjects[3].transform.tx = p4.x;
			sprite.displayObjects[3].transform.ty = p4.y;
			
			sprite.displayObjects[4].transform.tx = p5.x;
			sprite.displayObjects[4].transform.ty = p5.y;
		}
	}

}