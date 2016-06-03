package scene.game.board
{	
	import flash.geom.Point;
	
	import scene.Main;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	
	import util.IndexChecker;
	
	public class Board extends DisplayObjectContainer
	{
		private var _isResume:Boolean;
		private var _atlas:TextureAtlas;
		
		private var _difficulty:int;
		
		private var _maxRow:int;
		private var _maxCol:int;
		
		private var _datas:Array;
		private var _images:Array;
		private var _items:Array;
		
		private var _numberOfMine:int;
		private var _remainedMine:int = _numberOfMine;
		private var _hoverCount:int;
		private const MAX_HOVER_COUNT:int = 30;
		private var _lastX:int;
		private var _lastY:int;
		
		private var _countToClear:int;
		
		private var _isScrolled:Boolean;
		
		private var _isMineFinderSelected:Boolean;
		private var _numberOfMineFinder:int;				//가지고 있는 지뢰탐지기의 갯수
		private var _maxMineFinder:int;						//게임 시작 시 생성 될 지뢰탐지기의 갯수
		private var _chanceToGetItem:Number;
		
		private var _isFirstTouch:Boolean;
		private var _resumeDatas:Array;
		private var _resumeImages:Array;
		private var _resumeItems:Array;
		
		/** resume=0 일반,커스텀  resume=1 이어하기*/
		public function Board(isResume:Boolean, atlas:TextureAtlas, difficulty:int, maxRow:int, maxCol:int, mineNum:int = 0, finderNum:int = 0, chanceToGetItem:Number = 0.0,
								resumeDatas:Array = null, resumeImages:Array = null, resumeItems:Array = null)
		{
			_isResume = isResume;
			
			_atlas = atlas;
			_difficulty = difficulty;
			_countToClear = maxRow * maxCol - mineNum;
			_maxRow = maxRow + 2;
			_maxCol = maxCol + 2;
			trace("생성자 _maxRow = " + _maxRow);
			trace("생성자 _maxCol = " + _maxCol);
			_numberOfMine = mineNum;
			_numberOfMineFinder = finderNum;
			_chanceToGetItem = Number(chanceToGetItem / 100);
			_maxMineFinder = int(((maxRow * maxCol) - mineNum) * (chanceToGetItem / 100));
			init();
			
			_isFirstTouch = _isResume;
			if(_isResume)
			{
				_resumeDatas = resumeDatas;
				_resumeImages = resumeImages;
				_resumeItems = resumeItems;
				resume();
			}
			
		}
		
		public function get difficulty():int { return _difficulty; }

		public function get items():Array { return _items; }

		public function get numberOfMine():int { return _numberOfMine; }

		public function get chanceToGetItem():Number { return _chanceToGetItem; }

		public function get images():Array { return _images; }

		public function get datas():Array { return _datas; }

		public function get maxCol():int { return _maxCol; }

		public function get maxRow():int { return _maxRow; }

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
//			for(var y:int = 0; y < _maxCol; ++y)
//			{
//				for(var x:int = 0; x < _maxRow; ++x)
//				{
//					trace("[data] " + x, y, _datas[y][x]);
//				}				
//			}
		
		}
		
		private function printName():void
		{
			for(var y:int = 0; y < _maxCol; ++y)
			{
				for(var x:int = 0; x < _maxRow; ++x)
				{
					trace("[name] " + x, y, _images[y][x].name);
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
			_items = new Array();
			
			for(var y:int = 0; y < _maxCol; ++y)
			{
				var colDatas:Array = new Array();
				var colImages:Array = new Array();
				var colItems:Array = new Array();
				
				for(var x:int = 0; x < _maxRow; ++x)
				{
					colDatas[x] = -2;
					var image:Image = new Image(null);
					image.name = "border";						
					colImages[x] = image;
					colItems[x] = 0;
				}
				_datas[y] = colDatas;
				_images[y] = colImages;
				_items[y] = colItems;
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
		private function allocateMineAndItem(minePos:Vector.<int>, itemPos:Vector.<int>):void
		{
			trace("지뢰 포지션 = " + minePos);
			trace("아이템 포지션 = " + itemPos);
			for(var y:int = 0; y < _maxCol; ++y)
			{
				for(var x:int = 0; x < _maxRow; ++x)
				{
					if(minePos.indexOf((y * _maxRow) + x) != -1)
					{
						_datas[y][x] = -1;
						//_images[y][x].texture = _atlas.getTexture("mine");
					}
					if(itemPos.indexOf(y * _maxRow + x) != -1)
					{
						_items[y][x] = 1;
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
			for(var y:int = 1; y < _maxCol - 1; ++y)
			{
				for(var x:int = 1; x < _maxRow - 1; ++x)
				{
					if(_datas[y][x] != -1)
					{
						_datas[y][x] = getMineNumber(x, y);
						
					}		
					_images[y][x].name = "block";
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
		private function getMineNumber(x:int, y:int):int
		{
			var count:int;	
			if(_datas[y-1][x-1] == -1) { count++; }
			if(_datas[y-1][x] == -1)   { count++; }
			if(_datas[y-1][x+1] == -1) { count++; }
			if(_datas[y][x-1] == -1)   { count++; }
			if(_datas[y][x+1] == -1)   { count++; }
			if(_datas[y+1][x-1] == -1) { count++; }
			if(_datas[y+1][x] == -1)   { count++; }
			if(_datas[y+1][x+1] == -1) { count++; }	
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
				var random:int = int(Math.random() * _maxRow * _maxCol);
				//처음 클릭한 위치
				if(random == (inPoint.y * _maxRow) + inPoint.x)
				{			
					continue;
				}
				
				for(var y:int = 1; y < _maxCol - 1; ++y)
				{
					for(var x:int = 1; x < _maxRow - 1; ++x)
					{
						if(random == y * _maxRow + x)
						{
							//이미 지뢰인 곳인지  중복 검사
							if(minePos.indexOf(y * _maxRow + x) == -1)
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
		
		private function plantItem(minePos:Vector.<int>):Vector.<int>
		{
			var itemPos:Vector.<int> = new Vector.<int>();
			//var itemPos:Vector.<Point> = new Vector.<Point>();
			var count:int;
			trace(_maxMineFinder);
			while(count < _maxMineFinder)
			{
				var random:int = int(Math.random() * _maxRow * _maxCol);
				//trace(random);
				for(var y:int = 1; y < _maxCol - 1; ++y)
				{
					for(var x:int = 1; x < _maxRow - 1; ++x)
					{
						if(random == y * _maxRow + x)
						{
							//현재 지점이 지뢰가 아니면
							var point:Point = new Point(x, y);
							if(!isMine(point) && itemPos.indexOf(y * _maxRow + x) == -1)
							{
								itemPos.push(random);
								count++;
															
							}
						}
					}
				}
			}
			
			trace("생성된 아이템 개수 = " + itemPos.length);
			return itemPos;
		}
		
		private function isItem(inPoint:Point):Boolean
		{
			return _items[inPoint.y][inPoint.x] != 0;
		}
		/**
		 * 터치한 지점을 열어주는 메소드
		 * @param event 터치이벤트
		 * 
		 */
		private function onTouchBlock(event:TouchEvent):void
		{
			for(var y:int = 1; y < _maxCol - 1; ++y)
			{
				for(var x:int = 1; x < _maxRow -1; ++x)
				{
					var touch:Touch = event.getTouch(_images[y][x]);
					if(touch)
					{
						_lastX = x;
						_lastY = y;
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
								trace("[Click] " + x, y, _images[y][x].name);
								//처음 터치가 있고 난 후 지뢰를 랜덤으로 뿌림
								if(!_isFirstTouch)
								{
									var minePos:Vector.<int> = plantMine(new Point(x, y));
									var itemPos:Vector.<int> = plantItem(minePos);
									allocateMineAndItem(minePos, itemPos);			
									allocateNumber(minePos);
									_isFirstTouch = true;
									
								}
								
								//지뢰탐기지 사용 상태
								if(_isMineFinderSelected && _numberOfMineFinder > 0)
								{
									var checkedPoints:Vector.<Point> = detectMine(new Point(x, y), IndexChecker.CROSS);
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
									if(_datas[y][x] == -1)
									{
										showAllMines(new Point(x,y));
										//게임오버
										dispatchEvent(new Event("game_over"));
										removeEventListener(TouchEvent.TOUCH, onTouchBlock);
									}
									else
									{
										//여기에서 아이템 검사
										if(checkItem(new Point(x,y)))
										{
											getItem(new Point(x,y));
										}
										
										if(_datas[y][x] == 0)
										{
											openNearZeroBlocks(new Point(x, y));
										}
										else
										{
											_images[y][x].name = "opened";
											_images[y][x].texture = _atlas.getTexture(_datas[y][x].toString());
										}
										
										if(checkClear())
										{
											//게임클리어
											dispatchEvent(new Event("game_clear"));
											removeEventListener(TouchEvent.TOUCH, onTouchBlock);
										}
									}
//									printName();
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
				if(_images[_lastY][_lastX].name != "opened")
				{
					if(_images[_lastY][_lastX].name == "flag")
					{
						_images[_lastY][_lastX].texture = _atlas.getTexture("block");
						_images[_lastY][_lastX].name = "block";
						_remainedMine++;
					}
					else
					{
						_images[_lastY][_lastX].texture = _atlas.getTexture("flag");
						_images[_lastY][_lastX].name = "flag";
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
		private function openNearZeroBlocks(inPoint:Point):void
		{			
			if(_datas[inPoint.y][inPoint.x] == -2)
			{
				return;
			}
			
			if(checkItem(inPoint))
			{
				getItem(inPoint);
			}
			
			if(_datas[inPoint.y][inPoint.x] == 0)
			{			
				
				openBlock(inPoint);
				
				checkZeroBlock(new Point(inPoint.x, inPoint.y), IndexChecker.SQUARE);
			}
		
		}
		
		/**
		 *  
		 * @param inPoint x,y 좌표
		 * @param inTargetPoints
		 * 
		 */
		private function checkZeroBlock(inPoint:Point, inTargetPoints:vector.<Point> = null):void
		{
			for each (var target:Point in inTargetPoints) 
			{				
				var targetPoint:Point = new Point(inPoint.x + target.x, inPoint.y + target.y);
				if(checkBlock(targetPoint))
				{
					openBlock(targetPoint);
					openNearZeroBlocks(targetPoint);
				}				
			}
		}
		
		/**
		 * 벽도 아니고 지뢰도 아니고 열려있는 상태도 아니면 true를 리턴
		 * @param x 좌표
		 * @param y 좌표
		 * @return 
		 * 
		 */
		private function checkBlock(inPoint:Point):Boolean
		{
			return _datas[inPoint.y][inPoint.x] != -2 && _datas[inPoint.y][inPoint.x] != -1 && _images[inPoint.y][inPoint.x].name != "opened";				
		}
		
		private function openBlock(inPoint:Point):void
		{
			_images[inPoint.y][inPoint.x].name = "opened";
			_images[inPoint.y][inPoint.x].texture = _atlas.getTexture(_datas[inPoint.y][inPoint.x].toString());
		}
		
		private function checkItem(inPoint:Point):Boolean
		{
			return _items[inPoint.y][inPoint.x] != 0;
		}
		
		private function getItem(inPoint:Point):void
		{
			_items[inPoint.y][inPoint.x] = 0;
			trace("아이템 획득");
			_numberOfMineFinder++;
			dispatchEvent(new Event("getMineFinder"));
			
			var effect:TextField = new TextField(Main.stageWidth * 0.2, Main.stageHeight * 0.1, "아이템 획득");
			effect.alignPivot("center", "center");
			effect.format.color = Color.RED;
			effect.format.size = Main.stageWidth * 0.05;
			effect.x = inPoint.x * Main.stageWidth * 0.1 + Main.stageWidth * 0.05;
			effect.y = inPoint.y * Main.stageWidth * 0.1 + Main.stageWidth * 0.05;
			addChild(effect);
			effect.addEventListener(Event.ENTER_FRAME, onGetItem);
		}
		
		private function onGetItem(event:Event):void
		{
			(event.currentTarget as TextField).alpha -= 0.01;
			if((event.currentTarget as TextField).alpha <= 0)
			{
				(event.currentTarget as TextField).removeEventListener(Event.ENTER_FRAME, onGetItem);
				removeChild((event.currentTarget as TextField));
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
			
			for(var y:int = 1; y < _maxCol - 1; ++y)
			{
				for(var x:int = 1; x < _maxRow -1; ++x)
				{
					if(_images[y][x].name == "opened")
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
				var targetPoint:Point = new Point(inPoint.x + target.x, inPoint.y + target.y);
				
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
			trace("resumeDatas = " + _resumeDatas);
			for(var y:int = 0; y < _maxCol ; ++y)
			{
				for(var x:int = 0; x < _maxRow ; ++x)
				{
					
					_datas[y][x] = _resumeDatas[(y * (_maxRow )) + x];
					_images[y][x].name = _resumeImages[(y * (_maxRow )) + x];
					_items[y][x] = _resumeItems[(y * (_maxRow )) + x];
					
					if(_images[y][x].name == "opened")
					{
						_images[y][x].texture = _atlas.getTexture(_datas[y][x].toString());
					}
					else if(_images[y][x].name == "flag")
					{
						_images[y][x].texture = _atlas.getTexture("flag");
					}
				}
			}
			
			trace("이어하기 resume() 데이터 " + _datas);
		}
		
		/**
		 * 모든 지뢰의 위치를 보여주는 메소드 
		 * @param inPoint 클릭 위치
		 * 
		 */
		private function showAllMines(inPoint:Point):void
		{
			for(var y:int = 0; y < _maxCol ; ++y)
			{
				for(var x:int = 0; x < _maxRow ; ++x)
				{
					if(_datas[y][x] == -1)
					{
						_images[y][x].texture = _atlas.getTexture("mine");
					}
				}
			}
			
			_images[inPoint.y][inPoint.x].texture = _atlas.getTexture("mine_exploded");
		}

	}
}

