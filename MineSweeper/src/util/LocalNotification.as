package util
{
	import com.stzyoonsik.LocalNotiExtension;

	public class LocalNotification
	{
		private static var _localNoti:LocalNotiExtension = new LocalNotiExtension();;
		
		public function LocalNotification()
		{			
			//_localnoti = new LocalNotiExtension();
		}
		
		public static function push(title:String, message:String, time:int):void
		{
			_localNoti.setNotification(title, message, time);
		}
		
		public static function pop():void
		{
			_localNoti.removeNotification();
		}
	}
}