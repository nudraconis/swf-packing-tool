package external.fileSystem 
{
	import events.FileSystemScope;
	import external.cache.FilesListCache;
	import external.fileSystem.DirectoryScaner;
	import external.FileLists;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import settings.GlobalSettings;
	
	[Event(name="complete", type="flash.events.Event")]
	public class FileSystemController extends EventDispatcher
	{
		private var filesCache:FilesListCache;
		public var directoryScaner:DirectoryScaner;
		
		private var fileSystemData:FileSystemData;
		
		public function FileSystemController(fileSystemData:FileSystemData)
		{
			this.fileSystemData = fileSystemData;
			filesCache = new FilesListCache(fileSystemData);
			directoryScaner = new DirectoryScaner(fileSystemData, FileLists.ignoreListDirectories, FileLists.ignoreList);
			directoryScaner.addEventListener(Event.COMPLETE, onFilesScanComplete);
		}
		
		public function cleanCache():void
		{
			filesCache.clear();
		}
		
		private function onFilesScanComplete(e:Event):void
		{
			filesCache.saveCasheTo();
			
			broadcast(FileSystemScope, FileSystemScope.SCAN_COMPLETE);
		}
		
		public function getFilesListing(cleanCache:Boolean = false):void
		{
			print("- get files listing -");
			
			var isFilesInCache:Boolean;
			
			if (!cleanCache)
			{
				print("try to get files from cache");
				isFilesInCache = filesCache.restoreCasheFrom();
				
				if (!isFilesInCache)
					fileSystemData.clear();
			}
			
			if (isFilesInCache && !cleanCache)
			{
				fileSystemData.filesTree.buildTree();
				
				broadcast(FileSystemScope, FileSystemScope.SCAN_COMPLETE);
			}
			else
			{
				directoryScaner.scan(new File(GlobalSettings.FILES_PATH));
			}
		}
	}
}