package scene.custom
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	import util.SceneType;

	public class Custom extends Sprite
	{
		private var _maxRow:int;
		private var _maxCol:int;
		private var _numberOfMine:int;
		private var _numberOfMineFinder:int;
		
		private var _data:Vector.<int>;
		
		private var _textField:TextField;
		
		public function Custom()
		{
			_maxRow = 10;
			_maxCol = 10;
			_numberOfMine = 10;
			_numberOfMineFinder = 3;
			
			_textField = new TextField(200,100, "START");
			_textField.border = true;
			_textField.y = 200;
			_textField.addEventListener(TouchEvent.TOUCH, onTouchStart);
			addChild(_textField);
			
			_data = new Vector.<int>();
			_data.push(_maxCol);
			_data.push(_maxRow);
			_data.push(_numberOfMine);
			_data.push(_numberOfMineFinder);
		}
		
		public function release():void
		{
			if(_textField)
			{
				_textField.removeEventListener(TouchEvent.TOUCH, onTouchStart);
				_textField = null;
				
			}
		}
		
		private function onTouchStart(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_textField, TouchPhase.ENDED);
			if(touch)
			{
				dispatchEvent(new Event(SceneType.GAME, false, _data));
			}
		}
	}
}