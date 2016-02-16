package 
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	public class WindowUtil 
	{
		
		public function WindowUtil() 
		{
			
		}

		public static function openWindowToReview(bitmapData:BitmapData, title:String = null):void
		{
			var nativeWindowOption:NativeWindowInitOptions = new NativeWindowInitOptions();
			nativeWindowOption.systemChrome = NativeWindowSystemChrome.STANDARD; 
			nativeWindowOption.type = NativeWindowType.UTILITY 
			nativeWindowOption.transparent = false; 
			nativeWindowOption.resizable = true; 
			nativeWindowOption.maximizable = true; 
			nativeWindowOption.owner = NativeApplication.nativeApplication.activeWindow;
			
			var nativeWindow:NativeWindow = new NativeWindow(nativeWindowOption);
			
			var bitmapView:Bitmap = new Bitmap(bitmapData);
			
			//if (bitmapView.width > nativeWindow.stage.fullScreenWidth)
			//	bitmapView.scaleX = nativeWindow.stage.fullScreenWidth / bitmapView.width;
			
			//if (bitmapView.height > nativeWindow.stage.fullScreenHeight)
			//	bitmapView.scaleY = nativeWindow.stage.fullScreenHeight / bitmapView.height;
			
			//bitmapView.scaleX = bitmapView.scaleY = 0.5;
			
			nativeWindow.stage.addChild(bitmapView);
			nativeWindow.stage.scaleMode = StageScaleMode.NO_SCALE;
			nativeWindow.stage.align = StageAlign.TOP_LEFT;
			nativeWindow.stage.color = 0xCCCCCC;
			nativeWindow.title = title;
			
			//var border:Sprite = new Sprite();
			//border.graphics.lineStyle(5, 0x0);
			//border.graphics.drawRect(0, 0, bitmapView.width, bitmapView.height);
			//nativeWindow.stage.addChild(border);
			
			
			
			
			
			nativeWindow.width = bitmapView.width + 20;
			nativeWindow.height = bitmapView.height + 20;
			
			nativeWindow.activate();
			NativeApplication.nativeApplication.activate(nativeWindow);
		}
	}

}