package scene.title
{	
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGames;
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGamesEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.yoonsik.FacebookExtension;
	
	import flash.events.StatusEvent;
	
	import scene.Main;
	
	import server.UserDBMgr;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	
	import util.EmbeddedAssets;
	import util.UserInfo;
	import util.manager.DisplayObjectMgr;
	import util.manager.LoadMgr;
	import util.manager.SwitchActionMgr;
	import util.type.PlatformType;
	import util.type.SceneType;

	public class Title extends DisplayObjectContainer
	{
		private var _fb:FacebookExtension = new FacebookExtension();	
		private var _atlas:TextureAtlas;
		
		private var _logInGoogle:Button;
		private var _logInFacebook:Button;
		
		private var _token:String;
		
		
		public function Title()
		{	
			
			
			_atlas = LoadMgr.instance.load(EmbeddedAssets.TitleSprite, EmbeddedAssets.TitleXml);
			initBackground();
			initButton();	
			//SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
					
		}
		public function release():void
		{
			if(_logInGoogle)
			{
				_logInGoogle = null;
			}
			
			if(_logInFacebook)
			{
				_logInFacebook = null;
			}
			
			if(_fb)
			{
				_fb = null;
				
			}
		}
		
		/** 백그라운드 초기화 메소드	 */
		private function initBackground():void
		{
			var background:Image = new Image(_atlas.getTexture("background"));
			background.width = Main.stageWidth;
			background.height = Main.stageHeight;
			addChild(background);
			
			var title:Image = new Image(_atlas.getTexture("title"));
			title.width = Main.stageWidth;
			title.height = title.width * 0.3;
			title.x = Main.stageWidth * 0.5;
			title.y = Main.stageHeight * 0.2;
			title.alignPivot("center","center");
			title.scale = 0.1;
			
			var titleTween:Tween = new Tween(title, 2, Transitions.EASE_IN_BOUNCE);
			titleTween.scaleTo(1);
			titleTween.addEventListener(Event.REMOVE_FROM_JUGGLER, onRemoveTitleTween);
			Starling.juggler.add(titleTween);
			addChild(title);
		}
		
		private function onRemoveTitleTween(event:Event):void
		{
			trace("titleTween remove");
			var titleTween:Tween = event.target as Tween;
			event.target.removeEventListener(Event.REMOVE_FROM_JUGGLER, onRemoveTitleTween);
			titleTween = null;
			
			if(_logInGoogle && _logInFacebook)
			{
				TweenLite.to(_logInGoogle, 1, {x:Main.stageWidth*0.5, y:Main.stageHeight*0.5, ease:Back.easeOut});
				TweenLite.to(_logInFacebook, 1, {x:Main.stageWidth*0.5, y:Main.stageHeight*0.7, ease:Back.easeOut});
			}
			
		}
		
//		private function onSignInSuccess(event:AirGooglePlayGamesEvent):void
//		{
//			trace("login");
//			PlatformType.current = PlatformType.GOOGLE;
//			_userId = AirGooglePlayGames.getInstance().getActivePlayerID();
//			_userName = AirGooglePlayGames.getInstance().getActivePlayerName();
//			SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
//		}
//		
//		private function onSignOutSuccess(event:AirGooglePlayGamesEvent):void
//		{
//			trace("logout");
//		}
//		
//		private function onSignInFail(event:AirGooglePlayGamesEvent):void
//		{
//			trace("sign in fail");
//			trace(event);
//			//SwitchActionMgr.instance.switchScenefadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
//		}
//		
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
				SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
			}
		}
//		
//		
//				
//		
//		
		private function initButton():void
		{
			_logInGoogle = DisplayObjectMgr.instance.setButton(_logInGoogle, _atlas.getTexture("google"), Main.stageWidth * 1.5, Main.stageHeight * 0.5, Main.stageWidth * 0.5, Main.stageWidth * 0.1); 
			//_logInGoogle.addEventListener(TouchEvent.TOUCH, onTouchLoginGoogle);
			addChild(_logInGoogle);
			
			_logInFacebook = DisplayObjectMgr.instance.setButton(_logInFacebook, _atlas.getTexture("facebook"), Main.stageWidth * 1.5, Main.stageHeight * 0.7, Main.stageWidth * 0.5, Main.stageWidth * 0.1);

			_logInFacebook.addEventListener(TouchEvent.TOUCH, onTouchLoginFacebook);
			addChild(_logInFacebook);
			
			
		}
//		
//		private function onTouchLoginGoogle(event:TouchEvent):void
//		{
//			var touch:Touch = event.getTouch(_logInGoogle, TouchPhase.ENDED);
//			if(touch)
//			{				
//				AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_IN_SUCCESS, onSignInSuccess);
//				AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_OUT_SUCCESS, onSignOutSuccess);
//				AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_IN_FAIL, onSignInFail);
//				AirGooglePlayGames.getInstance().isSignedIn();
//				AirGooglePlayGames.getInstance().signIn();
//			}
//		}
//		
		private function onTouchLoginFacebook(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_logInFacebook, TouchPhase.ENDED);
			if(touch)
			{
				_fb.logIn();
				_fb.addEventListener("getObject", onGetObject);
				//_fb.addEventListener("getToken", onGetToken);
			}
		}
	}
}