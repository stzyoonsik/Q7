package scene.modeSelect
{
	import com.freshplanet.ane.AirFacebook.Facebook;
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGames;
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGamesLeaderboardEvent;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	import scene.Main;
	import scene.modeSelect.custom.CustomPopup;
	import scene.modeSelect.normal.NormalPopup;
	import scene.modeSelect.rank.RankPopup;
	import scene.modeSelect.user.Coin;
	import scene.modeSelect.user.Heart;
	import scene.modeSelect.user.Level;
	
	import server.UserDBMgr;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	
	import util.EmbeddedAssets;
	import util.UserInfo;
	import util.manager.DisplayObjectMgr;
	import util.manager.SwitchActionMgr;
	import util.type.PlatformType;
	import util.type.SceneType;

	public class ModeSelect extends DisplayObjectContainer
	{
		private var _atlas:TextureAtlas;
		
		private var _normalPopup:NormalPopup;
		private var _customPopup:CustomPopup;
		
		private var _resume:Button;
		private var _normal:Button;
		private var _custom:Button;
		
		private var _rankPopup:RankPopup;
		
		private var _userNameTextField:TextField;
		private var _userProfileImage:Image;
		
		private var _logOut:Button;		
		private var _ranking:Button;
		private var _achievement:Button;
		
		private var _level:Level;
		private var _heart:Heart;
		private var _coin:Coin;
		
		private var _temp:TextField;
		
		//private var leaderBoardId:String = "CgkIu_GfvOAVEAIQCA";
		
		public function ModeSelect()
		{
			load();
			initBackground();
			initButton();
			initUser();
			
		
			_heart = new Heart(_atlas);
			addChild(_heart);
			
			_coin = new Coin(_atlas);
			addChild(_coin);			
			
			_level = new Level(_atlas);
			addChild(_level);
			
			_rankPopup = new RankPopup(_atlas);
			_rankPopup.visible = false;
			addChild(_rankPopup);
			
			_normalPopup = new NormalPopup(_atlas);
			_normalPopup.visible = false;
			addChild(_normalPopup);
			
			_customPopup = new CustomPopup(_atlas);
			_customPopup.visible = false;
			addChild(_customPopup);
			
			
			trace(UserInfo.id, UserInfo.name, UserInfo.heart, UserInfo.level, UserInfo.exp);
			
//			_temp = new TextField(Main.stageWidth, Main.stageHeight * 0.2);
//			_temp.alignPivot("center", "center");
//			_temp.x = Main.stageWidth * 0.5;
//			_temp.y = Main.stageHeight * 0.9;
//			_temp.text = AirGooglePlayGames.getInstance().getActivePlayerName() + " " + AirGooglePlayGames.getInstance().getActivePlayerID();
//			addChild(_temp);
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
			
			
		}
		
		/**
		 * 스프라이트시트와 xml을 로드하는 메소드 
		 * 
		 */
		private function load():void
		{			
			var xml:XML = XML(new EmbeddedAssets.ModeXml());
			var texture:Texture = Texture.fromEmbeddedAsset(EmbeddedAssets.ModeSprite);
			_atlas = new TextureAtlas(texture, xml);
			
			xml = null;
			texture = null;
		}
		
		public function release():void
		{
//			UserDBMgr.instance.updateData(UserInfo.id, "lastDate", new Date().getTime().toString());
//			UserDBMgr.instance.updateData(UserInfo.id, "heartTime", _heart.remainHeartTime);
//			UserInfo.heart--;
//			UserDBMgr.instance.updateData(UserInfo.id, "heart", UserInfo.heart);
			
			if(_atlas) { _atlas = null; }
			if(_normalPopup) { _normalPopup.release(); _normalPopup = null;	removeChild(_normalPopup); }
			if(_customPopup) { _customPopup.release(); _customPopup = null;	removeChild(_customPopup); }
			if(_rankPopup) { _rankPopup.release(); _rankPopup = null; removeChild(_rankPopup); }
			if(_resume)	{ _resume.removeEventListener(TouchEvent.TOUCH, onTouchMode); _resume.dispose(); _resume = null; removeChild(_resume);}
			if(_normal)	{ _normal.removeEventListener(TouchEvent.TOUCH, onTouchMode); _normal.dispose(); _normal = null; removeChild(_normal);}
			if(_custom)	{ _custom.removeEventListener(TouchEvent.TOUCH, onTouchMode); _custom.dispose(); _custom = null; removeChild(_custom);}
			if(_userNameTextField) { _userNameTextField = null; removeChild(_userNameTextField); }
			if(_userProfileImage) { _userProfileImage.dispose(); _userProfileImage = null; removeChild(_userProfileImage); }
			if(_logOut) { _logOut.removeEventListener(TouchEvent.TOUCH, onTouchLogOut); _logOut.dispose(); _logOut = null; removeChild(_logOut); }
			if(_ranking) { _ranking.removeEventListener(TouchEvent.TOUCH, onTouchRanking); _ranking.dispose(); _ranking = null; removeChild(_ranking); }
			if(_achievement) { _achievement.removeEventListener(TouchEvent.TOUCH, onTouchAchievement); _achievement.dispose(); _achievement = null; removeChild(_achievement); }
			if(_level) { _level.release(); _level.dispose(); _level = null; removeChild(_level); }
			if(_heart) { _heart.release(); _heart.dispose(); _heart = null; removeChild(_heart); }
			
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
			//NativeApplication.nativeApplication.removeEventListener(flash.events.Event.DEACTIVATE, onDeactivated);
			//NativeApplication.nativeApplication.removeEventListener(flash.events.Event.ACTIVATE, onActivated);
		}
		
		private function initBackground():void
		{
			//var image:Image = new Image(_atlas.getTexture("background"));
			//image.width = Main.stageWidth;
			//image.height = Main.stageHeight;
			var image:Image = DisplayObjectMgr.instance.setImage(_atlas.getTexture("background"), 0, 0, Main.stageWidth, Main.stageHeight);
			addChild(image);
		}
		
		private function initUser():void
		{
			if(PlatformType.current == PlatformType.FACEBOOK)
			{
				_userProfileImage = new Image(null);
				_userProfileImage.alignPivot("center", "center");
				
				_userProfileImage.width = Main.stageWidth * 0.2;
				_userProfileImage.height = _userProfileImage.width;
				
				_userProfileImage.x = Main.stageWidth * 0.1;
				_userProfileImage.y = _userProfileImage.height / 2;
				
				addChild(_userProfileImage);
				
				//모드셀렉트에 최초 진입 시에만 로딩. 이후에는 메모리에 올린 texture를 불러옴
				if(UserInfo.picture == null)
				{
					var urlRequest:URLRequest = new URLRequest("https://graph.facebook.com/"+UserInfo.id+"/picture?type=large");
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onLoadImageComplete);
					loader.load(urlRequest);
				}
				
				else
				{
					_userProfileImage.texture = UserInfo.picture;
				}
				
				
				_userNameTextField = new TextField(Main.stageWidth * 0.5, Main.stageHeight * 0.5, UserInfo.name);
				_userNameTextField.autoSize = "left";
				_userNameTextField.alignPivot("center", "center");
				_userNameTextField.x = Main.stageWidth * 0.1;
				_userNameTextField.y = Main.stageHeight * 0.15;
				_userNameTextField.format.size = Main.stageWidth * 0.04;
				addChild(_userNameTextField);
			}			
			
		}
		
		private function onLoadImageComplete(event:flash.events.Event):void
		{
			var bitmap:Bitmap = event.currentTarget.loader.content as Bitmap;
			var texture:Texture = Texture.fromBitmap(bitmap);
			
			if(_userProfileImage)
				_userProfileImage.texture = texture;
			
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(flash.events.Event.COMPLETE, onLoadImageComplete);
			
		}
		
		private function initButton():void
		{			
			_logOut = DisplayObjectMgr.instance.setButton(_logOut, _atlas.getTexture("button"), Main.stageWidth * 0.8, Main.stageHeight * 0.9, Main.stageWidth * 0.2, Main.stageHeight * 0.075, "로그아웃", Main.stageWidth * 0.03);
			_logOut.addEventListener(TouchEvent.TOUCH, onTouchLogOut);
			addChild(_logOut); 
			
			
	
			_ranking = DisplayObjectMgr.instance.setButton(_ranking, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.9, Main.stageWidth * 0.2, Main.stageHeight * 0.075, "랭킹", Main.stageWidth * 0.05);
			_ranking.addEventListener(TouchEvent.TOUCH, onTouchRanking);
			addChild(_ranking); 
			
			
			
			_achievement = DisplayObjectMgr.instance.setButton(_achievement, _atlas.getTexture("button"), Main.stageWidth * 0.2, Main.stageHeight * 0.9, Main.stageWidth * 0.2, Main.stageHeight * 0.075, "업적", Main.stageWidth * 0.05);
			_achievement.addEventListener(TouchEvent.TOUCH, onTouchAchievement);
			addChild(_achievement); 
			if(PlatformType.current == PlatformType.FACEBOOK)
			{
				_achievement.alpha = 0.5;
				_achievement.touchable = false;
			}
				
			
			
			_resume = DisplayObjectMgr.instance.setButton(_resume, _atlas.getTexture("button"), 
						Main.stageWidth * 0.5, Main.stageHeight * 0.3, Main.stageWidth * 0.5, Main.stageWidth * 0.15, 
						"이어하기", Main.stageWidth * 0.05);			
			
			_normal = DisplayObjectMgr.instance.setButton(_normal, _atlas.getTexture("button"), 
						Main.stageWidth * 0.5, Main.stageHeight * 0.5, Main.stageWidth * 0.5, Main.stageWidth * 0.15, 
						"일반", Main.stageWidth * 0.05);
			
			_custom = DisplayObjectMgr.instance.setButton(_custom, _atlas.getTexture("button"), 
						Main.stageWidth * 0.5, Main.stageHeight * 0.7, Main.stageWidth * 0.5, Main.stageWidth * 0.15, 
						"커스텀", Main.stageWidth * 0.05);		
			
			_resume.addEventListener(TouchEvent.TOUCH, onTouchMode);
			_normal.addEventListener(TouchEvent.TOUCH, onTouchMode);
			_custom.addEventListener(TouchEvent.TOUCH, onTouchMode);
			
			addChild(_resume);
			addChild(_normal);
			addChild(_custom);
		}
		
		
		
		private function onTouchRanking(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_ranking, TouchPhase.ENDED);
			if(touch)
			{
				if(PlatformType.current == PlatformType.GOOGLE)
				{
					//AirGooglePlayGames.getInstance().showLeaderboards();
				}
				else
				{
					_rankPopup.reset();
					_rankPopup.visible = true;					
				}
			}
		}
		
		private function onTouchAchievement(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_achievement, TouchPhase.ENDED);
			if(touch)
			{
				//AirGooglePlayGames.getInstance().showStandardAchievements();
			}
		}
