package scene.stageSelect
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
	import util.manager.SwitchActionMgr;
	import util.type.DataType;
	import util.type.SceneType;

	public class StageSelect extends DisplayObjectContainer
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
		
//		private var _data:Vector.<int>;
		private var _data:Dictionary;
		
		public function StageSelect()
		{
			load();
			initBackground();
			initButton();
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
		}
		
		/**
		 * 스프라이트시트와 xml을 로드하는 메소드 
		 * 
		 */
		private function load():void
		{			
			var xml:XML = XML(new EmbeddedAssets.ModeXml());
			var texture:Texture = Texture.fromEmbeddedAsset(EmbeddedAssets.ModeSprite);
			_atlas = new TextureAtlas(texture, xml);
			
			xml = null;
			texture = null;
		}
		
		public function release():void
		{	
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
		}
		
		private function initBackground():void
		{
			var image:Image = new Image(_atlas.getTexture("background"));
			image.width = Main.stageWidth;
			image.height = Main.stageHeight;
			addChild(image);
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
			//아이템 전 / 노템전 선택 버튼
			_radioItem = new Image(_atlas.getTexture("radioItemOff"));
			_radioItem.x = Main.stageWidth * 0.7;
			_radioItem.y = Main.stageHeight * 0.1;
			_radioItem.width = Main.stageWidth * 0.3;
			_radioItem.height = _radioItem.width * 0.5;
			_radioItem.alignPivot("center", "center");
			_radioItem.addEventListener(TouchEvent.TOUCH, onTouchRadioItem);
			addChild(_radioItem);
			
			_veryEasy = ButtonMgr.instance.setButton(_veryEasy, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.25, Main.stageWidth * 0.5, Main.stageWidth * 0.15, "매우 쉬움", Main.stageWidth * 0.05);
			_easy     = ButtonMgr.instance.setButton(_easy, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.4, Main.stageWidth * 0.5, Main.stageWidth * 0.15, "쉬움", Main.stageWidth * 0.05);
			_normal   = ButtonMgr.instance.setButton(_normal, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.55, Main.stageWidth * 0.5, Main.stageWidth * 0.15, "일반", Main.stageWidth * 0.05);
			_hard     = ButtonMgr.instance.setButton(_hard, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.7, Main.stageWidth * 0.5, Main.stageWidth * 0.15, "어려움", Main.stageWidth * 0.05);
			_veryHard = ButtonMgr.instance.setButton(_veryHard, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.85, Main.stageWidth * 0.5, Main.stageWidth * 0.15, "매우 어려움", Main.stageWidth * 0.05);
			
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
				
				setData(_isItemMode, 0, 8, 8, 8, 2, 10);				
				
				//dispatchEvent(new Event(SceneType.GAME, false, _data));
				SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.GAME, false, _data, 0.5, Transitions.EASE_OUT);
			}
			
		}
		
		private function onTouchEasy(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_easy, TouchPhase.ENDED);
			if(touch)
			{
				setData(_isItemMode, 1, 10, 10, 15, 2, 8);		
				//dispatchEvent(new Event(SceneType.GAME, false, _data));
				SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.GAME, false, _data, 0.5, Transitions.EASE_OUT);
			}
			
		}
		
		private function onTouchNormal(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_normal, TouchPhase.ENDED);
			if(touch)
			{
				setData(_isItemMode, 2, 15, 15, 40, 2, 7);		
				//dispatchEvent(new Event(SceneType.GAME, false, _data));
				SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.GAME, false, _data, 0.5, Transitions.EASE_OUT);
			}
			
		}
		
		private function onTouchHard(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_hard, TouchPhase.ENDED);
			if(touch)
			{
				setData(_isItemMode, 3, 20, 20, 80, 2, 6);		
				//dispatchEvent(new Event(SceneType.GAME, false, _data));
				SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.GAME, false, _data, 0.5, Transitions.EASE_OUT);
			}
			
		}
		
		private function onTouchVeryHard(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_veryHard, TouchPhase.ENDED);
			if(touch)
			{
				setData(_isItemMode, 4, 25, 25, 150, 2, 5);		
				//dispatchEvent(new Event(SceneType.GAME, false, _data));
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
			}
		}
		
		
	}
}