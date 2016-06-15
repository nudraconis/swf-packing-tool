package events 
{
	import external.fileSystem.VirtualFile;
	import flash.events.Event;
	
	public class FileSystemEvent extends Event
	{
		public static const FILE_LOADED:String = "fileLoaded";
		
		public var file:VirtualFile;
		
		public function FileSystemEvent(type:String, bubbles:Boolean, cancelable:Boolean, file:VirtualFile) 
		{
			super(type, bubbles, cancelable)
			
			this.file = file;
		}
		
		override public function clone():Event 
		{
			return new FileSystemEvent(type, bubbles, cancelable, file);
		}
	}
}