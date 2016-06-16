package scene.modeSelect.popup.custom
{
	import flash.utils.Dictionary;
	
	import scene.Main;
	import scene.modeSelect.popup.Popup;
	
	import starling.animation.Transitions;
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	
	import util.UserInfo;
	import util.manager.DisplayObjectMgr;
	import util.manager.SwitchActionMgr;
	import util.type.DataType;
	import util.type.DifficultyType;
	import util.type.SceneType;

	public class CustomPopup extends Popup
	{
		private var _atlas:TextureAtlas;		
		
		private var _slider:Slider;
		private var _radioItem:Image;
		private var _isItemMode:Boolean;
		
		private var _data:Dictionary;
		private var _start:Button;
		
		public function CustomPopup(atlas:TextureAtlas)
		{
			_atlas = atlas;
			
			initBackground(Main.stageWidth * 0.5, Main.stageHeight * 0.5, Main.stageWidth, Main.stageHeight * 0.85);
			 
			_slider = new Slider(_atlas);
			addChild(_slider);
			
			initButton();	
			initClose(Main.stageWidth * 0.95, Main.stageHeight * 0.1, Main.stageWidth * 0.1, Main.stageWidth * 0.1);
		}
		
		public override function release():void
		{
			super.release();
			
			//if(_atlas) { _atlas.dispose(); _atlas = null; }
			if(_start) { _start.removeEventListener(TouchEvent.TOUCH, onTouchStart); _start.dispose(); _start = null;	}
			if(_slider)	{ _slider.release(); _slider = null; }			
			if(_radioItem) { _radioItem.removeEventListener(TouchEvent.TOUCH, onTouchRadioItem); _radioItem.dispose(); _radioItem = null; }
//			if(_data)
//			{
//				for(var key:String in _data)
//				{
//					_data[key] = null;
//					delete _data[key];
//				}
//				_data = null;
//			}
			removeChildren(0, this.numChildren - 1, true);
		}
		
//		private function initBackground():void
//		{
//			var quad:Quad = new Quad(Main.stageWidth, Main.stageHeight, Color.BLACK);
//			quad.alpha = 0.5;
//			addChild(quad);
//			
//			var background:Image = new Image(_atlas.getTexture("popupBg"));
//			background.width = Main.stageWidth;
//			background.height = Main.stageHeight * 0.85;
//			background.x = Main.stageWidth * 0.5;
//			background.y = Main.stageHeight * 0.5;			
//			background.alignPivot("center","center");
//			addChild(background);
//		}
		
		private function initButton():void
		{
			var textField:TextField = new TextField(Main.stageWidth * 0.5, Main.stageHeight * 0.2);
			textField.x = Main.stageWidth * 0.3;
			textField.y = Main.stageHeight * 0.2;
			textField.alignPivot("center", "center");
			textField.text = "아이템 : ";
			textField.format.size = Main.stageWidth * 0.1;
			textField.format.bold = true;
			addChild(textField);
			
			_radioItem = new Image(_atlas.getTexture("radioItemOff"));
			_radioItem.x = Main.stageWidth * 0.7;
			_radioItem.y = Main.stageHeight * 0.2;
			_radioItem.width = Main.stageWidth * 0.3;
			_radioItem.height = _radioItem.width * 0.5;
			_radioItem.alignPivot("center", "center");
			_radioItem.addEventListener(TouchEvent.TOUCH, onTouchRadioItem);
			addChild(_radioItem);
			
			_start = DisplayObjectMgr.instance.setButton(_start, _atlas.getTexture("button"), Main.stageWidth *0.5, Main.stageHeight * 0.825,
				Main.stageWidth * 0.5, Main.stageWidth * 0.15, "시작하기", Main.stageWidth * 0.05);
			_start.addEventListener(TouchEvent.TOUCH, onTouchStart);
			addChild(_start);
			
//			_close = DisplayObjectMgr.instance.setButton(_close, _atlas.getTexture("close"), 
//				Main.stageWidth * 0.95, Main.stageHeight * 0.1, Main.stageWidth * 0.1, Main.stageWidth * 0.1);
//			_close.addEventListener(TouchEvent.TOUCH, onTouchClose);
//			addChild(_close);
		}
		
		private function onTouchClose(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_close, TouchPhase.ENDED);
			if(touch)
			{
				this.visible = false;
			}
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
				_slider.blockItem(_isItemMode);
			}
		}
		
		private function onTouchStart(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_start, TouchPhase.ENDED);
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
				
				if(UserInfo.heart > 0)
					SwitchActionMgr.instance.switchSceneFadeOut(this.parent, SceneType.GAME, false, _data, 0.5, Transitions.EASE_OUT);
			}
		}
	}
}