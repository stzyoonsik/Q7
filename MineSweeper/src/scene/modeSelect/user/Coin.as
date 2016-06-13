package scene.modeSelect.user
{
	import scene.Main;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	
	import util.UserInfo;
	import util.manager.DisplayObjectMgr;

	public class Coin extends DisplayObjectContainer
	{
		private var _atlas:TextureAtlas;
		private var _coinImage:Image;
		private var _coinTextField:TextField;
		
		public function Coin(atlas:TextureAtlas)
		{
			_atlas = atlas;
			initImage();
			initTextField();
		}
		
		public function refresh():void
		{
			if(_coinTextField)
			{
				_coinTextField.text = UserInfo.coin.toString();
			}
		}
		
		public function release():void
		{
			
		}
		
		private function initImage():void
		{
			_coinImage = DisplayObjectMgr.instance.setImage(_atlas.getTexture("coin"), Main.stageWidth * 0.55, Main.stageHeight * 0.04
				, Main.stageWidth * 0.075, Main.stageWidth * 0.075, "center", "center");
			addChild(_coinImage);
			
		}
		
		private function initTextField():void
		{
			_coinTextField = DisplayObjectMgr.instance.setTextField(Main.stageWidth * 0.675, Main.stageHeight * 0.04, 
				Main.stageWidth * 0.3, Main.stageHeight * 0.1, UserInfo.coin.toString(), "center", "center");
			_coinTextField.format.size = Main.stageWidth * 0.05;
			addChild(_coinTextField);
		}
	}
}