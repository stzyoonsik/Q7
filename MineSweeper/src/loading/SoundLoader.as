package loading
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import starling.events.EventDispatcher;
	
	import util.manager.SoundMgr;
	

	public class SoundLoader extends EventDispatcher
	{
		private var _soundDic:Dictionary;
		private var _soundNameArray:Array;
		private var _soundLoadedCount:int;
		private var _path:File = File.applicationDirectory.resolvePath("assets/sound");
		
		public function SoundLoader()
		{
			_soundDic = new Dictionary();
			getList();
			load();
		}
		
		public function release():void
		{
			if(_soundDic)
			{
				for(var key:String in _soundDic)
				{
					_soundDic[key] = null;
					delete _soundDic[key];
				}
				
				_soundDic = null;
			}
			
			if(_soundNameArray)
			{
				for(var i:int = 0; i < _soundNameArray.length; ++i)
				{
					_soundNameArray[i] = null;
				}
				
				_soundNameArray.splice(0, _soundNameArray.length - 1);
			}
			
			if(_path)
			{
				_path = null;
			}
		}
		
		public function getFileCount():int
		{
			return _soundNameArray.length;
		}
		
		private function getList():void
		{
			_soundNameArray = _path.getDirectoryListing();
		}
		
		private function load():void
		{
			var sound:Sound;
			var soundURLRequest:URLRequest;
			for(var i:int = 0; i < _soundNameArray.length; ++i)
			{
				soundURLRequest = new URLRequest(_soundNameArray[i].url);
				sound = new Sound();
				sound.addEventListener(Event.COMPLETE, onCompleteLoadingSound);
				sound.addEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingSound);
				sound.load(soundURLRequest);
			}
		}
		
		private function onCompleteLoadingSound(event:Event):void
		{
			var soundName:String = Sound(event.currentTarget).url.replace(_path.url.toString()+"/", "");
			trace(soundName);
			_soundDic[soundName] = event.currentTarget as Sound;
			
			Sound(event.currentTarget).removeEventListener(Event.COMPLETE, onCompleteLoadingSound);
			Sound(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingSound);
			
			_soundLoadedCount++;
			dispatchEvent(new starling.events.Event("progressLoading"));
			checkDone();
		}
		
		private function onFailedLoadingSound(event:IOErrorEvent):void
		{
			trace(event.toString());
			Sound(event.currentTarget).removeEventListener(Event.COMPLETE, onCompleteLoadingSound);
			Sound(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingSound);
		}
		
		private function checkDone():void
		{
			if(_soundLoadedCount >= _soundNameArray.length)
			{
				for(var key:String in _soundDic)
				{
					SoundMgr.instance.addSound(key, _soundDic[key] as Sound);
				} 
				
				release();
				
				
				dispatchEvent(new starling.events.Event("completeLoadingSound"));
			}
		}
		
	}
}