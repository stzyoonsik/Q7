package util.manager
{
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGames;
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGamesEvent;
	
	import server.UserDBMgr;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	import util.EtcExtensions;
	import util.UserInfo;
	import util.type.PlatformType;

	public class GoogleExtensionMgr extends EventDispatcher
	{
		//싱글톤
		private static var _instance:GoogleExtensionMgr;
		private static var _isConstructing:Boolean;
		
		public function GoogleExtensionMgr()
		{
			if (!_isConstructing) throw new Error("Singleton, use GoogleExtensionMgr.instance()");
			
		}
		
		public static function get instance():GoogleExtensionMgr 
		{
			if (_instance == null)  
			{
				_isConstructing = true;
				_instance = new GoogleExtensionMgr();
				_isConstructing = false;
			}
			return _instance;
		}	
		
		public function logIn():void
		{			
			AirGooglePlayGames.getInstance().isSignedIn();
			AirGooglePlayGames.getInstance().signIn();
			
			AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_IN_SUCCESS, onSignInSuccess);			
			AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_IN_FAIL, onSignInFail);
		}
		
		public function logOut():void
		{
			AirGooglePlayGames.getInstance().signOut();
			AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_OUT_SUCCESS, onSignOutSuccess);
		}
		
		private function onSignInSuccess(event:AirGooglePlayGamesEvent):void
		{
			dispatchEvent(new Event("startLoading"));
			
			UserInfo.id = AirGooglePlayGames.getInstance().getActivePlayerID();
			UserInfo.name = AirGooglePlayGames.getInstance().getActivePlayerName();
			
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
		
		private function onSignInFail(event:AirGooglePlayGamesEvent):void
		{
			trace("sign in fail");
		}
		
		private function onSignOutSuccess(event:AirGooglePlayGamesEvent):void
		{
			trace("sign out");
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
			UserInfo.coin = 1000;
			UserInfo.expRatio = 1;
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
		
		public function showLeaderBoards():void
		{
			AirGooglePlayGames.getInstance().showLeaderboards();
		}
		
		public function showStandardAchievements():void
		{
			AirGooglePlayGames.getInstance().showStandardAchievements();
		}
		
		
		private function checkDone():void
		{
			trace(UserInfo.id, UserInfo.name, UserInfo.lastDate, UserInfo.heart, UserInfo.remainHeartTime, UserInfo.level, UserInfo.exp, UserInfo.coin);
			/**
			 * UserInfo.heart = 5;
			UserInfo.remainHeartTime = 300;
			UserInfo.level = 1;
			UserInfo.exp = 0;
			UserInfo.coin = 1000;*/
			if(UserInfo.id != null && UserInfo.name != null && UserInfo.lastDate != -1 && UserInfo.heart != -1 
				&& UserInfo.level != -1 && UserInfo.exp != -1 && UserInfo.expRatio != -1 && UserInfo.remainHeartTime != -1 && UserInfo.coin != -1)
			{
				PlatformType.current = PlatformType.GOOGLE;
				EtcExtensions.alert(UserInfo.name + " 님 환영합니다!");
				
				dispatchEvent(new Event("checkDone"));
			}
		}
	}
}