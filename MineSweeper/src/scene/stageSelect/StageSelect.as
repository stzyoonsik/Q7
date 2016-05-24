package scene.stageSelect
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	import util.SceneType;

	public class StageSelect extends Sprite
	{
		private var _textField:TextField;
		public function StageSelect()
		{
			_textField = new TextField(200,100,"초급");
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
				dispatchEvent(new Event(SceneType.GAME));
			}
			
		}
	}
}