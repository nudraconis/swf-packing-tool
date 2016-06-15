////////////////////////////////////////////////////////////////////////////////
//
//  © 2015 CrazyPanda LLC
//
////////////////////////////////////////////////////////////////////////////////
package  {
	import com.genome2d.textures.GTexture;
	import com.genome2d.textures.GTextureManager;
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	import utils.MaxRectPacker;
	import utils.PackerRectangle;

	/**
	 * @author                    Obi
	 * @langversion                3.0
	 * @date                    30.01.2015
	 */
	public class GTextureAtlasFactoryUtil {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static const _hash:Object = {};

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		public static function createAtlas(id:String, bitmapLinkages:Vector.<String>, disposeBitmapData:Boolean = false):GTexture {
			if (id in _hash) return _hash[id];

			var atlas:GTexture = GTextureManager.getTexture(id);
			if (atlas) {
				_hash[id] = atlas;
				return atlas;
			}

			var index:int = 0;
			var rectangles:Vector.<PackerRectangle> = new Vector.<PackerRectangle>();
			for each (var link:String in bitmapLinkages) {
				var r:PackerRectangle = new PackerRectangle();
				r.id = index++;
				r.bitmapData = (new (ApplicationDomain.currentDomain.getDefinition(link) as Class)) as BitmapData;
				r.width = r.bitmapData.width;
				r.height = r.bitmapData.height;
				r.pivotX = -r.width/2;
				r.pivotY = -r.height/2;
				rectangles.push(r);
			}

			var packer:MaxRectPacker = new MaxRectPacker();
			packer.clearData();
			packer.packRectangles(rectangles, 0);

			var atlasBmd:BitmapData = packer.drawAtlas(0);
            
			atlas = GTextureManager.createTexture(id, atlasBmd, 1, false, "bgra");
			for each (r in rectangles) {
				var subTexture:GTexture = GTextureManager.createSubTexture(bitmapLinkages[r.id], atlas, r.getRect());
				subTexture.pivotX = r.pivotX;
				subTexture.pivotY = r.pivotY;
				
				if (disposeBitmapData) r.bitmapData.dispose();
			}

			atlas.invalidateNativeTexture(false);
			_hash[id] = atlas;
			return atlas;
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function GTextureAtlasFactoryUtil() {
			super();
		}

	}
}
