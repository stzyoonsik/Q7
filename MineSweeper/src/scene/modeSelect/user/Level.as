package scene.modeSelect.user
{
	import scene.Main;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.utils.Align;
	import starling.utils.Color;
	
	import util.LevelSystem;
	import util.UserInfo;

	/**
	 * 사용자의 레벨과 경험치 데이터를 관리하는 클래스 
	 * @author user
	 * 
	 */
	public class Level extends DisplayObjectContainer
	{
		private var _atlas:TextureAtlas;
		private var _background:Quad;
		private var _expImage:Quad;
		
		private var _levelTextField:TextField;
		private var _expTextField:TextField;
		
		public function Level(atlas:TextureAtlas)
		{
			_atlas = atlas;
			initBackground();
			initExpImage();
			initTextField();
		}	
		
		/**
		 * 메모리 해제 메소드 
		 * 
		 */
		public function release():void
		{
			if(_background) { _background.dispose(); _background = null; }
			if(_expImage) { _expImage.dispose(); _expImage = null; }
			if(_levelTextField) { _levelTextField = null; }
			if(_expTextField) { _expTextField = null; }
			
			removeChildren();
		}
		
		/**
		 * 백그라운드 초기화 메소드 
		 * 
		 */
		private function initBackground():void
		{
			_background = new Quad(Main.stageWidth * 0.3, Main.stageWidth * 0.03, Color.SILVER);
			_background.x = Main.stageWidth * 0.55;
			_background.y = Main.stageHeight * 0.1;
			_background.alignPivot("center", "center");
			addChild(_background);
		}
		
		/**
		 * 경험치 이미지를 %를 계산하여 적절한 길이로 초기화하는 메소드 
		 * 
		 */
		private function initExpImage():void
		{
			if(LevelSystem.getPercent(UserInfo.level, UserInfo.exp) == 0)
				return;
			
			_expImage = new Quad(_background.width * (LevelSystem.getPercent(UserInfo.level, UserInfo.exp) / 100), Main.stageWidth * 0.03, Color.LIME);
			_expImage.x = Main.stageWidth * 0.55 - (_background.width / 2);
			_expImage.y = Main.stageHeight * 0.1;
			_expImage.alignPivot("left", "center");
			addChild(_expImage);
		}
		
		/**
		 * 텍스트필드 초기화 메소드 
		 * 
		 */
		private function initTextField():void
		{
			_expTextField = new TextField(Main.stageWidth * 0.4, Main.stageHeight * 0.1);
			_expTextField.format.size = Main.stageWidth * 0.05;
			_expTextField.text = UserInfo.exp.toString() + " / " + LevelSystem.getNeedExp(UserInfo.level);
			_expTextField.x = Main.stageWidth * 0.55;
			_expTextField.y = Main.stageHeight * 0.15;
			_expTextField.alignPivot("center", "center");
			addChild(_expTextField); 
			
			_levelTextField = new TextField(Main.stageWidth * 0.2, Main.stageHeight * 0.1);
			_levelTextField.format.size = Main.stageWidth * 0.05;
			_levelTextField.format.horizontalAlign = Align.LEFT;
			_levelTextField.text = "LV : " + UserInfo.level;
			_levelTextField.x = Main.stageWidth * 0.325;
			_levelTextField.y = Main.stageHeight * 0.1;
			_levelTextField.alignPivot("center", "center");
			addChild(_levelTextField);
		}
		
	}
}