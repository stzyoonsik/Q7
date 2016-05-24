package scene.game
{	
	import flash.geom.Point;
	
	import scene.Main;
	
	import starling.display.Image;
	import starling.display.Sprite;
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
		
		private var _beginPos:Point;
		private var _endedPos:Point;
		//private var _cover:Cover;
		
		public function Game(data:Object)
		{
			load();
			
			//스테이지 선택씬에서 왔으면 JSON 읽어서 
			//사용자 정의씬에서 왔으면 event.data 읽어서
			initBoard(data);
			
//			var image:Image = new Image(_atlas.getTexture("0"));
//			image.width = Main.stageWidth;
//			image.height = Main.stageHeight * 0.25;
//			addChild(image);
		}
		
		/**
		 * 스프라이트시트와 xml을 로드하는 메소드 
		 * 
		 */
		private function load():void
		{			
			var xml:XML = XML(new EmbeddedAssets.Game_Xml());
			var texture:Texture = Texture.fromEmbeddedAsset(EmbeddedAssets.Game_SpriteSheet);
			_atlas = new TextureAtlas(texture, xml);
		}
		
		private function initBoard(data:Object):void
		{
			
			if(data is Vector.<int>)
			{
				trace("custom board");
				_board = new Board(_atlas, data[0], data[1], data[2]);
				_board.addEventListener("game_over", onGameOver);
				_board.addEventListener("game_clear", onGameClear);
				_board.addEventListener(TouchEvent.TOUCH, onScrollGameBoard);
				addChild(_board);
				
				//_cover = new Cover(_atlas, data[0], data[1]);
				//_cover.addEventListener(TouchEvent.TOUCH, onScrollGameBoard);
				//addChild(_cover);
			}
			
			else if(data is int)
			{
				
			}
		}
		
		public function release():void
		{
			if(_board)
			{
				_board = null;
				removeChild(_board);
			}
//			if(_cover)
//			{
//				_cover = null;
//				removeChild(_cover);
//			}
		}
		
		public function onGameOver():void
		{
			trace("GAME OVER");
			_board.removeEventListener("game_over", onGameOver);
			_board.removeEventListener("game_clear", onGameClear);
			_board.removeEventListener(TouchEvent.TOUCH, onScrollGameBoard);
			
		}
		
		public function onGameClear():void
		{
			trace("GAME CLEAR");
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
					
					//if(delta.x > Main.stageWidth * 0.001 || delta.y > Main.stageHeight * 0.001)
					//{
					if(Math.abs(currentPos.x - _beginPos.x) > Main.stageWidth * 0.1 || Math.abs(currentPos.y - _beginPos.y) > Main.stageHeight * 0.1)
					{
						_board.isScrolled = true;
						//_board.count = 0;
						_board.x += delta.x;
						_board.y += delta.y;
					}
					
					//_board.isScrolled = true;
					//}
					//				_board.x += delta.x;
					//				_board.y += delta.y;
					
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
	}

}