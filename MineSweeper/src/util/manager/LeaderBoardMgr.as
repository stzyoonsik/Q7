package util.manager
{
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGames;
	
	import util.type.DifficultyType;

	public class LeaderBoardMgr
	{		
		//싱글톤
		private static var _instance:LeaderBoardMgr;
		private static var _isConstructing:Boolean;
		
		public function LeaderBoardMgr()
		{
			if (!_isConstructing) throw new Error("Singleton, use LeaderBoardMgr.instance()");
			
		}
		
		public static function get instance():LeaderBoardMgr 
		{
			if (_instance == null)  
			{
				_isConstructing = true;
				_instance = new LeaderBoardMgr();
				_isConstructing = false;
			}
			return _instance;
		}	
		
		private const ID_NOITEM_VERY_EASY:String = "CgkIu_GfvOAVEAIQDw";
		private const ID_NOITEM_EASY:String		 = "CgkIu_GfvOAVEAIQEA";
		private const ID_NOITEM_NORMAL:String    = "CgkIu_GfvOAVEAIQEQ";
		private const ID_NOITEM_HARD:String		 = "CgkIu_GfvOAVEAIQEg";
		private const ID_NOITEM_VERY_HARD:String = "CgkIu_GfvOAVEAIQEw";
		
		private const ID_VERY_EASY:String = "CgkIu_GfvOAVEAIQCA";
		private const ID_EASY:String	  = "CgkIu_GfvOAVEAIQCQ";
		private const ID_NORMAL:String	  = "CgkIu_GfvOAVEAIQCg";
		private const ID_HARD:String 	  = "CgkIu_GfvOAVEAIQCw";
		private const ID_VERY_HARD:String = "CgkIu_GfvOAVEAIQDA";
		
		
		
		public function reportScore(isItemMode:Boolean, difficulty:int, time:int):void
		{
			if(isItemMode)
			{
				switch(difficulty)
				{
					case DifficultyType.VERY_EASY :
						AirGooglePlayGames.getInstance().reportScore(ID_VERY_EASY , time * 1000);
						break;
					case DifficultyType.EASY :
						AirGooglePlayGames.getInstance().reportScore(ID_EASY, time * 1000);
						break;
					case DifficultyType.NORMAL :
						AirGooglePlayGames.getInstance().reportScore(ID_NORMAL, time * 1000);
						break;
					case DifficultyType.HARD :
						AirGooglePlayGames.getInstance().reportScore(ID_HARD, time * 1000);
						break;
					case DifficultyType.VERY_HARD :
						AirGooglePlayGames.getInstance().reportScore(ID_VERY_HARD, time * 1000);
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
						AirGooglePlayGames.getInstance().reportScore(ID_NOITEM_VERY_EASY , time * 1000);
						break;
					case DifficultyType.EASY :
						AirGooglePlayGames.getInstance().reportScore(ID_NOITEM_EASY, time * 1000);
						break;
					case DifficultyType.NORMAL :
						AirGooglePlayGames.getInstance().reportScore(ID_NOITEM_NORMAL, time * 1000);
						break;
					case DifficultyType.HARD :
						AirGooglePlayGames.getInstance().reportScore(ID_NOITEM_HARD, time * 1000);
						break;
					case DifficultyType.VERY_HARD :
						AirGooglePlayGames.getInstance().reportScore(ID_NOITEM_VERY_HARD, time * 1000);
						break;
					default:
						break;				
				}
			}
			
		}
	}
}