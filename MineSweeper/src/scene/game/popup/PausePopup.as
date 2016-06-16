package scene.game.popup
{
	import scene.Main;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	
	import util.manager.DisplayObjectMgr;

	/**
	 * 게임 중 뒤로가기를 눌렀을때 등장하는 클래스 
	 * @author user
	 * 
	 */
	public class PausePopup extends DisplayObjectContainer
	{
		private var _atlas:TextureAtlas;
		
		private var _again:Button;
		private var _exit:Button;
		private var _resume:Button;
		
		public function PausePopup(atlas:TextureAtlas)
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
			if(_exit)
			{
				_exit.dispose();
				_exit.removeEventListener(TouchEvent.TOUCH, onTouchExit);
				_exit = null;
			}
			
			if(_resume)
			{
				_resume.dispose();
				_resume.removeEventListener(TouchEvent.TOUCH, onTouchResume);
				_resume = null;
			}
			
			if(_again)
			{
				_again.dispose();
				_again.removeEventListener(TouchEvent.TOUCH, onTouchAgain);
				_again = null;
			}
			
			removeChildren();
		}
		
		/**
		 * 버튼을 반투명하고 터치 불가하게 만드는 메소드 
		 * @param type 어떤 버튼에 적용할지 스트링으로 받음
		 * 
		 */
		public function makeButtonInvisible(type:String):void
		{
			switch(type)
			{
				case "exit":
					_exit.alpha = 0.5;
					_exit.touchable = false;
					break;
				case "resume":
					_resume.alpha = 0.5;
					_resume.touchable = false;
					break;
				case "again":
					_again.alpha = 0.5;
					_again.touchable = false;
					break;
				default:
					break;
			}
		}
		
		/**
		 * 백그라운드 초기화 메소드 
		 * 
		 */
		private function initBackground():void
		{
			var background:Image = new Image(_atlas.getTexture("popupBg"));
			background.x = Main.stageWidth * 0.5;
			background.y = Main.stageHeight * 0.5;
			background.width = Main.stageWidth * 0.5;
			background.height = Main.stageHeight * 0.35;
			background.alignPivot("center","center");
			addChild(background);
		}
		
		/**
		 * 버튼 초기화 메소드 
		 * 
		 */
		private function initButton():void
		{			
			_again = DisplayObjectMgr.instance.setButton(_again, _atlas.getTexture("button"), Main.stageWidth * 0.5, Main.stageHeight * 0.5, Main.stageWidth * 0.3, Main.stageWidth * 0.1, "AGAIN", Main.stageWidth * 0.05);
			_exit = DisplayObjectMgr.instance.setButton(_exit, _atlas.getTexture("button"), Main.stageWidth * 0.375, Main.stageHeight * 0.6, Main.stageWidth * 0.175, Main.stageWidth * 0.1, "EXIT", Main.stageWidth * 0.05);			
			_resume = DisplayObjectMgr.instance.setButton(_resume, _atlas.getTexture("button"), Main.stageWidth * 0.625, Main.stageHeight * 0.6, Main.stageWidth * 0.175, Main.stageWidth * 0.1, "RESUME", Main.stageWidth * 0.05);
			
			_again.addEventListener(TouchEvent.TOUCH, onTouchAgain);
			_exit.addEventListener(TouchEvent.TOUCH, onTouchExit);
			_resume.addEventListener(TouchEvent.TOUCH, onTouchResume);
			
			addChild(_again);
			addChild(_exit);
			addChild(_resume);
		}
		
		/**
		 * 텍스트필드 초기화 메소드 
		 * 
		 */
		private function initTextField():void
		{
			var text:TextField = new TextField(Main.stageWidth * 0.5 , Main.stageHeight * 0.2,"PAUSE");
			text.format.size = Main.stageWidth * 0.1;
			text.alignPivot("center", "center");
			text.x = Main.stageWidth * 0.5;
			text.y = Main.stageHeight * 0.4;
			addChild(text);
		}
		
		/**
		 * 다시하기를 눌렀을때 호출되는 콜백메소드 . 게임을 다시 시작하기위해 이벤트를 보냄
		 * @param event
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
		 * 나가기를 눌렀을때 호출되는 콜백메소드. 게임에서 나가고 모드셀렉트 씬으로 가기위해 이벤트를 보냄
		 * @param event
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
		
		/**
		 * 재개하기를 눌렀을때 호출되는 콜백메소드. 게임을 계속 진행하기위해 이벤트를 보냄 
		 * @param event
		 * 
		 */
		private function onTouchResume(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_resume, TouchPhase.ENDED);
			if(touch)
			{
				this.visible = false;
				dispatchEvent(new Event("resume"));
			}
		}
	}
}