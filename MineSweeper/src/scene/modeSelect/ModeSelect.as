package scene.modeSelect
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	import util.SceneType;

	public class ModeSelect extends Sprite
	{
		private var _normal:TextField;
		private var _custom:TextField;
		
		public function ModeSelect()
		{
			_normal = new TextField(200,100,"일반");
			_normal.border = true;
			_normal.addEventListener(TouchEvent.TOUCH, onTouchTextField);
			addChild(_normal);
			
			_custom = new TextField(200,100,"사용자 정의");
			_custom.y = 300;
			_custom.border = true;
			_custom.addEventListener(TouchEvent.TOUCH, onTouchTextField);
			addChild(_custom);
			
		}
		
		public function release():void
		{
			if(_normal)
			{
				_normal.removeEventListener(TouchEvent.TOUCH, onTouchTextField);
				_normal = null;
				
			}
			if(_custom)
			{
				_custom.removeEventListener(TouchEvent.TOUCH, onTouchTextField);
				_custom = null;
				
			}
			
		}
		
		private function onTouchTextField(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_normal, TouchPhase.ENDED);
			if(touch)
			{
				dispatchEvent(new Event(SceneType.STAGE_SELECT));
			}
			
			touch = event.getTouch(_custom, TouchPhase.ENDED);
			if(touch)
			{
				dispatchEvent(new Event(SceneType.CUSTOM));
			}
			
		}
	}
}