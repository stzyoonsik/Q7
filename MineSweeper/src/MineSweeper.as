package
{
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import starling.core.Starling;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import starling.events.Event;
	import scene.Main;
	
	[SWF(backgroundColor="#AAAAAA", frameRate="60")]  
	public class MineSweeper extends Sprite   
	{  
		public static const WIDTH:int = 320;  
		public static const HEIGHT:int = 480;  
		
		public function MineSweeper():void   
		{  
			stage.quality = StageQuality.LOW;  
			
			// touch or gesture?  
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;  
			
			// entry point  
			//Starling.handleLostContext = true;  
			var viewPort:Rectangle = RectangleUtil.fit(new Rectangle(0, 0, WIDTH, HEIGHT), new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), ScaleMode.SHOW_ALL);  
			
			Starling.multitouchEnabled = true;  
			var starling:Starling = new Starling(Main, stage, viewPort);  
			starling.antiAliasing = 0;  
			starling.showStats = true;  
			starling.enableErrorChecking = false;  
			starling.simulateMultitouch = false;  
			
			starling.stage.stageWidth  = WIDTH;  
			starling.stage.stageHeight = HEIGHT;  
			
			starling.start();  
		}  
		
		private function deactivate(e:Event):void   
		{  
			// make sure the app behaves well (or exits) when in background  
			//NativeApplication.nativeApplication.exit();  
		}  
		
	}  
}