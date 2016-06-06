package scene.title
{	
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGames;
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGamesEvent;
	import com.yoonsik.FacebookExtension;
	
	import flash.events.StatusEvent;
	
	import scene.Main;
	
	import starling.animation.Transitions;
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	import util.manager.SwitchActionMgr;
	import util.type.PlatformType;
	import util.type.SceneType;

	public class Title extends DisplayObjectContainer
	{
		private var _fb:FacebookExtension = new FacebookExtension();	
		
		private var _logInGoogle:Button;
		private var _logInFacebook:Button;
		
		private var _userId:String;
		private var _userName:String;
		private var _token:String;
		
		public function get userName():String { return _userName; }
		public function get userId():String { return _userId; }
		
		public function Title()
		{			
			initButton();			
		}
		
		private function onSignInSuccess(event:AirGooglePlayGamesEvent):void
		{
			trace("login");
			PlatformType.current = PlatformType.GOOGLE;
			_userId = AirGooglePlayGames.getInstance().getActivePlayerID();
			_userName = AirGooglePlayGames.getInstance().getActivePlayerName();
			SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
		}
		
		private function onSignOutSuccess(event:AirGooglePlayGamesEvent):void
		{
			trace("logout");
		}
		
		private function onSignInFail(event:AirGooglePlayGamesEvent):void
		{
			trace("sign in fail");
			trace(event);
			//SwitchActionMgr.instance.switchScenefadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
		}
		
		private function onGetObject(event:StatusEvent):void
		{
			
			var data:Object = JSON.parse(event.level);
			_userId = data.id;
			_userName = data.name;
			trace(_userId);
			trace(_userName);
			
			checkDone();
		}
		
		private function onGetToken(event:StatusEvent):void
		{
			_token = event.level;
			
			checkDone();
		} 
		
		private function checkDone():void
		{
			if(_userId != null && _userName != null && _token != null)
			{
				PlatformType.current = PlatformType.FACEBOOK;
				SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
			}
		}
		
		
		public function release():void
		{
			if(_logInGoogle)
			{
				_logInGoogle = null;
			}
			
			if(_fb)
			{
				_fb = null;
				
			}
		}		
		
		
		private function initButton():void
		{
			_logInGoogle = new Button(Texture.fromColor(Main.stageWidth * 0.5, Main.stageHeight * 0.2, Color.SILVER),"");
			_logInGoogle.text = "Log In With Google";
			_logInGoogle.alignPivot("center", "center");
			_logInGoogle.x = Main.stageWidth * 0.5;
			_logInGoogle.y = Main.stageHeight * 0.4;
			_logInGoogle.addEventListener(TouchEvent.TOUCH, onTouchLoginGoogle);
			addChild(_logInGoogle);
			
			_logInFacebook = new Button(Texture.fromColor(Main.stageWidth * 0.5, Main.stageHeight * 0.2, Color.SILVER),"");
			_logInFacebook.text = "Log In With Facebook";
			_logInFacebook.alignPivot("center", "center");
			_logInFacebook.x = Main.stageWidth * 0.5;
			_logInFacebook.y = Main.stageHeight * 0.7;
			_logInFacebook.addEventListener(TouchEvent.TOUCH, onTouchLoginFacebook);
			addChild(_logInFacebook);
		}
		
		private function onTouchLoginGoogle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_logInGoogle, TouchPhase.ENDED);
			if(touch)
			{				
				AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_IN_SUCCESS, onSignInSuccess);
				AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_OUT_SUCCESS, onSignOutSuccess);
				AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_IN_FAIL, onSignInFail);
				AirGooglePlayGames.getInstance().isSignedIn();
				AirGooglePlayGames.getInstance().signIn();
			}
		}
		
		private function onTouchLoginFacebook(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_logInFacebook, TouchPhase.ENDED);
			if(touch)
			{
				_fb.logIn();
				_fb.addEventListener("getObject", onGetObject);
				_fb.addEventListener("getToken", onGetToken);
			}
		}
	}
}