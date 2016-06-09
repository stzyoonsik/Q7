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
	import util.manager.ButtonMgr;
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
		
//		private var _userId:String;
//		private var _userName:String;
		private var _token:String;
		
//		public function get userName():String { return _userName; }
//		public function get userId():String { return _userId; }
		
		public function Title()
		{			
//			UserDBMgr.instance.insert("1231237", "내일");
//			UserDBMgr.instance.updateRecord("1231237", false, 0, 25);
//			UserDBMgr.instance.updateRecord("1231237", false, 1, 54);
//			UserDBMgr.instance.updateRecord("1231237", false, 2, 91);
//			UserDBMgr.instance.updateRecord("1231237", false, 3, 292);
//			UserDBMgr.instance.updateRecord("1231237", false, 4, 352);
//			UserDBMgr.instance.updateRecord("1231237", true, 0, 25);
//			UserDBMgr.instance.updateRecord("1231237", true, 1, 62);
//			UserDBMgr.instance.updateRecord("1231237", true, 2, 78);
//			UserDBMgr.instance.updateRecord("1231237", true, 3, 192);
//			UserDBMgr.instance.updateRecord("1231237", true, 4, 342);
//			
//			UserDBMgr.instance.insert("1231238", "점심은");
//			UserDBMgr.instance.updateRecord("1231238", false, 0, 39);
//			UserDBMgr.instance.updateRecord("1231238", false, 1, 35);
//			UserDBMgr.instance.updateRecord("1231238", false, 2, 82);
//			UserDBMgr.instance.updateRecord("1231238", false, 3, 186);
//			UserDBMgr.instance.updateRecord("1231238", false, 4, 474);
//			UserDBMgr.instance.updateRecord("1231238", true, 0, 34);
//			UserDBMgr.instance.updateRecord("1231238", true, 1, 49);
//			UserDBMgr.instance.updateRecord("1231238", true, 2, 59);
//			UserDBMgr.instance.updateRecord("1231238", true, 3, 238);
//			UserDBMgr.instance.updateRecord("1231238", true, 4, 432);
//			
//			UserDBMgr.instance.insert("1231239", "뭐먹지");
//			UserDBMgr.instance.updateRecord("1231239", false, 0, 19);
//			UserDBMgr.instance.updateRecord("1231239", false, 1, 34);
//			UserDBMgr.instance.updateRecord("1231239", false, 2, 56);
//			UserDBMgr.instance.updateRecord("1231239", false, 3, 182);
//			UserDBMgr.instance.updateRecord("1231239", false, 4, 252);
//			UserDBMgr.instance.updateRecord("1231239", true, 0, 23);
//			UserDBMgr.instance.updateRecord("1231239", true, 1, 83);
//			UserDBMgr.instance.updateRecord("1231239", true, 2, 81);
//			UserDBMgr.instance.updateRecord("1231239", true, 3, 198);
//			UserDBMgr.instance.updateRecord("1231239", true, 4, 672);
			
			
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
			UserDBMgr.instance.insert(UserInfo.id, UserInfo.name);
			
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
			if(UserInfo.id != null && UserInfo.name != null /*&& _token != null*/)
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
			_logInGoogle = ButtonMgr.instance.setButton(_logInGoogle, _atlas.getTexture("google"), Main.stageWidth * 1.5, Main.stageHeight * 0.5, Main.stageWidth * 0.5, Main.stageWidth * 0.1); 
			//_logInGoogle.addEventListener(TouchEvent.TOUCH, onTouchLoginGoogle);
			addChild(_logInGoogle);
			
			_logInFacebook = ButtonMgr.instance.setButton(_logInFacebook, _atlas.getTexture("facebook"), Main.stageWidth * 1.5, Main.stageHeight * 0.7, Main.stageWidth * 0.5, Main.stageWidth * 0.1);

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