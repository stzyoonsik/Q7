package scene.game
{
	import flash.utils.Dictionary;
	
	import scene.Main;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	import util.EmbeddedAssets;

	public class Game extends Sprite
	{
		private var _atlas:TextureAtlas;
		
		private var _gameBoard:Sprite;
		
		private var _maxRow:int;
		private var _maxCol:int;
		private var _numberOfMine:int;
		
//		private var _data:Vector.<int> = new Vector.<int>();
//		private var _colData:Vector.<int> = new Vector.<int>();
//		private var _image:Vector.<Image>;
//		private var _colImage:Vector.<Image>;
		
		private var _data:Array;
		private var _colData:Array;
		private var _image:Array;
		private var _colImage:Array;
		
		private var _isOpen:Boolean;
		
		public function Game()
		{
			init();
		}
		
		private function init():void
		{
			load();
			
			
			_maxRow = 10;
			_maxCol = 10;
			_maxRow += 2;
			_maxCol += 2;
			_numberOfMine = 10;
			
			_gameBoard = new Sprite();
			allocate();
			_gameBoard.x = Main.stageWidth * 0.02;
			_gameBoard.y = Main.stageHeight * 0.25;
		}
		
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
			trace(minePos);
			//allocateMine(minePos);
			allocateNumber(minePos);
			addChild(_gameBoard);
		}
		
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
		}
		private function allocateMine(minePos:Vector.<int>):void
		{
			for(var i:int = 1; i < _maxRow - 1; ++i)
			{
				//_colData = new Array();
				//_colImage = new Array();
				for(var j:int = 1; j < _maxCol - 1; ++j)
				{
					//trace(minePos);
					//trace(i * 10 + j);
					if(minePos.indexOf((i * _maxCol) + j) != -1)
					{
						var texture:Texture = _atlas.getTexture("mine");
						_data[i][j] = -2;
					}
					else
					{
						texture = null;
						_data[i][j] = 0;
					}
					var image:Image = new Image(texture);
					image.width = Main.stageWidth * 0.08;
					image.height = image.width;
					image.x = j * image.width;
					image.y = i * image.height;
					//image.addEventListener(TouchEvent.TOUCH, onTouchBlock);
					
					
					_image[i][j] = image;
					_gameBoard.addChild(image);
				}
				_data[i] = _colData;
				_image[i] = _colImage;
				
				//_colImage.splice(0, _colImage.length);
			}
		}
		
		private function allocateNumber(minePos:Vector.<int>):void
		{
			for(var i:int = 1; i < _maxRow - 1; ++i)
			{
				for(var j:int = 1; j < _maxCol - 1; ++j)
				{
					var texture:Texture = null;
					if(minePos.indexOf((i * _maxCol) + j) != -1)
					{
						continue;
					}
					else
					{
						_data[i][j] = getMineNumber(i, j);
						texture = _atlas.getTexture(getMineNumber(i, j).toString());
						//_colData[j] = -1;
					}
					var image:Image = new Image(texture);
					image.width = Main.stageWidth * 0.08;
					image.height = image.width;
					image.x = j * image.width;
					image.y = i * image.height;
					//image.addEventListener(TouchEvent.TOUCH, onTouchBlock);
					
					
					_image[i][j] = image;
					_gameBoard.addChild(image);
				}
//				}
//				_data[i] = _colData;
//				_image[i] = _colImage;
				
				//_colImage.splice(0, _colImage.length);
			}
		}
		
		private function getMineNumber(i:int, j:int):int
		{
			var count:int;
			//trace(_data[i-1][j-1]);
			if(_data[i-1][j-1] != 0)	{ count++; }
			if(_data[i-1][j] != 0) { count++; }
			if(_data[i-1][j+1] != 0) { count++; }
			if(_data[i][j-1] != 0) { count++; }
			if(_data[i][j+1] != 0) { count++; }
			if(_data[i+1][j-1] != 0) { count++; }
			if(_data[i+1][j] != 0) { count++; }
			if(_data[i+1][j+1] != 0) { count++; }			
			
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
			
			while(true)
			{
				var random:int = int(Math.random() * 100);
				
//				if(random < _maxCol - 1 || random >= _maxCol * _maxRow - 1)		
//				{
//					continue;
//				}
//				
//				for(var i:int = 0; i < minePos.length; ++i)
//				{
//					if(random == minePos[i])
//					{
//						minePos.pop();
//						count--;
//					}
//				}
				
				for(var i:int = 1; i < _maxRow - 1; ++i)
				{
					for(var j:int = 1; j < _maxCol - 1; ++j)
					{
						if(random == i * _maxCol + j)
						{
							if(minePos.indexOf(i * _maxCol + j) == -1)
							{
								//minePos.pop();
								//count--;
								minePos.push(random);
								count++;
							}
//							else
//							{
//								minePos.push(random);
//								count++;
//							}
							
						}
					}
					
				}
				
				if(count >= _numberOfMine)
				{
					break;
				}
				
			}			
				
			return minePos;
		}
		
		private function onTouchBlock(event:TouchEvent):void
		{
			for(var i:int = 1; i < _maxRow - 1; ++i)
			{
				for(var j:int = 1; j < _maxCol -1; ++j)
				{
					var touch:Touch = event.getTouch(_image[i][j], TouchPhase.ENDED);
					if(touch)
					{
						trace(i, j);
						//open(i, j);
						_image[i][j].texture = _atlas.getTexture(_data[i][j].toString());
					}
				}
			}
			
		}
		
		private function open(col:int, row:int):void
		{
			checkNumber(col, row);
		}
		
		private function checkNumber(col:int, row:int):int
		{
			var mineCount:int;
			/**
			 * 00 01 02 03 04 05 06 07 08 09
			 * 10 11 12 13 14 15 16 17 18 19
			 * 20 21 22 23 24 25 26 27 28 29
			 * 30 31 32 33 34 35 36 37 38 39
			 * 40 41 42 43 44 45 46 47 48 49
			 * 50 51 52 53 54 55 56 57 58 59
			 * 60 61 62 63 64 65 66 67 68 69
			 * 70 71 72 73 74 75 76 77 78 79
			 * 80 81 82 83 84 85 86 87 88 89
			 * 90 91 92 93 94 95 96 97 98 99  
			 * */
			//↖
			if(col == 0 && row == 0)
			{
				
			}
			if(_data[col-1][row-1] == -2)
			{
				mineCount++;
			}
			
			return mineCount;
		}
	}
}