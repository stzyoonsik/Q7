package scene.select
{
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.text.TextField;

	public class Select extends Sprite
	{
		private var _textField:TextField;
		public function Select()
		{
			_textField = new TextField(200,100,"HI");
			_textField.border = true;
			addChild(_textField);
		}
	}
}