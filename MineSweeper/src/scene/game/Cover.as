package scene.game
{
	import scene.Main;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Cover extends GameBoard
	{		
		private var _count:int;
		private const MAX_HOVER_COUNT:int = 30;
		private var _lastRow:int;
		private var _lastCol:int;
		
		public function Cover(atlas:TextureAtlas, maxRow:int, maxCol:int)
		{
			_atlas = atlas;
			_maxRow = maxRow + 2;
			_maxCol = maxCol + 2;
			
			initCover();
			allocateCover();
			
			this.x = Main.stageWidth * 0.02;
			this.y = Main.stageHeight * 0.25;
			//this.addEventListener(TouchEvent.TOUCH, onScrollBoard);
			
			addEventListener(TouchEvent.TOUCH, onTouchCover);
		}
		
		private function initCover():void
		{
			_image = new Array();
			
			for(var i:int = 0; i < _maxRow; ++i)
			{
				_colData = new Array();
				_colImage = new Array();
				for(var j:int = 0; j < _maxCol; ++j)
				{
					_colData[j] = 0;
					_colImage[j] = null;
				}
				//_data[i] = _colData;
				_image[i] = _colImage;
			}
			
			//releaseObject(_colData);
			releaseObject(_colImage);
		}	
		
		/**
		 * 데이터에 저장된 값을 바탕으로 화면에 지뢰를 띄워주는 메소드 
		 * @param minePos
		 * 
		 */
		private function allocateCover():void
		{
			for(var i:int = 1; i < _maxRow - 1; ++i)
			{
				for(var j:int = 1; j < _maxCol - 1; ++j)
				{
					var texture:Texture = _atlas.getTexture("block");						
					putImage(texture, i, j);
					
				}
			}
		}
		
		/**
		 * 터치한 지점을 열어주는 메소드
		 * @param event 터치이벤트
		 * 
		 */
		private function onTouchCover(event:TouchEvent):void
		{
			for(var i:int = 1; i < _maxRow - 1; ++i)
			{
				for(var j:int = 1; j < _maxCol -1; ++j)
				{
					var touch:Touch = event.getTouch(_image[i][j]);
					if(touch)
					{
						_lastRow = i;
						_lastCol = j;
						
						if(touch.phase == TouchPhase.BEGAN)
						{
							addEventListener(Event.ENTER_FRAME, onHoverCover);
							_count = 0;
						}
						if(touch.phase == TouchPhase.ENDED)
						{
							removeEventListener(Event.ENTER_FRAME, onHoverCover);
							if(_count < MAX_HOVER_COUNT)
							{
								_image[i][j].visible = false;
							}
						}
					}
				}
			}
		}
		
		/**
		 * 0.5초 이상 hover를 유지하면 텍스쳐를 깃발로 바꿔주는 콜백메소드 
		 * @param event
		 * 
		 */
		private function onHoverCover(event:Event):void
		{
			_count++;
			trace(_count);
			if(_count > MAX_HOVER_COUNT)
			{
				var texture:Texture = _atlas.getTexture("flag");
				_image[_lastRow][_lastCol].texture = texture;
			}
		}
	}
}