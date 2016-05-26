package scene.modeSelect
{
	import scene.Main;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	import util.SceneType;

	public class ModeSelect extends Sprite
	{
		private var _normal:Button;
		private var _custom:Button;
		
		public function ModeSelect()
		{
			_normal = setButton(_normal, Main.stageWidth * 0.5, Main.stageHeight * 0.3, Main.stageWidth * 0.5, Main.stageWidth * 0.1, "일반", Color.SILVER);
			_custom = setButton(_custom, Main.stageWidth * 0.5, Main.stageHeight * 0.5, Main.stageWidth * 0.5, Main.stageWidth * 0.1, "커스텀", Color.SILVER);		
			
			_normal.addEventListener(TouchEvent.TOUCH, onTouchMode);
			_custom.addEventListener(TouchEvent.TOUCH, onTouchMode);
			
			addChild(_normal);
			addChild(_custom);
		}
		
		public function release():void
		{
			if(_normal)
			{
				_normal.removeEventListener(TouchEvent.TOUCH, onTouchMode);
				_normal = null;				
			}
			if(_custom)
			{
				_custom.removeEventListener(TouchEvent.TOUCH, onTouchMode);
				_custom = null;				
			}
			
		}
		
		private function setButton(button:Button, x:int, y:int, width:int, height:int, text:String, color:uint):Button
		{
			var texture:Texture = Texture.fromColor(width, height, color);
			button = new Button(texture, text);
			button.alignPivot("center", "center");
			button.x = x;
			button.y = y;
			
			return button;
		}
		
		private function onTouchMode(event:TouchEvent):void
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