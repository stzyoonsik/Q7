package scene.game.popup
{
	import scene.Main;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.utils.Align;
	
	import util.manager.DisplayObjectMgr;

	/**
	 * 게임 클리어시 등장하는 팝업 클래스 
	 * 
	 */
	public class ClearPopup extends DisplayObjectContainer
	{
		private var _atlas:TextureAtlas;
		
		private var _background:Quad;
		private var _textField:TextField;
		private var _again:Button;
		private var _exit:Button;
		
		
		public function ClearPopup(atlas:TextureAtlas)
		{
			_atlas = atlas;
			
			initBackground();
			initTextField();
			initButton();
			
			
			this.visible = false;
		}
		
		/**
		 * 메모리 해제 메소드 
		 * 
		 */
		public function release():void
		{
//			if(_atlas)
//			{
//				_atlas.dispose();
//				_atlas = null;
//			}
			if(_background)
			{
				_background.dispose();
				_background = null;
			}
			if(_textField)
			{
				_textField = null;
			}
			if(_exit)
			{
				_exit.dispose();
				_exit.removeEventListener(TouchEvent.TOUCH, onTouchExit);
				_exit = null;
			}
			if(_again)
			{
				_again.dispose();
				_again.removeEventListener(TouchEvent.TOUCH, onTouchAgain);
				_again = null;
			}
			removeChildren(0, this.numChildren, true);
		}
		
		/**
		 * 텍스트 필드의 텍스트를 set하는 메소드 
		 * @param text 텍스트
		 * 
		 */
		public function setTextField(text:String):void
		{
			_textField.text = text;
		}
		
		

		/** 백그라운드 초기화 메소드	 */
		private function initBackground():void
		{
			var background:Image = new Image(_atlas.getTexture("popupBg"));
			background.x = Main.stageWidth * 0.5;
			background.y = Main.stageHeight * 0.5;
			background.width = Main.stageWidth * 0.6;
			background.height = Main.stageHeight * 0.5;
			background.alignPivot("center","center");
			addChild(background);
		}
		
		/** 버튼 초기화 메소드	 */
		private function initButton():void
		{
			_again = DisplayObjectMgr.instance.setButton(_again, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.575, Main.stageWidth * 0.3, Main.stageWidth * 0.1, "AGAIN", Main.stageWidth * 0.05);
			_exit = DisplayObjectMgr.instance.setButton(_exit, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.675, Main.stageWidth * 0.3, Main.stageWidth * 0.1, "EXIT", Main.stageWidth * 0.05);
			
			_again.addEventListener(TouchEvent.TOUCH, onTouchAgain);
			_exit.addEventListener(TouchEvent.TOUCH, onTouchExit);
			
			addChild(_again);
			addChild(_exit);
		}
		
		/**
		 * 텍스트필드 초기화 메소드 
		 * 
		 */
		private function initTextField():void
		{
			_textField = new TextField(Main.stageWidth * 0.5, Main.stageHeight * 0.375, "");
			_textField.alignPivot("center", "center");
			_textField.format.size = Main.stageWidth * 0.05;
			_textField.format.horizontalAlign = Align.LEFT;
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