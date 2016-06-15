package view.genome 
{
	import com.genome2d.context.GContextConfig;
	import com.genome2d.context.IGContext;
	import com.genome2d.context.stats.GStats;
	import com.genome2d.Genome2D;
	import com.genome2d.textures.GTextureFilteringType;
	import com.genome2d.textures.GTextureManager;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DTextureFormat;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FullScreenEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	[Event(name="init", type="flash.events.Event")]
	public class Genome2DController extends EventDispatcher
	{
		static public const TEXTURE_FORMAT:String = Context3DTextureFormat.BGRA;
		
		public var stage:Stage;
		public static var genome:Genome2D;
		public static var context:IGContext;
		public static var debugConvas:Graphics;
		
		private static const SCREEN_SIZE_RECTANGLE:Rectangle = new Rectangle(0, 0, 256, 256);
		
		
		public function Genome2DController(stage:Stage) 
		{
			this.stage = stage;
			
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
			stage.addEventListener(Event.RESIZE, onScreenResize);
		}
		
		public function onStageDrawCall(convas:BitmapData, m:Matrix):void
		{
			var stage3DConvas:BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x0);
			context.setBitmapDataTarget(stage3DConvas);
			genome.render();
			
			convas.draw(stage3DConvas, m);
			stage3DConvas.dispose();
		}
		
		public function set enableErrorChecking(value:Boolean):void
		{
			Genome2D.g2d_instance.g2d_context.g2d_nativeContext.enableErrorChecking = value;
		}
		
		public function init():void
		{
			var genome:Genome2D = Genome2D.getInstance();
			
			genome.onInitialized.addOnce(onGenome2DInitialized);
			configureAndInitGenome(genome);
		}
		
		private function onScreenResize(e:Event):void 
		{
			setScreenSize();
		}
		
		private function onFullScreen(e:FullScreenEvent):void 
		{
			setScreenSize();
		}
		
		private function setScreenSize():void
		{
			if (!Genome2DController.genome) return;
			if (stage.displayState == StageDisplayState.FULL_SCREEN)
				SCREEN_SIZE_RECTANGLE.setTo(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
			else
				SCREEN_SIZE_RECTANGLE.setTo(0, 0, stage.stageWidth, stage.stageHeight);
				
			if (SCREEN_SIZE_RECTANGLE.width < 32)
				SCREEN_SIZE_RECTANGLE.width = 32;
				
			if (SCREEN_SIZE_RECTANGLE.height < 32)
				SCREEN_SIZE_RECTANGLE.height = 32;
			
			Genome2DController.genome.g2d_context.resize(SCREEN_SIZE_RECTANGLE);
		}
		
		private var costumeStats:Array = [];
		private function onGenome2DInitialized(arg:Object = null):void 
		{
			Genome2DController.genome = Genome2D.getInstance();
			Genome2DController.context = genome.getContext();
			
			genome.onPreRender.add(onPreRender);
			
			dispatchEvent(new Event(Event.INIT));
			
			GStats.visible = true;
			
			var profile:String = "baseline";
			
			var statIdx:int = 0;
				
			if (Genome2D.g2d_instance.g2d_context.g2d_nativeContext.hasOwnProperty("totalGPUMemory"))
			{
				costumeStats[statIdx] = new VMemStat();
				statIdx++;
			}
			 
			if (Genome2D.g2d_instance.g2d_context.g2d_nativeContext.hasOwnProperty("profile"))
				profile = Genome2D.g2d_instance.g2d_context.g2d_nativeContext["profile"];
				
			costumeStats[statIdx] = profile;
			
			GStats.customStats = costumeStats;
		}
		
		private function onPreRender(o:Object = null):void 
		{
			//Genome2DController.debugConvas.clear();
			
			//GStats.y = 45;
			//GStats.x = stage.stageWidth - 274
			GStats.x = 20;
		}
		
		private function configureAndInitGenome(genome:Genome2D):void 
		{
			var cfg:GContextConfig = new GContextConfig(stage);
			var profiles:Vector.<String> = Context3DProfiles.getMatchingProfiles();
			
			if(profiles.length > 0)
				cfg.profile = profiles;
				
			cfg.useFastMem = false;
			cfg.hdResolution = false;
			cfg.antiAliasing = 0;
			cfg.renderMode = Context3DRenderMode.AUTO;
			cfg.enableDepthAndStencil = true;
			
			GTextureManager.defaultFilteringType = GTextureFilteringType.LINEAR;
			
			genome.init(cfg);
		}
	}
}