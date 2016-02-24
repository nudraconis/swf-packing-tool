package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.sampler.getSize;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import swfdata.atlas.GenomeTextureAtlas;
	import swfdata.dataTags.SwfPackerTag;
	import swfDataExporter.SwfExporter;
	import swfparser.SwfParserLight;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TestImporting extends Sprite 
	{
		private var fileName:String = "testShapeCut.swf";
		private var fileContent:ByteArray;
		private var swfExporter:SwfExporter = new SwfExporter();
		private var testScene:TestScene;
		private var file:File;
		
		public function TestImporting() 
		{
			super();
			

			var t:Timer = new Timer(50, 1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, onStartParse);
			t.start();
		}
		
		private function onStartParse(e:Event):void 
		{
			//openAndLoadContent();
			browseContetn();
			
		}
		
		private function browseContetn():void 
		{
			file = new File("C://Users//k.klementyev//AppData//Local//Temp//swfpacker-cache//animation//actor//skin_summer/fruit_tree");//File.documentsDirectory.clone();
			
			file.browseForOpen("Select animation file", [new FileFilter("Packed animation file", "*.animation", "*.animation")]);
			file.addEventListener(Event.SELECT, onSelected);
		}
		
		private function onSelected(e:Event):void 
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			
			fileContent = new ByteArray();
			fileStream.readBytes(fileContent, 0, fileStream.bytesAvailable);
			fileStream.close();
			
			unpack();
		}
		
		private function unpack():void 
		{
			testScene = new TestScene();
			testScene.addEventListener(Event.COMPLETE, onGenomeReady);
			
			stage.addChild(testScene);
		}
		
		private function onGenomeReady(e:Event):void 
		{
			var swfParserLight:SwfParserLight = new SwfParserLight();
			var swfTags:Vector.<SwfPackerTag> = new Vector.<SwfPackerTag>;
			
			var genomeTextureAtlas:GenomeTextureAtlas = swfExporter.importSwfGenome("noname", fileContent, swfParserLight.context.shapeLibrary, swfTags);
			
			swfParserLight.context.library.addShapes(swfParserLight.context.shapeLibrary);
			swfParserLight.processDisplayObject(swfTags);
			
			
			testScene.show(swfParserLight.context.library, genomeTextureAtlas);
		}
		
		private function openAndLoadContent():void 
		{
			var file:File = File.documentsDirectory.resolvePath(fileName + ".animation");
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			
			fileContent = new ByteArray();
			fileStream.readBytes(fileContent, 0, fileStream.bytesAvailable);
			fileStream.close();
			
			unpack();
		}
	}
}