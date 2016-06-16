package scene.modeSelect.popup.normal
{	
	import flash.utils.Dictionary;
	
	import scene.Main;
	import scene.modeSelect.popup.Popup;
	
	import starling.animation.Transitions;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	
	import util.UserInfo;
	import util.manager.DisplayObjectMgr;
	import util.manager.SwitchActionMgr;
	import util.type.DataType;
	import util.type.SceneType;

	public class NormalPopup extends Popup
	{
		private var _atlas:TextureAtlas;
		
		private var _radioItem:Image;
		private var _isItemMode:Boolean;
		
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
		
		private var _data:Dictionary;
		
		public function NormalPopup(atlas:TextureAtlas)
		{
			_atlas = atlas;
			initBackground(Main.stageWidth * 0.5, Main.stageHeight * 0.5, Main.stageWidth * 0.9, Main.stageHeight * 0.85);
			initButton();
			initLock();
			initClose(Main.stageWidth * 0.9, Main.stageHeight * 0.1, Main.stageWidth * 0.1, Main.stageWidth * 0.1);
		}		
		
		
		public override function release():void
		{	
			super.release();
			
			if(_radioItem) { _radioItem.removeEventListener(TouchEvent.TOUCH, onTouchRadioItem); _radioItem.dispose(); _radioItem = null; }
			if(_veryEasy) { _veryEasy.removeEventListener(TouchEvent.TOUCH, onTouchVeryEasy); _veryEasy.dispose(); _veryEasy = null; }
			if(_easy) { _easy.removeEventListener(TouchEvent.TOUCH, onTouchEasy); _easy.dispose(); _easy = null; }
			if(_normal) { _normal.removeEventListener(TouchEvent.TOUCH, onTouchNormal); _normal.dispose(); _normal = null; }
			if(_hard) { _hard.removeEventListener(TouchEvent.TOUCH, onTouchHard); _hard.dispose(); _hard = null; }
			if(_veryHard) { _veryHard.removeEventListener(TouchEvent.TOUCH, onTouchVeryHard); _veryHard.dispose(); _veryHard = null; }
			
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
		
		private function initButton():void
		{
			var textField:TextField = new TextField(Main.stageWidth * 0.5, Main.stageHeight * 0.2);
			textField.x = Main.stageWidth * 0.3;
			textField.y = Main.stageHeight * 0.25;
			textField.alignPivot("center", "center");
			textField.text = "아이템 : ";
			textField.format.size = Main.stageWidth * 0.1;
			textField.format.bold = true;
			addChild(textField);
			//아이템 전 / 노템전 선택 버튼
			_radioItem = new Image(_atlas.getTexture("radioItemOff"));
			_radioItem.x = Main.stageWidth * 0.7;
			_radioItem.y = Main.stageHeight * 0.25;
			_radioItem.width = Main.stageWidth * 0.3;
			_radioItem.height = _radioItem.width * 0.5;
			_radioItem.alignPivot("center", "center");
			_radioItem.addEventListener(TouchEvent.TOUCH, onTouchRadioItem);
			addChild(_radioItem);
			
			_veryEasy = DisplayObjectMgr.instance.setButton(_veryEasy, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.4, Main.stageWidth * 0.5, Main.stageWidth * 0.15, "매우 쉬움", Main.stageWidth * 0.05);
			_easy     = DisplayObjectMgr.instance.setButton(_easy, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.5, Main.stageWidth * 0.5, Main.stageWidth * 0.15, "쉬움", Main.stageWidth * 0.05);
			_normal   = DisplayObjectMgr.instance.setButton(_normal, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.6, Main.stageWidth * 0.5, Main.stageWidth * 0.15, "일반", Main.stageWidth * 0.05);
			_hard     = DisplayObjectMgr.instance.setButton(_hard, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.7, Main.stageWidth * 0.5, Main.stageWidth * 0.15, "어려움", Main.stageWidth * 0.05);
			_veryHard = DisplayObjectMgr.instance.setButton(_veryHard, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.8, Main.stageWidth * 0.5, Main.stageWidth * 0.15, "매우 어려움", Main.stageWidth * 0.05);
			
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
			
		}
		
		private function lockButton(target:DisplayObject):void
		{
			var image:Image = DisplayObjectMgr.instance.setImage(_atlas.getTexture("lockedButton"), target.x, target.y, 
				target.width, target.height, "center", "center");
			image.alpha = 0.5;
			addChild(image);
			
			image = DisplayObjectMgr.instance.setImage(_atlas.getTexture("locked"), target.x, target.y, 
				Main.stageWidth * 0.1, Main.stageWidth * 0.1, "center", "center");
			addChild(image);
			
			target.touchable = false;
		}
		
		private function initLock():void
		{
			if(UserInfo.level < 2)
			{		
				lockButton(_easy);
				lockButton(_normal);
				lockButton(_hard);
				lockButton(_veryHard);
			}
			else if(UserInfo.level < 3)
			{				
				lockButton(_normal);
				lockButton(_hard);
				lockButton(_veryHard);
			} 
			else if(UserInfo.level < 4)
			{				
				lockButton(_hard);
				lockButton(_veryHard);
			} 
			else if(UserInfo.level < 5)
			{				
				lockButton(_veryHard);
			} 
		}
		
		
		/**
		 * 
		 * @param difficulty 0 : veryEasy, 1 : easy, 2 : normal, 3 : hard, 4 : veryHard 5 : custom
		 * @param row
		 * @param col
		 * @param mineNum
		 * @param itemNum
		 * @param chance
		 * 
		 */		
		private function setData(itemMode:Boolean, difficulty:int, row:int, col:int, mineNum:int, itemNum:int, chance:int):void
		{
			_maxRow = row;
			_maxCol = col;
			_numberOfMine = mineNum;
			_numberOfMineFinder = itemNum;
			_chanceToGetItem = chance;
			
			_data = new Dictionary();
			_data[DataType.IS_ITEM_MODE] = _isItemMode;
			_data[DataType.DIFFICULTY] = difficulty;
			_data[DataType.ROW] = row;
			_data[DataType.COL] = col;
			_data[DataType.MINE_NUM] = mineNum;
			_data[DataType.ITEM_NUM] = itemNum;
			_data[DataType.CHANCE] = chance;
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
				
		private function onTouchVeryEasy(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_veryEasy, TouchPhase.ENDED);
			if(touch)
			{
				if(UserInfo.heart > 0)
				{
					setData(_isItemMode, 0, 8, 8, 8, 2, 10);				
					SwitchActionMgr.instance.switchSceneFadeOut(this.parent, SceneType.GAME, false, _data, 0.5, Transitions.EASE_OUT);
				}
				
			}
			
		}
		
		private function onTouchEasy(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_easy, TouchPhase.ENDED);
			if(touch)
			{
				if(UserInfo.heart > 0)
				{
					setData(_isItemMode, 1, 10, 10, 15, 2, 8);				
					SwitchActionMgr.instance.switchSceneFadeOut(this.parent, SceneType.GAME, false, _data, 0.5, Transitions.EASE_OUT);
				}
				
			}
			
		}
		
		private function onTouchNormal(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_normal, TouchPhase.ENDED);
			if(touch)
			{
						
				if(UserInfo.heart > 0)
				{
					setData(_isItemMode, 2, 15, 15, 40, 2, 7);
					SwitchActionMgr.instance.switchSceneFadeOut(this.parent, SceneType.GAME, false, _data, 0.5, Transitions.EASE_OUT);
				}
			}
			
		}
		
		private function onTouchHard(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_hard, TouchPhase.ENDED);
			if(touch)
			{
				if(UserInfo.heart > 0)
				{
					setData(_isItemMode, 3, 20, 20, 80, 2, 6);		
					SwitchActionMgr.instance.switchSceneFadeOut(this.parent, SceneType.GAME, false, _data, 0.5, Transitions.EASE_OUT);
				}
				
			}
			
		}
		
		private function onTouchVeryHard(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_veryHard, TouchPhase.ENDED);
			if(touch)
			{
				if(UserInfo.heart > 0)
				{
					setData(_isItemMode, 4, 25, 25, 150, 2, 5);		
					SwitchActionMgr.instance.switchSceneFadeOut(this.parent, SceneType.GAME, false, _data, 0.5, Transitions.EASE_OUT);	
				}
				
			}
			
		}
	}
}