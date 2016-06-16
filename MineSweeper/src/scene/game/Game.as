package scene.game
{	
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
	
	import server.UserDBMgr;
	
	import starling.animation.Transitions;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	
	import util.LevelSystem;
	import util.Reward;
	import util.UserInfo;
	import util.manager.AchievementMgr;
	import util.manager.AtlasMgr;
	import util.manager.IOMgr;
	import util.manager.LeaderBoardMgr;
	import util.manager.SoundMgr;
	import util.manager.SwitchActionMgr;
	import util.type.DataType;
	import util.type.DifficultyType;
	import util.type.PlatformType;
	import util.type.SceneType;
	
	/**
	 * 게임 씬 클래스 
	 * 
	 */
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
		
		
		private var _beginPos:Point;
		private var _endedPos:Point;
		
		private var _data:Object;
		
		private const COUNT_DOWN_COUNT:int = 3;
		
		public function Game(data:Object)
		{
			_gameAtlas = AtlasMgr.instance.getAtlas("GameSprite");
			_modeAtlas = AtlasMgr.instance.getAtlas("ModeSprite");
			
			_data = data;
			
			initBackground();			
			initBoard(data);				
			initPopup(_modeAtlas);		
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, onDeactivated);
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, onActivated);
		}
		
		/**
		 * 백버튼을 눌렀을때 호출되는 콜백메소드 
		 * @param event 키보드이벤트
		 * 
		 */
		private function onTouchKeyBoard(event:KeyboardEvent):void
		{
			
			if(event.keyCode == Keyboard.BACK || event.keyCode == 8)
			{
				event.preventDefault();
				
				if(_pausePopup)
					_pausePopup.visible = true;
				if(_time)
					_time.stop();
				if(_countDown)
					_countDown.reset();
			}
		}
		
		/**
		 * 백그라운드 초기화 메소드 
		 * 
		 */
		private function initBackground():void
		{
			var quad:Quad = new Quad(Main.stageWidth, Main.stageHeight * 0.8, Color.SILVER);
			quad.y = Main.stageHeight * 0.2;
			addChild(quad);			
			
		}
		/**
		 * 팝업 초기화 메소드 
		 * @param atlas 텍스쳐 아틀라스
		 * 
		 */
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
		
		/**
		 * 카운트다운 초기화 메소드 
		 * @param count 카운트를 몇부터 시작할지
		 * 
		 */
		private function initCountDown(count:int):void
		{
			_countDown = new CountDown(count);
			_countDown.addEventListener("endTimer", onEndCountDown);
			addChild(_countDown);
		}
		
		/**
		 * 카운트다운이 끝나면 호출되는 콜백메소드 
		 * @param event 디스패치받은 이벤트
		 * 
		 */
		private function onEndCountDown(event:Event):void
		{
			_countDown.removeEventListener("endTimer", onEndCountDown);
			_countDown.visible = false;
			//게임 시작
			if(_time)
				_time.start();			
		}
		
		/**
		 * 보드를 초기화하는 메소드 
		 * @param data 가로 세로 크기, 난이도, 지뢰개수... 등이 담긴 데이터
		 * 
		 */
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
				
				initCountDown(COUNT_DOWN_COUNT);				
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
					
					initCountDown(COUNT_DOWN_COUNT);
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
		
		/**
		 * 게임오버를 초기화하는 메소드 
		 * 
		 */
		private function initGameOver():void
		{
			_gameOver = new GameOver();
			_gameOver.visible = false;
			addChild(_gameOver);
		}
		
		/**
		 * 아이템을 초기화하는 메소드 
		 * @param finderNum 시작했을때의 마인파인더의 갯수
		 * 
		 */
		private function initItem(finderNum:int):void
		{
			_item = new Item(_gameAtlas, finderNum);
			_item.x = Main.stageWidth * 0.8;
			_item.y = Main.stageHeight * 0.1;
			_item.addEventListener("mineFinder", onTouchMineFinder);
			addChild(_item);
		}
		
		/**
		 * 타이머를 초기화하는 메소드 
		 * @param time 타이머 시작 시간
		 * 
		 */
		private function initTime(time:int):void
		{
			_time = new Time(_gameAtlas, time);
			_time.y = Main.stageHeight * 0.05;
			//_time.timer.start();
			addChild(_time);
		}
		
		/**
		 * 메모리 해제 메소드 
		 * 
		 */
		public function release():void
		{
			//if(_gameAtlas) { _gameAtlas = null;	}
			//if(_modeAtlas) { _modeAtlas = null; }
			if(_board) { _board.removeEventListener("game_over", onGameOver);
				_board.removeEventListener("game_clear", onGameClear);
				_board.removeEventListener(TouchEvent.TOUCH, onScrollGameBoard);
				_board.removeEventListener("mineFinder", onTouchMineFinder);
				_board.removeEventListener("getMineFinder", onGetMineFinder);
				_board.release(); _board = null;	removeChild(_board); }
			if(_time) { _time.release(); _time = null; removeChild(_time); }
			if(_item) {	_item.release(); _item = null; removeChild(_item); }			
			if(_pausePopup) { _pausePopup.release(); _pausePopup = null; removeChild(_pausePopup); }
			if(_clearPopup) { _clearPopup.release(); _clearPopup = null; removeChild(_clearPopup); }
			if(_gameOver) { _gameOver.release(); _gameOver = null; removeChild(_gameOver); }
			if(_warning) { _warning.release(); _warning = null;	removeChild(_warning); }
			if(_countDown) { _countDown.release(); _countDown = null; }
			
			
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
		}
		
		/**
		 * 게임에 실패했을때 호출되는 콜백메소드 
		 * 
		 */
		public function onGameOver():void
		{
			SoundMgr.instance.stopAll();
			SoundMgr.instance.play("gameClear.mp3", true);
			SoundMgr.instance.play("defeat.mp3");
			trace("GAME OVER");
			
			
			_pausePopup.makeButtonInvisible("resume");
			
			_time.stop();
			
			_gameOver.setTextField("GAME OVER");
			_gameOver.visible = true;
			
			IOMgr.instance.removeData();
			_isGameEnded = true;
		}
		
		/**
		 * 게임에 성공했을때 호출되는 콜백메소드 
		 * 
		 */
		public function onGameClear():void
		{
			SoundMgr.instance.stopAll();
			SoundMgr.instance.play("gameClear.mp3", true);
			SoundMgr.instance.play("victory.mp3");
			trace("GAME CLEAR");
			
			
			_time.stop();
			
			//구글로 로그인 했으면		
			if(PlatformType.current == PlatformType.GOOGLE)
			{
				//기록 등록
				LeaderBoardMgr.instance.reportScore(_board.isItemMode, _board.difficulty, _time.realTime);
				//업적 등록
				AchievementMgr.instance.fastClear(_board.difficulty, _time.realTime);
				
				updateDatas();
			}
			//페북으로 로그인 했으면
			else
			{
				//난이도가 커스텀모드이면 기록 저장 안함
				if(_board.difficulty != DifficultyType.CUSTOM)
				{
					updateDatas();		
					UserDBMgr.instance.addEventListener("selectRecord", onSelectRecordComplete);
					UserDBMgr.instance.selectRecord(UserInfo.id, _board.isItemMode, _board.difficulty);	
				}
			}
			
			if(_clearPopup)
			{
				_clearPopup.visible = true;
				var isItem:String = _board.isItemMode == true ? "O" : "X";
				var text:String =  "이름 : " + UserInfo.name + "\n" 
								+ "아이템 : " + isItem + "\n"
								+ "난이도 : " + DifficultyType.getDifficulty(_board.difficulty) + "\n" 
								+ "시간 : " + _time.realTime.toString() + "\n" 
								+ "경험치 : " + (Reward.getRewardExp(_board.difficulty) * UserInfo.expRatio).toString() + "\n" 
								+ "보상 : " + Reward.getRewardCoin(_board.difficulty).toString() + "코인";
				_clearPopup.setTextField(text); 
			}
			
			
			_gameOver.setTextField("GAME CLEAR");
			_gameOver.visible = true;
			
			IOMgr.instance.removeData();
			_isGameEnded = true;
		}
		
		/**
		 * 게임 클리어를 통해 받은 보상을 업데이트 하는 메소드 
		 * 
		 */
		private function updateDatas():void
		{
			//경험치 보상
			UserInfo.exp += Reward.getRewardExp(_board.difficulty) * UserInfo.expRatio;				
			while(LevelSystem.checkLevelUp(UserInfo.level, UserInfo.exp))
			{					
				UserInfo.exp -= LevelSystem.getNeedExp(UserInfo.level);
				UserInfo.level++;
				UserInfo.levelUpAmount++;
			}
			UserInfo.coin += Reward.getRewardCoin(_board.difficulty); 
			
			UserDBMgr.instance.updateData(UserInfo.id, "level", UserInfo.level);
			UserDBMgr.instance.updateData(UserInfo.id, "exp", UserInfo.exp);
			UserDBMgr.instance.updateData(UserInfo.id, "coin", UserInfo.coin);
			
			
		}
		
		/**
		 * selectRecord가 끝났을때 호출되는 콜백메소드 
		 * @param event
		 * 
		 */
		private function onSelectRecordComplete(event:Event):void
		{			
			//select로 정보 가져오고, 최고기록인지 확인하고 , 최고기록이면 업데이트
			if(checkNewRecord(int(event.data), _time.realTime))
			{
				UserDBMgr.instance.updateRecord(UserInfo.id, _board.isItemMode, _board.difficulty, _time.realTime);
			}
			
			UserDBMgr.instance.removeEventListener("selectRecord", onSelectRecordComplete);
		}
		
		/**
		 * 보드를 드래그했을때 호출되는 콜백메소드 
		 * @param event 터치
		 * 
		 */
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
					
					if(Math.abs(currentPos.x - _beginPos.x) > Main.stageWidth * 0.1 ||
						Math.abs(currentPos.y - _beginPos.y) > Main.stageHeight * 0.1)
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
		 * 마인파인더 아이템을 터치했을때 호출되는 콜백메소드
		 * @param event
		 * 
		 */
		private function onTouchMineFinder(event:Event):void
		{
			_item.setMineFinderText(_board.numberOfMineFinder.toString());
			if(_board.numberOfMineFinder > 0)
			{							
				_board.isMineFinderSelected = _item.isMineFinderSelected;
				if(_item.isMineFinderSelected)
				{
					_item.setMineFinderAlpha(0.5);
				}
				else
				{
					_item.setMineFinderAlpha(1);		
				}
			}
			else 
			{
				_item.setMineFinderAlpha(1);			
				_board.isMineFinderSelected = false;
			}
		}
		
		/**
		 * 보드에서 마인파인더 아이템을 획득했을때 호출되는 콜백메소드 
		 * @param event 디스패치 받은 이벤트
		 * 
		 */
		private function onGetMineFinder(event:Event):void
		{
			_item.setMineFinderText(_board.numberOfMineFinder.toString());
		}
		
		/**
		 * 나가기 버튼을 클릭했을때 호출되는 콜백메소드 
		 * @param event
		 * 
		 */
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
			
			SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
		}
		
		/**
		 * 재게하기 버튼을 클릭했을때 호출되는 콜백메소드 
		 * @param event
		 * 
		 */
		private function onResume(event:Event):void
		{
		
			if(_countDown)
			{
				_countDown.removeEventListener("endTimer", onEndCountDown);
				_countDown.release();
				_countDown = null;
				
				initCountDown(3);
			}	
			else
			{
				_time.start();
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
			if(UserInfo.heart > 0)
			{
				//하트 빼야함
				UserInfo.heart--;
				UserDBMgr.instance.updateData(UserInfo.id, "heart", UserInfo.heart);
				removeChildren();
				release();
				
				_gameAtlas = AtlasMgr.instance.getAtlas("GameSprite");
				_modeAtlas = AtlasMgr.instance.getAtlas("ModeSprite");
				initBackground();
				initBoard(_data);
				initPopup(_modeAtlas);
				
				NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
			}
			else
			{
				SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
			}
			
		}
		
		/**
		 * 이전기록과 비교하여 더 나은 기록인지를 검사하는 메소드 
		 * @param preTime 이전 시간
		 * @param curTime 현재 시간
		 * @return 현재 시간이 이전 시간보다 더 작으면 true 아니면 false
		 * 
		 */
		private function checkNewRecord(preTime:int, curTime:int):Boolean
		{			
			return curTime < preTime;
		}

		
		/**
		 * 윈도우에서 어플리케이션이 내려갔을때 호출되는 콜백메소드. 카운트다운 또는 시간을 정지시킴
		 * @param event
		 * 
		 */
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
					_time.stop();
				}
			}
		}  
		
		/**
		 * 윈도우에 어플리케이션이 돌아왔을떄 호출되는 콜백메소드. 재게시킴. 
		 * @param event
		 * 
		 */
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
					_time.start();
				}
			}
		}
	}
}