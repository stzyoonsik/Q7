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

	public class Item extends Sprite
	{
		private var _atlas:TextureAtlas;
		private var _mineFinder:Button;
		private var _isMineFinderSelected:Boolean;
		private var _numberOfMineFinder:int;
		
		public function get mineFinder():Button { return _mineFinder; }
		public function set mineFinder(value:Button):void {	_mineFinder = value; }
		
		public function get isMineFinderSelected():Boolean { return _isMineFinderSelected; }
		
		public function Item(atlas:TextureAtlas, finderNum:int)
		{
			_atlas = atlas;
			_numberOfMineFinder = finderNum;
			
			initButton();
			
		}
		
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
		
		private function initButton():void
		{
			_mineFinder = new Button(_atlas.getTexture("mineFinder"), _numberOfMineFinder.toString());	
			_mineFinder.alignPivot("center", "center");
			_mineFinder.width = Main.stageWidth * 0.15;
			_mineFinder.height = _mineFinder.width;
			_mineFinder.textFormat.size = 20;
			_mineFinder.addEventListener(TouchEvent.TOUCH, onTouchMineFinder);
			
			addChild(_mineFinder);
		}

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