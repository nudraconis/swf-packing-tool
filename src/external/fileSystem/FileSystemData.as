package external.fileSystem 
{
	/**
	 * ...
	 * @author ...
	 */
	public class FileSystemData 
	{
		public var totalFiles:int = 0;
		public var totalFilesList:Vector.<VirtualFile> = new Vector.<VirtualFile>();
		
		public var selectedFilesList:Vector.<FileSystemEntity> = new Vector.<FileSystemEntity>();
		
		public var filesTree:FilesTree = new FilesTree();
		
		public function FileSystemData() 
		{
			
		}
		
		public function clear():void 
		{
			totalFiles = 0;
			totalFilesList.length = 0;
			selectedFilesList.length = 0;
			filesTree.clear();
		}
		
	}

}