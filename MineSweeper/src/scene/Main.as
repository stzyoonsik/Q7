package scene
{
	import scene.game.Game;
	import scene.select.Select;
	import scene.title.Title;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	public class Main extends DisplayObjectContainer
	{
		private var _title:Title;
		private var _select:Select;
		private var _game:Game;
		
		public function Main()
		{
			_title = new Title();
			addChild(_title);
			
			_title.addEventListener("select", onChangeScene);
		}
		
		private function onChangeScene(event:Event):void
		{
			if(event.type == "select")
			{
				removeChild(_title);
				
				_select = new Select();
				addChild(_select);
			}
		}
	}
}