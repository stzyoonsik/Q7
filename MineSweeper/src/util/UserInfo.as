package util
{
	import starling.textures.Texture;

	public class UserInfo
	{
		public static var id:String = null;
		public static var name:String = null;
		public static var picture:Texture = null;
		public static var level:int = -1;
		public static var exp:int = -1;
		public static var heart:int = -1;
		public static var remainHeartTime:int = -1;
		public static var coin:int = -1;
		public static var expRatio:int = -1;
		public static var lastDate:Number = -1;
		
		public static const MAX_HEART:int = 10;
		public static const HEART_GEN_TIME:int = 300;
		
		public static var levelUpAmount:int = 0;
		
		public static function test():void
		{
			id = "769885983113557";	
			name = "abcd";
			level = 2;
			exp = 100;
			heart = 5;
			remainHeartTime = 300;
			coin = 1000;
			expRatio = 1;
		}
		
		public static function reset():void
		{
			id = null;
			name = null;
			picture = null;
			level = -1;
			exp = -1;
			heart = -1;
			remainHeartTime = -1;
			coin = -1;
			expRatio = -1;
			lastDate = -1;
			levelUpAmount = 0;
		}
		
	}
}