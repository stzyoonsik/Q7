package util.manager
{
	import flash.utils.Dictionary;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;

	public class SceneMgr
	{
		private var _scenes:Dictionary;
		//싱글톤
		private static var _instance:SceneMgr;
		private static var _isConstructing:Boolean;
		
		public function SceneMgr()
		{
			if (!_isConstructing) throw new Error("Singleton, use SceneMgr.instance()");
			
			_scenes = new Dictionary();
		}
		
		public static function get instance():SceneMgr 
		{
			if (_instance == null)  
			{
				_isConstructing = true;
				_instance = new SceneMgr();
				_isConstructing = false;
			}
			return _instance;
		}	
		
		
		
		
		public function addScene(scene:DisplayObject, sceneName:String):void
		{
			_scenes[sceneName] = scene;
		}
		
		public function deledeScene(sceneName:String):void
		{
			_scenes[sceneName] = null;
			delete _scenes[sceneName];
		}
		
		public function switchScene(currentScene:DisplayObject, nextSceneType:String):void
		{
			if(Starling.current.stage.numChildren == 0)
				return;
			
			Starling.current.stage.removeChild(currentScene, true);
			Starling.current.stage.addChild(_scenes[nextSceneType]);
		}
	}
}