package external.fileSystem.task 
{
	import external.fileSystem.VirtualFile;
	import flash.events.Event;
	import flash.filesystem.File;
	import task.Task;
	
	public class GetModifiedDataTask extends Task 
	{
		private var virtualFile:VirtualFile;
		private var file:File;
		
		public function GetModifiedDataTask(virtualFile:VirtualFile, file:File) 
		{
			this.file = file;
			this.virtualFile = virtualFile;
		}
	
		override public function execute():void 
		{
			virtualFile.modificationDate = file.modificationDate.getTime();
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}