package external.fileSystem 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import settings.GlobalSettings;
	
	[Event(name="complete", type="flash.events.Event")]
	public class DirectoryScaner extends EventDispatcher
	{
		private var currentVirtualDirectory:VirtualDirectory;
		
		private var currentDirectory:File;
		private var directoryListingInProcess:Boolean = false;
		
		private var scanQueue:Vector.<File> = new Vector.<File>;
		public var scanQueueLength:int = 0;
		
		private var ignoreListFiles:Object;
		private var ignoreListDirectories:Object;
		
		private var fileSystemData:FileSystemData;
		private var filesTree:FilesTree;
		
		public var scanFilesExtensionFilter:Object = { "swf":"swf" };
		
		public function DirectoryScaner(fileSystemData:FileSystemData, ignoreListDirectories:Object, ignoreListFiles:Object) 
		{
			this.filesTree = fileSystemData.filesTree;
			this.fileSystemData = fileSystemData;
			this.ignoreListDirectories = ignoreListDirectories;
			this.ignoreListFiles = ignoreListFiles;
		}
		
		public function scan(file:File):void
		{
			var name:String = file.name;
			var extension:String = file.extension;
			
			if (extension == null)
			{
				if (ignoreListDirectories[name] != null)
					return;
					
				scanDirectory(file);
			}
			else
			{
				if (ignoreListFiles[name] != null)
					return;
					
				if (scanFilesExtensionFilter[extension] == null)
					return;
					
				scanFile(VirtualFile.fromFile(file));
			}
		}
		
		private static function getParentPath(path:String):String
		{
			var lastSlashIndex:int = path.lastIndexOf('\\');
			
			return path.substring(0, lastSlashIndex);
		}
		
		private static function getParentName(path:String):String
		{
			var lastSlashIndex:int = path.lastIndexOf('\\');
			
			path = path.substr(0, lastSlashIndex);
			
			lastSlashIndex = path.lastIndexOf('\\');
			
			return path.substr(lastSlashIndex + 1);
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
			
			var nativePath:String = directory.nativePath;
			var name:String = directory.name;
			
			var currentVirtualDirectory:VirtualDirectory = filesTree.makeOrGetDirectory(currentDirectory.name, nativePath);
			var parentVirtualDirectory:VirtualDirectory = filesTree.makeOrGetDirectory(getParentName(nativePath), getParentPath(nativePath));
			
			
			if (!filesTree.root)
				filesTree.root = currentVirtualDirectory;
			
			parentVirtualDirectory.addDirectory(currentVirtualDirectory);
			
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
			{
				//trace(filesTree);
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function scanFile(file:VirtualFile):void 
		{
			var packedFile:File = getFilePackedVersion(file);
			
			if (packedFile && packedFile.exists)
			{
					
				file.isOutDate = FileOutdateCheck.check(packedFile.modificationDate.getTime(), file.modificationDate);
				file.isHavePackedCopy = true;
			}
				
			var parentVirtualDirectory:VirtualDirectory = filesTree.getDirectory(getParentPath(file.nativePath));
			parentVirtualDirectory.addFile(file);
			
			//var pngfile:File = new File(file.nativePath.substring(0, file.nativePath.length - 3) + "animation");
			
			//if (pngfile.exists)
			//{
			//	pngfile.deleteFileAsync();
			//}
				
			fileSystemData.totalFilesList.push(file);
			fileSystemData.totalFiles++
		}
		
		private function getFilePackedVersion(currentFile:VirtualFile):File 
		{
			var relativePath:String = currentFile.nativePath;
			relativePath = relativePath.substring(GlobalSettings.FILES_PATH.length, relativePath.length - currentFile.extension.length) + ".animation";
			relativePath = relativePath.split("\\").join("/");
			var cacheFile:File = GlobalSettings.ANIMATION_BASE_CACHE_DIRECTORY.resolvePath(relativePath);
			
			return cacheFile;
		}
	}
}