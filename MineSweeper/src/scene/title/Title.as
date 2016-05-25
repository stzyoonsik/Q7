package scene.title
{
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	import util.SceneType;

	public class Title extends DisplayObjectContainer
	{
		private var _textField:TextField;
		
		public function Title()
		{
			_textField = new TextField(200,100, "click");
			_textField.autoScale = true;
			_textField.border = true;
			_textField.addEventListener(TouchEvent.TOUCH, onTouchTextField);
			addChild(_textField);
		}
		
		public function release():void
		{
			if(_textField)
			{
				_textField.removeEventListener(TouchEvent.TOUCH, onTouchTextField);
				_textField = null;
				
			}
		}
		
		private function onTouchTextField(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_textField, TouchPhase.ENDED);
			if(touch)
			{
				dispatchEvent(new Event(SceneType.MODE_SELECT));
			}
			
		}
		
	}
}