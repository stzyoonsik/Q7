package scene.game.popup
{
	import scene.Main;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	import util.manager.ButtonMgr;

	public class ClearPopup extends DisplayObjectContainer
	{
		private var _background:Quad;
		private var _textField:TextField;
		private var _again:Button;
		private var _exit:Button;
		
		public function get textField():TextField {	return _textField; }
		public function set textField(value:TextField):void	{ _textField = value; }
		
		public function ClearPopup()
		{
			initBackground();
			initTextField();
			initButton();
			
			
			this.visible = false;
		}
		
		

		/** 백그라운드 초기화 메소드	 */
		private function initBackground():void
		{
			_background = new Quad(Main.stageWidth * 0.6, Main.stageHeight * 0.4, Color.BLACK);
			_background.alignPivot("center", "center");
			_background.x = Main.stageWidth * 0.5;
			_background.y = Main.stageHeight * 0.5;
			addChild(_background);	
		}
		
		/** 버튼 초기화 메소드	 */
		private function initButton():void
		{
			_again = ButtonMgr.instance.setButton(_again, Texture.fromColor(1,1,Color.GRAY), Main.stageWidth * 0.4, Main.stageHeight * 0.6, Main.stageWidth * 0.1, Main.stageWidth * 0.075, "AGAIN", Main.stageWidth * 0.05);
			_exit = ButtonMgr.instance.setButton(_exit, Texture.fromColor(1,1,Color.GRAY), Main.stageWidth * 0.6, Main.stageHeight * 0.6, Main.stageWidth * 0.1, Main.stageWidth * 0.075, "EXIT", Main.stageWidth * 0.05);
			
			_again.addEventListener(TouchEvent.TOUCH, onTouchAgain);
			_exit.addEventListener(TouchEvent.TOUCH, onTouchExit);
			
			addChild(_again);
			addChild(_exit);
		}
		
		private function initTextField():void
		{
			_textField = new TextField(Main.stageWidth * 0.6, Main.stageHeight * 0.4, "");
			_textField.alignPivot("center", "center");
			_textField.format.size = Main.stageWidth * 0.05;
			_textField.format.color = Color.WHITE;
			_textField.x = Main.stageWidth * 0.5;
			_textField.y = Main.stageHeight * 0.4;
			
			addChild(_textField);
		}
		
		/**
		 * 다시하기 터치 이벤트 리스너 
		 * @param event 터치이벤트
		 * 
		 */		
		private function onTouchAgain(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_again, TouchPhase.ENDED);
			if(touch)
			{
				dispatchEvent(new Event("again"));
			}
		}
		
		/**
		 * 종료 터치 이벤트 리스너 
		 * @param event 터치이벤트
		 * 
		 */
		private function onTouchExit(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_exit, TouchPhase.ENDED);
			if(touch)
			{
				dispatchEvent(new Event("exit"));
			}
		}
	}
}