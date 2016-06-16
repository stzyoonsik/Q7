package loading.resource
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	
	import util.manager.AtlasMgr;

	/**
	 * 게임에서 사용될 스프라이트 시트를 로드하는 클래스 
	 * 
	 */
	public class SpriteSheetLoader extends EventDispatcher
	{
		private var _spriteSheetDic:Dictionary;
		private var _xmlDic:Dictionary;
		
		private var _fileArray:Array;
		
		private var _spriteSheetLoadedCount:int;
		private var _xmlLoadedCount:int;
		
		private var _path:File = File.applicationDirectory.resolvePath("assets/image");
		
		public function SpriteSheetLoader()
		{
			_spriteSheetDic = new Dictionary();
			_xmlDic = new Dictionary();
			getList();
			load();
		}
		
		/**
		 * 메모리 해제 메소드 
		 * 
		 */
		public function release():void
		{
			if(_spriteSheetDic)
			{
				for(var key:String in _spriteSheetDic)
				{
					_spriteSheetDic[key] = null;
					delete _spriteSheetDic[key];
				}
				
				_spriteSheetDic = null;
			}
			
			if(_xmlDic)
			{
				for(key in _xmlDic)
				{
					_xmlDic[key] = null;
					delete _xmlDic[key];
				}
				
				_xmlDic = null;
			}
			
			if(_fileArray)
			{
				for(var i:int = 0; i < _fileArray.length; ++i)
				{
					_fileArray[i] = null;
				}
				
				_fileArray.splice(0, _fileArray.length - 1);
			}
			
			if(_path)
			{
				_path = null;
			}
		}
		
		/**
		 * 몇 개의 파일을 담았는지를 리턴하는 메소드. 
		 * @return 
		 * 
		 */
		public function getFileCount():int
		{
			return _fileArray.length;
		}
		
		
		/**
		 * 선택된 디렉토리 안의 모든 파일들을 배열에 저장하는 메소드 
		 * 
		 */
		private function getList():void
		{
			_fileArray = _path.getDirectoryListing();			
		}
		
		/**
		 * 로딩 시작 메소드 
		 * 
		 */
		private function load():void
		{
			
			for(var i:int = 0; i < _fileArray.length; ++i)
			{
				if(checkPng(_fileArray[i].url))
				{
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoadingSpriteSheet);				
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingSpriteSheet);
					loader.load(new URLRequest(_fileArray[i].url));
					
					var xmlURL:String = replaceExtensionToXml(_fileArray[i].url);
					var urlRequest:URLRequest = new URLRequest(xmlURL);
					var urlLoader:URLLoader = new URLLoader();				
					urlLoader.addEventListener(Event.COMPLETE, onCompleteLoadingXml);
					urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingXml);
					urlLoader.load(urlRequest);	
				}				
			}
		}
		
		/**
		 * 스프라이트 시트의 로딩이 끝나면 호출되는 콜백메소드
		 * @param event 로딩 끝
		 * 
		 */
		private function onCompleteLoadingSpriteSheet(event:Event):void
		{
			var spriteSheetName:String = getFileName((event.currentTarget as LoaderInfo).url);
			
			var bitmap:Bitmap = (event.currentTarget as LoaderInfo).loader.content as Bitmap;
			var texture:Texture = Texture.fromBitmap(bitmap);
			_spriteSheetDic[spriteSheetName] = texture;
			
			(event.currentTarget as LoaderInfo).removeEventListener(Event.COMPLETE, onCompleteLoadingSpriteSheet);
			(event.currentTarget as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingSpriteSheet);			
			
			_spriteSheetLoadedCount++;
			dispatchEvent(new starling.events.Event("progressLoading"));
			checkDone();
		}
		
		/**
		 * 로딩 실패시 호출되는 콜백메소드
		 * @param event ioerror
		 * 
		 */
		private function onFailedLoadingSpriteSheet(event:IOErrorEvent):void
		{
			trace(event);
		}
		
		/**
		 * xml파일의 로딩이 끝나면 호출되는 콜백메소드 
		 * @param event 로딩 끝
		 * 
		 */
		private function onCompleteLoadingXml(event:Event):void
		{
			var xml:XML = new XML(event.currentTarget.data);
			var xmlName:String = getFileName(xml.attribute("imagePath").toString());
			
			_xmlDic[xmlName] = xml;			
			
			_xmlLoadedCount++;
			dispatchEvent(new starling.events.Event("progressLoading"));
			checkDone();
		}
		
		/**
		 * 로딩 실패시 호출되는 콜백메소드
		 * @param event ioerror
		 * 
		 */
		private function onFailedLoadingXml(event:IOErrorEvent):void
		{
			trace(event);
		}
		
		/**
		 * 모든 스프라이트 시트와 xml이 로딩됬는지 검사하는 메소드 
		 * 
		 */
		private function checkDone():void
		{
			if(_spriteSheetLoadedCount + _xmlLoadedCount >= _fileArray.length)
			{
				for(var key:String in _spriteSheetDic)
				{
					AtlasMgr.instance.addAtlas(key, _spriteSheetDic[key], _xmlDic[key]);
				} 
				
				release();
				
				dispatchEvent(new starling.events.Event("completeLoadingSpriteSheet"));
			}
		}
		
		/**
		 * 현재 파일이 png인지 아닌지 검사하는 메소드
		 * @param url 파일의 경로와 이름이 담긴 스트링
		 * @return png이면 true 아니면 false
		 * 
		 */
		private function checkPng(url:String):Boolean
		{			
			var fileName:String = url;
			if(getExtension(fileName) == "png")
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * 파일의 확장자를 알려주는 메소드
		 * @param url 파일의 경로와 이름이 담긴 스트링
		 * @return 가장 마지막 . 부터 끝까지의 string
		 * 
		 */
		private function getExtension(url:String):String
		{
			return url.substring(url.lastIndexOf(".") + 1, url.length);
		}
		
		/**
		 * url에서 경로, 확장자를 제거한 파일이름만 리턴하는 메소드
		 * @param url 현재 파일의 경로 + 파일이름 + 확장자
		 * @return only 파일 이름
		 * 
		 */
		private function getFileName(url:String):String
		{
			trace("getFileName = " + url.substring(url.lastIndexOf("/") + 1, url.lastIndexOf(".")));
			return url.substring(url.lastIndexOf("/") + 1 , url.lastIndexOf("."));
		}
		
		/**
		 * 파일 확장자의 이름을  xml로 바꾸는 메소드
		 * @param text 파일이름 + 확장자
		 * @return 파일이름 + xml
		 * 
		 */
		private function replaceExtensionToXml(text:String):String
		{
			var result:String = text;
			var dot:int = result.lastIndexOf(".");
			result = result.substring(0, dot);		
			result += ".xml";
			
			return result;
		}
	}
}