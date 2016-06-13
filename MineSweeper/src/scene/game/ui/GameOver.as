package scene.game.ui
{
	import scene.Main;
	
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.Color;

	public class GameOver extends Sprite
	{
		private var _textField:TextField;
		
		public function GameOver()
		{		
			_textField = new TextField(Main.stageWidth, Main.stageHeight * 0.1, "GAME OVER");
			_textField.alignPivot("center", "center");
			_textField.format.size = Main.stageWidth * 0.125;
			_textField.format.color = Color.RED;
			_textField.x = Main.stageWidth * 0.5;
			_textField.y = Main.stageHeight * 0.25;
			addChild(_textField);
		}
		
		public function release():void
		{
			if(_textField)
			{
				_textField = null;
				removeChild(_textField);
			}
		}

		public function get textField():TextField
		{
			return _textField;
		}

		public function set textField(value:TextField):void
		{
			_textField = value;
		}

	}
}