package scene
{
	import scene.game.Game;
	import scene.modeSelect.ModeSelect;
	import scene.modeSelect.popup.custom.CustomPopup;
	import scene.modeSelect.popup.normal.NormalPopup;
	import scene.title.Title;
	
	import server.UserDBMgr;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	
	import loading.resource.SoundLoader;
	import loading.resource.SpriteSheetLoader;
	import util.UserInfo;
	import util.manager.SwitchActionMgr;
	import util.type.SceneType;
	import loading.Loading;

	public class Main extends DisplayObjectContainer
	{
		private static var _stageWidth:int;
		private static var _stageHeight:int;
		
		private var _isSpriteSheetLoaded:Boolean;
		private var _isSoundLoaded:Boolean;
		
		private var _loading:Loading;
		private var _title:Title;
		private var _modeSelect:ModeSelect;
		private var _stageSelect:NormalPopup;
		private var _custom:CustomPopup;
		private var _game:Game;
		

		public static function get stageHeight():int{ return _stageHeight; }
		public static function get stageWidth():int{ return _stageWidth; }
		
		public function Main()
		{
			_stageWidth = Starling.current.stage.stageWidth;
			_stageHeight = Starling.current.stage.stageHeight;
			
			
			_loading = new Loading();
			addChild(_loading);
			
			var soundLoader:SoundLoader = new SoundLoader();
			soundLoader.addEventListener("completeLoadingSound", onCompleteLoadingSound);
			soundLoader.addEventListener("progressLoading", onProgressLoading);
			
			var spriteSheetLoader:SpriteSheetLoader = new SpriteSheetLoader();
			spriteSheetLoader.addEventListener("completeLoadingSpriteSheet", onCompleteLoadingSpriteSheet);
			spriteSheetLoader.addEventListener("progressLoading", onProgressLoading);
			
			_loading.maxCount = soundLoader.getFileCount() + spriteSheetLoader.getFileCount();
			
			SwitchActionMgr.instance.addEventListener(SceneType.TITLE, onChangeScene);
			SwitchActionMgr.instance.addEventListener(SceneType.MODE_SELECT, onChangeScene);
			SwitchActionMgr.instance.addEventListener(SceneType.GAME, onChangeScene);
		}	
		
		private function onProgressLoading(event:Event):void
		{
			_loading.refresh();
		}
		
		private function onCompleteLoadingSound(event:Event):void
		{		
			_isSoundLoaded = true;
			
			event.currentTarget.removeEventListener("completeLoadingSound", onCompleteLoadingSound);
			
			checkDone();
		}
		
		private function onCompleteLoadingSpriteSheet(event:Event):void
		{
			_isSpriteSheetLoaded = true;
			
			event.currentTarget.removeEventListener("completeLoadingSpriteSheet", onCompleteLoadingSpriteSheet);
			
			checkDone();
		}
		
		private function checkDone():void
		{
			if(_isSpriteSheetLoaded && _isSoundLoaded)
			{
				_loading.release();
				_loading = null;
				removeChild(_loading);
				
				
				_title = new Title();			
				addChild(_title);
				
				_title.addEventListener(SceneType.MODE_SELECT, onChangeScene);
			}
			
		}

		private function onChangeScene(event:Event):void
		{
			switch(event.type)
			{
				case SceneType.TITLE :
				{
					if(_modeSelect)
					{
						releaseModeSelect();
					}
					_title = new Title();	
					_title.addEventListener(SceneType.MODE_SELECT, onChangeScene);
					addChild(_title);
					break;	
				}
					
				case SceneType.MODE_SELECT :
				{
					if(_title)
					{												
						_title.release();
						_title.removeEventListener(SceneType.MODE_SELECT, onChangeScene);
						removeChild(_title);
						_title = null;
					}			
					if(_game)
					{
						releaseGame();
					}
					_modeSelect = new ModeSelect();
					_modeSelect.addEventListener(SceneType.GAME, onChangeScene);
					_modeSelect.addEventListener(SceneType.TITLE, onChangeScene);
					addChild(_modeSelect);
					trace("ModeSelect");
					break;
				}
				
				case SceneType.GAME :
				{
					if(_modeSelect)
					{
						releaseModeSelect();
					}
				
					_game = new Game(event.data);
					_game.addEventListener(SceneType.MODE_SELECT, onChangeScene);
					addChild(_game);
					trace("Game");
					
					UserInfo.lastDate = new Date().getTime();
					UserDBMgr.instance.updateData(UserInfo.id, "lastDate", UserInfo.lastDate);
					UserDBMgr.instance.updateData(UserInfo.id, "heartTime", UserInfo.remainHeartTime);
					UserInfo.heart--;
					UserDBMgr.instance.updateData(UserInfo.id, "heart", UserInfo.heart);
					
					break;
				}
					
			}
		}
		
		private function releaseTitle():void
		{
			trace("releaseTitle");
			_title.release();
			_title.removeEventListeners();
			removeChild(_title);
			_title = null;
		}
		
		private function releaseModeSelect():void
		{
			_modeSelect.release();
			_modeSelect.removeEventListeners();
			removeChild(_modeSelect);
			_modeSelect = null;
		}
		
		private function releaseGame():void
		{
			_game.release();
			_game.removeEventListeners();
			removeChild(_game);
			_game = null;
		}
	}
}