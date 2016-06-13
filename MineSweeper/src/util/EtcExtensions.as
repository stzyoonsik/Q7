package util
{
	import com.yoonsik.YoonsikExtension;

	public class EtcExtensions
	{
		private static var _extension:YoonsikExtension = new YoonsikExtension();
		
		public function EtcExtensions()
		{
			//_extension = new YoonsikExtension();
		}
		
		public static function exit():void
		{
			_extension.alert("EXIT");
		}
		
		public static function alert(message:String):void
		{
			_extension.toast(message);
		}
	}
}