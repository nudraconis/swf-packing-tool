package external.fileSystem 
{
	//import flash.filesystem.File;
	public class FileSystemEntity 
	{
		public var name:String;
		public var nativePath:String;
		public var parent:VirtualDirectory;
		
		public var selected:Boolean = false;
		
		public function FileSystemEntity() 
		{
			
		}
		
		public function toString():String 
		{
			return "[FileSystemEntity name=" + name + " nativePath=" + nativePath + "]";
		}
		//public function openWithApplication():void 
		//{
		//	var file:File = new File(nativePath);
		//	file.openWithDefaultApplication();
		//}
	}
}