package external.cache 
{
	import external.fileSystem.FilesTree;
	import external.fileSystem.FileSystemData;
	import external.fileSystem.VirtualDirectory;
	import external.fileSystem.VirtualFile;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import settings.GlobalSettings;
	
	public class FilesListCache 
	{
		
		static public const FILE_CACHE_TAG:String = "FILECACHE";
		static public const VERSION:int = 1;
		
		private var swfsList:Vector.<VirtualFile>;
		private var fileTree:FilesTree;
		private var fileSystemData:FileSystemData;
		
		public function FilesListCache(fileSystemData:FileSystemData) 
		{
			this.fileSystemData = fileSystemData;
		}
		
		public function clear():void 
		{
			var path:String = GlobalSettings.BASE_CACHE_DIRECTORY.nativePath + "/" + GlobalSettings.CACHE_PATH;
			new File(path).deleteFile();
		}
		
		public function saveCasheTo():void
		{
			var pathToSave:String = GlobalSettings.BASE_CACHE_DIRECTORY.nativePath + "/" + GlobalSettings.CACHE_PATH;
			
			swfsList = fileSystemData.totalFilesList;
			fileTree = fileSystemData.filesTree;
			
			print('save files to cache', pathToSave);
			print('cache version', VERSION);
			var file:File = File.cacheDirectory.resolvePath(pathToSave);
			
			var fileStream:FileStream = new FileStream();
			
			//file.openWithDefaultApplication();
			
			var fileContent:ByteArray = new ByteArray();
			
			fileContent.writeUTF(FILE_CACHE_TAG);
			fileContent.writeInt(VERSION);
			
			saveCache(fileContent);
			
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeBytes(fileContent, 0, fileContent.bytesAvailable);
			trace("save files to cache completed");
		}
		
		private function saveCache(fileContent:ByteArray):void 
		{
			var length:Number = swfsList.length;
			
			fileContent.writeInt(length);
			for (var i:int = 0; i < length; i++)
			{
				saveFile(swfsList[i], fileContent);
			}
		}
		
		private function saveFile(virtualFile:VirtualFile, fileContent:ByteArray):void 
		{
			virtualFile.toByteArray(fileContent);
		}
		
		public function restoreCasheFrom():Boolean
		{
			var pathToRestore:String = GlobalSettings.BASE_CACHE_DIRECTORY.nativePath + "/" + GlobalSettings.CACHE_PATH;
			
			var file:File = File.cacheDirectory.resolvePath(pathToRestore);
			
			if (!file.exists)
				return false;
				
			if (file.size == 0)
				return false;
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			
			var fileContent:ByteArray = new ByteArray();
			fileStream.readBytes(fileContent, 0, fileStream.bytesAvailable);
			fileStream.close();
			
			var tag:String = fileContent.readUTF();
			if (tag != FILE_CACHE_TAG)
				return false;
			
			var version:int = fileContent.readInt();
			if (version != VERSION)
				return false;
				
			swfsList = fileSystemData.totalFilesList;
			fileTree = fileSystemData.filesTree;
			
			restoreCashe(fileContent);
			
			return true;
		}
		
		public function restoreCashe(byteArray:ByteArray):void
		{
			var filesCount:int = byteArray.readInt();
			fileSystemData.totalFiles = filesCount;
			
			for (var i:int = 0; i < filesCount; i++)
			{
				swfsList.push(restoreFile(byteArray));
			}
		}
		
		public function restoreFile(from:ByteArray):VirtualFile
		{
			var virtualFile:VirtualFile = new VirtualFile();
			virtualFile.fromByteArray(from);
			
			var packedFile:File = getFilePackedVersion(virtualFile);
			
			if (packedFile && packedFile.exists)
			{
				virtualFile.isOutDate = FileOutdateCheck.check(virtualFile.modificationDate, packedFile.modificationDate.getTime());
				virtualFile.isHavePackedCopy = true;
			}
			
			var fileParent:VirtualDirectory = fileTree.makeOrGetDirectory(getParentName(virtualFile.nativePath), getParentPath(virtualFile.nativePath));
			fileParent.addFile(virtualFile);
			
			return virtualFile;
		}
		
		private function getFilePackedVersion(currentFile:VirtualFile):File 
		{
			var relativePath:String = currentFile.nativePath;
			relativePath = relativePath.substring(GlobalSettings.FILES_PATH.length, relativePath.length - currentFile.extension.length) + ".animation";
			relativePath = relativePath.split("\\").join("/");
			var cacheFile:File = GlobalSettings.ANIMATION_BASE_CACHE_DIRECTORY.resolvePath(relativePath);
			
			return cacheFile;
		}
		
		private static function getParentPath(path:String):String
		{
			var lastSlashIndex:int = path.lastIndexOf("\\");
			
			return path.substring(0, lastSlashIndex);
		}
		
		private static function getParentName(path:String):String
		{
			var lastSlashIndex:int = path.lastIndexOf('\\');
			
			path = path.substr(0, lastSlashIndex);
			
			lastSlashIndex = path.lastIndexOf('\\');
			
			return path.substr(lastSlashIndex + 1);
		}
	}
}