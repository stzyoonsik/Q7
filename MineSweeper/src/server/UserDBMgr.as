package server
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import starling.events.EventDispatcher;
	
	import util.manager.AchievementMgr;
	import util.type.DifficultyType;

	public class UserDBMgr extends EventDispatcher
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
		
		public function checkData(id:String):void
		{
			var urlLoader:URLLoader = new URLLoader();
			var urlRequest:URLRequest = new URLRequest(URL+"CheckData.php?id="+id);
			
			urlLoader.addEventListener(Event.COMPLETE, onCheckDataComplete);
			urlLoader.load(urlRequest);
		}
		
		private function onCheckDataComplete(event:Event):void
		{
			var urlLoader:URLLoader = event.target as URLLoader;
			trace(urlLoader.data);
			dispatchEvent(new starling.events.Event("checkData", false, urlLoader.data));
			urlLoader.removeEventListener(Event.COMPLETE, onCheckDataComplete);
			trace("check data is done");
		}
		
		public function insertUser(id:String, name:String):void
		{
			var urlLoader:URLLoader = new URLLoader();
			var urlRequest:URLRequest = new URLRequest(URL+"InsertUser.php?id="+id+"&name="+name);
			
			urlLoader.addEventListener(Event.COMPLETE, onInsertUserComplete);
			urlLoader.load(urlRequest);
		}
		
		private function onInsertUserComplete(event:Event):void
		{
			var urlLoader:URLLoader = event.target as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onInsertUserComplete);
			dispatchEvent(new starling.events.Event("insertUser"));
			trace("insertUser is done");
		}
		
		public function selectData(id:String, target:String):void
		{
			var urlLoader:URLLoader = new URLLoader();
			var urlRequest:URLRequest;
			
			urlRequest = new URLRequest(URL+"SelectData.php?id="+id+"&target="+target);
			
			trace(urlRequest.url);
			urlLoader.addEventListener(Event.COMPLETE, onSelectDataComplete);
			urlLoader.load(urlRequest);
		}
		
		private function onSelectDataComplete(event:Event):void
		{
			var urlLoader:URLLoader = event.target as URLLoader;
			trace(urlLoader.data);
			urlLoader.removeEventListener(Event.COMPLETE, onSelectDataComplete);
			dispatchEvent(new starling.events.Event("selectData", false, urlLoader.data));
			trace("select data is done");
		}
		
		
		public function selectRecord(id:String, isItemMode:Boolean, difficulty:int):void
		{
			var urlLoader:URLLoader = new URLLoader();
			var urlRequest:URLRequest;
			
			if(isItemMode)
			{
				switch(difficulty)
				{
					case DifficultyType.VERY_EASY :
						urlRequest = new URLRequest(URL+"SelectData.php?id="+id+"&target=itemVeryEasy");
						break;
					case DifficultyType.EASY :
						urlRequest = new URLRequest(URL+"SelectData.php?id="+id+"&target=itemEasy");
						break;
					case DifficultyType.NORMAL :
						urlRequest = new URLRequest(URL+"SelectData.php?id="+id+"&target=itemNormal");
						break;
					case DifficultyType.HARD :
						urlRequest = new URLRequest(URL+"SelectData.php?id="+id+"&target=itemHard");
						break;
					case DifficultyType.VERY_HARD :
						urlRequest = new URLRequest(URL+"SelectData.php?id="+id+"&target=itemVeryHard");
						break;
					default:
						break;				
				}
			}
				
			else
			{
				switch(difficulty)
				{
					case DifficultyType.VERY_EASY :
						urlRequest = new URLRequest(URL+"SelectData.php?id="+id+"&target=noItemVeryEasy");
						break;
					case DifficultyType.EASY :
						urlRequest = new URLRequest(URL+"SelectData.php?id="+id+"&target=noItemEasy");
						break;
					case DifficultyType.NORMAL :
						urlRequest = new URLRequest(URL+"SelectData.php?id="+id+"&target=noItemNormal");
						break;
					case DifficultyType.HARD :
						urlRequest = new URLRequest(URL+"SelectData.php?id="+id+"&target=noItemHard");
						break;
					case DifficultyType.VERY_HARD :
						urlRequest = new URLRequest(URL+"SelectData.php?id="+id+"&target=noItemVeryHard");
						break;
					default:
						break;				
				}
			}
			
			trace(urlRequest.url);
			urlLoader.addEventListener(Event.COMPLETE, onSelectRecordComplete);
			urlLoader.load(urlRequest);
		}
		
		private function onSelectRecordComplete(event:Event):void
		{
			var urlLoader:URLLoader = event.target as URLLoader;
			trace(urlLoader.data);
			urlLoader.removeEventListener(Event.COMPLETE, onSelectRecordComplete);
			dispatchEvent(new starling.events.Event("selectRecord", false, urlLoader.data));
			trace("select record is done");
		}
		
		public function selectRecords(isItemMode:Boolean, difficulty:int):void
		{
			var urlLoader:URLLoader = new URLLoader();
			var urlRequest:URLRequest;
			
			if(isItemMode)
			{
				switch(difficulty)
				{
					case DifficultyType.VERY_EASY :
						urlRequest = new URLRequest(URL+"SelectRecords.php?target=itemVeryEasy");
						break;
					case DifficultyType.EASY :
						urlRequest = new URLRequest(URL+"SelectRecords.php?target=itemEasy");
						break;
					case DifficultyType.NORMAL :
						urlRequest = new URLRequest(URL+"SelectRecords.php?target=itemNormal");
						break;
					case DifficultyType.HARD :
						urlRequest = new URLRequest(URL+"SelectRecords.php?target=itemHard");
						break;
					case DifficultyType.VERY_HARD :
						urlRequest = new URLRequest(URL+"SelectRecords.php?target=itemVeryHard");
						break;
					default:
						break;				
				}
			}
				
			else
			{
				switch(difficulty)
				{
					case DifficultyType.VERY_EASY :
						urlRequest = new URLRequest(URL+"SelectRecords.php?target=noItemVeryEasy");
						break;
					case DifficultyType.EASY :
						urlRequest = new URLRequest(URL+"SelectRecords.php?target=noItemEasy");
						break;
					case DifficultyType.NORMAL :
						urlRequest = new URLRequest(URL+"SelectRecords.php?target=noItemNormal");
						break;
					case DifficultyType.HARD :
						urlRequest = new URLRequest(URL+"SelectRecords.php?target=noItemHard");
						break;
					case DifficultyType.VERY_HARD :
						urlRequest = new URLRequest(URL+"SelectRecords.php?target=noItemVeryHard");
						break;
					default:
						break;				
				}
			}
			
			trace(urlRequest.url);
			urlLoader.addEventListener(Event.COMPLETE, onSelectRecordsComplete);
			urlLoader.load(urlRequest);
		}
		
		private function onSelectRecordsComplete(event:Event):void
		{
			var urlLoader:URLLoader = event.target as URLLoader;
			trace(urlLoader.data);
			urlLoader.removeEventListener(Event.COMPLETE, onSelectRecordsComplete);
			dispatchEvent(new starling.events.Event("selectRecords", false, urlLoader.data));
			trace("select records is done");
		}
		
