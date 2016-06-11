package scene.modeSelect.rank
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import scene.Main;
	
	import server.UserDBMgr;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.Align;
	import starling.utils.Color;
	
	import util.manager.DisplayObjectMgr;
	import util.type.DifficultyType;
	

	public class RankPopup extends DisplayObjectContainer
	{
		private var _atlas:TextureAtlas;
		
		private var _isItemModeSpr:Sprite;
		private var _difficultySpr:Sprite;
		private var _rankingSpr:Sprite;
		
		private var _pictures:Dictionary;
		private var _maxUserCount:int;
		private var _currentCount:int;
		
		private var _spriteVector:Vector.<Sprite>;
		private var _prev:Button;
		private var _next:Button;
		private var _page:TextField;
		private var _pageNum:int;
		
		private var _data:Object;
		
		private var _item:Button;
		private var _noItem:Button;
		
		private var _veryEasy:Button;
		private var _easy:Button;
		private var _normal:Button;
		private var _hard:Button;
		private var _veryHard:Button;
				
		private var _back:Button;
		private var _close:Button;
		
		private var _isItemMode:Boolean;
		private var _difficulty:int;
		
		private var _loadingBg:Quad;
		private var _loading:MovieClip;
		
		public function RankPopup(atlas:TextureAtlas)
		{
			_atlas = atlas;
			
			initBackground();
			initSpr();
			initButton();
			initLoading();
			
		}
		
		public function release():void
		{
			if(_atlas) { _atlas = null; }
			if(_isItemModeSpr) { _isItemModeSpr.dispose(); _isItemModeSpr.removeChildren(); _isItemModeSpr.dispose(); _isItemModeSpr = null; removeChild(_isItemModeSpr); }
			if(_difficultySpr) { _difficultySpr.dispose(); _difficultySpr.removeChildren(); _difficultySpr.dispose(); _difficultySpr = null; removeChild(_difficultySpr); }
			if(_rankingSpr) { _rankingSpr.dispose(); _rankingSpr.removeChildren(); _rankingSpr.dispose(); _rankingSpr = null; removeChild(_rankingSpr); }
			if(_pictures) 
			{
				for(var key:String in _pictures)
				{
					_pictures[key] = null;
					delete _pictures[key];
				}
				_pictures = null;
			}
			if(_spriteVector)
			{
				for(var i:int = 0; i < _spriteVector.length; ++i)
				{
					_spriteVector[i].dispose();
					_spriteVector[i] = null;
				}
				_spriteVector.splice(0, _spriteVector.length);
			}
			if(_prev) { _prev.removeEventListener(TouchEvent.TOUCH, onTouchPrev); _prev.dispose(); _prev = null; removeChild(_prev); }
			if(_next) { _next.removeEventListener(TouchEvent.TOUCH, onTouchNext); _next.dispose(); _next = null; removeChild(_next); }
			if(_page) { _page = null; removeChild(_page); }
			if(_data) { _data = null; }
			if(_item) { _item.removeEventListener(TouchEvent.TOUCH, onTouchItemMode); _item.dispose(); _item = null; removeChild(_item); }
			if(_noItem) { _noItem.removeEventListener(TouchEvent.TOUCH, onTouchItemMode); _noItem.dispose(); _noItem = null; removeChild(_noItem); }
			if(_veryEasy) { _veryEasy.removeEventListener(TouchEvent.TOUCH, onTouchDifficulty); _veryEasy.dispose(); _veryEasy = null; removeChild(_veryEasy); }
			if(_easy) { _easy.removeEventListener(TouchEvent.TOUCH, onTouchDifficulty); _easy.dispose(); _easy = null; removeChild(_easy); }
			if(_normal) { _normal.removeEventListener(TouchEvent.TOUCH, onTouchDifficulty); _normal.dispose(); _normal = null; removeChild(_normal); }
			if(_hard) { _hard.removeEventListener(TouchEvent.TOUCH, onTouchDifficulty); _hard.dispose(); _hard = null; removeChild(_hard); }
			if(_veryHard) { _veryHard.removeEventListener(TouchEvent.TOUCH, onTouchDifficulty); _veryHard.dispose(); _veryHard = null; removeChild(_veryHard); }
			if(_back) { _back.removeEventListener(TouchEvent.TOUCH, onTouchBack); _back.dispose(); _back = null; removeChild(_back); }
			if(_close) { _close.removeEventListener(TouchEvent.TOUCH, onTouchBack); _close.dispose(); _close = null; removeChild(_close); }
			if(_loadingBg) { _loadingBg.dispose(); _loadingBg = null; removeChild(_loadingBg); }
			if(_loading) { Starling.juggler.remove(_loading); _loading.dispose(); _loading = null; removeChild(_loading);}
		}
		
		public function reset():void
		{
			_isItemModeSpr.visible = true;
			_difficultySpr.visible = false;
			_rankingSpr.visible = false;
			
			_pageNum = 0;
			if(_rankingSpr.numChildren > 3)
				_rankingSpr.removeChildren(3, _rankingSpr.numChildren, true);
			if(_pictures)
			{
				for(var key:String in _pictures)
				{
					_pictures[key] = null;
					delete _pictures[key];
				}
			}
				
		}
		
		private function initBackground():void
		{
			var background:Image = new Image(_atlas.getTexture("popupBg"));
			background.width = Main.stageWidth * 0.8;
			background.height = Main.stageHeight * 0.8;
			background.x = Main.stageWidth * 0.5;
			background.y = Main.stageHeight * 0.5;
			background.alignPivot("center", "center");
			
			addChild(background);
		}
		
		private function initSpr():void
		{
			_isItemModeSpr = new Sprite();
			_difficultySpr = new Sprite();
			_rankingSpr = new Sprite();			
			
			
			_item = DisplayObjectMgr.instance.setButton(_item, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.6, 
				Main.stageWidth * 0.5, Main.stageWidth * 0.15, "아이템", Main.stageWidth * 0.05);
			_noItem = DisplayObjectMgr.instance.setButton(_noItem, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.4, 
				Main.stageWidth * 0.5, Main.stageWidth * 0.15, "노템", Main.stageWidth * 0.05);
			
			_noItem.addEventListener(TouchEvent.TOUCH, onTouchItemMode);
			_item.addEventListener(TouchEvent.TOUCH, onTouchItemMode);
			
			_isItemModeSpr.addChild(_noItem);
			_isItemModeSpr.addChild(_item);
			
			
			
			_veryEasy = DisplayObjectMgr.instance.setButton(_veryEasy, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.3, 
				Main.stageWidth * 0.5, Main.stageWidth * 0.15, "매우 쉬움", Main.stageWidth * 0.05);
			_easy     = DisplayObjectMgr.instance.setButton(_easy, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.4,
				Main.stageWidth * 0.5, Main.stageWidth * 0.15, "쉬움", Main.stageWidth * 0.05);
			_normal   = DisplayObjectMgr.instance.setButton(_normal, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.5, 
				Main.stageWidth * 0.5, Main.stageWidth * 0.15, "일반", Main.stageWidth * 0.05);
			_hard     = DisplayObjectMgr.instance.setButton(_hard, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.6, 
				Main.stageWidth * 0.5, Main.stageWidth * 0.15, "어려움", Main.stageWidth * 0.05);
			_veryHard = DisplayObjectMgr.instance.setButton(_veryHard, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.7, 
				Main.stageWidth * 0.5, Main.stageWidth * 0.15, "매우 어려움", Main.stageWidth * 0.05);
			
			_veryEasy.addEventListener(TouchEvent.TOUCH, onTouchDifficulty);
			_easy.addEventListener(TouchEvent.TOUCH, onTouchDifficulty);
			_normal.addEventListener(TouchEvent.TOUCH, onTouchDifficulty);
			_hard.addEventListener(TouchEvent.TOUCH, onTouchDifficulty);
			_veryHard.addEventListener(TouchEvent.TOUCH, onTouchDifficulty);
			
			
			_difficultySpr.addChild(_veryEasy);
			_difficultySpr.addChild(_easy);
			_difficultySpr.addChild(_normal);
			_difficultySpr.addChild(_hard);
			_difficultySpr.addChild(_veryHard);			
			
			_difficultySpr.visible = false;
			
			
			_rankingSpr.visible = false;			
			
			
			addChild(_isItemModeSpr);
			addChild(_difficultySpr);
			addChild(_rankingSpr);
		}
		
		private function initButton():void
		{
			_back = DisplayObjectMgr.instance.setButton(_back, _atlas.getTexture("back"), 
				Main.stageWidth * 0.2, Main.stageHeight * 0.175, Main.stageWidth * 0.1, Main.stageWidth * 0.1);
			_back.addEventListener(TouchEvent.TOUCH, onTouchBack);
			
			_close = DisplayObjectMgr.instance.setButton(_close, _atlas.getTexture("close"), 
				Main.stageWidth * 0.8, Main.stageHeight * 0.175, Main.stageWidth * 0.1, Main.stageWidth * 0.1);
			_close.addEventListener(TouchEvent.TOUCH, onTouchClose);
			
			addChild(_back);
			addChild(_close);
			
			
			_prev = DisplayObjectMgr.instance.setButton(_prev, _atlas.getTexture("prev"), 
				Main.stageWidth * 0.2, Main.stageHeight * 0.8, Main.stageWidth * 0.05, Main.stageWidth * 0.1);
			_prev.addEventListener(TouchEvent.TOUCH, onTouchPrev);
			
			_next = DisplayObjectMgr.instance.setButton(_next, _atlas.getTexture("next"),
				Main.stageWidth * 0.8, Main.stageHeight * 0.8, Main.stageWidth * 0.05, Main.stageWidth * 0.1);
			_next.addEventListener(TouchEvent.TOUCH, onTouchNext);
			
			_page = new TextField(Main.stageWidth * 0.2, Main.stageHeight * 0.1);
			_page.x = Main.stageWidth * 0.5;
			_page.y = Main.stageHeight * 0.8;
			_page.format.size = Main.stageWidth * 0.05;
			_page.text = "1";
			_page.alignPivot("center", "center");
			
			_rankingSpr.addChild(_prev);
			_rankingSpr.addChild(_next);
			_rankingSpr.addChild(_page);			
		}
		
		private function initLoading():void
		{
			_loadingBg = new Quad(Main.stageWidth, Main.stageHeight, Color.BLACK);
			_loadingBg.alpha = 0.5;
			_loadingBg.visible = false;
			addChild(_loadingBg);
			
			_loading = new MovieClip(_atlas.getTextures("loading_"), 18);
			_loading.visible = false;
			_loading.x = Main.stageWidth * 0.5;
			_loading.y = Main.stageHeight * 0.5;
			_loading.alignPivot("center", "center");
			Starling.juggler.add(_loading);
			addChild(_loading);
		}
		
		private function onTouchPrev(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_prev, TouchPhase.ENDED);
			if(touch)
			{
				if(_pageNum > 0)
				{
					_pageNum--;
					_page.text = (_pageNum + 1).toString();
					showCurrentpage();
				}
			}
		}
		
		private function onTouchNext(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_next, TouchPhase.ENDED);
			if(touch)
			{
				if(_pageNum < _spriteVector.length / 5)
				{
					trace(_pageNum.toString(), _spriteVector.length);
					_pageNum++;
					_page.text = (_pageNum + 1).toString();
					showCurrentpage();
				}
			}
		}
		
		private function onTouchBack(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_back, TouchPhase.ENDED);
			if(touch)
			{
				if(_isItemModeSpr.visible)
				{
					this.visible = false;
				}
				else if(_difficultySpr.visible)
				{					
					_isItemModeSpr.visible = true;
					_difficultySpr.visible = false;
					_rankingSpr.visible = false;
				}
				else if(_rankingSpr.visible)
				{
					_isItemModeSpr.visible = false;
					_difficultySpr.visible = true;
					_rankingSpr.visible = false;
					
					_pageNum = 0;
					if(_rankingSpr.numChildren > 3)
						_rankingSpr.removeChildren(3, _rankingSpr.numChildren, true);	
					if(_pictures)
					{
						for(var key:String in _pictures)
						{
							_pictures[key] = null;
							delete _pictures[key];
						}
					}
				}
			}
		}
				
		private function onTouchClose(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_close, TouchPhase.ENDED);
			if(touch)
			{
				this.visible = false;
			}
		}
		
		private function onTouchItemMode(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_noItem, TouchPhase.ENDED);
			if(touch)
			{
				_isItemMode = false;
				_isItemModeSpr.visible = false;
				_difficultySpr.visible = true;
			}
			
			touch = event.getTouch(_item, TouchPhase.ENDED);
			if(touch)
			{
				_isItemMode = true;
				_isItemModeSpr.visible = false;
				_difficultySpr.visible = true;
			}
		}
		
		private function onTouchDifficulty(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_veryEasy, TouchPhase.ENDED);
			if(touch)
			{
				UserDBMgr.instance.selectRecords(_isItemMode, DifficultyType.VERY_EASY);
				
				_isItemModeSpr.visible = false;
				_difficultySpr.visible = false;
				_rankingSpr.visible = true;
				
				UserDBMgr.instance.addEventListener("selectRecords", onSelectRecords);
			}
			
			touch = event.getTouch(_easy, TouchPhase.ENDED);
			if(touch)
			{
				UserDBMgr.instance.selectRecords(_isItemMode, DifficultyType.EASY);
				
				_isItemModeSpr.visible = false;
				_difficultySpr.visible = false;
				_rankingSpr.visible = true;
				
				UserDBMgr.instance.addEventListener("selectRecords", onSelectRecords);
			}
			
			touch = event.getTouch(_normal, TouchPhase.ENDED);
			if(touch)
			{
				UserDBMgr.instance.selectRecords(_isItemMode, DifficultyType.NORMAL);	
				
				_isItemModeSpr.visible = false;
				_difficultySpr.visible = false;
				_rankingSpr.visible = true;
				
				UserDBMgr.instance.addEventListener("selectRecords", onSelectRecords);
			}
			
			touch = event.getTouch(_hard, TouchPhase.ENDED);
			if(touch)
			{
				UserDBMgr.instance.selectRecords(_isItemMode, DifficultyType.HARD);	
				
				_isItemModeSpr.visible = false;
				_difficultySpr.visible = false;
				_rankingSpr.visible = true;
				
				UserDBMgr.instance.addEventListener("selectRecords", onSelectRecords);
			}
			
			touch = event.getTouch(_veryHard, TouchPhase.ENDED);
			if(touch)
			{
				UserDBMgr.instance.selectRecords(_isItemMode, DifficultyType.VERY_HARD);
				
				_isItemModeSpr.visible = false;
				_difficultySpr.visible = false;
				_rankingSpr.visible = true;
				
				UserDBMgr.instance.addEventListener("selectRecords", onSelectRecords);
			}
		}
		
		private function onSelectRecords(event:starling.events.Event):void
		{
			var data:Object = JSON.parse(event.data as String);
			
			showRanking(data);			
			
			_loadingBg.visible = true;
			_loading.visible = true;
			
			UserDBMgr.instance.removeEventListener("selectRecords", onSelectRecords);
		}
		
		private function showRanking(data:Object):void
		{
			_data = data;
			loadPicture(data);			
		}
		
		private function loadPicture(data:Object):void
		{
			_pictures = new Dictionary();
			_maxUserCount = data.length;
			_currentCount = 0;
			
			for(var i:int = 0; i < data.length; ++i)
			{
				_pictures[data[i].id] = new Image(null);
				
				var urlRequest:URLRequest = new URLRequest("https://graph.facebook.com/"+data[i].id+"/picture?type=small");				
				var loader:Loader = new Loader();
				loader.name = data[i].id;
				loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onLoadImageComplete);
				loader.load(urlRequest);
			}
			
		}
		
		private function onLoadImageComplete(event:flash.events.Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			
			var texture:Texture = Texture.fromBitmap(event.currentTarget.loader.content as Bitmap);			
			_pictures[loaderInfo.loader.name] = texture;		
			
			_currentCount++;
			
			loaderInfo.removeEventListener(flash.events.Event.COMPLETE, onLoadImageComplete);			
			
			if(_currentCount >= _maxUserCount)
			{
				if(_spriteVector)
				{
					for(var i:int = 0; i < _spriteVector.length; ++i)
					{
						_spriteVector[i].dispose();
						_spriteVector[i] = null;
					}
					_spriteVector.splice(0, _spriteVector.length);
				}
				_spriteVector = new Vector.<Sprite>();
				
				var spr:Sprite = new Sprite();
				
				trace("받아온 사람 수 : " + _data.length);
				for(i = 0; i < _data.length; ++i)
				{			
					if(i != 0 && i % 5 == 0)
					{
						_spriteVector.push(spr);
						_rankingSpr.addChild(spr);
						spr = new Sprite();						
					}
					
					var place:TextField = new TextField(Main.stageWidth * 0.3, Main.stageHeight * 0.1, (i+1).toString());
					place.format.size = Main.stageWidth * 0.05;
					place.x = Main.stageWidth * 0.15;
					place.y = Main.stageHeight * (0.3 + Number((i % 5) / 10));
					place.alignPivot("center", "center");
					
					var name:TextField = new TextField(Main.stageWidth * 0.3, Main.stageHeight * 0.1, _data[i].name);
					name.format.size = Main.stageWidth * 0.05;
					name.x = Main.stageWidth * 0.3;
					name.y = Main.stageHeight * (0.3 + Number((i % 5) / 10));
					name.alignPivot("center", "center");
					
					var pic:Image = new Image(_pictures[_data[i].id]);
					pic.width = Main.stageWidth * 0.1;
					pic.height = pic.width;
					pic.x = Main.stageWidth * 0.5;
					pic.y = Main.stageHeight * (0.3 + Number((i % 5) / 10));
					pic.alignPivot("center", "center");
					
					var record:TextField = new TextField(Main.stageWidth * 0.3, Main.stageHeight * 0.1);
					record.format.size = Main.stageWidth * 0.05;
					record.text = int(_data[i].record / 60) + " 분 " + int(_data[i].record % 60) + " 초";
					record.format.horizontalAlign = Align.RIGHT;
					record.x = Main.stageWidth * 0.7;
					record.y = Main.stageHeight * (0.3 + Number((i % 5) / 10));
					record.alignPivot("center", "center");					
					
					spr.addChild(place);
					spr.addChild(name);
					spr.addChild(pic);
					spr.addChild(record);
					
					spr.visible = false;
					
					if(i == _data.length - 1)
					{
						_spriteVector.push(spr);
						_rankingSpr.addChild(spr);
					}
										
				}	
				
				_loadingBg.visible = false;
				_loading.visible = false;
				showCurrentpage();
			}			
		}
		
		private function showCurrentpage():void
		{
			for(var i:int = 0; i < _spriteVector.length; ++i)
			{
				_spriteVector[i].visible = false;
			}
			
			_spriteVector[_pageNum].visible = true;
		}
	}
}