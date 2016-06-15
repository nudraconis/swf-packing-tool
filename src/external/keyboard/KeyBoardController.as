package external.keyboard
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;

	public class KeyBoardController
	{
		private var keyDownListeners:KeyboardListenersList;
		private var keyUpListeners:KeyboardListenersList;

		private var passedKeys:Object;
		private var preventedKeys:Object;
		
		private var instance:Sprite;

		public function KeyBoardController(instance:Sprite)
		{
			this.instance = instance;
			
			instance.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			instance.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			initilize();
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			instance.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			instance.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			instance.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			instance.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		public function isKeysDown():Boolean
		{
			for each(var i:int in passedKeys)
				return true;
				
			return false
		}

		public function isKeyDown(code:uint):Boolean
		{
			return passedKeys[code] != null;
		}

		private function initilize():void
		{
			passedKeys = { };
			preventedKeys = { };
			
			keyDownListeners = new KeyboardListenersList();
			keyUpListeners = new KeyboardListenersList();
		}

		public function destroy():void
		{
			if (instance.stage)
			{
				instance.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				instance.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			}
			
			instance.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			instance.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function prevent(e:KeyboardEvent):void
		{
			if(e.keyCode.toString() in preventedKeys)
				e.preventDefault();
		}

		private function onKeyUp(e:KeyboardEvent):void
		{
			var code:uint = e.keyCode;

			delete passedKeys[code];

			prevent(e);
			
			var listeners:Dictionary = keyUpListeners.getListenersList(code);
			
			if (listeners)
			{
				for each(var listener:Function in listeners)
					listener();
			}
		}

		private function onKeyDown(e:KeyboardEvent):void
		{
			var code:uint = e.keyCode;
			prevent(e);

			if (passedKeys[code])
				return;
			else
			{
				passedKeys[code] = 1;
				
				var listeners:Dictionary = keyDownListeners.getListenersList(code);
			
				if (listeners)
				{
					for each(var listener:Function in listeners)
						listener();
				}
			}
		}
		
		public function registerPreventKey(key:uint):void
		{
			preventedKeys[key] = 1;
		}
		
		public function unregisterPreventKey(key:uint):void
		{
			if (preventedKeys[key] != null)
				delete preventedKeys[key];
		}

		public function registerKeyDownReaction(key:uint, reaction:Function):void
		{
			keyDownListeners.registerListener(key, reaction);
		}
		
		public function unregisterKeyDownReaction(key:uint, reaction:Function):void
		{
			keyDownListeners.unregisterListener(key, reaction);
		}

		public function registerKeyUpReaction(key:uint, reaction:Function):void
		{
			keyUpListeners.registerListener(key, reaction);
		}
		
		public function unregiterKeyUpReaction(key:uint, reaction:Function):void
		{
			keyUpListeners.unregisterListener(key, reaction);
		}

	}

}