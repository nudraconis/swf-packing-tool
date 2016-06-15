package events 
{
	import flash.events.Event;
	import swfdata.SymbolsLibrary;
	import swfdata.atlas.GenomeTextureAtlas;

	public class SceneEvent extends Event
	{
		public var library:SymbolsLibrary;
		public var atlas:GenomeTextureAtlas;
		
		public function SceneEvent(type:String, bubbling:Boolean = false, cancelable:Boolean = false, library:SymbolsLibrary = null, atlas:GenomeTextureAtlas = null) 
		{
			super(type, bubbles, cancelable);
			
			
			this.atlas = atlas;
			this.library = library;
		}
		
	}

}