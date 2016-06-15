package external.fileSystem 
{
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	public class VirtualDirectory extends FileSystemEntity
	{
		
		
		private var _filesListing:Vector.<VirtualFile> = new Vector.<VirtualFile>();
		private var _directoryListing:Vector.<VirtualDirectory> = new Vector.<VirtualDirectory>();
		
		public function VirtualDirectory(name:String = null, nativePath:String = null) 
		{
			this.name = name;
			this.nativePath = nativePath;
		}
		
		public static function fromFile(file:File):VirtualDirectory
		{
			var directory:VirtualDirectory = new VirtualDirectory();
			directory.fillFromFile(file);
			
			return directory;
		}
		
		public function fillFromFile(file:File):void
		{
			this.name = file.name;
			this.nativePath = file.nativePath;
		}
		
		public function fromByteArray(from:ByteArray):void 
		{
			name = from.readUTF();
			nativePath = from.readUTF();
		}
		
		public function toByteArray(out:ByteArray):ByteArray
		{
			out.writeUTF(name);
			out.writeUTF(nativePath);
			
			return out;
		}
		
		public function addFile(file:VirtualFile):void
		{
			file.parent = this;
			_filesListing.push(file);
		}
		
		public function addDirectory(currentDirectory:VirtualDirectory):void 
		{
			if (currentDirectory.parent == this)
				return;
				
			currentDirectory.parent = this;
			directoryListing.push(currentDirectory);
		}
		
		public function get filesListing():Vector.<VirtualFile> 
		{
			return _filesListing;
		}
		
		public function get directoryListing():Vector.<VirtualDirectory> 
		{
			return _directoryListing;
		}
	}
}