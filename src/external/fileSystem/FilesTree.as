package external.fileSystem 
{
	public class FilesTree 
	{
		private var directoriesToPathMap:Object = { };
		
		public var root:VirtualDirectory;
		
		public function FilesTree() 
		{
			
		}
		
		public function clear():void
		{
			directoriesToPathMap = {};
			root = null;
		}
		
		public function buildTree():void 
		{
			var path:String;
			var minPathValue:int = int.MAX_VALUE;
			var minPath:String = "";
			
			for (path in directoriesToPathMap)
			{
				var currentPathValue:int = path.split("\\").length;
				
				if (currentPathValue < minPathValue)
				{
					minPathValue = currentPathValue;
					minPath = path;
				}
			}
			
			root = getDirectory(minPath);
			
			for (path in directoriesToPathMap)
			{
				if (path == root.nativePath)
					continue;
				
				var currentDir:VirtualDirectory = makeOrGetDirectory(path, path);
				
				if (currentDir.parent)
					continue;
				
				var parent:VirtualDirectory = makeOrGetDirectory(getParentName(path), getParentPath(path));
				parent.addDirectory(currentDir);
				
				while (parent != root)
				{
					currentDir = parent;
					path = currentDir.nativePath;
					parent = makeOrGetDirectory(getParentName(path), getParentPath(path));	
					parent.addDirectory(currentDir);
				}
			}
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
		
		public function makeOrGetDirectory(name:String, path:String):VirtualDirectory
		{
			var currentDirectory:VirtualDirectory = directoriesToPathMap[path];
			
			if (!currentDirectory)
			{
				currentDirectory = new VirtualDirectory(name, path);
				directoriesToPathMap[path] = currentDirectory;
			}
			
			return currentDirectory;
		}
		
		public function getDirectory(path:String):VirtualDirectory
		{
			return directoriesToPathMap[path];;
		}
		
		public function putDirectory(directory:VirtualDirectory):void
		{
			directoriesToPathMap[directory.nativePath] = directory;
		}
		
		private var tabs:String = "\t-\t-\t-\t-\t-\t-\t-\t-\t-\t-\t-\t-\t-";
		private var data:String;
		
		public function toString():String 
		{
			data = "";
			makeDirectoryDataString(root, 0)
			
			return "[FilesTree root=" + data + "\n]";
		}

		
		private function makeDirectoryDataString(directory:VirtualDirectory, level:int):void
		{
			data += "\n";
			var tab:String = tabs.substr(0, level * 3);
			
			data += tab;
			
			data += directory.name;
			
			for (var i:int = 0; i < directory.directoryListing.length; i++)
			{
				makeDirectoryDataString(directory.directoryListing[i], level + 1);
			}
		}
	}
}