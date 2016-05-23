package scene
{
	import scene.game.Game;
	import scene.select.Select;
	import scene.title.Title;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	public class Main extends DisplayObjectContainer
	{
		private static var _stageWidth:int;
		private static var _stageHeight:int;
		
		private var _title:Title;
		private var _select:Select;
		private var _game:Game;
		
		public static function get stageHeight():int{ return _stageHeight; }
		public static function get stageWidth():int{ return _stageWidth; }
		
		public function Main()
		{
			_stageWidth = Starling.current.stage.stageWidth;
			_stageHeight = Starling.current.stage.stageHeight;
			
			_title = new Title();			addChild(_title);
			
			_title.addEventListener("select", onChangeScene);
		}		
	

		private function onChangeScene(event:Event):void
		{
			if(event.type == "select")
			{
				if(_title)
				{
					_title.removeEventListener("select", onChangeScene);
					removeChild(_title);
				}
				
				
				_select = new Select();
				_select.addEventListener("game", onChangeScene);
				addChild(_select);
			}
			
			else if(event.type == "game")
			{
				if(_select)
				{
					_select.removeEventListener("game", onChangeScene);
					removeChild(_select);
				}
				
				
				_game = new Game();
				addChild(_game);
			}
		}
	}
}