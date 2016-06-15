package loading
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	
	import util.manager.AtlasMgr;
	import util.manager.SoundMgr;

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
		
		public function getFileCount():int
		{
			return _fileArray.length;
		}
		
		private function getList():void
		{
			_fileArray = _path.getDirectoryListing();
			
		}
		
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
					
					var xmlURL:String = replaceExtensionPngToXml(_fileArray[i].url);
					var urlRequest:URLRequest = new URLRequest(xmlURL);
					var urlLoader:URLLoader = new URLLoader();				
					urlLoader.addEventListener(Event.COMPLETE, onCompleteLoadingXml);
					urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingXml);
					urlLoader.load(urlRequest);	
				}				
			}
		}
		
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
		
		private function onFailedLoadingSpriteSheet(event:IOErrorEvent):void
		{
			trace(event);
		}
		
		private function onCompleteLoadingXml(event:Event):void
		{
			var xml:XML = new XML(event.currentTarget.data);
			var xmlName:String = getFileName(xml.attribute("imagePath").toString());
			
			_xmlDic[xmlName] = xml;			
			
			_xmlLoadedCount++;
			dispatchEvent(new starling.events.Event("progressLoading"));
			checkDone();
		}
		
		private function onFailedLoadingXml(event:IOErrorEvent):void
		{
			trace(event);
		}
		
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
		
		private function checkPng(url:String):Boolean
		{			
			var fileName:String = url;
			if(getExtension(fileName) == "png")
			{
				return true;
			}
			
			return false;
		}
		
		private function getExtension(url:String):String
		{
			return url.substring(url.lastIndexOf(".") + 1, url.length);
		}
		
		private function getFileName(url:String):String
		{
			trace("getFileName = " + url.substring(url.lastIndexOf("/") + 1, url.lastIndexOf(".")));
			return url.substring(url.lastIndexOf("/") + 1 , url.lastIndexOf("."));
		}
		
		private function replaceExtensionPngToXml(text:String):String
		{
			var result:String = text;
			var dot:int = result.lastIndexOf(".");
			result = result.substring(0, dot);		
			result += ".xml";
			
			return result;
		}
	}
}