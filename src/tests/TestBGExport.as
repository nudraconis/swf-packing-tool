package tests 
{
	import com.genome2d.context.GContextConfig;
	import com.genome2d.context.stats.GStats;
	import com.genome2d.Genome2D;
	import com.genome2d.textures.GTexture;
	import com.genome2d.textures.GTextureFilteringType;
	import com.genome2d.textures.GTextureManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import util.MaxRectPacker;
	/**
	 * ...
	 * @author ...
	 */
	public class TestBGExport extends Sprite
	{
		private var file:File;
		private var globalSkin:String = "skin_autumn";
		private var genome:Genome2D;
		
		public function TestBGExport() 
		{
			stage.align = "TL";
			stage.scaleMode = "noScale";
			file = File.documentsDirectory.resolvePath("background_autumn_mao" + ".swf");
				
			genome = Genome2D.getInstance();
			genome.onInitialized.addOnce(onGenome2DInitialized);
			
			var cfg:GContextConfig = new GContextConfig(stage);
			cfg.profile = Context3DProfile.BASELINE;
			cfg.useFastMem = true;
			cfg.hdResolution = true;
			cfg.antiAliasing = 0;
			cfg.renderMode = Context3DRenderMode.AUTO;
			cfg.enableDepthAndStencil = true;
			
			GTextureManager.defaultFilteringType = GTextureFilteringType.LINEAR;

			genome.init(cfg);
			
			GStats.visible = true;
			GStats.x = stage.stageWidth - 200;
			
		}
		
		public function onGenome2DInitialized(arg:* = null):void 
		{
			openAndLoadContent();
		}
		
		
		private function openAndLoadContent():void 
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			
			var fileContent:ByteArray = new ByteArray();
			fileStream.readBytes(fileContent, 0, fileStream.bytesAvailable);
			fileStream.close();
			
			var swfLoader:Loader = new Loader();
			swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			context.allowCodeImport = true;
			swfLoader.loadBytes(fileContent, context);
		}
		
		private function onLoadComplete(e:Event):void 
		{
			var maxRectPacker:MaxRectPacker = new MaxRectPacker();
			
			var tileLinkage:String = 'BG_tile';
			var planePostfix:String = '';
			globalSkin = globalSkin;

			tileLinkage += '_' + globalSkin;
			planePostfix += '_' + globalSkin;

			var t1:String = 'game_plane_top0' + planePostfix;
			var t2:String = 'game_plane_top1' + planePostfix;
			var t3:String = 'game_plane_top2' + planePostfix;

			var topAtlas:GTexture = GTextureAtlasFactoryUtil.createAtlas('topAtlas' + globalSkin, new <String>[t1, t2, t3]);
			var topTextures:Array = [GTextureManager.getTexture(topAtlas.id + "_" + t1), GTextureManager.getTexture(topAtlas.id + "_" + t2), GTextureManager.getTexture(topAtlas.id + "_" + t3)];

			var bmd:BitmapData = (new (ApplicationDomain.currentDomain.getDefinition(tileLinkage) as Class)) as BitmapData;
			var backgroundTexture:GTexture = GTextureManager.getTexture(tileLinkage) || GTextureManager.createTexture(tileLinkage, bmd, 1, true);
			//_backgroundTexture.repeatable = true;
			backgroundTexture.filteringType = GTextureFilteringType.NEAREST;
			
			this.stage.addChild(new Bitmap(topAtlas.g2d_source as BitmapData));
		}
	}

}