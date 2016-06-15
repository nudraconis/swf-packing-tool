package view.genome.textures 
{
	import com.genome2d.textures.GTexture;
	import com.genome2d.textures.GTextureFilteringType;
	import com.genome2d.textures.GTextureManager;
	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	import flash.geom.Rectangle;
	import view.genome.Genome2DController;
	
	/**
	 * Мульти текстур атлас, хранит в себе N атласов для акторов с кучей субтекстур
	 * 
	 */
	public class MultyTextureAtlas 
	{
		public var id:String;
		
		private var atlasesUsed:int = 0;
		
		private var atlases:Vector.<GTexture> = new Vector.<GTexture>;
		private var currentAtlas:GTexture;
		
		private var subtextureToAtlasLinkMap:Object = { };
		
		public function MultyTextureAtlas(id:String) 
		{
			this.id = id;
		}
			
		/**
		 * Создает новый атлас из входного битмапа и устанавливает его как текущий атлас
		 * Новые субтекстуры будут создаватся в этом атласа
		 * @param	source
		 */
		public function createAtlas(source:BitmapData):void
		{
			currentAtlas = GTextureManager.createTexture(id + atlasesUsed, source, 1, false, Genome2DController.TEXTURE_FORMAT);
			currentAtlas.filteringType = GTextureFilteringType.LINEAR;

			atlases.push(currentAtlas);
			
			//currentAtlas.invalidateNativeTexture(false);
			
			atlasesUsed++;
		}
		
		/**
		 * Создает субтекстуру в текущем атласе и ложит ее в мэп
		 * @param	name
		 * @param	result
		 * @param	rectangle
		 * @return
		 */
		public function createSubTexture(name:String, result:MultyTextureAtlas, rectangle:Rectangle):GTexture 
		{
			//дельта в геометрии для рендера эфектов типа аутлайна и тд
			
			rectangle.x -= 3;
			rectangle.y -= 3;
			rectangle.width += 6;
			rectangle.height += 6;
			
			var subTexture:GTexture = GTextureManager.createSubTexture(name, currentAtlas, rectangle);
			subTexture.filteringType = GTextureFilteringType.LINEAR;
			
			subtextureToAtlasLinkMap[name] = currentAtlas.id + "_" + name;
			
			return subTexture;
		}
		
		public function getTexture(name:String):GTexture
		{
			var atlasLink:String = subtextureToAtlasLinkMap[name];
				
			return GTextureManager.getTexture(atlasLink);
		}
	}
}