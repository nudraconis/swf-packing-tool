package web 
{
	import events.FileSystemEvent;
	import events.FileSystemEvent;
	import events.FileSystemScope;
	import events.SceneEvent;
	import events.SystemMenuEvent;
	import events.SystemMenuScope;
	import external.fileSystem.VirtualFile;
	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import swfdata.atlas.BitmapSubTexture;
	import swfdata.atlas.BitmapTextureAtlas;
	import swfdata.atlas.GenomeTextureAtlas;
	import swfparser.SwfDataParser;
	import util.MaxRectPacker;
	import util.PackerRectangle;
	
	public class FileManagerController 
	{
		private var fileReference:FileReference;
		
		private var swfDataParser:SwfDataParser;
		private var maxRectPacker:MaxRectPacker;
		
		private var lastAtlas:GenomeTextureAtlas;
		
		public function FileManagerController() 
		{
			initialize();
		}
		
		private function initialize():void 
		{
			swfDataParser = new SwfDataParser();
			maxRectPacker = new MaxRectPacker();
			
			describe(SystemMenuScope, new SystemMenuEvent(SystemMenuEvent.OPEN_SWF), onOpenSWF);
			describe(SystemMenuScope, new SystemMenuEvent(SystemMenuEvent.OPEN_ANIMATION), onOpenAnimation);
			describe(SystemMenuScope, new SystemMenuEvent(SystemMenuEvent.SAVE_ANIMATION), onSaveAnimation);
		
			fileReference = new FileReference();
			fileReference.addEventListener(Event.SELECT, onFileSelect);
			fileReference.addEventListener(Event.COMPLETE, onFileLoaded);
		}
		
		private function onFileLoaded(e:Event):void 
		{
			try
			{
				if (lastAtlas)
					lastAtlas.dispose(true);
					
				swfDataParser.clear();
				
				swfDataParser.parseSwf(fileReference.data, true);
				fileReference.data.clear();
				
				packRectangles();
				lastAtlas = rebuildAtlas();
			}
			catch (e:Error)
			{
				internal_error(e.name, e);
			}
			
			broadcast(FileSystemScope, new SceneEvent("showScene", false, false, swfDataParser.context.library, lastAtlas));
		}
		
		private function onFileSelect(e:Event):void 
		{
			fileReference.load();
		}
		
		private function rebuildAtlas():GenomeTextureAtlas 
		{
			var atlasSoruce:BitmapData = maxRectPacker.drawAtlas(0);
			var packedAtlas:GenomeTextureAtlas = new GenomeTextureAtlas("genome", atlasSoruce, Context3DTextureFormat.BGRA, 4);
			
			var rects:Vector.<PackerRectangle> = maxRectPacker.atlasDatas[0].rectangles;
			
			for (var i:int = 0; i < rects.length; i++)
			{
				var currentRegion:PackerRectangle = rects[i];
				
				var region:Rectangle = new Rectangle();
				region.setTo(currentRegion.x, currentRegion.y, currentRegion.width, currentRegion.height);
				
				packedAtlas.createSubTexture(currentRegion.id, region, currentRegion.scaleX, currentRegion.scaleY);
			}
			
			maxRectPacker.clearData();
			
			return packedAtlas;
		}
		
		private function packRectangles():void 
		{
			var rectangles:Vector.<PackerRectangle> = new Vector.<PackerRectangle>;
			
			var atlas:BitmapTextureAtlas = swfDataParser.context.atlasDrawer.targetAtlas;
			
			for(var regionName:int in atlas.subTextures)
			{
				var subTexture:BitmapSubTexture = atlas.subTextures[regionName];
				var region:Rectangle = subTexture.bounds;
				var packerRect:PackerRectangle = PackerRectangle.get(0, 0, region.width + atlas.padding * 2, region.height + atlas.padding * 2, subTexture.id, atlas.atlasData, region.x - atlas.padding, region.y - atlas.padding);
				packerRect.scaleX = subTexture.transform.scaleX;
				packerRect.scaleY = subTexture.transform.scaleY;
				
				rectangles.push(packerRect);
			}
			
			maxRectPacker.clearData();
			maxRectPacker.packRectangles(rectangles, 0, 2);		
		}
		
		private function onSaveAnimation(e:Event):void 
		{
			
		}
		
		private function onOpenAnimation(e:Event):void 
		{
			
		}
		
		private function onOpenSWF(e:Event):void 
		{
			fileReference.browse([new FileFilter("swf file with animation", "*.swf", "*.swf")]);
		}
		
	}

}