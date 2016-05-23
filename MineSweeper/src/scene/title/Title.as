package scene.title
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;

	public class Title extends Sprite
	{
		private var _textField:TextField;
		public function Title()
		{
			_textField = new TextField(200,100,"click");
			_textField.border = true;
			_textField.addEventListener(TouchEvent.TOUCH, onTouchTextField);
			addChild(_textField);
		}
		
		private function onTouchTextField(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_textField, TouchPhase.ENDED);
			if(touch)
			{
				dispatchEvent(new Event("select"));
			}
			
		}
	}
}