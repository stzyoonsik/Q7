package scene.game
{	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	
	import scene.Main;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import util.EmbeddedAssets;
	
	public class Game extends Sprite
	{ 
		private var _atlas:TextureAtlas;
		
		private var _board:Board;
		private var _item:Item;
		
		private var _beginPos:Point;
		private var _endedPos:Point;
		
		private var _time:Time;
		//private var _cover:Cover;
		
		public function Game(data:Object)
		{
			load();
			
			//스테이지 선택씬에서 왔으면 JSON 읽어서 
			//사용자 정의씬에서 왔으면 event.data 읽어서
			initBoard(data);
			initItem(data[3]);
			initTime();
			
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
				_board = new Board(_atlas, data[0], data[1], data[2], data[3]);
				_board.addEventListener("game_over", onGameOver);
				_board.addEventListener("game_clear", onGameClear);
				_board/*.boardSprite*/.addEventListener(TouchEvent.TOUCH, onScrollGameBoard);
				_board.addEventListener("mineFinder", onTouchMineFinder);
				_board.addEventListener("getMineFinder", onGetMineFinder);
				addChild(_board);
			}
			
			else if(data is int)
			{
				
			}
		}
		
		private function initItem(finderNum:int):void
		{
			_item = new Item(_atlas, finderNum);
			_item.addEventListener("mineFinder", onTouchMineFinder);
			addChild(_item);
		}
		
		private function initTime():void
		{
			_time = new Time(_atlas);
			_time.timer.start();
			addChild(_time);
		}
		
		public function release():void
		{
			if(_board)
			{
				_board = null;
				removeChild(_board);
			}
		}
		
		public function onGameOver():void
		{
			trace("GAME OVER");
			_board.removeEventListener("game_over", onGameOver);
			_board.removeEventListener("game_clear", onGameClear);
			_board.removeEventListener(TouchEvent.TOUCH, onScrollGameBoard);
			
			//아이템 안의 이벤트 제거해야함
			
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
						_board.count = 0;
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
	}

}