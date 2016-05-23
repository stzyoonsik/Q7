package scene.game
{	
	import scene.Main;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import util.EmbeddedAssets;
	
	public class Board extends Sprite
	{
		private var _atlas:TextureAtlas;
		
		private var _gameBoard:Sprite;
		
		private var _maxRow:int;
		private var _maxCol:int;
		private var _numberOfMine:int;
		
		private var _data:Array;
		private var _colData:Array;
		private var _image:Array;
		private var _colImage:Array;
		
		private var _isOpen:Boolean;
		
		public function Board(maxRow:int, maxCol:int, mine:int)
		{
			_maxRow = maxRow + 2;
			_maxCol = maxCol + 2;
			_numberOfMine = mine;
			
			init();
		}
		
		private function init():void
		{
			load();		
			
			_gameBoard = new Sprite();
			allocate();
			_gameBoard.x = Main.stageWidth * 0.02;
			_gameBoard.y = Main.stageHeight * 0.25;
		}
		
		/**
		 * 메모리 해제 메소드. 타입을 검사하여 해제시킴.
		 * @param obj 오브젝트 
		 * 
		 */
		private function release(obj:Object):void
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
		
		/**
		 * 초기 위치를 세팅하는 메소드 
		 * 
		 */
		private function allocate():void
		{
			_data = new Array();
			_image = new Array();
			
			initBoard();
			
			var minePos:Vector.<int> = plantMine();
			allocateMine(minePos);			
			allocateNumber(minePos);
			
			addChild(_gameBoard);
		}
		
		/**
		 * 보드를 초기화 시키는 메소드 
		 * 
		 */
		private function initBoard():void
		{
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
			
			release(_colData);
			release(_colImage);
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
						var texture:Texture = _atlas.getTexture("mine");
						_data[i][j] = -2;
						
						putImage(texture, i, j);
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
						var texture:Texture = _atlas.getTexture(getMineNumber(i, j).toString());
						
						putImage(texture, i, j);						
					}					
				}				
			}
		}
		
		/**
		 * 
		 * @param texture 텍스쳐
		 * @param row 행
		 * @param col 렬
		 * 
		 */
		private function putImage(texture:Texture, row:int, col:int):void
		{
			var image:Image = new Image(texture);
			image.width = Main.stageWidth * 0.08;
			image.height = image.width;
			image.x = row * image.width;
			image.y = col * image.height;	
			
			_image[row][col] = image;
			_gameBoard.addChild(image);
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
		
//		private function onTouchBlock(event:TouchEvent):void
//		{
//			for(var i:int = 1; i < _maxRow - 1; ++i)
//			{
//				for(var j:int = 1; j < _maxCol -1; ++j)
//				{
//					var touch:Touch = event.getTouch(_image[i][j], TouchPhase.ENDED);
//					if(touch)
//					{
//						trace(i, j);
//						//open(i, j);
//						_image[i][j].texture = _atlas.getTexture(_data[i][j].toString());
//					}
//				}
//			}
//			
//		}
//		
//		private function open(col:int, row:int):void
//		{
//			checkNumber(col, row);
//		}
//		
//		private function checkNumber(col:int, row:int):int
//		{
//			var mineCount:int;
//			/**
//			 * 00 01 02 03 04 05 06 07 08 09
//			 * 10 11 12 13 14 15 16 17 18 19
//			 * 20 21 22 23 24 25 26 27 28 29
//			 * 30 31 32 33 34 35 36 37 38 39
//			 * 40 41 42 43 44 45 46 47 48 49
//			 * 50 51 52 53 54 55 56 57 58 59
//			 * 60 61 62 63 64 65 66 67 68 69
//			 * 70 71 72 73 74 75 76 77 78 79
//			 * 80 81 82 83 84 85 86 87 88 89
//			 * 90 91 92 93 94 95 96 97 98 99  
//			 * */
//			//↖
//			if(col == 0 && row == 0)
//			{
//				
//			}
//			if(_data[col-1][row-1] == -2)
//			{
//				mineCount++;
//			}
//			
//			return mineCount;
//		}
	}
}

