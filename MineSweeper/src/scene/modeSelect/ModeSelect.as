package scene.modeSelect
{
	import com.freshplanet.ane.AirFacebook.Facebook;
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGames;
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGamesLeaderboardEvent;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	import scene.Main;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	import util.manager.SwitchActionMgr;
	import util.type.SceneType;

	public class ModeSelect extends DisplayObjectContainer
	{
		private var _resume:Button;
		private var _normal:Button;
		private var _custom:Button;
		
		private var _userNameTextField:TextField;
		private var _userProfileImage:Image;
		
		private var _logOut:Button;
		
		private var _ranking:Button;
		
		private var _temp:TextField;
		
		public static var leaderBoardId:String = "CgkIu_GfvOAVEAIQCA";
		
		public function ModeSelect()
		{
			initUser();
			initButton();
			_resume = setButton(_resume, Main.stageWidth * 0.5, Main.stageHeight * 0.3, Main.stageWidth * 0.5, Main.stageWidth * 0.1, "이어하기", Main.stageWidth * 0.05, Color.SILVER);
			_normal = setButton(_normal, Main.stageWidth * 0.5, Main.stageHeight * 0.5, Main.stageWidth * 0.5, Main.stageWidth * 0.1, "일반", Main.stageWidth * 0.05, Color.SILVER);
			_custom = setButton(_custom, Main.stageWidth * 0.5, Main.stageHeight * 0.7, Main.stageWidth * 0.5, Main.stageWidth * 0.1, "커스텀", Main.stageWidth * 0.05, Color.SILVER);		
			
			_resume.addEventListener(TouchEvent.TOUCH, onTouchMode);
			_normal.addEventListener(TouchEvent.TOUCH, onTouchMode);
			_custom.addEventListener(TouchEvent.TOUCH, onTouchMode);
			
			addChild(_resume);
			addChild(_normal);
			addChild(_custom);
			
			_temp = new TextField(Main.stageWidth, Main.stageHeight * 0.2);
			_temp.alignPivot("center", "center");
			_temp.x = Main.stageWidth * 0.5;
			_temp.y = Main.stageHeight * 0.9;
			_temp.text = AirGooglePlayGames.getInstance().getActivePlayerName() + " " + AirGooglePlayGames.getInstance().getActivePlayerID();
			addChild(_temp);
			
			AirGooglePlayGames.getInstance().showStandardAchievements();
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
		}
		
		public function release():void
		{
			if(_resume)
			{
				_resume.removeEventListener(TouchEvent.TOUCH, onTouchMode);
				_resume = null;
			}
			if(_normal)
			{
				_normal.removeEventListener(TouchEvent.TOUCH, onTouchMode);
				_normal = null;				
			}
			if(_custom)
			{
				_custom.removeEventListener(TouchEvent.TOUCH, onTouchMode);
				_custom = null;				
			}
			
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
		}
		
		private function initUser():void
		{
			var urlRequest:URLRequest = new URLRequest("https://graph.facebook.com/"+Main.userId+"/picture?type=large");
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onLoadImageComplete);
			loader.load(urlRequest);
			
			_userNameTextField = new TextField(Main.stageWidth * 0.5, Main.stageHeight * 0.5, Main.userName);
			_userNameTextField.autoSize = "left";
			_userNameTextField.alignPivot("center", "center");
			_userNameTextField.x = Main.stageWidth * 0.1;
			_userNameTextField.y = Main.stageHeight * 0.2;
			_userNameTextField.format.size = Main.stageWidth * 0.04;
			addChild(_userNameTextField);
			
		}
		
		private function onLoadImageComplete(event:flash.events.Event):void
		{
			var bitmap:Bitmap = event.currentTarget.loader.content as Bitmap;
			var texture:Texture = Texture.fromBitmap(bitmap);
			
			_userProfileImage = new Image(texture);
			_userProfileImage.alignPivot("center", "center");
			
			_userProfileImage.width = Main.stageWidth * 0.2;
			_userProfileImage.height = _userProfileImage.width;
			
			_userProfileImage.x = Main.stageWidth * 0.1;
			_userProfileImage.y = _userProfileImage.height / 2;
			
			addChild(_userProfileImage);
		}
		
		private function initButton():void
		{
			_logOut = new Button(Texture.fromColor(Main.stageWidth * 0.4, Main.stageHeight * 0.1, Color.SILVER),"");
			_logOut.text = "Log Out";
			_logOut.textFormat.size =  Main.stageWidth * 0.05;
			_logOut.alignPivot("center", "center");
			_logOut.x = Main.stageWidth * 0.8;
			_logOut.y = Main.stageHeight * 0.1;
			_logOut.addEventListener(TouchEvent.TOUCH, onTouchLogOut);
			addChild(_logOut);
			
			_ranking = new Button(Texture.fromColor(Main.stageWidth * 0.2, Main.stageHeight * 0.1, Color.SILVER),"Ranking");
			_ranking.textFormat.size =  Main.stageWidth * 0.05;
			_ranking.alignPivot("center", "center");
			_ranking.x = Main.stageWidth * 0.5;
			_ranking.y = Main.stageHeight * 0.1;
			_ranking.addEventListener(TouchEvent.TOUCH, onTouchRanking);
			addChild(_ranking);
			
		}
		
		
		
		private function onTouchRanking(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_ranking, TouchPhase.ENDED);
			if(touch)
			{
				AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesLeaderboardEvent.LEADERBOARD_LOADED, onLoadSuccessLeaderBoard);
				AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesLeaderboardEvent.LEADERBOARD_LOADING_FAILED, onLoadFailLeaderBoard);
				AirGooglePlayGames.getInstance().getLeaderboard(leaderBoardId);
			}
		}
		
		private function onLoadSuccessLeaderBoard(event:AirGooglePlayGamesLeaderboardEvent):void
		{
			
			AirGooglePlayGames.getInstance().showLeaderboards();
		}
		
		private function onLoadFailLeaderBoard(event:AirGooglePlayGamesLeaderboardEvent):void
		{
			_temp.text = "onLoadFailLeaderBoard" + event.type;
		}
		
		private function onTouchLogOut(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_logOut, TouchPhase.ENDED);
			if(touch)
			{
//				if(Facebook.getInstance().isSessionOpen)
//				{
//					Facebook.getInstance().closeSessionAndClearTokenInformation();
//					dispatchEvent(new starling.events.Event(SceneType.TITLE));
//				}
				AirGooglePlayGames.getInstance().signOut();
				_temp.text = "";
				//토스트로 로그아웃 알림
			}
		}
		
		private function setButton(button:Button, x:int, y:int, width:int, height:int, text:String, textSize:int, color:uint):Button
		{
			var texture:Texture = Texture.fromColor(width, height, color);
			button = new Button(texture, text);
			button.textFormat.size = textSize;
			button.alignPivot("center", "center");
			button.x = x;
			button.y = y;
			
			return button;
		}
		
		private function onTouchMode(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_resume, TouchPhase.ENDED);
			if(touch)
			{
				//dispatchEvent(new starling.events.Event(SceneType.GAME, false, 0));
				SwitchActionMgr.instance.switchScenefadeOut(this, SceneType.GAME, false, 0, 0.5, Transitions.EASE_OUT);
			}
			
			touch = event.getTouch(_normal, TouchPhase.ENDED);
			if(touch)
			{
				SwitchActionMgr.instance.switchScenefadeOut(this, SceneType.STAGE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
			}
			
			touch = event.getTouch(_custom, TouchPhase.ENDED);
			if(touch)
			{
				SwitchActionMgr.instance.switchScenefadeOut(this, SceneType.CUSTOM, false, null, 0.5, Transitions.EASE_OUT);
			}			
			
		}
		
		private function onTouchKeyBoard(event:KeyboardEvent):void
		{
			
			if(event.keyCode == Keyboard.BACK || event.keyCode == 8)
			{
				//event.preventDefault();
				//종료팝업 ane
			}
		}
	}
}