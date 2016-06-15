////////////////////////////////////////////////////////////////////////////////
//
//  © 2015 CrazyPanda LLC
//
////////////////////////////////////////////////////////////////////////////////
package paralax 
{
	import flash.display.Stage;
	import flash.Lib;
	import swfdata.DisplayObjectData;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author                    Obi
	 * @langversion                3.0
	 * @date                    22.01.2015
	 */
	public class ParallaxLayerController {

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static const _RATIOS:Vector.<Number> = (new <Number>[0.25, 0.55, 0.75, 0.85, 0.92]);

		/**
		 * @private
		 */
		private static const _BASE_POSITIONS:Vector.<Point> = new <Point>[
			new Point(), new Point(), new Point(), new Point(), new Point()
		];

		/**
		 * @private
		 */
		private static const _CURRENT_POSITIONS:Vector.<Point> = new <Point>[
			new Point(), new Point(), new Point(), new Point(), new Point()
		];
		private var stage:Stage;
		private var layer:ParalaxLayer;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function ParallaxLayerController(stage:Stage, layer:ParalaxLayer) {
			this.layer = layer;
			this.stage = stage;
		}
		
		public var camera:Point = new Point(0, 0);

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//-------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------

		public function init():void {
			this.render();
		}

		public function render():void {
			//this.updateBasePositions();
			this.updatePositions();
		}

		public function updateRadius():void {
			//this.updateBasePositions();
			this.updatePositions();
		}

		public function updatePositions():void {

			var dx:Number = camera.x// + stage.width / 2;
			
			var len:int = _BASE_POSITIONS.length;
			for (var i:int = 0; i < len; i++) 
			{
				var ratio:Number = _RATIOS[i];
				var base:Point = _BASE_POSITIONS[i];

				var result_x:Number = base.x + (dx - (dx * ratio)) + stage.width / 2;
				var result_y:Number = base.y + camera.y;
				
				var childName:String = 'plane_' + i;
				var child:DisplayObjectData = layer.sprite.getChildByName(childName);
				
				if (!child) 
				{
					//trace('Error: Cant find parallax plane named ' + childName);
					continue;
				}
				
				
				child.transform.tx = result_x;
				//child.transform.ty = result_y;
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private function updateBasePositions():void 
		{
			for (var i:int = 0; i < _BASE_POSITIONS.length; i++) 
			{
				var childName:String = 'plane_' + i;
				var child:DisplayObjectData = layer.sprite.getChildByName(childName);
				
				if (!child) 
				{
					//trace('Error: Cant find parallax plane named ' + childName);
					continue;
				}

				var pt:Point = _BASE_POSITIONS[i];
				pt.x = child.transform.tx;
				pt.y = child.transform.ty;
			}
		}
	}
}
