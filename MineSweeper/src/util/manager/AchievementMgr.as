package util.manager
{
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGames;	
	
	import util.type.DifficultyType;

	public class AchievementMgr
	{
		//싱글톤
		private static var _instance:AchievementMgr;
		private static var _isConstructing:Boolean;
		
		public function AchievementMgr()
		{
			if (!_isConstructing) throw new Error("Singleton, use AchievementMgr.instance()");
			
		}
		
		public static function get instance():AchievementMgr 
		{
			if (_instance == null)  
			{
				_isConstructing = true;
				_instance = new AchievementMgr();
				_isConstructing = false;
			}
			return _instance;
		}	
		
		
		
		
		private const ID_VERY_EASY_FAST_CLEAR:String = "CgkIu_GfvOAVEAIQAQ";
		private const ID_EASY_FAST_CLEAR:String = "CgkIu_GfvOAVEAIQAw";
		private const ID_NORMAL_FAST_CLEAR:String = "CgkIu_GfvOAVEAIQBA";
		private const ID_HARD_FAST_CLEAR:String = "CgkIu_GfvOAVEAIQBQ";
		private const ID_VERY_HARD_FAST_CLEAR:String = "CgkIu_GfvOAVEAIQBg";
		
		
		
		private const FAST_CLEAR_VERY_EASY:int = 30;
		private const FAST_CLEAR_EASY:int = 60;
		private const FAST_CLEAR_NORMAL:int = 120;
		private const FAST_CLEAR_HARD:int = 240;
		private const FAST_CLEAR_VERY_HARD:int = 480;
		
		
		
		/**
		 * 빨리 깨기 업적 메소드 
		 * @param difficulty 난이도
		 * @param time 깬 시간
		 * @return 정해진 시간보다 빨리꺳으면 true
		 * 
		 */
		public function fastClear(difficulty:int, time:int):void
		{
			switch(difficulty)
			{
				case DifficultyType.VERY_EASY:
					if(time < FAST_CLEAR_VERY_EASY)
						AirGooglePlayGames.getInstance().reportAchievement(ID_VERY_EASY_FAST_CLEAR);
					break;
				case DifficultyType.EASY:
					if(time < FAST_CLEAR_EASY)
						AirGooglePlayGames.getInstance().reportAchievement(ID_EASY_FAST_CLEAR);
					break;
				case DifficultyType.NORMAL:
					if(time < FAST_CLEAR_NORMAL)
						AirGooglePlayGames.getInstance().reportAchievement(ID_NORMAL_FAST_CLEAR);
					break;
				case DifficultyType.HARD:
					if(time < FAST_CLEAR_HARD)
						AirGooglePlayGames.getInstance().reportAchievement(ID_HARD_FAST_CLEAR);
					break;
				case DifficultyType.VERY_HARD:
					if(time < FAST_CLEAR_VERY_HARD)
						AirGooglePlayGames.getInstance().reportAchievement(ID_VERY_HARD_FAST_CLEAR);
					break;
				default:
					break;
			}
		}
	}
}