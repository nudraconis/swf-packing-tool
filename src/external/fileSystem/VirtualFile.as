package external.fileSystem 
{
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	public class VirtualFile extends FileSystemEntity
	{
		private static const DOT:String = ".";
		
		public var pureName:String;
		public var extension:String;
		public var modificationDate:Number;
		
		public var content:ByteArray;
		
		public var isOutDate:Boolean = false;
		public var isHavePackedCopy:Boolean = false;
		
		public function VirtualFile() 
		{
			
		}
		
		public static function fromFile(file:File):VirtualFile
		{
			var virtualFile:VirtualFile = new VirtualFile();
			virtualFile.fillFromFile(file);
			
			return virtualFile;
		}
		
		public function fillFromFile(file:File, withContent:Boolean = false):void
		{
			name = file.name;
			pureName = name.substring(0, name.lastIndexOf(DOT));
			extension = name.substr(name.lastIndexOf(DOT));
			nativePath = file.nativePath;
			
			modificationDate = file.modificationDate.getTime();
		}
		
		public function fromByteArray(from:ByteArray):void 
		{
			name = from.readUTF();
			pureName = name.substring(0, name.lastIndexOf(DOT));
			extension = from.readUTF();
			nativePath = from.readUTF();
			modificationDate = from.readDouble();
		}
		
		public function toByteArray(out:ByteArray):ByteArray
		{
			out.writeUTF(name);
			out.writeUTF(extension);
			out.writeUTF(nativePath);
			out.writeDouble(modificationDate);
			
			return out;
		}
	}
}