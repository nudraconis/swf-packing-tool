package 
{
	import com.genome2d.Genome2D;
	import com.genome2d.context.GContextConfig;
	import com.genome2d.context.stats.GStats;
	import com.genome2d.textures.GTextureFilteringType;
	import com.genome2d.textures.GTextureManager;
	import com.greensock.TweenLite;
	import debugUi.DefinitionUiContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	import genome.drawer.GenomeDisplayListDrawer;
	import genome.drawer.GenomeDrawer;
	import swfdata.ColorData;
	import swfdata.MovieClipData;
	import swfdata.SpriteData;
	import swfdata.SymbolsLibrary;
	import swfdata.atlas.GenomeTextureAtlas;
	import swfdrawer.DisplayListDrawer;
	import ui.TextButton;
	import view.genome.Context3DProfiles;
	import view.genome.VMemStat;
	
	public class TestScene extends Sprite 
	{
		private var atlas:GenomeTextureAtlas;
		
		private var cameraX:Number = 0;
		private var cameraY:Number = 0;
		
		private var bounding:Rectangle = new Rectangle();
		private var frame:int = 0;
		public var size:Number = 3;
		private var ratio:Number = 0.0;
		
		private var outlineSize:Number = 1;
		
		private var backgroundBorder:BackgroundBorder;
		private var color:ColorData = new ColorData();
		
		private var debugDrawer:GenomeDisplayListDrawer;
		
		private var sprite:SpriteData;
		private var library:SymbolsLibrary
		
		
		private var debug:Boolean = false;
		private var checkBounds:Boolean = false;
		private var checkMouseHit:Boolean = false;
		
		public static var convas:Graphics;
		public static var numPoint:int = 0;
		
		
		private var definitionUiContainer:DefinitionUiContainer;
		
		private var mousePoint:Point = new Point();
		
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
		
		private function onMouseUp(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private var mouseClickPosition:Point = new Point();
		
		private function onMouseDown(e:MouseEvent):void 
		{
			mouseClickPosition.setTo(mouseX, mouseY);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseWheel(e:MouseEvent):void 
		{
			if (e.ctrlKey == false)
			{
				var delta:Number = e.delta / (e.shiftKey? 5:50);
				
				var factor:Number = 3 / size;
				
				delta /= factor;
				
				var _size:Number = size;
				_size += delta;
				
				if (_size < 0.5)
					_size = 0.5;
					
				if (_size > 3)
					_size = 3;
					
				TweenLite.to(this, 0.15, { size:_size } );
			}
			else
				outlineSize += e.delta / 100;
				
			trace(outlineSize);
			
			debugDrawer.hightlightSize = outlineSize;
			//outline.outlineFactor = outlineSize;
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			var deltaX:Number = (mouseX - mouseClickPosition.x);
			var deltaY:Number = (mouseY - mouseClickPosition.y);
			
			mouseClickPosition.setTo(mouseX, mouseY);
			
			cameraX += deltaX;
			cameraY += deltaY;
		}
		
		private function onAddedToStage(e:Event):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			definitionUiContainer = new debugUi.DefinitionUiContainer();
			definitionUiContainer.y = 55;
			addChild(definitionUiContainer);
			
			var showAtlasButton:TextButton = new TextButton("Show atlas");
			
			addChild(showAtlasButton);
			
			showAtlasButton.x = stage.stageWidth - showAtlasButton.width;
			showAtlasButton.y = stage.stageHeight - showAtlasButton.height;
			
			showAtlasButton.addEventListener(MouseEvent.CLICK, showAtlas);
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		
			internal_trace('constructing genome');
			var genome:Genome2D = Genome2D.getInstance();
			genome.onInitialized.addOnce(onGenome2DInitialized);
			
			var cfg:GContextConfig = new GContextConfig(stage);
			cfg.profile = Context3DProfiles.getMatchingProfiles();
			cfg.useFastMem = false;
			cfg.hdResolution = false;
			cfg.antiAliasing = 0;
			cfg.renderMode = Context3DRenderMode.AUTO;
			cfg.enableDepthAndStencil = true;
			cfg.enableErrorChecking = true;
			
			GTextureManager.defaultFilteringType = GTextureFilteringType.LINEAR;
			
			genome.init(cfg);
		}
		
		private function onGenome2DInitialized(arg:* = null):void 
		{
			internal_trace('genome init');
			
			internal_trace("Mouse and Mouse wheel to drag camera and zoom");
			internal_trace("use Q/W to jump on next/prev symbol");
			internal_trace("space for pause/unpause");
			internal_trace("D toggle debug drawing");
			internal_trace("S toggle bounds calculation");
			internal_trace("A toggle mouse hit calculation");
			
			
			Genome2D.getInstance().getContext().setBackgroundColor(0xC0C0C0, 1);
			Genome2D.getInstance().onPreRender.add(onFrame);
			Genome2D.getInstance().g2d_context.g2d_nativeContext.enableErrorChecking = false;
			
			GStats.visible = true;
			GStats.x = stage.stageWidth - 200;
			
			var profile:String = "baseline";
			
			var statIdx:int = 0;
			
			var costumeStats:Array = new Array();
				
			if (Genome2D.g2d_instance.g2d_context.g2d_nativeContext.hasOwnProperty("totalGPUMemory"))
			{
				costumeStats[statIdx] = new VMemStat();
				statIdx++;
			}
			 
			if (Genome2D.g2d_instance.g2d_context.g2d_nativeContext.hasOwnProperty("profile"))
				profile = Genome2D.g2d_instance.g2d_context.g2d_nativeContext["profile"];
				
			costumeStats[statIdx] = profile;
			
			GStats.customStats = costumeStats;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function showAtlas(e:Event = null):void
		{
			if (Capabilities.playerType == "Desktop")
			{
				if(atlas != null)
					WindowUtil.openWindowToReview(atlas.atlasData);
			}
			else
				internal_error("atlas review only for desktop version");
		}
		
		public function show(library:SymbolsLibrary, atlas:GenomeTextureAtlas):void
		{
			cameraX = 0;
			cameraY = 0;
			
			color.a = 1;
			
			this.atlas = atlas;
			this.library = library;
			
			
			debugDrawer = new GenomeDisplayListDrawer(atlas, mousePoint);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			this.sprite = library.linkagesList[0];
			var spriteAsTimeline:MovieClipData = sprite as MovieClipData;
				
			if(spriteAsTimeline && spriteAsTimeline.getChildByName('animation'))
				(spriteAsTimeline.getChildByName('animation') as MovieClipData).play();
		}
		
		private var libLookupIndex:int = 0;
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.T)
			{
				color.a -= 0.1;
				size-= 0.2;
			}
			else if (e.keyCode == Keyboard.R)
			{
				color.a += 0.1;
				size+= 0.2;
			}
			if (e.keyCode == Keyboard.F)
			{
				ratio-=0.1;
				
			}
			else if (e.keyCode == Keyboard.G)
			{
				ratio+=0.1
				
			}
			if (e.keyCode == Keyboard.V)
			{
				
			}
			else if (e.keyCode == Keyboard.B)
			{
				
			}
			else if (e.keyCode == Keyboard.A)
			{
				checkMouseHit = !checkMouseHit;
			}
			else if (e.keyCode == Keyboard.S)
			{
				checkBounds = !checkBounds;
			}
			else if (e.keyCode == Keyboard.D)
			{
				debug = !debug;
			}
			
			if (color.a > 1.5)
				color.a = 1.5;
			if (color.a < -0.5)
				color.a = -0.5;
			
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
			else if (e.keyCode == Keyboard.R)
			{
				//sprite.alpha = Math.random();
				//trace("Alpha", sprite.alpha);
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
			
			//trace(sprite.libraryLinkage, sprite.name);
		}
		
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
			
			debugDrawer.checkBounds = checkBounds;
			debugDrawer.debugDraw = debug;
			debugDrawer.checkMouseHit = checkMouseHit;
			
			debugDrawer.smooth = true;
			
			var direction:Number = 1;
			
			sprite.transform.a = size * direction;
			sprite.transform.d = size;
			
			//trace("======draw=======");
			debugDrawer.hightlight = true;
			color.a = 1;
			debugDrawer.drawDisplayObject(sprite, new Matrix(1, 0, 0, 1, cameraX, cameraY), bounding, color);
			
			bounding.setTo(0, 0, 0, 0);
			debugDrawer.hightlight = false;
			color.a = 1
			debugDrawer.drawDisplayObject(sprite, new Matrix(1, 0, 0, 1, cameraX, cameraY), bounding, color);
			//trace("=====end draw=====");
			
			if(cameraX == 0)
				cameraX = (stage.stageWidth - (bounding.width)) / 2 + Math.abs(bounding.x);
				
			if(cameraY == 0)
				cameraY = (stage.stageHeight - (bounding.height)) / 2 + Math.abs(bounding.y);
			
			if (checkBounds)
			{
				graphics.lineStyle(1, 0);
				graphics.drawRect(bounding.x, bounding.y, bounding.width, bounding.height);
			}
			
			graphics.lineStyle(1, 0x00FF00, 0.5);
			graphics.moveTo(stage.stageWidth / 2, 0);
			graphics.lineTo(stage.stageWidth / 2, stage.stageHeight);
			
			graphics.lineStyle(1, 0xFF0000, 0.5);
			graphics.moveTo(0, stage.stageHeight / 2);
			graphics.lineTo(stage.stageWidth, stage.stageHeight / 2);
			
			definitionUiContainer.buildControls(sprite);
			definitionUiContainer.update();
		}
	}
}