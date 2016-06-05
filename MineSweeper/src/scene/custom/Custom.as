package scene.custom
{
	import flash.desktop.NativeApplication;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import scene.Main;
	
	import starling.animation.Transitions;
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	import util.manager.SwitchActionMgr;
	import util.type.DataType;
	import util.type.DifficultyType;
	import util.type.SceneType;

	public class Custom extends DisplayObjectContainer
	{
		private var _slider:Slider;
		
//		private var _maxRow:int;
//		private var _maxCol:int;
//		private var _numberOfMine:int;
//		private var _numberOfMineFinder:int;
//		private var _chanceToGetItem:int;
		
		//private var _data:Vector.<int>;
		private var _data:Dictionary;
		private var _startButton:Button;
		
		public function Custom()
		{
			_slider = new Slider();
			addChild(_slider);
			
			var texture:Texture = Texture.fromColor(100, 50, Color.GRAY);
			_startButton = new Button(texture, "START");
			_startButton.alignPivot("center", "center");
			_startButton.x = Main.stageWidth / 2;
			_startButton.y = Main.stageHeight * 0.8;
			_startButton.addEventListener(TouchEvent.TOUCH, onTouchStart);
			addChild(_startButton);
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
			
		}
		
		public function release():void
		{
			if(_startButton)
			{
				_startButton.removeEventListener(TouchEvent.TOUCH, onTouchStart);
				_startButton = null;				
			}
			if(_slider)
			{				
				_slider = null;
			}
			
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
		}
		
		private function onTouchStart(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_startButton, TouchPhase.ENDED);
			if(touch)
			{
//				_maxRow = _slider.row;
//				_maxCol = _slider.col;
//				_numberOfMine = _slider.mineNum;
//				_numberOfMineFinder = _slider.itemNum;
//				_chanceToGetItem = _slider.chance;				
				
				_data = new Dictionary();
				_data[DataType.DIFFICULTY] = DifficultyType.CUSTOM;
				_data[DataType.ROW] = _slider.row;
				_data[DataType.COL] = _slider.col;
				_data[DataType.MINE_NUM] =  _slider.mineNum;
				_data[DataType.ITEM_NUM] = _slider.itemNum;
				_data[DataType.CHANCE] = _slider.chance;	
				
//				_data = new Vector.<int>();
//				_data.push(_maxRow);
//				_data.push(_maxCol);
//				_data.push(_numberOfMine);
//				_data.push(_numberOfMineFinder);
//				_data.push(_chanceToGetItem);
//				_data.push(0);
//				_data.push(0);
//				_data.push(0);
//				_data.push(0);
//				_data.push(5);
				
				//dispatchEvent(new Event(SceneType.GAME, false, _data));
				SwitchActionMgr.instance.switchScenefadeOut(this, SceneType.GAME, false, _data, 0.5, Transitions.EASE_OUT);
			}
		}
		
		private function onTouchKeyBoard(event:KeyboardEvent):void
		{
			
			if(event.keyCode == Keyboard.BACK || event.keyCode == 8)
			{
				event.preventDefault();
				dispatchEvent(new Event(SceneType.MODE_SELECT));
				SwitchActionMgr.instance.switchScenefadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
				trace("[Custom] back");
			}
		}
	}
}