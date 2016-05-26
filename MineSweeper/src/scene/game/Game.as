package scene.game
{	
	import flash.desktop.NativeApplication;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import scene.Main;
	
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
	import util.IOMgr;
	import util.SceneType;
	
	public class Game extends Sprite
	{ 
		private var _atlas:TextureAtlas;
		
		private var _board:Board;
		private var _time:Time;
		private var _item:Item;
		private var _exitPopup:ExitPopup;
		
		private var _beginPos:Point;
		private var _endedPos:Point;
		
	
		
		public function Game(data:Object)
		{
			load();
			
			initBoard(data);			
			
			_exitPopup = new ExitPopup();
			_exitPopup.addEventListener("exit", onExit);
			_exitPopup.addEventListener("resume", onResume);
			addChild(_exitPopup);
			
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
		
		private function initBoard(data:Object):void
		{
			
			if(data is Vector.<int>)
			{
				trace("custom board");
				_board = new Board(false, _atlas, data[0], data[1], data[2], data[3], data[4]);
				
				addChild(_board);
				
				var quad:Quad = new Quad(Main.stageWidth, Main.stageHeight * 0.2, Color.WHITE);
				addChild(quad);
				
				initItem(data[3]);
				initTime(0);
			}
			
			//이어하기
			else if(data is int && data == 0)
			{
				/**
				 * 0 (data.row - 2);
				 * 1 (data.col - 2);
				 * 2 (data.mineNum);
				 * 3 (data.itemNum);
				 * 4 (data.chance);
				 * 5 (data.data);
				 * 6 (data.image);
				 * 7 (data.time);
				 * */
				var datas:Vector.<Object> = IOMgr.instance.load();
				_board = new Board(true, _atlas, int(datas[0]), int(datas[1]), int(datas[2]), int(datas[3]), int(datas[4]), datas[5] as Array, datas[6] as Array);
				addChild(_board);
				
				quad = new Quad(Main.stageWidth, Main.stageHeight * 0.2, Color.WHITE);
				addChild(quad);
				
				initItem(int(datas[3]));
				initTime(int(datas[7]));
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
		
		private function initItem(finderNum:int):void
		{
			_item = new Item(_atlas, finderNum);
			_item.addEventListener("mineFinder", onTouchMineFinder);
			addChild(_item);
		}
		
		private function initTime(time:int):void
		{
			_time = new Time(_atlas, time);
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
				_time = null;
				removeChild(_time);
			}
			
			if(_item)
			{
				_item = null;
				removeChild(_item);
			}
			
			if(_exitPopup)
			{
				_exitPopup = null;
				removeChild(_exitPopup);
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
		}
		
		public function onGameClear():void
		{
			trace("GAME CLEAR");
			_board.removeEventListener("game_over", onGameOver);
			_board.removeEventListener("game_clear", onGameClear);
			_board.removeEventListener(TouchEvent.TOUCH, onScrollGameBoard);
			
			_time.timer.stop();
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
			if(_board)
				IOMgr.instance.save(_board.maxRow, _board.maxCol, _board.numberOfMine, _board.numberOfMineFinder, _board.chanceToGetItem * 100, _board.datas, _board.images, _time.realTime);			
			
			dispatchEvent(new Event(SceneType.MODE_SELECT));
		}
		
		private function onResume(event:Event):void
		{
			_time.timer.start();
		}
	}

}