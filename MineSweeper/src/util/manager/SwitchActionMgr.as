package util.manager
{
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class SwitchActionMgr extends EventDispatcher
	{
		//싱글톤
		private static var _instance:SwitchActionMgr;
		private static var _isConstructing:Boolean;
		
		public function SwitchActionMgr()
		{
			if (!_isConstructing) throw new Error("Singleton, use SwitchActionMgr.instance()");
		}
		
		public static function get instance():SwitchActionMgr 
		{
			if (_instance == null)  
			{
				_isConstructing = true;
				_instance = new SwitchActionMgr();
				_isConstructing = false;
			}
			return _instance;
		}		
		
		private var _nextScene:String;
		private var _tween:Tween;
		private var _bubbles:Boolean;
		private var _data:Object;
		
		
		public function switchSceneFadeOut(currentScene:DisplayObject, nextScene:String, bubbles:Boolean = false, data:Object = null, time:Number = 1.0, transition:String = null):void
		{
			_nextScene = nextScene;
			_bubbles = bubbles;
			_data = data;
			
			currentScene.touchable = false;
			
			_tween = new Tween(currentScene, time, transition);
			_tween.fadeTo(0);			
			_tween.addEventListener(Event.REMOVE_FROM_JUGGLER, onFadeOutEnd);
			
			Starling.juggler.add(_tween);
		}
		
		private function onFadeOutEnd(event:Event):void
		{
			
			_tween.removeEventListener(Event.REMOVE_FROM_JUGGLER, onFadeOutEnd);
			_tween = null;
			dispatchEvent(new Event(_nextScene, _bubbles, _data));
			_nextScene = null;
		}
	}
}