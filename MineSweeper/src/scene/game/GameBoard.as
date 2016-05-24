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

	public class GameBoard extends Sprite
	{
		protected var _atlas:TextureAtlas;		
		
		protected var _maxRow:int;
		protected var _maxCol:int;
		//protected var _numberOfMine:int;
		
		protected var _data:Array;
		protected var _colData:Array;
		protected var _image:Array;
		protected var _colImage:Array;
		
//		public function GameBoard()
//		{
//		}
		
		/**
		 * 메모리 해제 메소드. 타입을 검사하여 해제시킴.
		 * @param obj 오브젝트 
		 * 
		 */
		protected function releaseObject(obj:Object):void
		{
			if(obj is Array)
			{
				for(var i:int in obj)
				{
					obj[i] = null;
				}			
				obj.splice(0, obj.length);
			}			
		}
		
//		/**
//		 * 
//		 * @param texture 텍스쳐
//		 * @param row 행
//		 * @param col 렬
//		 * 
//		 */
//		protected function putImage(texture:Texture, row:int, col:int):void
//		{
//			var image:Image = new Image(texture);
//			image.width = Main.stageWidth * 0.08;
//			image.height = image.width;
//			image.x = row * image.width;
//			image.y = col * image.height;	
//			
//			_image[row][col] = image;
//			
//			addChild(image);
//		}
		
//		/**
//		 * 게임 보드를 스크롤링하는 콜백메소드
//		 * @param event 터치이벤트
//		 * 
//		 */
//		protected function onScrollBoard(event:TouchEvent):void
//		{
//			var touch:Touch = event.getTouch(this, TouchPhase.MOVED);
//			if(touch)
//			{
//				var currentPos:Point = touch.getLocation(parent);
//				var previousPos:Point = touch.getPreviousLocation(parent);
//				var delta:Point = currentPos.subtract(previousPos);
//				
//				this.x += delta.x;
//				
//				if(this.x > Main.stageWidth / 2)
//					this.x = Main.stageWidth / 2;
//				
//				if(this.x + this.width < Main.stageWidth / 2)
//					this.x = Main.stageWidth / 2 - this.width;
//				
//				
//				this.alpha = 0.5;
//			}
//			else
//			{
//				this.alpha = 1;
//			}
//			
//		}
	}
}