package scene.game
{	
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGames;
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGamesEvent;
	
	import flash.desktop.NativeApplication;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import scene.Main;
	import scene.game.board.Board;
	import scene.game.board.CountDown;
	import scene.game.popup.ClearPopup;
	import scene.game.popup.PausePopup;
	import scene.game.ui.GameOver;
	import scene.game.ui.Item;
	import scene.game.ui.Time;
	import scene.game.ui.Warning;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
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
	import util.manager.AchievementMgr;
	import util.manager.IOMgr;
	import util.manager.LeaderBoardMgr;
	import util.manager.LoadMgr;
	import util.manager.SwitchActionMgr;
	import util.type.DataType;
	import util.type.DifficultyType;
	import util.type.PlatformType;
	import util.type.SceneType;
	
	public class Game extends Sprite
	{ 
		//private var _difficulty:int;
		private var _gameAtlas:TextureAtlas;
		private var _modeAtlas:TextureAtlas;
		
		private var _countDown:CountDown;
		private var _board:Board;
		private var _time:Time;
		private var _item:Item;
		private var _pausePopup:PausePopup;
		private var _clearPopup:ClearPopup;
		private var _gameOver:GameOver;
		private var _warning:Warning;
		
		private var _isGameEnded:Boolean;
		
		//지역변수로
		private var _beginPos:Point;
		private var _endedPos:Point;
		
		private var _data:Object;
		
		public function Game(data:Object)
		{
			_gameAtlas = LoadMgr.instance.load(EmbeddedAssets.GameSprite, EmbeddedAssets.GameXml);
			_modeAtlas = LoadMgr.instance.load(EmbeddedAssets.ModeSprite, EmbeddedAssets.ModeXml);
			
			_data = data;
			
			initBackground();			
			initBoard(data);				
			initPopup(_modeAtlas);		
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, onDeactivated);
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, onActivated);
		}
		
		private function onTouchKeyBoard(event:KeyboardEvent):void
		{
			
			if(event.keyCode == Keyboard.BACK || event.keyCode == 8)
			{
				event.preventDefault();
				
				if(_pausePopup)
					_pausePopup.visible = true;
				if(_time)
					_time.timer.stop();
				if(_countDown)
					_countDown.reset();
			}
		}
		
		private function initBackground():void
		{
			var quad:Quad = new Quad(Main.stageWidth, Main.stageHeight * 0.8, Color.SILVER);
			quad.y = Main.stageHeight * 0.2;
			addChild(quad);			
			
		}
		private function initPopup(atlas:TextureAtlas):void
		{
			_pausePopup = new PausePopup(atlas);
			_pausePopup.addEventListener("again", onAgain);
			_pausePopup.addEventListener("exit", onExit);
			_pausePopup.addEventListener("resume", onResume);
			addChild(_pausePopup);
			
			_clearPopup = new ClearPopup(atlas);
			_clearPopup.addEventListener("again", onAgain);
			_clearPopup.addEventListener("exit", onExit);
			addChild(_clearPopup);
		}
		
		private function initCountDown(count:int):void
		{
			_countDown = new CountDown(count);
			_countDown.addEventListener("endTimer", onEndCountDown);
			addChild(_countDown);
		}
		
		private function onEndCountDown(event:Event):void
		{
			_countDown.removeEventListener("endTimer", onEndCountDown);
			_countDown.release();
			_countDown = null;
			//게임 시작
			_time.timer.start();
			
		}
		
		private function initBoard(data:Object):void
		{
			//새로 시작
			if(data is Dictionary)
			{
				trace("custom board");
				_board = new Board(false, _gameAtlas, data[DataType.IS_ITEM_MODE], data[DataType.DIFFICULTY], data[DataType.ROW], data[DataType.COL], data[DataType.MINE_NUM],
					data[DataType.ITEM_NUM], data[DataType.CHANCE]);
				
				addChild(_board);
				var quad:Quad = new Quad(Main.stageWidth, Main.stageHeight * 0.2, Color.GRAY);
				addChild(quad);
				
				if(data[DataType.IS_ITEM_MODE])
					initItem(data[DataType.ITEM_NUM]);
				
				initTime(0);
				initGameOver();
				
				initCountDown(3);				
			}
			
			//이어하기
			else if(data is int && data == 0)
			{
				var datas:Dictionary = IOMgr.instance.loadData();
				if(datas)
				{					
					_board = new Board(true, _gameAtlas, datas[DataType.IS_ITEM_MODE], int(datas[DataType.DIFFICULTY]), int(datas[DataType.ROW]) - 2, int(datas[DataType.COL]) - 2, 
						int(datas[DataType.MINE_NUM]), int(datas[DataType.ITEM_NUM]), 
						int(datas[DataType.CHANCE]), datas[DataType.DATA] as Array, 
						datas[DataType.IMAGE] as Array, datas[DataType.ITEM] as Array);
					
					addChild(_board);
					quad = new Quad(Main.stageWidth, Main.stageHeight * 0.2, Color.GRAY);
					addChild(quad);
					
					if(datas[DataType.IS_ITEM_MODE])
						initItem(int(datas[DataType.ITEM_NUM]));
					
					initTime(int(datas[DataType.TIME]));
					initGameOver();
					
					initCountDown(3);
				}
				else
				{
					trace("이어하기 데이터 없음");
					_warning = new Warning();
					addChildAt(_warning, 1);
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
			_item = new Item(_gameAtlas, finderNum);
			_item.x = Main.stageWidth * 0.8;
			_item.y = Main.stageHeight * 0.1;
			_item.addEventListener("mineFinder", onTouchMineFinder);
			addChild(_item);
		}
		
		private function initTime(time:int):void
		{
			_time = new Time(_gameAtlas, time);
			_time.y = Main.stageHeight * 0.05;
			//_time.timer.start();
			addChild(_time);
		}
		
		public function release():void
		{
			if(_gameAtlas != null)
			{
				_gameAtlas = null;
			}
			if(_modeAtlas != null)
			{
				_modeAtlas = null;
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
			
			if(_pausePopup)
			{
				_pausePopup = null;
				removeChild(_pausePopup);
			}
			
			if(_clearPopup)
			{
				_clearPopup = null;
				removeChild(_clearPopup);
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
			
			//구글로 로그인 했으면		
//			if(PlatformType.current == PlatformType.GOOGLE)
//			{
//				//기록 등록
//				LeaderBoardMgr.instance.reportScore(_board.isItemMode, _board.difficulty, _time.realTime);
//				//업적 등록
//				AchievementMgr.instance.fastClear(_board.difficulty, _time.realTime);
//			}
			
			if(_clearPopup)
			{
				_clearPopup.visible = true;
				_clearPopup.textField.text = "이름 = " + Main.userName + "\n" + "난이도 = " + DifficultyType.getDifficulty(_board.difficulty) + "\n" + "시간 = " + _time.realTime.toString();
			}
			
			
			_gameOver.text.text = "GAME CLEAR";
			_gameOver.visible = true;
			
			IOMgr.instance.removeData();
			
			//var datas:Object = IOMgr.instance.loadRecord();
			//renewalData(datas);
			
			
			//IOMgr.instance.saveRecord(data);
//			var object:Object = new Object();
//			object.id = Main.userId;
//			object.name = Main.userName;
//			object.lastLogOut = new Date().toString();
//			object.stamina = 10;
			
			
			_isGameEnded = true;
		}
		
		private function insertObject(id:String, name:String, lastLogOut:String, stamina:int):Object
		{
			return new Object;
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
			//게임이 끝나지 않은 상태라면 데이터를 저장 (이어하기를 위함)
			if(_board && _board.isFirstTouch && !_isGameEnded)
			{
				trace("items : " + _board.items);
				IOMgr.instance.saveData(_board.isItemMode, _board.difficulty, _board.maxRow, _board.maxCol, _board.numberOfMine, _board.numberOfMineFinder, _board.chanceToGetItem * 100, _board.datas, _board.images, _board.items, _time.realTime);
			}
			else
			{
				IOMgr.instance.removeData();
			}
			
			//dispatchEvent(new Event(SceneType.MODE_SELECT));
			SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
		}
		
		private function onResume(event:Event):void
		{
//			if(_time)
//				_time.timer.start();
		
			if(_countDown)
			{
				_countDown.removeEventListener("endTimer", onEndCountDown);
				_countDown.release();
				_countDown = null;
				
				initCountDown(3);
			}	
			else
			{
				_time.timer.start();
			}
		}
		
		/**
		 * 다시하기 버튼 이벤트리스너 
		 * @param event 디스패치 이벤트
		 * 
		 */
		private function onAgain(event:Event):void
		{
			trace("onAgain");
			removeChildren();
			release();
			
			_gameAtlas = LoadMgr.instance.load(EmbeddedAssets.GameSprite, EmbeddedAssets.GameXml);
			_modeAtlas = LoadMgr.instance.load(EmbeddedAssets.ModeSprite, EmbeddedAssets.ModeXml);
			initBackground();
			initBoard(_data);
			initPopup(_modeAtlas);
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
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
		
		private function onDeactivated(event:flash.events.Event):void   
		{  			
			if(_countDown)
			{
				_countDown.stop();
			}
			else
			{
				if(_time)
				{
					_time.timer.stop();
				}
			}
		}  
		
		private function onActivated(event:flash.events.Event):void 
		{			
			if(_countDown)
			{
				_countDown.start();
			}
			else
			{
				if(_time)
				{
					_time.timer.start();
				}
			}
		}
	}
}