//		
//		private function onLoadSuccessLeaderBoard(event:AirGooglePlayGamesLeaderboardEvent):void
//		{
//			
//			AirGooglePlayGames.getInstance().showLeaderboards();
//		}
//		
//		private function onLoadFailLeaderBoard(event:AirGooglePlayGamesLeaderboardEvent):void
//		{
//			_temp.text = "onLoadFailLeaderBoard" + event.type;
//		}
		
		private function onTouchLogOut(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_logOut, TouchPhase.ENDED);
			if(touch)
			{
				if(PlatformType.current == PlatformType.GOOGLE)
				{
					//					AirGooglePlayGames.getInstance().signOut();
					//					Main.userId = "";
					//					Main.userName = "";
				}
				else
				{
					
					UserInfo.id = null;
					UserInfo.name = null;
					UserInfo.picture = null;
					UserInfo.level = -1;
					UserInfo.exp = -1;
					UserInfo.heart = -1;
					UserInfo.remainHeartTime = -1;
					UserInfo.coin = -1;
				}	
				trace("로그아웃********************************");
				//_temp.text = "";
				SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.TITLE, false, null, 0.5, Transitions.EASE_OUT);
				//토스트로 로그아웃 알림
			}
		}
		 
		private function onTouchMode(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_resume, TouchPhase.ENDED);
			if(touch)
			{
				UserInfo.heart++;
				SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.GAME, false, 0, 0.5, Transitions.EASE_OUT);
			}
			
			touch = event.getTouch(_normal, TouchPhase.ENDED);
			if(touch)
			{
				//SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.STAGE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
				_normalPopup.visible = true;
			}
			
			touch = event.getTouch(_custom, TouchPhase.ENDED);
			if(touch)
			{
				//SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.CUSTOM, false, null, 0.5, Transitions.EASE_OUT);
				_customPopup.visible = true;
			}			
			
		}
		
		private function onTouchKeyBoard(event:KeyboardEvent):void
		{
			
			if(event.keyCode == Keyboard.BACK || event.keyCode == 8)
			{
				event.preventDefault();
				if(_rankPopup.visible)
				{
					_rankPopup.visible = false;
					_rankPopup.reset();
				}
				if(_normalPopup.visible)
				{
					_normalPopup.visible = false;
				}
				if(_customPopup.visible)
				{
					_customPopup.visible = false;
				}
				
				if(!_rankPopup.visible && !_normalPopup.visible && !_customPopup.visible)
				{
					//종료팝업 ane
				}
				
			}
		}
		
		
		
	}
}