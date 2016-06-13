package util
{

	public final class LevelSystem
	{				
		
		
		private static var needExp:Vector.<int> = Vector.<int>([50, 110, 180, 260, 350, 450, 560, 780, 910, 1050, 1200,
																1360, 1530, 1710, 1900, 2100, 2310, 2530, 2760]);
		 
		 
//		public static function getRewardExp(difficulty:int):int
//		{ 
//			switch(difficulty)
//			{
//				case DifficultyType.VERY_EASY :
//					return LevelSystem.REWARD_EXP_FOR_VERY_EASY;
//					break;
//				case DifficultyType.EASY :
//					return LevelSystem.REWARD_EXP_FOR_EASY;
//					break;
//				case DifficultyType.NORMAL :
//					return LevelSystem.REWARD_EXP_FOR_NORMAL;
//					break;
//				case DifficultyType.HARD :
//					return LevelSystem.REWARD_EXP_FOR_HARD;
//					break;
//				case DifficultyType.VERY_HARD :
//					return LevelSystem.REWARD_EXP_FOR_VERY_HARD;
//					break;
//				default:
//					return 0;
//					break;				
//			}
//			
//			return 0;
//		}
		
		public static function getNeedExp(level:int):int
		{
			return needExp[level-1];
		}
		
		
		public static function getPercent(level:int, currentExp:int):Number
		{
			var percent:Number = (currentExp / needExp[level-1]) * 100; 
			
			return percent;
		}
		
		public static function checkLevelUp(currentLevel:int, currentExp):Boolean
		{
			return currentExp > getNeedExp(currentLevel);
		}
	}
}