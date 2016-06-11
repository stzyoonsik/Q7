//package util
//{
//	public class RetainData
//	{
//		//싱글톤
//		private static var _instance:RetainData;
//		private static var _isConstructing:Boolean;
//		
//		public function RetainData()
//		{
//			if (!_isConstructing) throw new Error("Singleton, use RetainData.instance()");
//			
//		}
//		
//		public static function get instance():RetainData 
//		{
//			if (_instance == null)  
//			{
//				_isConstructing = true;
//				_instance = new RetainData();
//				_isConstructing = false;
//			}
//			return _instance;
//		}	
//		
//		
//		public var lastModeSelectDate:Number;		
//		public var lastGameData:Number;		
//		
//		
//		public function getTimeDuringGame():Number
//		{
//			if(!isNaN(lastModeSelectDate))
//			{
//				var currentTime:Number = new Date().getTime();
//				return currentTime - lastModeSelectDate;
//			}
//			
//			return -1;
//		}
//		
//		
//	}
//}