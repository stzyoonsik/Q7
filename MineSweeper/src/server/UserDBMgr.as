package server
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import util.manager.AchievementMgr;

	public class UserDBMgr
	{
		private static var _instance:UserDBMgr;
		private static var _isConstructing:Boolean;
		
		public function UserDBMgr()
		{
			if (!_isConstructing) throw new Error("Singleton, use UserDBMgr.instance()");
			
		}
		
		public static function get instance():UserDBMgr 
		{
			if (_instance == null)  
			{
				_isConstructing = true;
				_instance = new UserDBMgr();
				_isConstructing = false;
			}
			return _instance;
		}	
		
		
		
		
		private const URL:String = "http://ec2-52-78-35-135.ap-northeast-2.compute.amazonaws.com/minesweeper/";
		
		
		
		public function insert(id:String, name:String):void
		{
			var urlLoader:URLLoader = new URLLoader();
			var urlRequest:URLRequest = new URLRequest(URL+"InsertUser.php");
			var urlVars:URLVariables = new URLVariables();
			
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlRequest.method = URLRequestMethod.POST;
			
			urlVars.id = id;
			urlVars.name = name;			
			
			urlRequest.data = urlVars;
			urlLoader.addEventListener(Event.COMPLETE, onInsertComplete);
			urlLoader.load(urlRequest);
		}
		
		private function onInsertComplete(event:Event):void
		{
			var urlLoader:URLLoader = event.target as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onInsertComplete);
			trace("insert done");
		}
		
		public function select():void
		{
			
		}
		
		public function updateDate():void
		{
			
		}
		
		public function updateRecord():void
		{
			
		}
	}
}