package scene
{
	import scene.custom.Custom;
	import scene.game.Game;
	import scene.modeSelect.ModeSelect;
	import scene.stageSelect.StageSelect;
	import scene.title.Title;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	
	import util.SceneType;

	public class Main extends DisplayObjectContainer
	{
		private static var _stageWidth:int;
		private static var _stageHeight:int;
		
		private var _title:Title;
		private var _modeSelect:ModeSelect;
		private var _stageSelect:StageSelect;
		private var _custom:Custom;
		private var _game:Game;
		
		public static function get stageHeight():int{ return _stageHeight; }
		public static function get stageWidth():int{ return _stageWidth; }
		
		public function Main()
		{
			_stageWidth = Starling.current.stage.stageWidth;
			_stageHeight = Starling.current.stage.stageHeight;
			
			_title = new Title();			
			addChild(_title);
			
			_title.addEventListener(SceneType.MODE_SELECT, onChangeScene);
		}		
	

		private function onChangeScene(event:Event):void
		{
			switch(event.type)
			{
				case SceneType.MODE_SELECT :
				{
					if(_title)
					{
						_title.release();
						_title.removeEventListener(SceneType.MODE_SELECT, onChangeScene);
						removeChild(_title);
					}					
					
					_modeSelect = new ModeSelect();
					_modeSelect.addEventListener(SceneType.STAGE_SELECT, onChangeScene);
					_modeSelect.addEventListener(SceneType.CUSTOM, onChangeScene);
					addChild(_modeSelect);
					trace("ModeSelect");
					break;
				}
				
				case SceneType.STAGE_SELECT :
				{
					if(_modeSelect)
					{
						_modeSelect.release();
						_modeSelect.removeEventListener(SceneType.STAGE_SELECT, onChangeScene);
						_modeSelect.removeEventListener(SceneType.CUSTOM, onChangeScene);
						removeChild(_modeSelect);
					}
					
					_stageSelect = new StageSelect();
					_stageSelect.addEventListener(SceneType.GAME, onChangeScene);
					addChild(_stageSelect);
					trace("StageSelect");
					break;
				}
				
				case SceneType.CUSTOM : 
				{
					if(_modeSelect)
					{
						_modeSelect.release();
						_modeSelect.removeEventListener(SceneType.STAGE_SELECT, onChangeScene);
						_modeSelect.removeEventListener(SceneType.CUSTOM, onChangeScene);
						removeChild(_modeSelect);
					}
					
					_custom = new Custom();
					_custom.addEventListener(SceneType.GAME, onChangeScene);
					addChild(_custom);
					trace("Custom");
					break;
				}
				
				case SceneType.GAME :
				{
					if(_stageSelect)
					{
						_stageSelect.release();
						_stageSelect.removeEventListener(SceneType.GAME, onChangeScene);
						removeChild(_stageSelect);
						
						_game = new Game(event.data);					
						addChild(_game);
						trace("Game");
					}
					
					if(_custom)
					{
						_custom.release();
						_custom.removeEventListener(SceneType.GAME, onChangeScene);
						removeChild(_custom);
						
						_game = new Game(event.data);					
						addChild(_game);
						trace("Game");
					}
					
					
					break;
				}
					
			}
			
			
//			if(event.type == "stageSelect")
//			{
//				if(_title)
//				{
//					_title.removeEventListener("stageSelect", onChangeScene);
//					removeChild(_title);
//				}
//				
//				
//				_stageSelect = new StageSelect();
//				_stageSelect.addEventListener("game", onChangeScene);
//				addChild(_stageSelect);
//			}
//			
//			else if(event.type == "game")
//			{
//				if(_stageSelect)
//				{
//					_stageSelect.removeEventListener("game", onChangeScene);
//					removeChild(_stageSelect);
//				}
//				
//				
//				_game = new Game();
//				addChild(_game);
//			}
		}
	}
}