package util.manager
{
	
	import com.yoonsik.FacebookExtension;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	
	import loading.CircleLoading;
	
	import server.UserDBMgr;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	
	import util.EtcExtensions;
	import util.UserInfo;
	import util.type.PlatformType;

	public class FacebookExtensionMgr extends EventDispatcher
	{
		//싱글톤
		private static var _instance:FacebookExtensionMgr;
		private static var _isConstructing:Boolean;
		
		public function FacebookExtensionMgr()
		{
			if (!_isConstructing) throw new Error("Singleton, use FacebookExtensionMgr.instance()");
			
		}
		
		public static function get instance():FacebookExtensionMgr 
		{
			if (_instance == null)  
			{
				_isConstructing = true;
				_instance = new FacebookExtensionMgr();
				_isConstructing = false;
			}
			return _instance;
		}	
		
		
		CONFIG::device 
		{
			private var _fb:FacebookExtension = new FacebookExtension();
			private var _circleLoading:CircleLoading 
		}	
		
		
		
		public function logIn():void
		{
			CONFIG::device
			{
				_fb.logIn();
				_fb.addEventListener("getObject", onGetObject);
			}
		}
		
		
		private function onGetObject(event:StatusEvent):void
		{
			dispatchEvent(new Event("startLoading"));
			
			var data:Object = JSON.parse(event.level);
			UserInfo.id = data.id;
			UserInfo.name = data.name;
			
			var urlRequest:URLRequest = new URLRequest("https://graph.facebook.com/"+UserInfo.id+"/picture?type=large");
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onLoadImageComplete);
			loader.load(urlRequest);
			
			//체크 하고 인서트
			UserDBMgr.instance.checkData(UserInfo.id);
			UserDBMgr.instance.addEventListener("checkData", onCheckDataComplete);
			
		}
		
		
		private function onLoadImageComplete(event:flash.events.Event):void
		{
			var bitmap:Bitmap = event.currentTarget.loader.content as Bitmap;
			var texture:Texture = Texture.fromBitmap(bitmap);
			
			UserInfo.picture = texture;
			
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(flash.events.Event.COMPLETE, onLoadImageComplete);
			
			checkDone();
		}
		
		private function onCheckDataComplete(event:Event):void
		{
			trace("event.data = " + event.data);
			UserDBMgr.instance.removeEventListener("checkData", onCheckDataComplete);
			if(int(event.data) == 0)
			{
				UserDBMgr.instance.insertUser(UserInfo.id, UserInfo.name);
				UserDBMgr.instance.addEventListener("insertUser", onInsertUserComplete);				
			}
			else
			{
				UserDBMgr.instance.selectData(UserInfo.id, "heart");
				UserDBMgr.instance.addEventListener("selectData", onSelectDataComplete);
				
			}
		}
		
		private function onInsertUserComplete(event:Event):void
		{
			UserDBMgr.instance.removeEventListener("insertUser", onInsertUserComplete);
			trace("[TITLE] insert user is done");
			UserDBMgr.instance.updateData(UserInfo.id, "heart", 5);
			UserDBMgr.instance.updateData(UserInfo.id, "heartTime", 300);
			UserDBMgr.instance.updateData(UserInfo.id, "level", 1);
			UserDBMgr.instance.updateData(UserInfo.id, "exp", 0);
			UserDBMgr.instance.updateData(UserInfo.id, "expRatio", 1);
			UserDBMgr.instance.updateData(UserInfo.id, "coin", 1000);
			UserDBMgr.instance.updateData(UserInfo.id, "lastDate", new Date().getTime().toString());
			
			UserInfo.heart = 5;
			UserInfo.remainHeartTime = 300;
			UserInfo.level = 1;
			UserInfo.exp = 0;
			UserInfo.expRatio = 1;
			UserInfo.coin = 1000;
			UserInfo.lastDate = new Date().getTime();
			
			
			checkDone();
		}
	
		
		private function onSelectDataComplete(event:Event):void
		{
			UserDBMgr.instance.removeEventListener("selectData", onSelectDataComplete);
			
			if(UserInfo.heart == -1)
			{
				UserInfo.heart = int(event.data);				
				
				UserDBMgr.instance.selectData(UserInfo.id, "level");
				UserDBMgr.instance.addEventListener("selectData", onSelectDataComplete);
			}
				
			else if(UserInfo.level == -1)
			{
				UserInfo.level = int(event.data);				
				
				UserDBMgr.instance.selectData(UserInfo.id, "exp");
				UserDBMgr.instance.addEventListener("selectData", onSelectDataComplete);
			}
				
			else if(UserInfo.exp == -1)
			{
				UserInfo.exp = int(event.data);	
				
				UserDBMgr.instance.selectData(UserInfo.id, "expRatio");
				UserDBMgr.instance.addEventListener("selectData", onSelectDataComplete);
			}
			
			else if(UserInfo.expRatio == -1)
			{
				UserInfo.expRatio = int(event.data);	
				
				UserDBMgr.instance.selectData(UserInfo.id, "lastDate");
				UserDBMgr.instance.addEventListener("selectData", onSelectDataComplete);
			}
			
			else if(UserInfo.lastDate == -1)
			{
				UserInfo.lastDate = Number(event.data);	
				
				UserDBMgr.instance.selectData(UserInfo.id, "coin");
				UserDBMgr.instance.addEventListener("selectData", onSelectDataComplete);
			}
				
			else if(UserInfo.coin == -1)
			{
				UserInfo.coin = int(event.data);	
				
				UserDBMgr.instance.selectData(UserInfo.id, "heartTime");
				UserDBMgr.instance.addEventListener("selectData", onSelectDataComplete);
			}
				
			else if(UserInfo.remainHeartTime == -1)
			{
				UserInfo.remainHeartTime = int(event.data);	
				
			}
			trace(UserInfo.id, UserInfo.name, UserInfo.heart, UserInfo.remainHeartTime, UserInfo.level, UserInfo.exp, UserInfo.expRatio, UserInfo.coin);
			checkDone();
		}
		
		
		private function checkDone():void
		{
			trace(UserInfo.id, UserInfo.name, UserInfo.lastDate, UserInfo.heart, UserInfo.remainHeartTime, UserInfo.level, UserInfo.exp, UserInfo.coin);
			
			if(UserInfo.id != null && UserInfo.name != null && UserInfo.lastDate != -1 && UserInfo.picture != null && UserInfo.heart != -1 
				&& UserInfo.level != -1 && UserInfo.exp != -1 && UserInfo.expRatio != -1 && UserInfo.remainHeartTime != -1 && UserInfo.coin != -1)
			{
				PlatformType.current = PlatformType.FACEBOOK;
				EtcExtensions.alert(UserInfo.name + " 님 환영합니다!");
				
				dispatchEvent(new Event("checkDone"));
			}
		}
	}
}