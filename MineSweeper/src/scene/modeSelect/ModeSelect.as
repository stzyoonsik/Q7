package scene.modeSelect
{
	import com.freshplanet.ane.AirFacebook.Facebook;
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGames;
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGamesLeaderboardEvent;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.KeyboardEvent;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	import scene.Main;
	import scene.modeSelect.popup.custom.CustomPopup;
	import scene.modeSelect.popup.normal.NormalPopup;
	import scene.modeSelect.popup.rank.RankPopup;
	import scene.modeSelect.popup.reward.RewardPopup;
	import scene.modeSelect.popup.shop.ShopPopup;
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
	import starling.utils.Align;
	import starling.utils.Color;
	
	import util.EmbeddedAssets;
	import util.EtcExtensions;
	import util.UserInfo;
	import util.manager.AtlasMgr;
	import util.manager.DisplayObjectMgr;
	import util.manager.GoogleExtensionMgr;
	import util.manager.SoundMgr;
	import util.manager.SwitchActionMgr;
	import util.type.PlatformType;
	import util.type.SceneType;

	public class ModeSelect extends DisplayObjectContainer
	{
		private var _atlas:TextureAtlas;
		
		private var _normalPopup:NormalPopup;
		private var _customPopup:CustomPopup;
		private var _shopPopup:ShopPopup;
		private var _rankPopup:RankPopup;
		private var _rewardPopup:RewardPopup;
		
		private var _resume:Button;
		private var _normal:Button;
		private var _custom:Button;		
		
		
		private var _userNameTextField:TextField;
		private var _userProfileImage:Image;
		private var _itemTextField:TextField;
		
		private var _logOut:Button;		
		private var _ranking:Button;
		private var _achievement:Button;
		private var _shop:Button;
		
		private var _level:Level;
		private var _heart:Heart;
		private var _coin:Coin;
		
		private var _levelUpAmount:int;
		
		private var _temp:TextField;
		
		//private var leaderBoardId:String = "CgkIu_GfvOAVEAIQCA";
		
		public function ModeSelect()
		{
			//SoundMgr.instance.stop("titleBgm0.mp3");
			SoundMgr.instance.stopAll();
			SoundMgr.instance.play("modeBgm.mp3", true);
			
			_atlas = AtlasMgr.instance.getAtlas("ModeSprite");
			
			initBackground();			
			initUser();
			initButton();
			initPopup();
			
			checkItemOver();
//			CONFIG::local
//			{				
//				UserDBMgr.instance.updateData(UserInfo.id, "lastDate", new Date().getDate().toString());
//			}
		
			
//			_temp = new TextField(Main.stageWidth, Main.stageHeight * 0.2);
//			_temp.alignPivot("center", "center");
//			_temp.x = Main.stageWidth * 0.5;
//			_temp.y = Main.stageHeight * 0.9;
//			_temp.text = AirGooglePlayGames.getInstance().getActivePlayerName() + " " + AirGooglePlayGames.getInstance().getActivePlayerID();
//			addChild(_temp);
			
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
			
			
		}		
		public function release():void
		{
			
			//if(_atlas) { _atlas = null; }
			if(_normalPopup) { _normalPopup.release(); _normalPopup = null;	removeChild(_normalPopup); }
			if(_customPopup) { _customPopup.release(); _customPopup = null;	removeChild(_customPopup); }
			if(_rankPopup) { _rankPopup.release(); _rankPopup = null; removeChild(_rankPopup); }
			if(_shopPopup) { _shopPopup.removeEventListener("boughtHeart", onBoughtHeart); _shopPopup.removeEventListener("boughtExpBoost", onBoughtExpBoost);_shopPopup.release; _shopPopup = null; removeChild(_shopPopup); }
			if(_rewardPopup) { _rewardPopup.release(); _rewardPopup = null; removeChild(_rewardPopup); }
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
			
		}
		
		private function initBackground():void
		{
			var image:Image = DisplayObjectMgr.instance.setImage(_atlas.getTexture("background"), 0, 0, 
				Main.stageWidth, Main.stageHeight);
			addChild(image);
		}
		
		private function initUser():void
		{
			if(PlatformType.current == PlatformType.FACEBOOK)
			{
				_userProfileImage = new Image(UserInfo.picture);
				_userProfileImage.alignPivot("center", "center");
				
				_userProfileImage.width = Main.stageWidth * 0.2;
				_userProfileImage.height = _userProfileImage.width;
				
				_userProfileImage.x = Main.stageWidth * 0.1;
				_userProfileImage.y = _userProfileImage.height / 2;
				addChild(_userProfileImage);				
				
				
				_userNameTextField = new TextField(Main.stageWidth * 0.3, Main.stageHeight * 0.1, UserInfo.name);
				_userNameTextField.autoSize = "left";
				_userNameTextField.alignPivot("center", "center");
				_userNameTextField.x = Main.stageWidth * 0.1;
				_userNameTextField.y = Main.stageHeight * 0.15;
				_userNameTextField.format.size = Main.stageWidth * 0.04;
				addChild(_userNameTextField);
				
				_itemTextField = DisplayObjectMgr.instance.setTextField(Main.stageWidth * 0.2, Main.stageHeight * 0.2,
												Main.stageWidth * 0.3, Main.stageHeight * 0.1, "", "center", "center");
				_itemTextField.text = "";
				_itemTextField.format.horizontalAlign = Align.LEFT;
				_itemTextField.format.size = Main.stageWidth * 0.025;
				addChild(_itemTextField);
			}	
			
			_heart = new Heart(_atlas);
			addChild(_heart);
			
			_coin = new Coin(_atlas);
			addChild(_coin);			
			
			_level = new Level(_atlas);
			addChild(_level);
			
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
			
			_shop = DisplayObjectMgr.instance.setButton(_shop, _atlas.getTexture("button"), Main.stageWidth * 0.85, Main.stageHeight * 0.075, Main.stageWidth * 0.2, Main.stageHeight * 0.075, "상점", Main.stageWidth * 0.05);
			_shop.addEventListener(TouchEvent.TOUCH, onTouchShop);
			addChild(_shop); 
				
			
			
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
		
		private function initPopup():void
		{
			_shopPopup = new ShopPopup(_atlas);
			_shopPopup.addEventListener("boughtHeart", onBoughtHeart);
			_shopPopup.addEventListener("boughtExpBoost", onBoughtExpBoost);
			_shopPopup.visible = false;
			addChild(_shopPopup);
			
			_rankPopup = new RankPopup(_atlas);
			_rankPopup.visible = false;
			addChild(_rankPopup);
			
			_normalPopup = new NormalPopup(_atlas);
			_normalPopup.visible = false;
			addChild(_normalPopup);
			
			_customPopup = new CustomPopup(_atlas);
			_customPopup.visible = false;
			addChild(_customPopup);
			
			_rewardPopup = new RewardPopup(_atlas);
			_rewardPopup.visible = false;			
			addChild(_rewardPopup);
			if(_rewardPopup.checkLevelUp())
			{
				_coin.refresh();
			}
			if(_rewardPopup.checkAttend())
			{
				_coin.refresh();
			}
		}
		
		private function checkItemOver():void
		{
			UserDBMgr.instance.selectItemOverTime(UserInfo.id);
			UserDBMgr.instance.addEventListener("selectItemOverTime", onCompleteSelectItemOverTime);
		}
		
		private function onCompleteSelectItemOverTime(event:Event):void
		{
			UserDBMgr.instance.removeEventListener("selectItemOverTime", onCompleteSelectItemOverTime);
			if(event.data == null)
			{
				trace("itemOverTime NULL");
				_itemTextField.text = "";
				
				
			}
			
			else
			{
				var currentTime:Number = new Date().getTime();
				trace("itemOverTime 널 아님 " + currentTime, Number(event.data));
				if(currentTime < Number(event.data))
				{
					_itemTextField.text = "경험치 2배";
				}
				else
				{
					_itemTextField.text = "";
					UserInfo.expRatio = 1;
					UserDBMgr.instance.updateData(UserInfo.id, "expRatio", UserInfo.expRatio);
					UserDBMgr.instance.updateData(UserInfo.id, "itemOverTime", null);
				}
			}
		}
		
		
		private function onTouchRanking(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_ranking, TouchPhase.ENDED);
			if(touch)
			{
				if(PlatformType.current == PlatformType.GOOGLE)
				{
					GoogleExtensionMgr.instance.showLeaderBoards();
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
				GoogleExtensionMgr.instance.showStandardAchievements();
			}
		}
		
		private function onTouchLogOut(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_logOut, TouchPhase.ENDED);
			if(touch)
			{
				if(PlatformType.current == PlatformType.GOOGLE)
				{
					GoogleExtensionMgr.instance.logOut();
					UserInfo.reset();
				}
				else
				{
					UserInfo.reset();	
				
				}	
				trace("로그아웃********************************");
				//_temp.text = "";
				SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.TITLE, false, null, 0.5, Transitions.EASE_OUT);
				//토스트로 로그아웃 알림
			}
		}
		
		private function onTouchShop(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_shop, TouchPhase.ENDED);
			if(touch)
			{
				_shopPopup.visible = true;
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
		
		private function onBoughtHeart(event:Event):void
		{
			trace("아이템 삼");
			
			_heart.refresh();
			_coin.refresh();
		}
		
		private function onBoughtExpBoost(event:Event):void
		{
			trace("경험치 부스트 삼");
			_itemTextField.text = "경험치 2배";
			_coin.refresh();
		}
		
		private function onTouchKeyBoard(event:KeyboardEvent):void
		{
			
			if(event.keyCode == Keyboard.BACK || event.keyCode == 8)
			{
				event.preventDefault();				
				if(!_rankPopup.visible && !_normalPopup.visible && !_customPopup.visible)
				{
					EtcExtensions.exit();
				}
				
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
				if(_shopPopup.visible)
				{
					_shopPopup.visible = false;
				}
				
				
				
			}
		}		
		
	
		
	}
}