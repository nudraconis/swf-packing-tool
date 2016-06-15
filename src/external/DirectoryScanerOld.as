package external 
{
	import external.fileSystem.DirectoryScaner;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	
	[Event(name="complete", type="flash.events.Event")]
	public class DirectoryScaner extends EventDispatcher
	{
		public var totalFilesList:Vector.<File> = new Vector.<File>();
		
		public var totalFiles:int = 0;
		
		private var currentDirectory:File;
		private var directoryListingInProcess:Boolean = false;
		
		private var scanQueue:Vector.<File> = new Vector.<File>;
		public var scanQueueLength:int = 0;
		private var ignoreListFiles:Object;
		private var ignoreListFloder:Object;
		
		
		public function DirectoryScaner() 
		{
			
		}
		
		public function scan(file:File):void
		{
			var extension:String = file.extension;
			
			if (extension == null)
			{	
				scanDirectory(file);
			}
			else
			{
				scanFile(file);
			}
		}
		
		private function scanDirectory(directory:File):void 
		{
			if (directoryListingInProcess)
			{
				scanQueue[scanQueueLength++] = directory;
				return;
			}
				
			directoryListingInProcess = true;
			
			currentDirectory = directory;
			currentDirectory.getDirectoryListingAsync();
			currentDirectory.addEventListener(FileListEvent.DIRECTORY_LISTING, onDirectoryListing);
		}
		
		private function onDirectoryListing(e:FileListEvent):void 
		{
			var directoryContent:Array = e.files;
			
			var length:int = directoryContent.length;
			for (var i:int = 0; i < length; i++)
			{
				scan(directoryContent[i]);
			}
			
			directoryListingInProcess = false;
			
			if (scanQueueLength > 0)
				scan(scanQueue[--scanQueueLength]);
			else
				dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function scanFile(file:File):void 
		{
			totalFilesList.push(file);
		}
	}
}