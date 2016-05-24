package scene.game
{	
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
	
	public class Board extends GameBoard
	{
		private var _numberOfMine:int;
		private var _count:int;
		private const MAX_HOVER_COUNT:int = 30;
		private var _lastRow:int;
		private var _lastCol:int;
		
		public function Board(atlas:TextureAtlas, maxRow:int, maxCol:int, mineNum:int, minePos:Vector.<int> = null)
		{
			_atlas = atlas;
			_maxRow = maxRow + 2;
			_maxCol = maxCol + 2;
			_numberOfMine = mineNum;
			
			init();
		}
		
		private function init():void
		{
			allocate();
			this.x = Main.stageWidth * 0.02;
			this.y = Main.stageHeight * 0.25;
			//this.addEventListener(TouchEvent.TOUCH, onScrollBoard);
			addEventListener(TouchEvent.TOUCH, onTouchBlock);
		}
		
		/**
		 * 초기 위치를 세팅하는 메소드 
		 * 
		 */
		private function allocate():void
		{
			initBoard();
			
			var minePos:Vector.<int> = plantMine();
			allocateMine(minePos);			
			allocateNumber(minePos);
		}
		
		/**
		 * 보드를 초기화 시키는 메소드 
		 * 
		 */
		private function initBoard():void
		{
			_data = new Array();
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
				_data[i] = _colData;
				_image[i] = _colImage;
			}
			
			releaseObject(_colData);
			releaseObject(_colImage);
		}
		
		/**
		 * 데이터에 저장된 값을 바탕으로 화면에 지뢰를 띄워주는 메소드 
		 * @param minePos
		 * 
		 */
		private function allocateMine(minePos:Vector.<int>):void
		{
			for(var i:int = 1; i < _maxRow - 1; ++i)
			{
				for(var j:int = 1; j < _maxCol - 1; ++j)
				{
					if(minePos.indexOf((i * _maxCol) + j) != -1)
					{
						//var texture:Texture = _atlas.getTexture("mine");
						_data[i][j] = -2;
						
						//putImage(texture, i, j);
					}
					var texture:Texture = _atlas.getTexture("block");
					putImage(texture, i, j);
				}
			}
		}
		
		/**
		 * 주변 8방위의 지뢰 갯수를 검사한 뒤, 그 숫자의 이미지를 띄워주는 메소드 
		 * @param minePos
		 * 
		 */
		private function allocateNumber(minePos:Vector.<int>):void
		{
			for(var i:int = 1; i < _maxRow - 1; ++i)
			{
				for(var j:int = 1; j < _maxCol - 1; ++j)
				{
					if(minePos.indexOf((i * _maxCol) + j) != -1)
					{
						continue;
					}
					else
					{
						_data[i][j] = getMineNumber(i, j);
						//var texture:Texture = _atlas.getTexture(getMineNumber(i, j).toString());
						
						//putImage(texture, i, j);						
					}					
				}				
			}
		}		
		
		
		/**
		 * 자기 중심 8방위의 셀을 검사하여 지뢰의 갯수를 검사한뒤 리턴하는 메소드
		 * @param i column
		 * @param j row
		 * @return 주위의 지뢰의 갯수
		 * 
		 */
		private function getMineNumber(i:int, j:int):int
		{
			var count:int;
			if(_data[i-1][j-1] == -2) { count++; }
			if(_data[i-1][j] == -2)   { count++; }
			if(_data[i-1][j+1] == -2) { count++; }
			if(_data[i][j-1] == -2)   { count++; }
			if(_data[i][j+1] == -2)   { count++; }
			if(_data[i+1][j-1] == -2) { count++; }
			if(_data[i+1][j] == -2)   { count++; }
			if(_data[i+1][j+1] == -2) { count++; }			
			
			return count;
		}
		
		/**
		 * 지뢰를 정해진 갯수만큼 랜덤한 위치에 생성하는 메소드
		 * @return 지뢰가 생성된 인덱스가 담긴 배열
		 * 
		 */
		private function plantMine():Vector.<int>			
		{
			var minePos:Vector.<int> = new Vector.<int>();
			var count:int;
			
			while(count < _numberOfMine)
			{
				var random:int = int(Math.random() * 100);
				
				for(var i:int = 1; i < _maxRow - 1; ++i)
				{
					for(var j:int = 1; j < _maxCol - 1; ++j)
					{
						if(random == i * _maxCol + j)
						{
							if(minePos.indexOf(i * _maxCol + j) == -1)
							{
								minePos.push(random);
								count++;
							}
						}
					}					
				}				
			}				
			return minePos;
		}
		
		/**
		 * 터치한 지점을 열어주는 메소드
		 * @param event 터치이벤트
		 * 
		 */
		private function onTouchBlock(event:TouchEvent):void
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
								if(_data[i][j] == -2)
								{
									_image[i][j].texture = _atlas.getTexture("mine");
								}
								else
								{
									if(_data[i][j] == 0)
									{
										openNearZeroBlocks(i, j);
									}
									_image[i][j].texture = _atlas.getTexture(_data[i][j].toString());
								}								
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
		
		private function openNearZeroBlocks(row:int, col:int):void
		{
			
		}

	}
}

