package external.fileSystem.task 
{
	import external.fileSystem.VirtualFile;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import task.Task;
	
	public class LoadSwfFileTask extends Task 
	{
		private var isFileRead:Boolean = false;
		private var isFileLoaded:Boolean = false;
		private var isFileLoadCall:Boolean = false;
		
		private var fileStream:FileStream = new FileStream();
		
		//public var loader:Loader;
		public var file:VirtualFile;
		//public var content:DisplayObject;
		
		public function LoadSwfFileTask( file:VirtualFile = null) 
		{
			this.file = file;
			
			//if (loader == null)
			//	loader = new Loader();
				
			//this.loader = loader;
				
			initialize();
		}
		
		public function get hasCompleteEvent():Boolean
		{
			return true;//loader.contentLoaderInfo.hasEventListener(Event.COMPLETE);
		}
		
		private function initialize():void 
		{
			//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			fileStream.addEventListener(Event.COMPLETE, onFileOpen)
		}
		
		private function onLoadComplete(e:Event = null):void 
		{
			//content = loader;
			
			isFileLoaded = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onFileOpen(e:Event):void 
		{
			var fileByteContent:ByteArray = new ByteArray();
			fileStream.readBytes(fileByteContent, 0, fileByteContent.bytesAvailable);
			fileStream.close();
			
			file.content = fileByteContent;
			
			isFileRead = true;
			
			//var context:LoaderContext = new LoaderContext(false);
			//context.allowCodeImport = true;
			//loader.loadBytes(fileByteContent, context);
			
			isFileLoadCall = true;
			
			onLoadComplete();
		}
		
		override public function execute():void 
		{
			isFileRead = false;
			isFileLoadCall = false;
			isFileLoaded = false;
			
			var nativeFile:File = new File(file.nativePath);
			fileStream.openAsync(nativeFile, FileMode.READ);
		}
	}
}