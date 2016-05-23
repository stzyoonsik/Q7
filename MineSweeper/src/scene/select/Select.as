package scene.select
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;

	public class Select extends Sprite
	{
		private var _textField:TextField;
		public function Select()
		{
			_textField = new TextField(200,100,"초급");
			_textField.border = true;
			_textField.addEventListener(TouchEvent.TOUCH, onTouchTextField);
			addChild(_textField);
			
		}
		
		private function onTouchTextField(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_textField, TouchPhase.ENDED);
			if(touch)
			{
				dispatchEvent(new Event("game"));
			}
			
		}
	}
}