package scene.modeSelect.popup.normal
{
	
	import flash.desktop.NativeApplication;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import scene.Main;
	
	import server.UserDBMgr;
	
	import starling.animation.Transitions;
	import starling.core.starling_internal;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
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
	import util.UserInfo;
	import util.manager.DisplayObjectMgr;
	import util.manager.SwitchActionMgr;
	import util.type.DataType;
	import util.type.SceneType;

	public class NormalPopup extends DisplayObjectContainer
	{
		private var _atlas:TextureAtlas;
		
		private var _radioItem:Image;
		private var _isItemMode:Boolean;
		
		private var _veryEasy:Button;
		private var _easy:Button;
		private var _normal:Button;
		private var _hard:Button;
		private var _veryHard:Button;
		
		private var _close:Button;
		
		private var _maxRow:int;
		private var _maxCol:int;
		private var _numberOfMine:int;
		private var _numberOfMineFinder:int;
		private var _chanceToGetItem:int;
		
//		private var _data:Vector.<int>;
		private var _data:Dictionary;
		
		public function NormalPopup(atlas:TextureAtlas)
		{
			_atlas = atlas;
			//load();
			initBackground();
			initButton();
			initLock();
			
			//NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
		}		
		
		
		public function release():void
		{	
			//NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
		}
		
		private function initBackground():void			
		{
			var quad:Quad = new Quad(Main.stageWidth, Main.stageHeight, Color.BLACK);
			quad.alpha = 0.5;
			addChild(quad);
			
			var background:Image = new Image(_atlas.getTexture("popupBg"));
			background.width = Main.stageWidth * 0.9;
			background.height = Main.stageHeight * 0.85;
			background.x = Main.stageWidth * 0.5;
			background.y = Main.stageHeight * 0.5;				
			background.alignPivot("center","center");
			addChild(background);
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
			
			
			_close = DisplayObjectMgr.instance.setButton(_close, _atlas.getTexture("close"), 
				Main.stageWidth * 0.9, Main.stageHeight * 0.1, Main.stageWidth * 0.1, Main.stageWidth * 0.1);
			_close.addEventListener(TouchEvent.TOUCH, onTouchClose);
			addChild(_close);
			
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
		
		private function onTouchClose(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_close, TouchPhase.ENDED);
			if(touch)
			{
				this.visible = false;
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
		
//		private function onTouchKeyBoard(event:KeyboardEvent):void
//		{
//			
//			if(event.keyCode == Keyboard.BACK || event.keyCode == 8)
//			{
//				event.preventDefault();
//				//dispatchEvent(new Event(SceneType.MODE_SELECT));
//				SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
//			}
//		}
		
		
	}
}