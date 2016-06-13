package util.manager
{
	
	import com.yoonsik.FacebookExtension;
	
	import flash.events.StatusEvent;
	
	import server.UserDBMgr;
	
	import starling.animation.Transitions;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	import util.EtcExtensions;
	import util.UserInfo;
	import util.type.PlatformType;
	import util.type.SceneType;

	public class FacebookExtensionManager extends EventDispatcher
	{
		CONFIG::device 
		{
			private var _fb:FacebookExtension = new FacebookExtension();
		}	
		
		public function FacebookExtensionManager()
		{
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
			
			var data:Object = JSON.parse(event.level);
			UserInfo.id = data.id;
			UserInfo.name = data.name;
			
			//체크 하고 인서트
			UserDBMgr.instance.checkData(UserInfo.id);
			UserDBMgr.instance.addEventListener("checkData", onCheckDataComplete);
			
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
			UserDBMgr.instance.updateData(UserInfo.id, "coin", 1000);
			UserDBMgr.instance.updateData(UserInfo.id, "lastDate", new Date().getTime().toString());
			
			UserInfo.heart = 5;
			UserInfo.remainHeartTime = 300;
			UserInfo.level = 1;
			UserInfo.exp = 0;
			UserInfo.coin = 1000;
			
			
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
			trace(UserInfo.id, UserInfo.name, UserInfo.heart, UserInfo.remainHeartTime, UserInfo.level, UserInfo.exp, UserInfo.coin);
			checkDone();
		}
		
		//		private function onGetToken(event:StatusEvent):void
		//		{
		//			_token = event.level;
		//			
		//			checkDone();
		//		} 
		
		private function checkDone():void
		{
			trace(UserInfo.id, UserInfo.name, UserInfo.heart, UserInfo.remainHeartTime, UserInfo.level, UserInfo.exp, UserInfo.coin);
			
			if(UserInfo.id != null && UserInfo.name != null && UserInfo.heart != -1 
				&& UserInfo.level != -1 && UserInfo.exp != -1 && UserInfo.remainHeartTime != -1 && UserInfo.coin != -1)
			{
				PlatformType.current = PlatformType.FACEBOOK;
				EtcExtensions.alert(UserInfo.name + " 님 환영합니다!");
				//SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
				dispatchEvent(new Event("checkDone"));
			}
		}
	}
}