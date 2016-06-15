package scene.modeSelect.popup.custom
{
	import flash.geom.Point;
	
	import scene.Main;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	
	import util.manager.DisplayObjectMgr;

	public class Slider extends Sprite
	{
		private var _atlas:TextureAtlas;
		private const MIN_ROW:int = 2;
		private const MIN_COL:int = 2;
		private const MIN_MINE_NUM:int = 1;
		private const MIN_ITEM_NUM:int = 0;
		private const MIN_CHANCE:int = 0;
		
		private const MAX_ROW:int = 30;
		private const MAX_COL:int = 30;
		private var _maxMineNum:int;
		private var _maxItemNum:int;
		private const MAX_CHANCE:int = 100;
		
		private var _row:int;
		private var _col:int;
		private var _mineNum:int;
		private var _itemNum:int;
		private var _chance:int;
		
		private var _rowText:TextField;
		private var _colText:TextField;
		private var _mineNumText:TextField;
		private var _itemNumText:TextField;
		private var _chanceText:TextField;
		
		private var _rowValue:TextField;
		private var _colValue:TextField;
		private var _mineNumValue:TextField;
		private var _itemNumValue:TextField;
		private var _chanceValue:TextField;
		
		private var _rowBar:Image;
		private var _colBar:Image;
		private var _mineBar:Image;
		private var _itemBar:Image;
		private var _chanceBar:Image;
		
		private var _rowSlider:Button;
		private var _colSlider:Button;
		private var _mineSlider:Button;
		private var _itemSlider:Button;
		private var _chanceSlider:Button;
		
		
		public function get chance():int { return _chance; }
		
		public function get itemNum():int {	return _itemNum; }
		
		public function get mineNum():int { return _mineNum; }
		
		public function get col():int {	return _col; }
		
		public function get row():int {	return _row; }
		
		public function Slider(atlas:TextureAtlas)
		{
			_atlas = atlas;
			
			_row = 16;
			_col = 16;
			_mineNum = (_row * _col) / 2;
			_itemNum = Math.round(_row * _col / 40);
			_chance = 50;
			_maxMineNum = setMaxMineNum(_row, _col);
			_maxItemNum = setMaxItemNum(_row, _col);
			
			
			initQuad();
			initTextField();
		}
		
		public function release():void
		{
			
		}
		
		public function blockItem(value:Boolean):void
		{
			_itemNumValue.visible = value;
			_chanceValue.visible = value;
			_itemNumText.visible = value;
			_chanceText.visible = value;
			
			_itemBar.visible = value;
			_chanceBar.visible = value;
			_itemSlider.visible = value;
			_chanceSlider.visible = value;
		}
		
		

		private function initQuad():void
		{
			_rowBar = DisplayObjectMgr.instance.setImage(_atlas.getTexture("bar"), Main.stageWidth * 0.5, Main.stageHeight * 0.3,
														Main.stageWidth * 0.5, Main.stageWidth * 0.05, "center", "center");
			_colBar = DisplayObjectMgr.instance.setImage(_atlas.getTexture("bar"), Main.stageWidth * 0.5, Main.stageHeight * 0.4,
				Main.stageWidth * 0.5, Main.stageWidth * 0.05, "center", "center");
			_mineBar = DisplayObjectMgr.instance.setImage(_atlas.getTexture("bar"), Main.stageWidth * 0.5, Main.stageHeight * 0.5,
				Main.stageWidth * 0.5, Main.stageWidth * 0.05, "center", "center");
			_itemBar = DisplayObjectMgr.instance.setImage(_atlas.getTexture("bar"), Main.stageWidth * 0.5, Main.stageHeight * 0.6,
				Main.stageWidth * 0.5, Main.stageWidth * 0.05, "center", "center");
			_chanceBar = DisplayObjectMgr.instance.setImage(_atlas.getTexture("bar"), Main.stageWidth * 0.5, Main.stageHeight * 0.7,
				Main.stageWidth * 0.5, Main.stageWidth * 0.05, "center", "center");
			
			_itemBar.visible = false;
			_chanceBar.visible = false;
			
			addChild(_rowBar);
			addChild(_colBar);
			addChild(_mineBar);
			addChild(_itemBar);
			addChild(_chanceBar);
			
			_rowSlider = DisplayObjectMgr.instance.setButton(_rowSlider, _atlas.getTexture("sliderButton"), Main.stageWidth * 0.5, Main.stageHeight * 0.3, Main.stageWidth * 0.1, Main.stageWidth * 0.1);
			_colSlider = DisplayObjectMgr.instance.setButton(_colSlider, _atlas.getTexture("sliderButton"), Main.stageWidth * 0.5, Main.stageHeight * 0.4, Main.stageWidth * 0.1, Main.stageWidth * 0.1);
			_mineSlider = DisplayObjectMgr.instance.setButton(_mineSlider, _atlas.getTexture("sliderButton"), Main.stageWidth * 0.5, Main.stageHeight * 0.5, Main.stageWidth * 0.1, Main.stageWidth * 0.1);
			_itemSlider = DisplayObjectMgr.instance.setButton(_itemSlider, _atlas.getTexture("sliderButton"), Main.stageWidth * 0.5, Main.stageHeight * 0.6, Main.stageWidth * 0.1, Main.stageWidth * 0.1);
			_chanceSlider = DisplayObjectMgr.instance.setButton(_chanceSlider, _atlas.getTexture("sliderButton"), Main.stageWidth * 0.5, Main.stageHeight * 0.7, Main.stageWidth * 0.1, Main.stageWidth * 0.1);
			
			_itemSlider.visible = false;
			_chanceSlider.visible = false;
			
			addChild(_rowSlider);
			addChild(_colSlider);
			addChild(_mineSlider);
			addChild(_itemSlider);
			addChild(_chanceSlider);
			
			_rowSlider.addEventListener(TouchEvent.TOUCH, onTouchRowSlider);
			_colSlider.addEventListener(TouchEvent.TOUCH, onTouchColSlider);
			_mineSlider.addEventListener(TouchEvent.TOUCH, onTouchMineSlider);
			_itemSlider.addEventListener(TouchEvent.TOUCH, onTouchItemSlider);
			_chanceSlider.addEventListener(TouchEvent.TOUCH, onTouchChanceSlider);
		}
		
		private function initTextField():void
		{
			_rowText     = setTextField(_rowText, Main.stageWidth * 0.125, Main.stageHeight * 0.3, Main.stageWidth * 0.15, Main.stageHeight * 0.05, "가로", Main.stageWidth * 0.025, true);
			_colText 	 = setTextField(_colText, Main.stageWidth * 0.125, Main.stageHeight * 0.4, Main.stageWidth * 0.15, Main.stageHeight * 0.05, "세로", Main.stageWidth * 0.025, true);
			_mineNumText = setTextField(_mineNumText, Main.stageWidth * 0.125, Main.stageHeight * 0.5, Main.stageWidth * 0.15, Main.stageHeight * 0.05, "지뢰 갯수", Main.stageWidth * 0.025, true);
			_itemNumText = setTextField(_itemNumText, Main.stageWidth * 0.125, Main.stageHeight * 0.6, Main.stageWidth * 0.15, Main.stageHeight * 0.05, "아이템 갯수", Main.stageWidth * 0.025, true);
			_chanceText  = setTextField(_chanceText, Main.stageWidth * 0.125, Main.stageHeight * 0.7, Main.stageWidth * 0.15, Main.stageHeight * 0.05, "아이템 확률", Main.stageWidth * 0.025, true);
			
			_itemNumText.visible = false;
			_chanceText.visible = false;
			
			addChild(_rowText);
			addChild(_colText);
			addChild(_mineNumText);
			addChild(_itemNumText);
			addChild(_chanceText);
			
			
			
			_rowValue	  = setTextField(_rowValue, Main.stageWidth * 0.875, Main.stageHeight * 0.3, Main.stageWidth * 0.15, Main.stageHeight * 0.05, _row.toString(), Main.stageWidth * 0.05, true);
			_colValue 	  = setTextField(_colValue, Main.stageWidth * 0.875, Main.stageHeight * 0.4, Main.stageWidth * 0.15, Main.stageHeight * 0.05, _col.toString(), Main.stageWidth * 0.05, true);
			_mineNumValue = setTextField(_mineNumValue, Main.stageWidth * 0.875, Main.stageHeight * 0.5, Main.stageWidth * 0.15, Main.stageHeight * 0.05, _mineNum.toString(), Main.stageWidth * 0.05, true);
			_itemNumValue = setTextField(_itemNumValue, Main.stageWidth * 0.875, Main.stageHeight * 0.6, Main.stageWidth * 0.15, Main.stageHeight * 0.05, _itemNum.toString(), Main.stageWidth * 0.05, true);
			_chanceValue  = setTextField(_chanceValue, Main.stageWidth * 0.875, Main.stageHeight * 0.7, Main.stageWidth * 0.15, Main.stageHeight * 0.05, _chance.toString(), Main.stageWidth * 0.05, true);
			
			_itemNumValue.visible = false;
			_chanceValue.visible = false;
			
			addChild(_rowValue);
			addChild(_colValue);
			addChild(_mineNumValue);
			addChild(_itemNumValue);
			addChild(_chanceValue);
		}
		
		private function setTextField(textField:TextField, x:int, y:int, width:int, height:int, text:String, textSize:int, border:Boolean):TextField
		{
			var tf:TextField = textField;
			tf = new TextField(width, height, "");				
			tf.border = border;
			tf.text = text;
			tf.format.size = textSize;
			tf.x = x;
			tf.y = y;
			tf.alignPivot("center", "center");
			
			
			return tf;
		}
		
		 
		
		private function onTouchRowSlider(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_rowSlider, TouchPhase.MOVED);
			if(touch)
			{
				moveSlider(touch, touch.target);
				_row = changeValue(touch.target, MIN_ROW, MAX_ROW);
				_rowValue.text = _row.toString();		
				
				_maxMineNum = setMaxMineNum(_row, _col);
				_maxItemNum = setMaxItemNum(_row, _col);
				
				checkMineNumAndItemNum();
				
				_mineSlider.x = replaceSlider(_mineSlider, _mineNum, MIN_MINE_NUM, _maxMineNum);	
				_itemSlider.x = replaceSlider(_itemSlider, _itemNum, MIN_ITEM_NUM, _maxItemNum);
			}
		}
		
		private function onTouchColSlider(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_colSlider, TouchPhase.MOVED);
			if(touch)
			{
				moveSlider(touch, touch.target);
				_col = changeValue(touch.target, MIN_COL, MAX_COL);
				_colValue.text = _col.toString();
				_maxMineNum = setMaxMineNum(_row, _col);
				_maxItemNum = setMaxItemNum(_row, _col);
				checkMineNumAndItemNum();
				
				_mineSlider.x = replaceSlider(_mineSlider, _mineNum, MIN_MINE_NUM, _maxMineNum);
				_itemSlider.x = replaceSlider(_itemSlider, _itemNum, MIN_ITEM_NUM, _maxItemNum);
			}
		}
		
		private function onTouchMineSlider(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_mineSlider, TouchPhase.MOVED);
			if(touch)
			{
				moveSlider(touch, touch.target);
				_mineNum = changeValue(touch.target, MIN_MINE_NUM, _maxMineNum);
				_mineNumValue.text = _mineNum.toString();
			}
		}
		
		private function onTouchItemSlider(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_itemSlider, TouchPhase.MOVED);
			if(touch)
			{
				moveSlider(touch, touch.target);
				_itemNum = changeValue(touch.target, MIN_ITEM_NUM, _maxItemNum);
				_itemNumValue.text = _itemNum.toString();
			}
		}
		
		private function onTouchChanceSlider(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_chanceSlider, TouchPhase.MOVED);
			if(touch)
			{
				moveSlider(touch, touch.target);
				_chance = changeValue(touch.target, MIN_CHANCE, MAX_CHANCE);
				_chanceValue.text = _chance.toString();
			}
		}
		
		private function moveSlider(touch:Touch, target:DisplayObject):void
		{
			var currentPos:Point = touch.getLocation(parent);
			var previousPos:Point = touch.getPreviousLocation(parent);
			var delta:Point = currentPos.subtract(previousPos);
			
			target.x += delta.x;
			
			if(target.x < Main.stageWidth * 0.25)
			{
				target.x = Main.stageWidth * 0.25;
			}
			
			if(target.x > Main.stageWidth * 0.75)
			{
				target.x = Main.stageWidth * 0.75;
			}
		}
		
		private function setMaxMineNum(row:int, col:int):int
		{
			return (row * col) - 1;
		}
		
		private function setMaxItemNum(row:int, col:int):int
		{
			return (row * col) / 20;
		}
		
		private function changeValue(target:DisplayObject, min:int, max:int):int
		{			
			var value:Number = (target.x - Main.stageWidth * 0.25) / Main.stageWidth * 2;
			value = Math.round((value * (max - min)) + min);			
			
			return value;
		}
		
		private function replaceSlider(target:DisplayObject, value:int, min:int, max:int):Number
		{
			var result:Number = value / max;
			result = (result * Main.stageWidth * 0.5) + Main.stageWidth * 0.25;
			
			return result;	
		}
		
		private function checkMineNumAndItemNum():void
		{
			if(_mineNum > _maxMineNum)
			{
				_mineNum = _maxMineNum;
				_mineNumValue.text = _mineNum.toString();
			}
			
			if(_itemNum > _maxItemNum)
			{
				_itemNum = _maxItemNum;
				_itemNumValue.text = _itemNum.toString();
			}
		}
	}
}