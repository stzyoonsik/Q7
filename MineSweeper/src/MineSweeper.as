package
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import scene.Main;
	
	import server.UserDBMgr;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	import util.UserInfo;
	import util.type.PlatformType;
	
	[SWF(backgroundColor="#FFFFFF", frameRate="60")]  
	public class MineSweeper extends Sprite   
	{  
		public static const WIDTH:int = 480;  
		public static const HEIGHT:int = 800;  
		
		public function MineSweeper():void   
		{  			
			var viewPort:Rectangle = RectangleUtil.fit(new Rectangle(0, 0, WIDTH, HEIGHT), new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), ScaleMode.SHOW_ALL);  
			
			var starling:Starling = new Starling(Main, stage, viewPort);  
			starling.showStats = true;  
			
			starling.stage.stageWidth  = WIDTH;  
			starling.stage.stageHeight = HEIGHT;  
			
			starling.start();  
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, onDeactivated);
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, onActivated);
		}  
		
		private function onDeactivated(event:flash.events.Event):void   
		{  
			// make sure the app behaves well (or exits) when in background  
			//NativeApplication.nativeApplication.exit();  
			trace("deactive");
			if(PlatformType.current != "")
			{
				UserDBMgr.instance.updateData(UserInfo.id, "lastDate", new Date().getTime().toString());
				UserDBMgr.instance.updateData(UserInfo.id, "heartTime", UserInfo.remainHeartTime);
			}
			
			
			Starling.current.stop(true);
			NativeApplication.nativeApplication.executeInBackground = true;
		}  
		
		private function onActivated(event:flash.events.Event):void 
		{
			trace("active");
			Starling.current.start();
		}
		
	}  
}