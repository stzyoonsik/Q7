package scene.modeSelect.popup
{
	import scene.Main;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Color;
	
	import util.manager.AtlasMgr;
	import util.manager.DisplayObjectMgr;

	public class Popup extends DisplayObjectContainer
	{
		protected var _close:Button;
		public function Popup()
		{
			
		}
		
		public function release():void
		{
			if(_close) { _close.removeEventListener(TouchEvent.TOUCH, onTouchClose); _close.dispose(); _close = null; removeChild(_close); }
		}
		
		protected function initBackground(x:Number, y:Number, width:Number, height:Number):void
		{
			var quad:Quad = new Quad(Main.stageWidth, Main.stageHeight, Color.BLACK);
			quad.alpha = 0.5;
			addChild(quad);
			
			var background:Image = new Image(AtlasMgr.instance.getAtlas("ModeSprite").getTexture("popupBg"));
			background.width = width;
			background.height = height;
			background.x = x;
			background.y = y;		
			background.alignPivot("center","center");
			addChild(background);
		}
		
		protected function initClose(x:Number, y:Number, width:Number, height:Number):void
		{
			_close = DisplayObjectMgr.instance.setButton(_close, AtlasMgr.instance.getAtlas("ModeSprite").getTexture("close"), 
				x, y, width, height);
			_close.addEventListener(TouchEvent.TOUCH, onTouchClose);
			addChild(_close);
		}
		
		private function onTouchClose(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_close, TouchPhase.ENDED);
			if(touch)
			{
				this.visible = false;
			}
		}
	}
}