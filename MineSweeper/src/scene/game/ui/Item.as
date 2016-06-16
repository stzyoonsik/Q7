package scene.game.ui
{
	import scene.Main;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.TextureAtlas;

	/**
	 * 게임내에서 사용되는 아이템 클래스 
	 * @author user
	 * 
	 */
	public class Item extends Sprite
	{
		private var _atlas:TextureAtlas;
		private var _mineFinder:Button;
		private var _isMineFinderSelected:Boolean;
		private var _numberOfMineFinder:int;
				
		public function get isMineFinderSelected():Boolean { return _isMineFinderSelected; }
		
		public function Item(atlas:TextureAtlas, finderNum:int)
		{
			_atlas = atlas;
			_numberOfMineFinder = finderNum;
			
			initButton();
			
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
			if(_mineFinder)
			{
				_mineFinder.dispose();
				_mineFinder.removeEventListener(TouchEvent.TOUCH, onTouchMineFinder);
				_mineFinder = null;
				removeChild(_mineFinder);
			}
		}
		
		/**
		 * 마인파인더 버튼의 텍스트를 바꿔주는 메소드 
		 * @param text 바꿀 텍스트
		 * 
		 */
		public function setMineFinderText(text:String):void
		{
			_mineFinder.text = text;
		}
		
		/**
		 * 마인파인더 버튼의 알파값을 조정하는 메소드 
		 * @param value 알파값
		 * 
		 */
		public function setMineFinderAlpha(value:Number):void
		{
			_mineFinder.alpha = value;
		}
		
		/**
		 * 버튼 초기화 메소드 
		 * 
		 */
		private function initButton():void
		{
			_mineFinder = new Button(_atlas.getTexture("mineFinder"), _numberOfMineFinder.toString());	
			_mineFinder.alignPivot("center", "center");
			_mineFinder.width = Main.stageWidth * 0.15;
			_mineFinder.height = _mineFinder.width;
			_mineFinder.textFormat.size = Main.stageWidth * 0.05;
			_mineFinder.addEventListener(TouchEvent.TOUCH, onTouchMineFinder);
			
			addChild(_mineFinder);
		}

		/**
		 * 마인파인더 버튼을 클릭했을때 호출되는 콜백메소드. 
		 * @param event 터치이벤트
		 * 
		 */
		private function onTouchMineFinder(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_mineFinder, TouchPhase.ENDED);
			if(touch)
			{
				_isMineFinderSelected = !_isMineFinderSelected;
				dispatchEvent(new Event("mineFinder")); 
			}
			
		}
	}
}