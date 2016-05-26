package scene.modeSelect
{
	import flash.desktop.NativeApplication;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
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
		private var _resume:Button;
		private var _normal:Button;
		private var _custom:Button;
		
		public function ModeSelect()
		{
			_resume = setButton(_resume, Main.stageWidth * 0.5, Main.stageHeight * 0.2, Main.stageWidth * 0.5, Main.stageWidth * 0.1, "이어하기", Color.SILVER);
			_normal = setButton(_normal, Main.stageWidth * 0.5, Main.stageHeight * 0.4, Main.stageWidth * 0.5, Main.stageWidth * 0.1, "일반", Color.SILVER);
			_custom = setButton(_custom, Main.stageWidth * 0.5, Main.stageHeight * 0.6, Main.stageWidth * 0.5, Main.stageWidth * 0.1, "커스텀", Color.SILVER);		
			
			_resume.addEventListener(TouchEvent.TOUCH, onTouchMode);
			_normal.addEventListener(TouchEvent.TOUCH, onTouchMode);
			_custom.addEventListener(TouchEvent.TOUCH, onTouchMode);
			
			addChild(_resume);
			addChild(_normal);
			addChild(_custom);
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
		}
		
		public function release():void
		{
			if(_resume)
			{
				_resume.removeEventListener(TouchEvent.TOUCH, onTouchMode);
				_resume = null;
			}
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
			
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
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
			var touch:Touch = event.getTouch(_resume, TouchPhase.ENDED);
			if(touch)
			{
				dispatchEvent(new Event(SceneType.GAME, false, 0));
			}
			
			touch = event.getTouch(_normal, TouchPhase.ENDED);
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
		
		private function onTouchKeyBoard(event:KeyboardEvent):void
		{
			
			if(event.keyCode == Keyboard.BACK || event.keyCode == 8)
			{
				event.preventDefault();
				//종료팝업 ane
			}
		}
	}
}