//		public function updateDate(id:String, date:String):void
//		{
//			
//		}
		
		public function updateData(id:String, target:String, value:Object):void
		{
			var urlLoader:URLLoader = new URLLoader();
			var urlRequest:URLRequest;
			
			urlRequest = new URLRequest(URL+"UpdateData.php?id="+id+"&target="+target+"&value="+value);
			
			trace(urlRequest.url);
			urlLoader.addEventListener(Event.COMPLETE, onUpdateDataComplete);
			urlLoader.load(urlRequest);
		}
		
		private function onUpdateDataComplete(event:Event):void
		{
			var urlLoader:URLLoader = event.target as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onUpdateDataComplete);
			trace("update data is done");
		}
		
		public function updateRecord(id:String, isItemMode:Boolean, difficulty:int, record:int):void
		{
			var urlLoader:URLLoader = new URLLoader();
			var urlRequest:URLRequest;
			
			if(isItemMode)
			{
				switch(difficulty)
				{
					case DifficultyType.VERY_EASY :
						urlRequest = new URLRequest(URL+"UpdateData.php?id="+id+"&target=itemVeryEasy&value="+record);
						break;
					case DifficultyType.EASY :
						urlRequest = new URLRequest(URL+"UpdateData.php?id="+id+"&target=itemEasy&value="+record);
						break;
					case DifficultyType.NORMAL :
						urlRequest = new URLRequest(URL+"UpdateData.php?id="+id+"&target=itemNormal&value="+record);
						break;
					case DifficultyType.HARD :
						urlRequest = new URLRequest(URL+"UpdateData.php?id="+id+"&target=itemHard&value="+record);
						break;
					case DifficultyType.VERY_HARD :
						urlRequest = new URLRequest(URL+"UpdateData.php?id="+id+"&target=itemVeryHard&value="+record);
						break;
					default:
						break;				
				}
			}
			
			else
			{
				switch(difficulty)
				{
					case DifficultyType.VERY_EASY :
						urlRequest = new URLRequest(URL+"UpdateData.php?id="+id+"&target=noItemVeryEasy&value="+record);
						break;
					case DifficultyType.EASY :
						urlRequest = new URLRequest(URL+"UpdateData.php?id="+id+"&target=noItemEasy&value="+record);
						break;
					case DifficultyType.NORMAL :
						urlRequest = new URLRequest(URL+"UpdateData.php?id="+id+"&target=noItemNormal&value="+record);
						break;
					case DifficultyType.HARD :
						urlRequest = new URLRequest(URL+"UpdateData.php?id="+id+"&target=noItemHard&value="+record);
						break;
					case DifficultyType.VERY_HARD :
						urlRequest = new URLRequest(URL+"UpdateData.php?id="+id+"&target=noItemVeryHard&value="+record);
						break;
					default:
						break;				
				}
			}
			
			trace(urlRequest.url);
			urlLoader.addEventListener(Event.COMPLETE, onUpdateRecordComplete);
			urlLoader.load(urlRequest);
		}
		
		private function onUpdateRecordComplete(event:Event):void
		{
			var urlLoader:URLLoader = event.target as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onUpdateRecordComplete);
			trace("update record is done");
		}
	}
}