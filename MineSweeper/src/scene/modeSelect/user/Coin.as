package scene.modeSelect.user
{
	import scene.Main;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	
	import util.UserInfo;
	import util.manager.DisplayObjectMgr;

	/**
	 * 사용자의 현재 코인을 보여주는 클래스 
	 * 
	 */
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
		
		/**
		 * 정보가 업데이트 되었을때 보여지는 부분을 새로고침 하는 메소드 
		 * 
		 */
		public function refresh():void
		{
			if(_coinTextField)
			{
				_coinTextField.text = UserInfo.coin.toString();
			}
		}
		
		/**
		 * 메모리 해제 메소드 
		 * 
		 */
		public function release():void
		{
			if(_coinImage) { _coinImage.dispose(); _coinImage = null; }
			if(_coinTextField) { _coinTextField = null; }
			
			removeChildren();
		}
		
		/**
		 * 이미지 초기화 메소드 
		 * 
		 */
		private function initImage():void
		{
			_coinImage = DisplayObjectMgr.instance.setImage(_atlas.getTexture("coin"), Main.stageWidth * 0.55, Main.stageHeight * 0.04
				, Main.stageWidth * 0.075, Main.stageWidth * 0.075, "center", "center");
			addChild(_coinImage);
			
		}
		
		/**
		 * 텍스트필드 초기화 메소드 
		 * 
		 */
		private function initTextField():void
		{
			_coinTextField = DisplayObjectMgr.instance.setTextField(Main.stageWidth * 0.675, Main.stageHeight * 0.04, 
				Main.stageWidth * 0.3, Main.stageHeight * 0.1, UserInfo.coin.toString(), "center", "center");
			_coinTextField.format.size = Main.stageWidth * 0.05;
			addChild(_coinTextField);
		}
	}
}