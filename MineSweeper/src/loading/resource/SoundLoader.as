package loading.resource
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	import util.manager.SoundMgr;
	

	/**
	 * 게임에서 사용할 사운드 파일들을 로드하는 클래스
	 * 
	 */
	public class SoundLoader extends EventDispatcher
	{
		private var _soundDic:Dictionary;
		private var _fileNameArray:Array;
		private var _soundLoadedCount:int;
		private var _path:File = File.applicationDirectory.resolvePath("assets/sound");
		
		public function SoundLoader()
		{
			_soundDic = new Dictionary();
			getList();
			load();
		}
		
		/**
		 * 메모리 해제 클래스 
		 * 
		 */
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
			
			if(_fileNameArray)
			{
				for(var i:int = 0; i < _fileNameArray.length; ++i)
				{
					_fileNameArray[i] = null;
				}
				
				_fileNameArray.splice(0, _fileNameArray.length - 1);
			}
			
			if(_path)
			{
				_path = null;
			}
		}
		
		/**
		 * 몇개의 파일을 저장했는지를 알려주는 메소드
		 * 
		 */
		public function getFileCount():int
		{
			return _fileNameArray.length;
		}
		
		/**
		 * 선택된 디렉토리 안의 모든 파일들을 배열에 저장하는 메소드 
		 * 
		 */
		private function getList():void
		{
			_fileNameArray = _path.getDirectoryListing();
		}
		
		/**
		 * 로드 시작 메소드.  
		 * 
		 */
		private function load():void
		{
			var sound:Sound;
			var soundURLRequest:URLRequest;
			for(var i:int = 0; i < _fileNameArray.length; ++i)
			{
				soundURLRequest = new URLRequest(_fileNameArray[i].url);
				sound = new Sound();
				sound.addEventListener(flash.events.Event.COMPLETE, onCompleteLoadingSound);
				sound.addEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingSound);
				sound.load(soundURLRequest);
			}
		}
		
		/**
		 * 로딩이 끝났을때 호출되는 콜백 메소드. 
		 * @param event
		 * 
		 */
		private function onCompleteLoadingSound(event:flash.events.Event):void
		{
			var soundName:String = Sound(event.currentTarget).url.replace(_path.url.toString()+"/", "");
			trace(soundName);
			_soundDic[soundName] = event.currentTarget as Sound;
			
			Sound(event.currentTarget).removeEventListener(flash.events.Event.COMPLETE, onCompleteLoadingSound);
			Sound(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingSound);
			
			_soundLoadedCount++;
			dispatchEvent(new starling.events.Event("progressLoading"));
			checkDone();
		}
		
		/**
		 * 로딩에 실패했을때 호출되는 콜백 메소드. 
		 * @param event
		 * 
		 */
		private function onFailedLoadingSound(event:IOErrorEvent):void
		{
			trace(event.toString());
			Sound(event.currentTarget).removeEventListener(flash.events.Event.COMPLETE, onCompleteLoadingSound);
			Sound(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, onFailedLoadingSound);
		}
		
		/**
		 * 리스트 안의 파일들의 로딩이 모두 끝났는지 검사하는 메소드. 
		 * 
		 */
		private function checkDone():void
		{
			if(_soundLoadedCount >= _fileNameArray.length)
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