package external.cache 
{
	import external.fileSystem.VirtualFile;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import settings.GlobalSettings;
	
	public class PackedFilesCache 
	{
		private var fileStream:FileStream = new FileStream();
		
		private var basePath:String;
		
		public function PackedFilesCache(basePath:String) 
		{
			this.basePath = basePath;
			
		}
		
		public function isHaveCache():Boolean
		{
			return false;
		}
		
		public function createCache(file:VirtualFile, content:ByteArray):void
		{
			var relativePath:String = file.nativePath;
			relativePath = relativePath.substring(basePath.length, relativePath.length - file.extension.length) + ".animation";
			
			//PATH.ANIMATION_BASE_CACHE_DIRECTORY.openWithDefaultApplication();
			var nativeFile:File = GlobalSettings.ANIMATION_BASE_CACHE_DIRECTORY.resolvePath(relativePath);
			
			//if (!nativeFile.exists)
			//	nativeFile.createDirectory();
			
			fileStream.open(nativeFile, FileMode.WRITE);
			fileStream.writeBytes(content, 0, content.length);
			fileStream.close();
			//trace(nativeFile.nativePath);
			//trace('create cache ', content.length);
		}
		
		public function getCache(file:VirtualFile):ByteArray
		{
			return null;
		}
	}
}