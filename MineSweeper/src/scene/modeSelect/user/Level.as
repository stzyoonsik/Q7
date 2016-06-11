package scene.modeSelect.user
{
	import scene.Main;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.utils.Align;
	
	import util.LevelSystem;
	import util.UserInfo;

	public class Level extends DisplayObjectContainer
	{
		private var _atlas:TextureAtlas;
		private var _background:Image;
		private var _expImage:Image;
		
		private var _levelTextField:TextField;
		private var _expTextField:TextField;
		
		public function Level(atlas:TextureAtlas)
		{
			_atlas = atlas;
			initBackground();
			initExpImage();
			initTextField();
		}	
		
		public function release():void
		{
			
		}
		
		
		public function refreshExp():void
		{
			_expImage.width = UserInfo.exp;
		}
		
		private function initBackground():void
		{
			_background = new Image(_atlas.getTexture("expBg"));
			_background.x = Main.stageWidth * 0.65;
			_background.y = Main.stageHeight * 0.1;
			_background.width = Main.stageWidth * 0.5;
			_background.height = _background.width * 0.1;
			_background.alignPivot("center", "center");
			addChild(_background);
		}
		
		private function initExpImage():void
		{
			if(LevelSystem.getPercent(UserInfo.level, UserInfo.exp) == 0)
				return;
			
			_expImage = new Image(_atlas.getTexture("exp"));
			_expImage.x = Main.stageWidth * 0.65;
			_expImage.y = Main.stageHeight * 0.1;
			_expImage.width = _background.width * 0.98;
			_expImage.height = _background.height * 0.9;
			_expImage.alignPivot("center", "center");
			
			//??? *2를 왜 해야하는가 미스터리
			var mask:Quad = new Quad(_expImage.width * (LevelSystem.getPercent(UserInfo.level, UserInfo.exp) / 100) * 2, _expImage.height * 2);
			_expImage.mask = mask;
			
			addChild(_expImage);
		}
		
		private function initTextField():void
		{
			_expTextField = new TextField(Main.stageWidth * 0.4, Main.stageHeight * 0.1);
			_expTextField.format.size = Main.stageWidth * 0.05;
			_expTextField.text = UserInfo.exp.toString() + " / " + LevelSystem.getNeedExp(UserInfo.level);
			_expTextField.x = Main.stageWidth * 0.65;
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