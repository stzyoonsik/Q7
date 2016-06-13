package util
{
	import util.type.DifficultyType;

	public class Reward
	{
		public static const REWARD_EXP_FOR_VERY_EASY:uint = 64;
		public static const REWARD_EXP_FOR_EASY:uint = 110;
		public static const REWARD_EXP_FOR_NORMAL:uint = 270;
		public static const REWARD_EXP_FOR_HARD:uint = 520;
		public static const REWARD_EXP_FOR_VERY_HARD:uint = 875;
		
		public static const REWARD_COIN_FOR_VERY_EASY:uint = 32;
		public static const REWARD_COIN_FOR_EASY:uint = 55;
		public static const REWARD_COIN_FOR_NORMAL:uint = 135;
		public static const REWARD_COIN_FOR_HARD:uint = 260;
		public static const REWARD_COIN_FOR_VERY_HARD:uint = 440;
		
		public static function getRewardExp(difficulty:int):int
		{ 
			switch(difficulty)
			{
				case DifficultyType.VERY_EASY :
					return REWARD_EXP_FOR_VERY_EASY;
					break;
				case DifficultyType.EASY :
					return REWARD_EXP_FOR_EASY;
					break;
				case DifficultyType.NORMAL :
					return REWARD_EXP_FOR_NORMAL;
					break;
				case DifficultyType.HARD :
					return REWARD_EXP_FOR_HARD;
					break;
				case DifficultyType.VERY_HARD :
					return REWARD_EXP_FOR_VERY_HARD;
					break;
				default:
					return 0;
					break;				
			}
			
			return 0;
		}
		
		public static function getRewardCoin(difficulty:int):int
		{
			switch(difficulty)
			{
				case DifficultyType.VERY_EASY :
					return REWARD_COIN_FOR_VERY_EASY;
					break;
				case DifficultyType.EASY :
					return REWARD_COIN_FOR_EASY;
					break;
				case DifficultyType.NORMAL :
					return REWARD_COIN_FOR_NORMAL;
					break;
				case DifficultyType.HARD :
					return REWARD_COIN_FOR_HARD;
					break;
				case DifficultyType.VERY_HARD :
					return REWARD_COIN_FOR_VERY_HARD;
					break;
				default:
					return 0;
					break;				
			}
			
			return 0;
		}
	}
}