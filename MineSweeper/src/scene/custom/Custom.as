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
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	
	import util.EmbeddedAssets;
	import util.manager.ButtonMgr;
	import util.manager.LoadMgr;
	import util.manager.SwitchActionMgr;
	import util.type.DataType;
	import util.type.DifficultyType;
	import util.type.SceneType;

	public class Custom extends DisplayObjectContainer
	{
		private var _atlas:TextureAtlas;
		
		private var _slider:Slider;
		private var _radioItem:Image;
		private var _isItemMode:Boolean;
		
		private var _data:Dictionary;
		private var _startButton:Button;
		
		public function Custom()
		{
			_atlas = LoadMgr.instance.load(EmbeddedAssets.ModeSprite, EmbeddedAssets.ModeXml);
			
			initBackground();
			
			_slider = new Slider(_atlas);
			addChild(_slider);
			
			initButton();
			
			
			
			//_radioItem = new Button(Texture.fromColor(Main.stageWidth * 0.2, Main.stageHeight * 0.1, Color.
			
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
				_slider.release();
				_slider = null;
			}
			
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
		}
		
		private function initBackground():void
		{
			var background:Image = new Image(_atlas.getTexture("background"));
			background.width = Main.stageWidth;
			background.height = Main.stageHeight;
			addChild(background);
		}
		
		private function initButton():void
		{
			var textField:TextField = new TextField(Main.stageWidth * 0.5, Main.stageHeight * 0.2);
			textField.x = Main.stageWidth * 0.3;
			textField.y = Main.stageHeight * 0.1;
			textField.alignPivot("center", "center");
			textField.text = "아이템 : ";
			textField.format.size = Main.stageWidth * 0.1;
			textField.format.bold = true;
			addChild(textField);
			
			_radioItem = new Image(_atlas.getTexture("radioItemOff"));
			_radioItem.x = Main.stageWidth * 0.7;
			_radioItem.y = Main.stageHeight * 0.1;
			_radioItem.width = Main.stageWidth * 0.3;
			_radioItem.height = _radioItem.width * 0.5;
			_radioItem.alignPivot("center", "center");
			_radioItem.addEventListener(TouchEvent.TOUCH, onTouchRadioItem);
			addChild(_radioItem);
			
			_startButton = ButtonMgr.instance.setButton(_startButton, _atlas.getTexture("button"), Main.stageWidth *0.5, Main.stageHeight * 0.8,
				Main.stageWidth * 0.5, Main.stageWidth * 0.15, "시작하기", Main.stageWidth * 0.05);
			_startButton.addEventListener(TouchEvent.TOUCH, onTouchStart);
			addChild(_startButton);
		}
		
		private function onTouchRadioItem(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_radioItem, TouchPhase.ENDED);
			if(touch)
			{
				if(_isItemMode)
				{
					_isItemMode = false;
					_radioItem.texture = _atlas.getTexture("radioItemOff");
				}
				else
				{
					_isItemMode = true;
					_radioItem.texture = _atlas.getTexture("radioItemOn");
				}
			}
		}
		
		private function onTouchStart(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_startButton, TouchPhase.ENDED);
			if(touch)
			{				
				_data = new Dictionary();
				_data[DataType.IS_ITEM_MODE] = _isItemMode;
				_data[DataType.DIFFICULTY] = DifficultyType.CUSTOM;
				_data[DataType.ROW] = _slider.row;
				_data[DataType.COL] = _slider.col;
				_data[DataType.MINE_NUM] = _slider.mineNum;
				_data[DataType.ITEM_NUM] = _slider.itemNum;
				_data[DataType.CHANCE] = _slider.chance;	
				

				SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.GAME, false, _data, 0.5, Transitions.EASE_OUT);
			}
		}
		
		private function onTouchKeyBoard(event:KeyboardEvent):void
		{
			
			if(event.keyCode == Keyboard.BACK || event.keyCode == 8)
			{
				event.preventDefault();
				//dispatchEvent(new Event(SceneType.MODE_SELECT));
				SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
				trace("[Custom] back");
			}
		}
	}
}