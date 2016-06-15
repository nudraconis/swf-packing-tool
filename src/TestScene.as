package 
{
	import com.genome2d.context.GContextConfig;
	import com.genome2d.context.stats.GStats;
	import com.genome2d.Genome2D;
	import com.genome2d.textures.GTexture;
	import com.genome2d.textures.GTextureFilteringType;
	import com.genome2d.textures.GTextureManager;
	import debugUi.DefinitionUiContainer;
	import flash.display.BitmapData;
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
	import paralax.ParalaxLayer;
	import paralax.ParallaxLayerController;
	import swfdata.atlas.GenomeTextureAtlas;
	import swfdata.ColorData;
	import swfdata.MovieClipData;
	import swfdata.SpriteData;
	import swfdata.SymbolsLibrary;
	import swfdrawer.DisplayListDrawer;
	import ui.TextButton;
	import view.genome.Context3DProfiles;
	import view.genome.filters.AdjustColor;
	
	public class TestScene extends Sprite 
	{
		private var debugDrawer:DisplayListDrawer;
		private var sprite:SpriteData;
		private var library:SymbolsLibrary
		
		private var definitionUiContainer:debugUi.DefinitionUiContainer;
		
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
		
		private function onMouseMove(e:MouseEvent):void 
		{
			var deltaX:Number = (mouseX - mouseClickPosition.x);
			var deltaY:Number = (mouseY - mouseClickPosition.y);
			
			paralaxController.camera.x += deltaX;
			paralaxController.camera.y += deltaY;
			
			mouseClickPosition.setTo(mouseX, mouseY);
			
			next_x += deltaX;
			next_y += deltaY;
		}
		
		private function onAddedToStage(e:Event):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			definitionUiContainer = new debugUi.DefinitionUiContainer();
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
			trace('genome init');
			
			Genome2D.getInstance().getContext().setBackgroundColor(0xC0C0C0, 1);
			Genome2D.getInstance().onPreRender.add(onFrame);
			Genome2D.getInstance().g2d_context.g2d_nativeContext.enableErrorChecking = true;
			
			GStats.visible = false;
			GStats.x = stage.stageWidth - 200;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function showAtlas(e:Event = null):void
		{
			WindowUtil.openWindowToReview(atlas.atlasData);
		}
		
		public function show(library:SymbolsLibrary, atlas:GenomeTextureAtlas):void
		{
			color.a = 1;
			this.atlas = atlas;
			this.library = library;
			
			
			debugDrawer = new DisplayListDrawer(atlas, mousePoint);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			this.sprite = library.linkagesList[0];
			var spriteAsTimeline:MovieClipData = sprite as MovieClipData;
				
			if(spriteAsTimeline && spriteAsTimeline.getChildByName('animation'))
				(spriteAsTimeline.getChildByName('animation') as MovieClipData).play();
			else if (spriteAsTimeline)
				spriteAsTimeline.gotoAndPlayAll(0);
				
			sprite.gotoAndPlayAll(0);
			
			paralaxController = new ParallaxLayerController(stage, new ParalaxLayer(sprite));
			paralaxController.init();
			
		}
		
		private var libLookupIndex:int = 0;
		private function onKeyDown(e:KeyboardEvent):void 
		{
			
			if (e.keyCode == Keyboard.T)
			{
				
				color.a -= 0.1;
				size-= 0.2;
				//backgroundBorder.setSize(size);
				AdjustColor.brightness += 0.1;
				
			}
			else if (e.keyCode == Keyboard.R)
			{
				color.a += 0.1;
				size+= 0.2;
				//backgroundBorder.setSize(size);
				AdjustColor.brightness -= 0.1;
				
			}
			if (e.keyCode == Keyboard.F)
			{
				ratio-=0.1;
				AdjustColor.contrast += 0.1;
				
			}
			else if (e.keyCode == Keyboard.G)
			{
				ratio+=0.1
				AdjustColor.contrast -= 0.1;
				
			}
			if (e.keyCode == Keyboard.V)
			{
				AdjustColor.saturation += 0.1;
				
			}
			else if (e.keyCode == Keyboard.B)
			{
				AdjustColor.saturation -= 0.1;
				
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
		
		
		private var atlas:GenomeTextureAtlas;
		private var frame:int = 0;
		private var bounding:Rectangle = new Rectangle();
		private var mousePoint:Point = new Point();
		private var size:Number = 3;
		private var ratio:Number = 0.0;
		
		private var backgroundBorder:BackgroundBorder;
		private var color:ColorData = new ColorData();
		
		public function drawRect():void
		{
			
			var text:GTexture = GTextureManager.getTexture("neibor_border");
			if (text == null)
			{
				var bmp:BitmapData = new BitmapData(64, 64, true, 0x0);
				var m:Matrix = new Matrix();
				//m.scale(64 / 48, 64 / 48);
				bmp.draw(new neibor_border, m);
				text = GTextureManager.createTexture("neibor_border", bmp, 32/64, true);
				text.filteringType = GTextureFilteringType.LINEAR;
				
				backgroundBorder = new BackgroundBorder(text, 5);
			}
			
			backgroundBorder.draw(400, 300);
			backgroundBorder.setSize(9);
			
			Genome2D.g2d_instance.g2d_context.drawMatrix(text, 1, 0, 0, 1, 400, 300);
		}
		
		public function render():void 
		{
			
			
			/*var ax:Number = cam_x;
			var ay:Number = cam_y;

			var debugBorder:int = -25;
			
			var aly:int = cam_y + 40;

			var len:int = 5;

			for (var i:int = 0; i < len; i++) 
			{
				if (_positions[i] == null)
					continue;
					
				//var textures:Vector.<GTexture> = this._planes[i];

				var position:Point = this._positions[i];
				var nextX:int = position.x;

				//var tLen:int = textures.length;
				for (var j:int = 0; j < 5; j++) 
				{
					//var t:GTexture = textures[j];
					
					var h:Number = t.height;
					var y:Number = position.y + ay;
					var b:Number = y + h;
					
					var y:Number = position.y;
					
					next_x = nextX;
					next_y = y + aly;
					
					nextX += t.width;
				}
			}*/
		}
		
		private var _positions:Vector.<Point> = new Vector.<Point>(5, true);
		private var cam_x:Number = 0;
		private var cam_y:Number = 0;
		private var next_x:Number = 0;
		private var next_y:Number = 0;
		private var paralaxController:ParallaxLayerController;
		
		private function onFrame(e:Event = null):void 
		{
			if (!sprite || ! debugDrawer)
				return;
				
			graphics.clear();
			
			
			if ((sprite.getChildByName("mill") as MovieClipData) )
				(sprite.getChildByName("mill") as MovieClipData).play();
			
			numPoint = 0;
			
			mousePoint.x = mouseX;
			mousePoint.y = mouseY;
			
			if(sprite is IUpdatable)
				(sprite as IUpdatable).update();
				
			//paralaxController.render();
				
			bounding.setTo(0, 0, 0, 0);
			debugDrawer.debugConvas = this.graphics;
			
			debugDrawer.checkBounds = true;
			debugDrawer.debugDraw = false;
			debugDrawer.checkMouseHit = false;
			
			debugDrawer.smooth = true;
			
			var direction:Number = 1;
			
			sprite.transform.a = 1 * direction;
			sprite.transform.d = 1;
			
			
			render();
			
			//trace("======draw=======");
			debugDrawer.drawDisplayObject(sprite, new Matrix(1, 0, 0, 1, next_x, next_y), bounding, color);
			//trace("=====end draw=====");
			
			//if(next_x == 0)
			//	next_x = (stage.stageWidth - (bounding.width)) / 2 + Math.abs(bounding.x);
				
			//if(next_y == 0)
			//	next_y = (stage.stageHeight - (bounding.height)) / 2 + Math.abs(bounding.y);
			
			//debugDrawer.drawDisplayObject(library.getDisplayObjectByLinkage("lake11110001"), new Matrix(1, 0, 0, 1, 400, 300 + 37.45), true, false, false, -1, bounding);
			
			//debugDrawer.drawDisplayObject(library.getDisplayObjectByLinkage("lake1110000"), new Matrix(1, 0, 0, 1, 400 + -37.45, 300 + 37.45 / 2), true, false, false, -1, bounding);
			
			//debugDrawer.drawDisplayObject(library.getDisplayObjectByLinkage("lake111"), new Matrix(1, 0, 0, 1, 400 + 37.45, 300 + 37.45 / 2), true, false, false, -1, bounding);
			
			//drawRect();
			
			//Genome2D.g2d_instance.g2d_context.drawPoly(text, [ -50, -50, 50, -50, 50, 50, 50, 50, -50, 50, -50, -50 ], [0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0], 400, 350);
			
			//graphics.lineStyle(1, 0);
			//graphics.drawRect(bounding.x, bounding.y, bounding.width, bounding.height);
			
			/*graphics.lineStyle(1, 0x00FF00, 0.5);
			graphics.moveTo(stage.stageWidth / 2, 0);
			graphics.lineTo(stage.stageWidth / 2, stage.stageHeight);
			
			graphics.lineStyle(1, 0xFF0000, 0.5);
			graphics.moveTo(0, stage.stageHeight / 2);
			graphics.lineTo(stage.stageWidth, stage.stageHeight / 2);
				*/
			
			//definitionUiContainer.buildControls(sprite);
			//definitionUiContainer.update();
			
			//trace(bounding);
			
			
		}
		
	}

}