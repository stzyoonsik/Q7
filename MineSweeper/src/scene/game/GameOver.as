package scene.game
{
	import scene.Main;
	
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.Color;

	public class GameOver extends Sprite
	{
		private var _text:TextField;
		
		public function GameOver()
		{
			_text = new TextField(Main.stageWidth, Main.stageHeight * 0.1, "GAME OVER");
			_text.alignPivot("center", "center");
			_text.format.size = Main.stageWidth / 10;
			_text.format.color = Color.RED;
			_text.x = Main.stageWidth * 0.5;
			_text.y = Main.stageHeight * 0.15;
			addChild(_text);
		}

		public function get text():TextField
		{
			return _text;
		}

		public function set text(value:TextField):void
		{
			_text = value;
		}

	}
}