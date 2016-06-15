package util.manager
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.utils.Dictionary;

	public class SoundMgr
	{
		private var _sounds:Dictionary;
		private var _channels:Dictionary;
		//싱글톤
		private static var _instance:SoundMgr;
		private static var _isConstructing:Boolean;
		
		public function SoundMgr()
		{
			if (!_isConstructing) throw new Error("Singleton, use SoundMgr.instance()");
			trace("사운드 매니저 생성");
			_sounds = new Dictionary();
			_channels = new Dictionary();
		}
		
		public static function get instance():SoundMgr 
		{
			if (_instance == null)  
			{
				_isConstructing = true;
				_instance = new SoundMgr();
				_isConstructing = false;
			}
			return _instance;
		}	
		
		 
		
		public function addSound(name:String, sound:Sound):void
		{
			_sounds[name] = sound;
		}
		
		public function removeSound(name:String):void
		{
			_sounds[name] = null;
			delete _sounds[name];
			
			_channels[name] = null;
			delete _channels[name];
		}
		
		public function play(name:String, infinite:Boolean = false):void
		{
			if(!infinite)
			{	
				_channels[name] = _sounds[name].play();
			}
			else
			{
				_channels[name] = _sounds[name].play(0, int.MAX_VALUE);
			}
			
		}
		
		public function pauseAll():void
		{
			for(var key:String in _channels)
			{
				trace("stop 전 " + key, _channels[key].position);
				(_channels[key] as SoundChannel).stop();
				trace("stop 후 " + key, _channels[key].position);
			}
		}
		
		public function resumeAll():void
		{
			for(var key:String in _sounds)
			{
				if(_channels[key])
				{
					trace(key, _channels[key].position);
					_channels[key] = _sounds[key].play(_channels[key].position, int.MAX_VALUE);
//					_channels[key] = null;
//					delete _channels[key];
				}
				
			}
		}
		
		public function stop(name:String):void
		{
			if(_channels[name] != null)
				(_channels[name] as SoundChannel).stop();
		}
		
		
		public function stopAll():void
		{
			for(var key:String in _sounds)
			{
				if(_channels[key])
				{					
					_channels[key] = null;
					delete _channels[key];
				}				
			}
			SoundMixer.stopAll();
		}
		
	}
}