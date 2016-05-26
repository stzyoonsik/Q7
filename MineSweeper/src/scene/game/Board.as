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
	
	import util.IOMgr;
	
	public class Board extends Sprite
	{
		private var _isResume:Boolean;
		private var _atlas:TextureAtlas;		
		
		private var _maxCol:int;
		private var _maxRow:int;
		
		private var _datas:Array;
		private var _colDatas:Array;
		private var _images:Array;
		private var _colImages:Array;
		
		private var _numberOfMine:int;
		private var _remainedMine:int = _numberOfMine;
		private var _hoverCount:int;
		private const MAX_HOVER_COUNT:int = 30;
		private var _lastRow:int;
		private var _lastCol:int;
		
		private var _countToClear:int;
		
		private var _isScrolled:Boolean;
		
		private var _isMineFinderSelected:Boolean;
		private var _numberOfMineFinder:int;
		private var _chanceToGetItem:Number;
		
		private var _isFirstTouch:Boolean;
		private var _resumeDatas:Array;
		private var _resumeImages:Array;
		
		/** resume=0 일반,커스텀  resume=1 이어하기*/
		public function Board(isResume:Boolean, atlas:TextureAtlas, maxRow:int, maxCol:int, mineNum:int = 0, finderNum:int = 0, chanceToGetItem:Number = 0.0,
								resumeDatas:Array = null, resumeImages:Array = null)
		{
			_isResume = isResume;
			
			_atlas = atlas;
			_countToClear = maxRow * maxCol - mineNum;
			_maxCol = maxRow + 2;
			_maxRow = maxCol + 2;
			_numberOfMine = mineNum;
			_numberOfMineFinder = finderNum;
			_chanceToGetItem = Number(chanceToGetItem / 100);
			init();
			
			_isFirstTouch = _isResume;
			if(_isResume)
			{
				_resumeDatas = resumeDatas;
				_resumeImages = resumeImages;
				resume();
			}
		}
		
		public function get numberOfMine():int { return _numberOfMine; }

		public function get chanceToGetItem():Number { return _chanceToGetItem; }

		public function get images():Array { return _images; }

		public function get datas():Array { return _datas; }

		public function get maxCol():int { return _maxRow; }

		public function get maxRow():int { return _maxCol; }

		public function get numberOfMineFinder():int { return _numberOfMineFinder; }

		public function set isMineFinderSelected(value:Boolean):void { _isMineFinderSelected = value; }

		public function get hoverCount():int{ return _hoverCount;	}
		public function set hoverCount(value:int):void{ _hoverCount = value; }

		public function get isScrolled():Boolean{ return _isScrolled; }
		public function set isScrolled(value:Boolean):void{ _isScrolled = value; }

		private function init():void
		{
			allocate();
			this.x = -Main.stageWidth * 0.1;
			this.y = Main.stageHeight * 0.25;
			addEventListener(TouchEvent.TOUCH, onTouchBlock);
		}
		
		/**
		 * 초기 위치를 세팅하는 메소드 
		 * 
		 */
		private function allocate():void
		{
			initBoard();
			allocateBlock();			
			
			
		}
		
		private function printData():void
		{
			for(var i:int = 0; i < _maxCol; ++i)
			{
				for(var j:int = 0; j < _maxRow; ++j)
				{
					trace("[data] " + i, j, _datas[i][j]);
				}				
			}
		}
		
		private function printName():void
		{
			for(var i:int = 0; i < _maxCol; ++i)
			{
				for(var j:int = 0; j < _maxRow; ++j)
				{					
					trace("[name] " + i, j, _images[i][j].name);	
				}	
			}
		}
		
		/**
		 * 보드를 초기화 시키는 메소드 
		 * 
		 */
		private function initBoard():void
		{
			_datas = new Array();
			_images = new Array();
			
			for(var y:int = 0; y < _maxCol; ++y)
			{
				_colDatas = new Array();
				_colImages = new Array();
				for(var x:int = 0; x < _maxRow; ++x)
				{
					_colDatas[x] = -2;
					var image:Image = new Image(null);
					image.name = "border";						
					_colImages[x] = image;
				}
				_datas[y] = _colDatas;
				_images[y] = _colImages;
			}			
		}
		
		private function allocateBlock():void
		{
			for(var y:int = 1; y < _maxCol - 1; ++y)
			{
				for(var x:int = 1; x < _maxRow - 1; ++x)
				{
					var texture:Texture = _atlas.getTexture("block");
					var image:Image = new Image(texture);
					image.name = "block";
					image.width = Main.stageWidth * 0.1;
					image.height = image.width;
					image.x = x * image.width;
					image.y = y * image.height;	
					
					_images[y][x] = image;
					
					addChild(image);
				}
			}
			
		}
		/**
		 * 데이터에 저장된 값을 바탕으로 화면에 지뢰를 띄워주는 메소드 
		 * @param minePos
		 * 
		 */
		private function allocateMine(minePos:Vector.<int>):void
		{
			for(var i:int = 1; i < _maxCol - 1; ++i)
			{
				for(var j:int = 1; j < _maxRow - 1; ++j)
				{
					if(minePos.indexOf((i * _maxRow) + j) != -1)
					{
						_datas[i][j] = -1;
					}
					
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
			for(var i:int = 1; i < _maxCol - 1; ++i)
			{
				for(var j:int = 1; j < _maxRow - 1; ++j)
				{
					if(minePos.indexOf((i * _maxRow) + j) != -1)
					{
						//_image[i][j].name = "mine";
					}
					else
					{
						_datas[i][j] = getMineNumber(i, j);
						//_image[i][j].name = _data[i][j].toString();		
					}		
					_images[i][j].name = "block";
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
			if(_datas[row-1][col-1] == -1) { count++; }
			if(_datas[row-1][col] == -1)   { count++; }
			if(_datas[row-1][col+1] == -1) { count++; }
			if(_datas[row][col-1] == -1)   { count++; }
			if(_datas[row][col+1] == -1)   { count++; }
			if(_datas[row+1][col-1] == -1) { count++; }
			if(_datas[row+1][col] == -1)   { count++; }
			if(_datas[row+1][col+1] == -1) { count++; }		
			
			return count;
		}
		
		/**
		 * 지뢰를 정해진 갯수만큼 랜덤한 위치에 생성하는 메소드
		 * @return 지뢰가 생성된 인덱스가 담긴 배열
		 * 
		 */
		private function plantMine(inPoint:Point):Vector.<int>			
		{
			var minePos:Vector.<int> = new Vector.<int>();
			var count:int;
			
			while(count < _numberOfMine)
			{
				var random:int = int(Math.random() * _maxCol * _maxRow);
				if(random == (inPoint.y * _maxRow) + inPoint.x)
				{			
					continue;
				}
				
				for(var i:int = 1; i < _maxCol - 1; ++i)
				{
					for(var j:int = 1; j < _maxRow - 1; ++j)
					{
						if(random == i * _maxRow + j)
						{
							//이미 지뢰인 곳인지 검사
							if(minePos.indexOf(i * _maxRow + j) == -1)
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
			for(var i:int = 1; i < _maxCol - 1; ++i)
			{
				for(var j:int = 1; j < _maxRow -1; ++j)
				{
					var touch:Touch = event.getTouch(_images[i][j]);
					if(touch)
					{
						_lastRow = i;
						_lastCol = j;
						if(touch.phase == TouchPhase.BEGAN)
						{
							addEventListener(Event.ENTER_FRAME, onHoverCover);
							_hoverCount = 0;
						}
						if(touch.phase == TouchPhase.ENDED)
						{
							removeEventListener(Event.ENTER_FRAME, onHoverCover);							
							
							if(_isScrolled)
							{
								_hoverCount = 0;
								_isScrolled = false;
								return;
							}
							//일반 터치
							if(_hoverCount < MAX_HOVER_COUNT)
							{								
								trace("[Click] " + i, j, _images[i][j].name);
								//처음 터치가 있고 난 후 지뢰를 랜덤으로 뿌림
								if(!_isFirstTouch)
								{
									var minePos:Vector.<int> = plantMine(new Point(j,i));
									allocateMine(minePos);			
									allocateNumber(minePos);
									_isFirstTouch = true;
									
								}
								
								//지뢰탐기지 사용 상태
								if(_isMineFinderSelected && _numberOfMineFinder > 0)
								{
									var checkedPoints:Vector.<Point> = detectMine(new Point(i, j), IndexChecker.CROSS);
									for each(var target:Point in checkedPoints)
									{
										showFlag(target);	
									}
									_numberOfMineFinder--;
									_isMineFinderSelected = true;
									dispatchEvent(new Event("mineFinder")); 
									return;
								}
								else
								{
									if(_datas[i][j] == -1)
									{
										_images[i][j].texture = _atlas.getTexture("mine");
										//게임오버
										dispatchEvent(new Event("game_over"));
										removeEventListener(TouchEvent.TOUCH, onTouchBlock);
									}
									else
									{
										if(_images[i][j].name != "opened")
										{
											//지뢰탐지기 아이템을 획득할 확률
											if(getMineFinder(_chanceToGetItem))
											{
												_numberOfMineFinder++;
												dispatchEvent(new Event("getMineFinder"));
												trace("아이템 획득 " + _numberOfMineFinder);
											}	
										}
										if(_datas[i][j] == 0)
										{
											openNearZeroBlocks(i, j);
										}
										else
										{
											_images[i][j].name = "opened";
											_images[i][j].texture = _atlas.getTexture(_datas[i][j].toString());
										}
										
										if(checkClear())
										{
											//게임클리어
											dispatchEvent(new Event("game_clear"));
											removeEventListener(TouchEvent.TOUCH, onTouchBlock);
										}
									}
									//printName();
									//printData();
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
			_hoverCount++;
			if(_hoverCount == MAX_HOVER_COUNT)
			{
				//한번만 들어와야함
				if(_images[_lastRow][_lastCol].name != "opened")
				{
					if(_images[_lastRow][_lastCol].name == "flag")
					{
						_images[_lastRow][_lastCol].texture = _atlas.getTexture("block");
						_images[_lastRow][_lastCol].name = "block";
						_remainedMine++;
					}
					else
					{
						_images[_lastRow][_lastCol].texture = _atlas.getTexture("flag");
						_images[_lastRow][_lastCol].name = "flag";
						_remainedMine--;
					}					
				}	
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
			if(_datas[row][col] == -2)
			{
				return;
			}
			else if(_datas[row][col] == 0)
			{			
				_images[row][col].name = "opened";
				_images[row][col].texture = _atlas.getTexture("0");
				
				if(_datas[row-1][col] != -2 && _datas[row-1][col] != -1 && _images[row-1][col].name != "opened")  
				{		
					_images[row-1][col].name = "opened";
					_images[row-1][col].texture = _atlas.getTexture(_datas[row-1][col].toString());
					openNearZeroBlocks(row-1, col);
				}
				if(_datas[row][col-1] != -2 && _datas[row][col-1] != -1 && _images[row][col-1].name != "opened")  
				{ 
					_images[row][col-1].name = "opened";
					_images[row][col-1].texture = _atlas.getTexture(_datas[row][col-1].toString());
					openNearZeroBlocks(row, col-1); 
				}
				if(_datas[row][col+1] != -2 && _datas[row][col+1] != -1 && _images[row][col+1].name != "opened") 
				{ 
					_images[row][col+1].name = "opened";
					_images[row][col+1].texture = _atlas.getTexture(_datas[row][col+1].toString());
					openNearZeroBlocks(row, col+1); 
				}	
				if(_datas[row+1][col] != -2 && _datas[row+1][col] != -1 && _images[row+1][col].name != "opened")
				{
					_images[row+1][col].name = "opened";
					_images[row+1][col].texture = _atlas.getTexture(_datas[row+1][col].toString());
					openNearZeroBlocks(row+1, col); 
				}
				
				if(_datas[row-1][col-1] != -2 && _datas[row-1][col-1] != -1 && _images[row-1][col-1].name != "opened")
				{
					_images[row-1][col-1].name = "opened";
					_images[row-1][col-1].texture = _atlas.getTexture(_datas[row-1][col-1].toString());
				}
				
				if(_datas[row-1][col+1] != -2 && _datas[row-1][col+1] != -1 && _images[row-1][col+1].name != "opened")
				{
					_images[row-1][col+1].name = "opened";
					_images[row-1][col+1].texture = _atlas.getTexture(_datas[row-1][col+1].toString());
				}
				
				if(_datas[row+1][col-1] != -2 && _datas[row+1][col-1] != -1 && _images[row+1][col-1].name != "opened")
				{
					_images[row+1][col-1].name = "opened";
					_images[row+1][col-1].texture = _atlas.getTexture(_datas[row+1][col-1].toString());
				}
				
				if(_datas[row+1][col+1] != -2 && _datas[row+1][col+1] != -1 && _images[row+1][col+1].name != "opened")
				{
					_images[row+1][col+1].name = "opened";
					_images[row+1][col+1].texture = _atlas.getTexture(_datas[row+1][col+1].toString());
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
			
			for(var i:int = 1; i < _maxCol - 1; ++i)
			{
				for(var j:int = 1; j < _maxRow -1; ++j)
				{
					if(_images[i][j].name == "opened")
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
		
		/**
		 * 해당 인덱스가 지뢰인지 아닌지 검사하는 메소드
		 * @param inPoint 비교 인덱스
		 * @return 지뢰이면 true 아니면 false
		 * 
		 */
		private function isMine(inPoint:Point):Boolean
		{
			return _datas[inPoint.y][inPoint.x] == -1
		}
		
		/**
		 * 특정 인덱스 기준으로 targetIndex의 지뢰여부 확인 함수
		 * @param inIndex 선택한 인덱스
		 * @param detectTargetIndex
		 * @return 지뢰 좌표가 담긴 배열 
		 */
		private function detectMine(inPoint:Point, inTargetPoints:Vector.<Point> = null):Vector.<Point>
		{
			var result:Vector.<Point> = new Vector.<Point>();
			
			if (inTargetPoints == null) 
			{
				inTargetPoints = new Vector.<Point>;
				inTargetPoints.push (new Point(0, 0));
			}				
			
			for each (var target:Point in inTargetPoints) 
			{				
				var targetPoint:Point = new Point(inPoint.y + target.y, inPoint.x + target.x);
				
				if(isMine(targetPoint))
				{
					result.push(targetPoint);
				}	
			}
			
			return result;
		}
		
		/**
		 * 지뢰가 탐지된 영역의 이미지를 깃발로 바꿔주는 메소드
		 * @param inPoint 좌표
		 * 
		 */
		private function showFlag(inPoint:Point):void
		{
			_images[inPoint.y][inPoint.x].texture = _atlas.getTexture("flag");
			_images[inPoint.y][inPoint.x].name = "flag";
			_remainedMine--;
		}
		
		/**
		 *  
		 * @param chance 0~1 사이 확률
		 * 
		 */
		private function getMineFinder(chance:Number):Boolean
		{
			trace(chance);
			if(chance < 0 || chance > 1)
			{
				trace("chance should be between 0 and 1");
				return false;
			}
				
			if(Math.random() <= chance)
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * 이어하기로 보드가 생성됬을때 이전 상태로 복원하는 메소드 
		 * 
		 */
		private function resume():void
		{
			for(var i:int = 0; i < _maxCol ; ++i)
			{
				for(var j:int = 0; j < _maxRow ; ++j)
				{
					//trace(_resumeDatas[i * (_maxCol - 2) + j]);
					_datas[i][j] = _resumeDatas[i * (_maxRow) + j];
					_images[i][j].name = _resumeImages[i * (_maxRow) + j];
					//trace(_images[i][j].name);
					if(_images[i][j].name == "opened")
					{
						_images[i][j].texture = _atlas.getTexture(_datas[i][j].toString());
					}
					else if(_images[i][j].name == "flag")
					{
						_images[i][j].texture = _atlas.getTexture("flag");
					}
				}
			}
		}

	}
}

