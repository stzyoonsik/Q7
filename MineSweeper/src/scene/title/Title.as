package scene.title
{	
	import com.freshplanet.ane.AirFacebook.Facebook;
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGames;
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGamesEvent;
	import com.yoonsik.FacebookExtension;
	
	import flash.events.StatusEvent;
	
	import scene.Main;
	
	import starling.animation.Transitions;
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	import util.manager.SceneMgr;
	import util.manager.SwitchActionMgr;
	import util.type.SceneType;

	public class Title extends DisplayObjectContainer
	{
		//private var _fb:FacebookExtension = new FacebookExtension();	
		
		private var _logIn:Button;
		
		private var _userId:String;
		private var _userName:String;
		private var _token:String;
		
		public function get userName():String { return _userName; }
		public function get userId():String { return _userId; }
		
		public function Title()
		{
			
			//initButton();
			AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_IN_SUCCESS, onSignInSuccess);
			AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_OUT_SUCCESS, onSignOutSuccess);
			AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_IN_FAIL, onSignInFail);
			//AirGooglePlayGames.getInstance().startAtLaunch();
			AirGooglePlayGames.getInstance().isSignedIn();
			AirGooglePlayGames.getInstance().signIn();
			//SwitchActionMgr.instance.switchScenefadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
		}
		
		private function onSignInSuccess(event:AirGooglePlayGamesEvent):void
		{
			trace("login");
			trace(AirGooglePlayGames.getInstance().getActivePlayerName());
			SwitchActionMgr.instance.switchScenefadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
		}
		
		private function onSignOutSuccess(event:AirGooglePlayGamesEvent):void
		{
			trace("logout");
		}
		
		private function onSignInFail(event:AirGooglePlayGamesEvent):void
		{
			trace("sininfail");
			trace(event);
			SwitchActionMgr.instance.switchScenefadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
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
				//dispatchEvent(new Event(SceneType.MODE_SELECT));
				SwitchActionMgr.instance.switchScenefadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
				//SceneMgr.instance.switchScene(this, SceneType.MODE_SELECT);
			}
		}
		
		
		public function release():void
		{
			if(_logIn)
			{
				//_logIn.removeEventListener(TouchEvent.TOUCH, onTouchLogin);
				_logIn = null;
			}
		}		
//		
//		
//		private function initButton():void
//		{
//			_logIn = new Button(Texture.fromColor(Main.stageWidth * 0.5, Main.stageHeight * 0.2, Color.SILVER),"");
//			_logIn.text = "Log In With Facebook";
//			_logIn.alignPivot("center", "center");
//			_logIn.x = Main.stageWidth * 0.5;
//			_logIn.y = Main.stageHeight * 0.5;
//			_logIn.addEventListener(TouchEvent.TOUCH, onTouchLogin);
//			addChild(_logIn);
//		}
		
//		private function onTouchLogin(event:TouchEvent):void
//		{
//			var touch:Touch = event.getTouch(_logIn, TouchPhase.ENDED);
//			if(touch)
//			{
//				_fb.logIn();
//				_fb.addEventListener("getObject", onGetObject);
//				_fb.addEventListener("getToken", onGetToken);
//				
//			}
//		}
	}
}