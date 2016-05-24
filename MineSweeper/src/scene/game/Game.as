package scene.game
{	
	import flash.geom.Point;
	
	import scene.Main;
	
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
		//private var _cover:Cover;
		
		public function Game(data:Object)
		{
			load();
			//스테이지 선택씬에서 왔으면 JSON 읽어서 
			//사용자 정의씬에서 왔으면 event.data 읽어서
			initBoard(data);
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
				//_board.addEventListener(TouchEvent.TOUCH, onScrollGameBoard);
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
		}
		
//		private function onScrollGameBoard(event:TouchEvent):void
//		{
//			var touch:Touch = event.getTouch(_cover, TouchPhase.MOVED);
//			if(touch)
//			{
//				var currentPos:Point = touch.getLocation(parent);
//				var previousPos:Point = touch.getPreviousLocation(parent);
//				var delta:Point = currentPos.subtract(previousPos);
//				
//				_cover.x += delta.x;
//				_board.x += delta.x;
//				
//				if(_cover.x > Main.stageWidth / 2)
//				{
//					_cover.x = Main.stageWidth / 2;
//					_board.x = Main.stageWidth / 2;
//				}
//				
//				if(_cover.x + _cover.width < Main.stageWidth / 2)
//				{
//					_cover.x = Main.stageWidth / 2 - _cover.width;
//					_board.x = Main.stageWidth / 2 - _board.width;
//				}
//				
//				//개발용
//				this.alpha = 0.5;
//			}
//			else
//			{
//				this.alpha = 1;
//			}
//		}
	}

}