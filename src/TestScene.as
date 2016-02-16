package 
{
	import com.genome2d.context.GContextConfig;
	import com.genome2d.context.stats.GStats;
	import com.genome2d.Genome2D;
	import com.genome2d.textures.GTextureFilteringType;
	import com.genome2d.textures.GTextureManager;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import swfdata.atlas.GenomeTextureAtlas;
	import swfdata.MovieClipData;
	import swfdata.SpriteData;
	import swfdata.SymbolsLibrary;
	import ui.TextButton;
	
	public class TestScene extends Sprite 
	{
		private var debugDrawer:DisplayListDrawer;
		private var sprite:SpriteData;
		private var library:SymbolsLibrary
		
		private var definitionUiContainer:DefinitionUiContainer;
		
		public static var convas:Graphics;
		public static var numPoint:int = 0;
		
		public function TestScene() 
		{
			super();
			
			convas = this.graphics;
			initialize();
		}
		
		private function initialize():void 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			definitionUiContainer = new DefinitionUiContainer();
			addChild(definitionUiContainer);
			
			var showAtlasButton:TextButton = new TextButton("Show atlas");
			
			addChild(showAtlasButton);
			
			showAtlasButton.x = stage.stageWidth - showAtlasButton.width;
			showAtlasButton.y = stage.stageHeight - showAtlasButton.height;
			
			showAtlasButton.addEventListener(MouseEvent.CLICK, showAtlas);
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
			trace('constructing genome');
			var genome:Genome2D = Genome2D.getInstance();
			genome.onInitialized.addOnce(onGenome2DInitialized);
			
			var cfg:GContextConfig = new GContextConfig(stage);
			cfg.profile = Context3DProfile.BASELINE;
			cfg.useFastMem = true;
			cfg.hdResolution = false;
			cfg.antiAliasing = 0;
			cfg.renderMode = Context3DRenderMode.AUTO;
			cfg.enableDepthAndStencil = true;
			
			GTextureManager.defaultFilteringType = GTextureFilteringType.LINEAR;

			genome.init(cfg);
			
			GStats.visible = true;
			GStats.x = stage.stageWidth - 200;
		}
		
		private function onGenome2DInitialized(arg:* = null):void 
		{
			trace('genome init');
			
			Genome2D.getInstance().getContext().setBackgroundColor(0xC0C0C0, 1);
			Genome2D.getInstance().onPreRender.add(onFrame);
			Genome2D.getInstance().g2d_context.g2d_nativeContext.enableErrorChecking = true;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function showAtlas(e:Event = null):void
		{
			WindowUtil.openWindowToReview(atlas.atlasData);
		}
		
		public function show(library:SymbolsLibrary, atlas:GenomeTextureAtlas):void
		{
			this.atlas = atlas;
			this.library = library;
			
			
			debugDrawer = new DisplayListDrawer(atlas, mousePoint);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			

			this.sprite = library.linkagesList[0];
			var spriteAsTimeline:MovieClipData = sprite as MovieClipData;
			
			
			
			if(spriteAsTimeline && spriteAsTimeline.getChildByName('animation'))
				(spriteAsTimeline.getChildByName('animation') as MovieClipData).play();
			else if (spriteAsTimeline)
				spriteAsTimeline.play();
		}
		
		private var libLookupIndex:int = 0;
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.Q)
			{
				for (;libLookupIndex < library.spritesList.length; libLookupIndex++)
				{
					if (library.spritesList[libLookupIndex] != sprite)
					{
						sprite = library.spritesList[libLookupIndex];
						break;
					}
				}
				
				if (libLookupIndex == library.spritesList.length)
					libLookupIndex = 0;
					
				frame = 0;
			}
			else if (e.keyCode == Keyboard.W)
			{
				for (; libLookupIndex > 0; libLookupIndex--)
				{
					if (library.spritesList[libLookupIndex] != sprite)
					{
						sprite = library.spritesList[libLookupIndex];
						break;
					}
				}
				
				if (libLookupIndex == 0)
					libLookupIndex = library.spritesList.length-1;
					
				frame = 0;
			}
			else if (e.keyCode == Keyboard.SPACE)
			{
				if (sprite is MovieClipData)
				{
					var spriteAsTimeline:MovieClipData = sprite as MovieClipData;
					
					if (spriteAsTimeline.isPlaying)
						spriteAsTimeline.stop();
					else
						spriteAsTimeline.play();
					
					if(spriteAsTimeline.getChildByName('animation'))
						(spriteAsTimeline.getChildByName('animation') as MovieClipData).play();
				}
			}
		}
		
		
		private var atlas:GenomeTextureAtlas;
		private var frame:int = 0;
		private var bounding:Rectangle = new Rectangle();
		private var mousePoint:Point = new Point();
		
		private function onFrame(e:Event = null):void 
		{
			if (!sprite || ! debugDrawer)
				return;
				
			graphics.clear();
			numPoint = 0;
			
			mousePoint.x = mouseX;
			mousePoint.y = mouseY;
			
			if(sprite is IUpdatable)
				(sprite as IUpdatable).update();
				
			bounding.setTo(0, 0, 0, 0);
			debugDrawer.debugConvas = this.graphics;
			debugDrawer.drawDisplayObject(sprite, new Matrix(1, 0, 0, 1, 400, 300), true, false, false, -1, bounding);
			
		
			
			graphics.lineStyle(1, 0);
			graphics.drawRect(bounding.x, bounding.y, bounding.width, bounding.height);
			
			//definitionUiContainer.buildControls(sprite);
			//definitionUiContainer.update();
			
			//trace(bounding);
			
			
		}
		
	}

}