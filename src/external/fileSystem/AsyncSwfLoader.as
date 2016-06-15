package external.fileSystem 
{
	import events.SwfExporterScope;
	import external.fileSystem.task.LoadSwfFileTask;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	public class AsyncSwfLoader extends EventDispatcher
	{
		public static const MAX_QUOTE:int = 100;//system resources limit
		
		public var queue:Vector.<FileSystemEntity> = new Vector.<FileSystemEntity>;
		private var loadingTasksPool:Vector.<LoadSwfFileTask>
		
		private var loadingQuote:int;
		public var currentlyLoadingNumber:int = 0;
		private var isPaused:Boolean = false;
		
		public var lastLoadedTask:LoadSwfFileTask;
		
		private var totalLoadNumber:int = 0;
		private var totalLoadedNumer:int = 0;
		
		public function AsyncSwfLoader(loadingQuote:int = 3) 
		{
			if (loadingQuote > MAX_QUOTE)
				loadingQuote = MAX_QUOTE;
				
			this.loadingQuote = loadingQuote;
			
			loadingTasksPool = new Vector.<LoadSwfFileTask>();
			
			for (var i:int = 0; i < loadingQuote; i++)
			{
				var currentTask:LoadSwfFileTask = new LoadSwfFileTask();
				currentTask.addEventListener(Event.COMPLETE, onCurrentLoadComplete);
				loadingTasksPool.push(currentTask);
			}
		}
		
		public function loadFile(file:VirtualFile):void
		{
			queue.push(file);
			totalLoadNumber++;
			
			loadNext();
		}
		
		public function loadFiles(filesList:Vector.<FileSystemEntity>):void
		{
			queue = filesList.slice();
			totalLoadNumber = queue.length;
			
			loadNext();
		}
	
		public function loadFileContent(file:VirtualFile):void
		{
			queue.push(file);
			totalLoadNumber++;
			
			loadNext();
		}
		
		public function unpause():void 
		{
			isPaused = false;
			loadNext();
		}
		
		public function pause():void 
		{
			isPaused = true;
		}
		
		private function loadNext():void 
		{
			//print('load next', isPaused.toString(), currentlyLoadingNumber, loadingQuote, queue.length)
			
			if (isPaused)
				return;
				
			if (currentlyLoadingNumber == loadingQuote)
			{
				return;
			}
				
			if (queue.length == 0)
			{
				if(currentlyLoadingNumber == 0)
					complete();
					
				return;
			}
				
			currentlyLoadingNumber++;
			
			var currentTask:LoadSwfFileTask = loadingTasksPool.shift();
			currentTask.file = queue.pop() as VirtualFile;
			
			currentTask.execute();
			
			if (queue.length > 0)
				loadNext();
		}
		
		private function complete():void 
		{
			print('load complete');
			totalLoadedNumer = 0
			totalLoadNumber = 0;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onCurrentLoadComplete(e:Event):void 
		{
			//print('current load complete');
			
			var currentTask:LoadSwfFileTask = e.target as LoadSwfFileTask;
			currentlyLoadingNumber--;
			totalLoadedNumer++;
			
			lastLoadedTask = currentTask;
			//trace("#######", totalLoadNumber, totalLoadedNumer);
			SwfExporterScope.LOAD_PROGRESS.bytesLoaded = totalLoadedNumer;
			SwfExporterScope.LOAD_PROGRESS.bytesTotal = totalLoadNumber;
			
			broadcast(SwfExporterScope, SwfExporterScope.LOAD_PROGRESS);
			
			loadingTasksPool.push(currentTask);
			loadNext();
		}
	}
}