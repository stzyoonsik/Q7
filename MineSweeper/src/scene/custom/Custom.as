package scene.custom
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

	public class Custom extends Sprite
	{
		private var _slider:Slider;
		
		private var _maxRow:int;
		private var _maxCol:int;
		private var _numberOfMine:int;
		private var _numberOfMineFinder:int;
		private var _chanceToGetItem:int;
		
		private var _data:Vector.<int>;
		
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
		}
		
		private function onTouchStart(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_startButton, TouchPhase.ENDED);
			if(touch)
			{
				_maxRow = _slider.row;
				_maxCol = _slider.col;
				_numberOfMine = _slider.mineNum;
				_numberOfMineFinder = _slider.itemNum;
				_chanceToGetItem = _slider.chance;				
				
				_data = new Vector.<int>();
				_data.push(_maxCol);
				_data.push(_maxRow);
				_data.push(_numberOfMine);
				_data.push(_numberOfMineFinder);
				_data.push(_chanceToGetItem);
				
				dispatchEvent(new Event(SceneType.GAME, false, _data));
			}
		}
	}
}