package scene.game.ui
{
	import scene.Main;
	
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.Color;

	public class Warning extends Sprite
	{
		private var _text:TextField;
		
		public function Warning()
		{
			_text = new TextField(Main.stageWidth, Main.stageHeight * 0.1, "NO DATA");
			_text.alignPivot("center", "center");
			_text.format.size = Main.stageWidth / 10;
			_text.format.color = Color.RED;
			_text.x = Main.stageWidth * 0.5;
			_text.y = Main.stageHeight * 0.5;
			addChild(_text);
		}
	}
}