package scene.game.ui
{
	import scene.Main;
	
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.Color;

	/**
	 * 게임에 실패했을때 표시하기 위한 클래스 
	 * 
	 */
	public class GameOver extends Sprite
	{
		private var _textField:TextField;
		
		public function GameOver()
		{		
			_textField = new TextField(Main.stageWidth, Main.stageHeight * 0.1, "GAME OVER");
			_textField.alignPivot("center", "center");
			_textField.format.size = Main.stageWidth * 0.125;
			_textField.format.color = Color.RED;
			_textField.x = Main.stageWidth * 0.5;
			_textField.y = Main.stageHeight * 0.25;
			addChild(_textField);
		}
		
		/**
		 * 메모리 해제 메소드 
		 * 
		 */
		public function release():void
		{
			if(_textField)
			{
				_textField = null;
				removeChild(_textField);
			}
		}
		
		/**
		 * 텍스트필드의 텍스트를 set하는 메소드 
		 * @param text 텍스트
		 * 
		 */
		public function setTextField(text:String):void
		{
			_textField.text = text;
		}

	}
}