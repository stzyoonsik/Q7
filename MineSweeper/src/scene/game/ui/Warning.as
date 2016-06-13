package scene.game.ui
{
	import scene.Main;
	
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.Color;

	public class Warning extends Sprite
	{
		private var _textField:TextField;
		
		public function Warning()
		{
			_textField = new TextField(Main.stageWidth, Main.stageHeight * 0.1, "NO DATA");
			_textField.alignPivot("center", "center");
			_textField.format.size = Main.stageWidth / 10;
			_textField.format.color = Color.RED;
			_textField.x = Main.stageWidth * 0.5;
			_textField.y = Main.stageHeight * 0.5;
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
	}
}