package util.type
{
	public final class DifficultyType
	{
		public static const VERY_EASY:int = 0;
		public static const EASY:int = 1;
		public static const NORMAL:int = 2;
		public static const HARD:int = 3;
		public static const VERY_HARD:int = 4;
		public static const CUSTOM:int = 5;
		
		public static const STRING_VERY_EASY:String = "veryEasy";
		public static const STRING_EASY:String = "easy";
		public static const STRING_NORMAL:String = "normal";
		public static const STRING_HARD:String = "hard";
		public static const STRING_VERY_HARD:String = "veryHard";
		public static const STRING_CUSTOM:String = "custom";
		
		public static function getDifficulty(difficulty:int):String
		{
			switch(difficulty)
			{
				case 0:
					return STRING_VERY_EASY;
					break;
				case 1:
					return STRING_EASY;
					break;
				case 2:
					return STRING_NORMAL;
					break;
				case 3:
					return STRING_HARD;
					break;
				case 4:
					return STRING_VERY_HARD;
					break;
				case 5:
					return STRING_CUSTOM;
					break;
				default:
					return "";
					break;
			}
			
			return "";
		}
	}
}