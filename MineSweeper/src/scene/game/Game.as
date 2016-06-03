package scene.game
{	
	import flash.desktop.NativeApplication;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import scene.Main;
	import scene.game.board.Board;
	import scene.game.popup.ExitPopup;
	import scene.game.ui.GameOver;
	import scene.game.ui.Item;
	import scene.game.ui.Time;
	import scene.game.ui.Warning;
	
	import starling.animation.Transitions;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	
	import util.EmbeddedAssets;
	import util.manager.IOMgr;
	import util.manager.SwitchActionMgr;
	import util.type.DataType;
	import util.type.SceneType;
	
	public class Game extends Sprite
	{ 
		//private var _difficulty:int;
		private var _atlas:TextureAtlas;
		
		private var _board:Board;
		private var _time:Time;
		private var _item:Item;
		private var _exitPopup:ExitPopup;
		private var _gameOver:GameOver;
		private var _warning:Warning;
		
		private var _isGameEnded:Boolean;
		
		//지역변수로
		private var _beginPos:Point;
		private var _endedPos:Point;
		
	
		
		public function Game(data:Object)
		{
			load();
			initBackground();
			initBoard(data);	
			initExitPopup();			
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
		}
		
		private function onTouchKeyBoard(event:KeyboardEvent):void
		{
			
			if(event.keyCode == Keyboard.BACK || event.keyCode == 8)
			{
				event.preventDefault();
				if(_exitPopup)
					_exitPopup.visible = true;
				if(_time)
					_time.timer.stop();
			}
		}
		
		/**
		 * 스프라이트시트와 xml을 로드하는 메소드 
		 * 
		 */
		private function load():void
		{			
			var xml:XML = XML(new EmbeddedAssets.GameXml());
			var texture:Texture = Texture.fromEmbeddedAsset(EmbeddedAssets.GameSprite);
			_atlas = new TextureAtlas(texture, xml);
		}
		
		private function initBackground():void
		{
			var quad:Quad = new Quad(Main.stageWidth, Main.stageHeight * 0.8, Color.SILVER);
			quad.y = Main.stageHeight * 0.2;
			addChild(quad);			
			
		}
		private function initExitPopup():void
		{
			_exitPopup = new ExitPopup();
			_exitPopup.addEventListener("exit", onExit);
			_exitPopup.addEventListener("resume", onResume);
			addChild(_exitPopup);
		}
		
		private function initBoard(data:Object):void
		{
			//새로 시작
			if(data is Dictionary)
			{
				trace("custom board");
				_board = new Board(false, _atlas, data[DataType.DIFFICULTY], data[DataType.ROW], data[DataType.COL], data[DataType.MINE_NUM],
					data[DataType.ITEM_NUM], data[DataType.CHANCE]);
				
				addChild(_board);
				var quad:Quad = new Quad(Main.stageWidth, Main.stageHeight * 0.2, Color.GRAY);
				addChild(quad);
				
				initItem(data[DataType.ITEM_NUM]);
				initTime(0);
				initGameOver();
			}
			
			//이어하기
			else if(data is int && data == 0)
			{
				var datas:Dictionary = IOMgr.instance.loadData();
				if(datas)
				{					
					_board = new Board(true, _atlas, int(datas[DataType.DIFFICULTY]), int(datas[DataType.ROW]) - 2, int(datas[DataType.COL]) - 2, 
						int(datas[DataType.MINE_NUM]), int(datas[DataType.ITEM_NUM]), 
						int(datas[DataType.CHANCE]), datas[DataType.DATA] as Array, 
						datas[DataType.IMAGE] as Array, datas[DataType.ITEM] as Array);
					
					addChild(_board);
					quad = new Quad(Main.stageWidth, Main.stageHeight * 0.2, Color.GRAY);
					addChild(quad);
					
					initItem(int(datas[DataType.ITEM_NUM]));
					initTime(int(datas[DataType.TIME]));
					initGameOver();
				}
				else
				{
					trace("이어하기 데이터 없음");
					_warning = new Warning();
					addChild(_warning);
				}
				
			}
			
			if(_board)
			{
				_board.addEventListener("game_over", onGameOver);
				_board.addEventListener("game_clear", onGameClear);
				_board.addEventListener(TouchEvent.TOUCH, onScrollGameBoard);
				_board.addEventListener("mineFinder", onTouchMineFinder);
				_board.addEventListener("getMineFinder", onGetMineFinder);
			}
		}
		
		private function initGameOver():void
		{
			_gameOver = new GameOver();
			_gameOver.visible = false;
			addChild(_gameOver);
		}
		
		private function initItem(finderNum:int):void
		{
			_item = new Item(_atlas, finderNum);
			_item.y = Main.stageHeight * 0.05;
			_item.addEventListener("mineFinder", onTouchMineFinder);
			addChild(_item);
		}
		
		private function initTime(time:int):void
		{
			_time = new Time(_atlas, time);
			_time.y = Main.stageHeight * 0.05;
			_time.timer.start();
			addChild(_time);
		}
		
		public function release():void
		{
			if(_atlas != null)
			{
				_atlas = null;
			}
			if(_board)
			{
				_board = null;
				removeChild(_board);
			}
			
			if(_time)
			{
				_time.release();
				_time = null;
				removeChild(_time);
			}
			
			if(_item)
			{
				_item.release();
				_item = null;
				removeChild(_item);
			}
			
			if(_exitPopup)
			{
				_exitPopup = null;
				removeChild(_exitPopup);
			}
			
			if(_gameOver)
			{
				_gameOver = null;
				removeChild(_gameOver);
			}
			
			if(_warning)
			{
				_warning = null;
				removeChild(_warning);
			}
			
			_beginPos = null;
			_endedPos = null;
			
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
		}
		
		public function onGameOver():void
		{
			trace("GAME OVER");
			_board.removeEventListener("game_over", onGameOver);
			_board.removeEventListener("game_clear", onGameClear);
			_board.removeEventListener(TouchEvent.TOUCH, onScrollGameBoard);
			
			//아이템 안의 이벤트 제거해야함 release 함수 만들자
			
			//타이머 안의 이벤트 제거해야함
			
			_time.timer.stop();
			
			_gameOver.text.text = "GAME OVER";
			_gameOver.visible = true;
			
			IOMgr.instance.removeData();
			_isGameEnded = true;
		}
		
		public function onGameClear():void
		{
			trace("GAME CLEAR");
			_board.removeEventListener("game_over", onGameOver);
			_board.removeEventListener("game_clear", onGameClear);
			_board.removeEventListener(TouchEvent.TOUCH, onScrollGameBoard);
			
			
			_time.timer.stop();
			
			_gameOver.text.text = "GAME CLEAR";
			_gameOver.visible = true;
			
			IOMgr.instance.removeData();
			
			var datas:Object = IOMgr.instance.loadRecord();
			renewalData(datas);
			
			
			//IOMgr.instance.saveRecord(data);
			
			_isGameEnded = true;
			
			
		}
		
		private function onScrollGameBoard(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_board);
			if(touch)
			{
				if(touch.phase == TouchPhase.BEGAN)
				{
					_beginPos = touch.getLocation(parent);
				}
				if(touch.phase == TouchPhase.MOVED)
				{
					var currentPos:Point = touch.getLocation(parent);
					var previousPos:Point = touch.getPreviousLocation(parent);
					var delta:Point = currentPos.subtract(previousPos);
					
					if(Math.abs(currentPos.x - _beginPos.x) > Main.stageWidth * 0.1 || Math.abs(currentPos.y - _beginPos.y) > Main.stageHeight * 0.1)
					{
						_board.isScrolled = true;
						_board.hoverCount = 0;
						_board.x += delta.x;
						_board.y += delta.y;
					}
					
					if(_board.x > Main.stageWidth * 0.4)
					{
						_board.x = Main.stageWidth * 0.4;
					}
					
					if(_board.x + _board.width < Main.stageWidth * 0.4)
					{
						_board.x = Main.stageWidth * 0.4 - _board.width;
					}
					
					if(_board.y > Main.stageHeight * 0.6)
					{
						_board.y = Main.stageHeight * 0.6;
					}		
					
					if(_board.y + _board.height < Main.stageHeight * 0.3)
					{
						_board.y = Main.stageHeight * 0.3 - _board.height;
					}
				}
				
			}
		}
		
		/**
		 *  
		 * @param event
		 * 
		 */
		private function onTouchMineFinder(event:Event):void
		{
			_item.mineFinder.text = _board.numberOfMineFinder.toString();
			if(_board.numberOfMineFinder > 0)
			{							
				_board.isMineFinderSelected = _item.isMineFinderSelected;
				if(_item.isMineFinderSelected)
				{
					_item.mineFinder.alpha = 0.5;	
				}
				else
				{
					_item.mineFinder.alpha = 1;			
				}
			}
			else 
			{
				_item.mineFinder.alpha = 1;				
				_board.isMineFinderSelected = false;
			}
		}
		
		private function onGetMineFinder(event:Event):void
		{
			_item.mineFinder.text = _board.numberOfMineFinder.toString();
		}
		
		private function onExit(event:Event):void
		{
			
			if(_board && !_isGameEnded)
			{
				trace("items : " + _board.items);
				IOMgr.instance.saveData(_board.difficulty, _board.maxRow, _board.maxCol, _board.numberOfMine, _board.numberOfMineFinder, _board.chanceToGetItem * 100, _board.datas, _board.images, _board.items, _time.realTime);
			}
			
			//dispatchEvent(new Event(SceneType.MODE_SELECT));
			SwitchActionMgr.instance.switchScenefadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
		}
		
		private function onResume(event:Event):void
		{
			if(_time)
				_time.timer.start();
		}
		
		private function checkNewRecord(preTime:int, curTime:int):Boolean
		{
			
			return false;
		}
		
		private function renewalData(datas:Object):void
		{
			for(var i:int = 0; i < datas.length; ++i)
			{
				if(datas[i].id == Main.userId)
				{
					switch(_board.difficulty)
					{
						case 0 :
							if(checkNewRecord(datas[i].record.veryEasy, _time.timer.currentCount))
							{
								
							}
							break;
						case 1 :
							break;
						case 2 :
							break;
						case 3 :
							break;
						case 4 :
							break;
						default :
							break;
					}
				}
			}
			
			
		}
	}

}