package scene.custom
{
	import flash.geom.Point;
	
	import scene.Main;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.Color;

	public class Slider extends Sprite
	{
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
		
		private var _rowTextField:TextField;
		private var _colTextField:TextField;
		private var _mineNumTextField:TextField;
		private var _itemNumTextField:TextField;
		private var _chanceTextField:TextField;
		
		private var _rowSlider:Quad;
		private var _colSlider:Quad;
		private var _mineSlider:Quad;
		private var _itemSlider:Quad;
		private var _chanceSlider:Quad;
		
		
		public function get chance():int { return _chance; }
		
		public function get itemNum():int {	return _itemNum; }
		
		public function get mineNum():int { return _mineNum; }
		
		public function get col():int {	return _col; }
		
		public function get row():int {	return _row; }
		
		public function Slider()
		{
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
		
	

		private function initQuad():void
		{
			for(var i:int = 0; i < 5; ++i)
			{
				var quad:Quad = setQuad(Main.stageWidth * 0.5, Main.stageHeight * (0.2 + Number(i / 10)), Main.stageWidth * 0.5, Main.stageWidth * 0.05, Color.GRAY);
				addChild(quad);
			}
			
			_rowSlider = setQuad(Main.stageWidth * 0.5, Main.stageHeight * 0.2, Main.stageWidth * 0.05, Main.stageWidth * 0.1,  Color.SILVER);
			addChild(_rowSlider);
			
			_colSlider = setQuad(Main.stageWidth * 0.5, Main.stageHeight * 0.3, Main.stageWidth * 0.05, Main.stageWidth * 0.1,  Color.SILVER);
			addChild(_colSlider);
			
			_mineSlider = setQuad(Main.stageWidth * 0.5, Main.stageHeight * 0.4, Main.stageWidth * 0.05, Main.stageWidth * 0.1,  Color.SILVER);
			addChild(_mineSlider);
			
			_itemSlider = setQuad(Main.stageWidth * 0.5, Main.stageHeight * 0.5, Main.stageWidth * 0.05, Main.stageWidth * 0.1,  Color.SILVER);
			addChild(_itemSlider);
			
			_chanceSlider = setQuad(Main.stageWidth * 0.5, Main.stageHeight * 0.6, Main.stageWidth * 0.05, Main.stageWidth * 0.1,  Color.SILVER);
			addChild(_chanceSlider);			
			
			
			_rowSlider.addEventListener(TouchEvent.TOUCH, onTouchRowSlider);
			_colSlider.addEventListener(TouchEvent.TOUCH, onTouchColSlider);
			_mineSlider.addEventListener(TouchEvent.TOUCH, onTouchMineSlider);
			_itemSlider.addEventListener(TouchEvent.TOUCH, onTouchItemSlider);
			_chanceSlider.addEventListener(TouchEvent.TOUCH, onTouchChanceSlider);
		}
		
		private function setQuad(x:int, y:int, width:int, height:int, color:uint):Quad
		{
			var quad:Quad = new Quad(width, height, color);
			quad.alignPivot("center", "center");
			quad.x = x;
			quad.y = y;
			
			return quad;
		}
		
		private function initTextField():void
		{
			_rowText     = setTextField(_rowText, Main.stageWidth * 0.15, Main.stageHeight * 0.2, 100, 20, "가로", false);
			_colText 	 = setTextField(_colText, Main.stageWidth * 0.15, Main.stageHeight * 0.3, 100, 20, "세로", false);
			_mineNumText = setTextField(_mineNumText, Main.stageWidth * 0.15, Main.stageHeight * 0.4, 100, 20, "지뢰", false);
			_itemNumText = setTextField(_itemNumText, Main.stageWidth * 0.15, Main.stageHeight * 0.5, 100, 20, "아이템", false);
			_chanceText  = setTextField(_chanceText, Main.stageWidth * 0.15, Main.stageHeight * 0.6, 100, 20, "아이템 확률", false);
			
			addChild(_rowText);
			addChild(_colText);
			addChild(_mineNumText);
			addChild(_itemNumText);
			addChild(_chanceText);
			
			
			
			_rowTextField	  = setTextField(_rowTextField, Main.stageWidth * 0.85, Main.stageHeight * 0.2, 40, 20, _row.toString(), true);
			_colTextField 	  = setTextField(_colTextField, Main.stageWidth * 0.85, Main.stageHeight * 0.3, 40, 20, _col.toString(), true);
			_mineNumTextField = setTextField(_mineNumTextField, Main.stageWidth * 0.85, Main.stageHeight * 0.4, 40, 20, _mineNum.toString(), true);
			_itemNumTextField = setTextField(_itemNumTextField, Main.stageWidth * 0.85, Main.stageHeight * 0.5, 40, 20, _itemNum.toString(), true);
			_chanceTextField  = setTextField(_chanceTextField, Main.stageWidth * 0.85, Main.stageHeight * 0.6, 40, 20, _chance.toString(), true);
			
			addChild(_rowTextField);
			addChild(_colTextField);
			addChild(_mineNumTextField);
			addChild(_itemNumTextField);
			addChild(_chanceTextField);
		}
		
		private function setTextField(textField:TextField, x:int, y:int, width:int, height:int, text:String, border:Boolean):TextField
		{
			var tf:TextField = textField;
			tf = new TextField(width, height, "");
			tf.alignPivot("center", "center");	
			tf.border = border;
			tf.x = x;
			tf.y = y;
			tf.text = text;
			
			return tf;
		}
		
		private function onTouchRowSlider(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_rowSlider, TouchPhase.MOVED);
			if(touch)
			{
				moveSlider(touch, touch.target);
				_row = changeValue(touch.target, MIN_ROW, MAX_ROW);
				_rowTextField.text = _row.toString();		
				
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
				_colTextField.text = _col.toString();
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
				_mineNumTextField.text = _mineNum.toString();
			}
		}
		
		private function onTouchItemSlider(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_itemSlider, TouchPhase.MOVED);
			if(touch)
			{
				moveSlider(touch, touch.target);
				_itemNum = changeValue(touch.target, MIN_ITEM_NUM, _maxItemNum);
				_itemNumTextField.text = _itemNum.toString();
			}
		}
		
		private function onTouchChanceSlider(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_chanceSlider, TouchPhase.MOVED);
			if(touch)
			{
				moveSlider(touch, touch.target);
				_chance = changeValue(touch.target, MIN_CHANCE, MAX_CHANCE);
				_chanceTextField.text = _chance.toString();
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
				_mineNumTextField.text = _mineNum.toString();
			}
			
			if(_itemNum > _maxItemNum)
			{
				_itemNum = _maxItemNum;
				_itemNumTextField.text = _itemNum.toString();
			}
		}
	}
}