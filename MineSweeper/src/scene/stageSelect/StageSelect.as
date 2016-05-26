package scene.stageSelect
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

	public class StageSelect extends Sprite
	{
		private var _veryEasy:Button;
		private var _easy:Button;
		private var _normal:Button;
		private var _hard:Button;
		private var _veryHard:Button;
		
		private var _maxRow:int;
		private var _maxCol:int;
		private var _numberOfMine:int;
		private var _numberOfMineFinder:int;
		private var _chanceToGetItem:int;
		
		private var _data:Vector.<int>;
		
		public function StageSelect()
		{
			_veryEasy = setButton(_veryEasy, Main.stageWidth * 0.5, Main.stageHeight * 0.3, Main.stageWidth * 0.5, Main.stageWidth * 0.1, "매우 쉬움", Color.SILVER);
			_easy     = setButton(_easy, Main.stageWidth * 0.5, Main.stageHeight * 0.4, Main.stageWidth * 0.5, Main.stageWidth * 0.1, "쉬움", Color.SILVER);
			_normal   = setButton(_normal, Main.stageWidth * 0.5, Main.stageHeight * 0.5, Main.stageWidth * 0.5, Main.stageWidth * 0.1, "보통", Color.SILVER);
			_hard     = setButton(_hard, Main.stageWidth * 0.5, Main.stageHeight * 0.6, Main.stageWidth * 0.5, Main.stageWidth * 0.1, "어려움", Color.SILVER);
			_veryHard = setButton(_veryHard, Main.stageWidth * 0.5, Main.stageHeight * 0.7, Main.stageWidth * 0.5, Main.stageWidth * 0.1, "매우 어려움", Color.SILVER);
			
			_veryEasy.addEventListener(TouchEvent.TOUCH, onTouchVeryEasy);
			_easy.addEventListener(TouchEvent.TOUCH, onTouchEasy);
			_normal.addEventListener(TouchEvent.TOUCH, onTouchNormal);
			_hard.addEventListener(TouchEvent.TOUCH, onTouchHard);
			_veryHard.addEventListener(TouchEvent.TOUCH, onTouchVeryHard);
			
			addChild(_veryEasy);
			addChild(_easy);
			addChild(_normal);
			addChild(_hard);
			addChild(_veryHard);
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
		}
		
		public function release():void
		{
//			if(_textField)
//			{
//				_textField.removeEventListener(TouchEvent.TOUCH, onTouchTextField);
//				_textField = null;
//				
//			}		
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
		
		private function setData(row:int, col:int, mineNum:int, itemNum:int, chance:int):void
		{
			_maxRow = row;
			_maxCol = col;
			_numberOfMine = mineNum;
			_numberOfMineFinder = itemNum;
			_chanceToGetItem = chance;
			
			_data = new Vector.<int>();
			_data.push(_maxRow);
			_data.push(_maxCol);
			_data.push(_numberOfMine);
			_data.push(_numberOfMineFinder);
			_data.push(_chanceToGetItem);
		}
		
				
		private function onTouchVeryEasy(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_veryEasy, TouchPhase.ENDED);
			if(touch)
			{
				setData(8, 8, 8, 2, 10);
				dispatchEvent(new Event(SceneType.GAME, false, _data));
			}
			
		}
		
		private function onTouchEasy(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_easy, TouchPhase.ENDED);
			if(touch)
			{
				setData(10, 10, 15, 2, 8);
				dispatchEvent(new Event(SceneType.GAME, false, _data));
			}
			
		}
		
		private function onTouchNormal(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_normal, TouchPhase.ENDED);
			if(touch)
			{
				setData(15, 15, 40, 2, 7);
				dispatchEvent(new Event(SceneType.GAME, false, _data));
			}
			
		}
		
		private function onTouchHard(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_hard, TouchPhase.ENDED);
			if(touch)
			{
				setData(20, 20, 80, 2, 6);
				dispatchEvent(new Event(SceneType.GAME, false, _data));
			}
			
		}
		
		private function onTouchVeryHard(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_veryHard, TouchPhase.ENDED);
			if(touch)
			{
				setData(25, 25, 150, 2, 5);
				dispatchEvent(new Event(SceneType.GAME, false, _data));
			}
			
		}
		
		private function onTouchKeyBoard(event:KeyboardEvent):void
		{
			
			if(event.keyCode == Keyboard.BACK || event.keyCode == 8)
			{
				event.preventDefault();
				dispatchEvent(new Event(SceneType.MODE_SELECT));
			}
		}
		
		
	}
}