package scene
{
	import com.freshplanet.ane.AirFacebook.Facebook;
	
	import scene.modeSelect.custom.CustomPopup;
	import scene.game.Game;
	import scene.modeSelect.ModeSelect;
	import scene.modeSelect.normal.NormalPopup;
	import scene.title.Title;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import util.UserInfo;
	import util.manager.SceneMgr;
	import util.manager.SwitchActionMgr;
	import util.type.SceneType;

	public class Main extends DisplayObjectContainer
	{
		private static var _stageWidth:int;
		private static var _stageHeight:int;
		
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
			
			SwitchActionMgr.instance.addEventListener(SceneType.TITLE, onChangeScene);
			SwitchActionMgr.instance.addEventListener(SceneType.MODE_SELECT, onChangeScene);
			SwitchActionMgr.instance.addEventListener(SceneType.GAME, onChangeScene);
			
			_title = new Title();			
			addChild(_title);
			
			_title.addEventListener(SceneType.MODE_SELECT, onChangeScene);
			
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
					
					//if(!_modeSelect)
					//{
						_modeSelect = new ModeSelect();
						_modeSelect.addEventListener(SceneType.GAME, onChangeScene);
						_modeSelect.addEventListener(SceneType.TITLE, onChangeScene);
						addChild(_modeSelect);
						trace("ModeSelect");
					//}
					//trace("모드셀렉트 visible 킴");
					//_modeSelect.visible = true;
					
				
					break;
				}
				
				case SceneType.GAME :
				{
					if(_modeSelect)
					{
						releaseModeSelect();
						//trace("모드셀렉트 visible 끔");
						//_modeSelect.visible = false;
					}
				
					_game = new Game(event.data);
					_game.addEventListener(SceneType.MODE_SELECT, onChangeScene);
					addChild(_game);
					trace("Game");
					
					break;
				}
					
			}
		}
		
//		private function releaseScenes(title:Title, modeSelect:ModeSelect = null, stageSelect:Sprite = null, custom:Sprite = null, game:Sprite = null):void
//		{
//			if(title) { releaseTitle; }
//			if(modeSelect) { releaseModeSelect; }
//			if(stageSelect) { releaseStageSelect; }
//			if(custom) { releaseCustom; }
//			if(game) { releaseGame; }
//		}
		
		private function releaseTitle():void
		{
			trace("releaseTitle");
			_title.release();
			_title.removeEventListeners();
			//_title.removeEventListener(SceneType.MODE_SELECT, onChangeScene);
			removeChild(_title);
			_title = null;
		}
		
		private function releaseModeSelect():void
		{
			_modeSelect.release();
			//_modeSelect.removeEventListener(SceneType.STAGE_SELECT, onChangeScene);
			//_modeSelect.removeEventListener(SceneType.CUSTOM, onChangeScene);
			//_modeSelect.removeEventListener(SceneType.GAME, onChangeScene);
			_modeSelect.removeEventListeners();
			removeChild(_modeSelect);
			_modeSelect = null;
		}
		
		private function releaseGame():void
		{
			_game.release();
			_game.removeEventListeners();
			//_game.removeEventListener(SceneType.MODE_SELECT, onChangeScene);
			removeChild(_game);
			_game = null;
		}
	}
}