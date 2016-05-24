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
	
	public class Board extends Sprite
	{
		private var _atlas:TextureAtlas;		
		
		private var _maxRow:int;
		private var _maxCol:int;
		
		private var _data:Array;
		private var _colData:Array;
		private var _image:Array;
		private var _colImage:Array;
		
		private var _numberOfMine:int;
		private var _count:int;
		private const MAX_HOVER_COUNT:int = 30;
		private var _lastRow:int;
		private var _lastCol:int;
		
		private var _countToClear:int;
		
		private var _isScrolled:Boolean;
		
		public function Board(atlas:TextureAtlas, maxRow:int, maxCol:int, mineNum:int, minePos:Vector.<int> = null)
		{
			_atlas = atlas;
			_countToClear = maxRow * maxCol - mineNum;
			_maxRow = maxRow + 2;
			_maxCol = maxCol + 2;
			_numberOfMine = mineNum;
			init();
		}
		
		public function get count():int{ return _count;	}
		public function set count(value:int):void{ _count = value; }

		public function get isScrolled():Boolean{ return _isScrolled; }
		public function set isScrolled(value:Boolean):void{ _isScrolled = value; }

		private function init():void
		{
			allocate();
			this.x = Main.stageWidth * 0.02;
			this.y = Main.stageHeight * 0.25;
			//addEventListener(TouchEvent.TOUCH, onScrollBoard);
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
			
			//printData();
			//printName();
		}
		
//		private function printData():void
//		{
//			for(var i:int = 0; i < _maxRow; ++i)
//			{
//				for(var j:int = 0; j < _maxCol; ++j)
//				{
//					trace("[data] " + i, j, _data[i][j]);
//				}				
//			}
//		}
//		
//		private function printName():void
//		{
//			for(var i:int = 0; i < _maxRow; ++i)
//			{
//				for(var j:int = 0; j < _maxCol; ++j)
//				{					
//					trace("[name] " + i, j, _image[i][j].name);	
//				}	
//			}
//		}
		
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
					_colData[j] = -2;
					var image:Image = new Image(null);
					image.name = "border";						
					_colImage[j] = image;
				}
				_data[i] = _colData;
				_image[i] = _colImage;
			}
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
						_data[i][j] = -1;
					}
					var texture:Texture = _atlas.getTexture("block");
					var image:Image = new Image(texture);
					image.width = Main.stageWidth * 0.1;
					image.height = image.width;
					image.x = i * image.width;
					image.y = j * image.height;	
					
					_image[i][j] = image;
					
					addChild(image);
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
						_image[i][j].name = "mine";
					}
					else
					{
						_data[i][j] = getMineNumber(i, j);
						_image[i][j].name = _data[i][j].toString();		
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
		private function getMineNumber(row:int, col:int):int
		{
			var count:int;
			if(_data[row-1][col-1] == -1) { count++; }
			if(_data[row-1][col] == -1)   { count++; }
			if(_data[row-1][col+1] == -1) { count++; }
			if(_data[row][col-1] == -1)   { count++; }
			if(_data[row][col+1] == -1)   { count++; }
			if(_data[row+1][col-1] == -1) { count++; }
			if(_data[row+1][col] == -1)   { count++; }
			if(_data[row+1][col+1] == -1) { count++; }		
			
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
							
							if(_isScrolled)
							{
								_count = 0;
								_isScrolled = false;
								return;
							}
							//일반 터치
							if(_count < MAX_HOVER_COUNT)
							{
								trace("[Click] " + i, j, _image[i][j].name);
								
								if(_data[i][j] == -1)
								{
									_image[i][j].texture = _atlas.getTexture("mine");
									dispatchEvent(new Event("game_over"));
									removeEventListener(TouchEvent.TOUCH, onTouchBlock);
								}
								else
								{
									if(_data[i][j] == 0)
									{
										openNearZeroBlocks(i, j);
									}
									else
									{
										_image[i][j].name = "opened";
										_image[i][j].texture = _atlas.getTexture(_data[i][j].toString());
									}
									
									if(checkClear())
									{
										dispatchEvent(new Event("game_clear"));
									}
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
			//event.
			_count++;
			if(_count > MAX_HOVER_COUNT)
			{
				var texture:Texture = _atlas.getTexture("flag");
				if(_image[_lastRow][_lastCol].name != "opened")
					_image[_lastRow][_lastCol].texture = texture;
			}
		}
		
		/**
		 * 선택한 블록에 가로,세로로 인접한 (대각선 제외) 모든 0을 오픈해주는 메소드
		 * @param row 행
		 * @param col 열
		 * 
		 */
		private function openNearZeroBlocks(row:int, col:int):void
		{			
			if(_data[row][col] == -2)
			{
				return;
			}
			else if(_data[row][col] == 0)
			{			
				//_openCount++;
				_image[row][col].name = "opened";
				_image[row][col].texture = _atlas.getTexture("0");
				
				if(_data[row-1][col] != -2 && _data[row-1][col] != -1 && _image[row-1][col].name != "opened")  
				{					
					_image[row-1][col].name = "opened";
					_image[row-1][col].texture = _atlas.getTexture(_data[row-1][col].toString());
					openNearZeroBlocks(row-1, col);
				}
				if(_data[row][col-1] != -2 && _data[row][col-1] != -1 && _image[row][col-1].name != "opened")  
				{ 
					_image[row][col-1].name = "opened";
					_image[row][col-1].texture = _atlas.getTexture(_data[row][col-1].toString());
					openNearZeroBlocks(row, col-1); 
				}
				if(_data[row][col+1] != -2 && _data[row][col+1] != -1 && _image[row][col+1].name != "opened") 
				{ 
					_image[row][col+1].name = "opened";
					_image[row][col+1].texture = _atlas.getTexture(_data[row][col+1].toString());
					openNearZeroBlocks(row, col+1); 
				}	
				if(_data[row+1][col] != -2 && _data[row+1][col] != -1 && _image[row+1][col].name != "opened")
				{
					_image[row+1][col].name = "opened";
					_image[row+1][col].texture = _atlas.getTexture(_data[row+1][col].toString());
					openNearZeroBlocks(row+1, col); 
				}
			}
		}
		
		
		/**
		 * 게임을 성공적으로 마쳤는지 검사하는 메소드 
		 * @return 클리어 했으면 true 아니면 false
		 * 
		 */
		private function checkClear():Boolean
		{
			var count:int;
			
			for(var i:int = 1; i < _maxRow - 1; ++i)
			{
				for(var j:int = 1; j < _maxCol -1; ++j)
				{
					if(_image[i][j].name == "opened")
					{
						count++;
					}
				}
			}
			
			if(count >= _countToClear)
			{
				return true;
			}
			
			return false;					
		}

	}
}

