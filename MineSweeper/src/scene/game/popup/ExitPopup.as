package scene.game.popup
{
	import scene.Main;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;

	public class ExitPopup extends DisplayObjectContainer
	{
		private var _yes:Button;
		private var _no:Button;
		
		public function ExitPopup()
		{
			var background:Quad = new Quad(Main.stageWidth * 0.6, Main.stageWidth * 0.4, Color.BLACK);
			background.alignPivot("center", "center");
			background.x = Main.stageWidth * 0.5;
			background.y = Main.stageHeight * 0.5;
			addChild(background);	
			
			var text:TextField = new TextField(200,100,"EXIT?");
			text.format.color = Color.WHITE;
			text.format.size = Main.stageWidth * 0.1;
			text.alignPivot("center", "center");
			text.x = Main.stageWidth * 0.5;
			text.y = Main.stageHeight * 0.425;
			addChild(text);
			
			_yes = setButton(_yes, Main.stageWidth * 0.4, Main.stageHeight * 0.55, Main.stageWidth * 0.1, Main.stageWidth * 0.075, "YES", Color.GRAY);
			_no = setButton(_no, Main.stageWidth * 0.6, Main.stageHeight * 0.55, Main.stageWidth * 0.1, Main.stageWidth * 0.075, "NO", Color.GRAY);
			
			_yes.addEventListener(TouchEvent.TOUCH, onTouchYes);
			_no.addEventListener(TouchEvent.TOUCH, onTouchNo);
			
			addChild(_yes);
			addChild(_no);
			
			this.visible = false;
		}
		
		public function release():void
		{
			if(_yes)
			{
				_yes.dispose();
				_yes.removeEventListener(TouchEvent.TOUCH, onTouchYes);
				_yes = null;
			}
			
			if(_no)
			{
				_no.dispose();
				_no.removeEventListener(TouchEvent.TOUCH, onTouchNo);
				_no = null;
			}
			
			removeChildren();
		}
		
		private function setButton(button:Button, x:int, y:int, width:int, height:int, text:String, color:uint):Button
		{
			var texture:Texture = Texture.fromColor(width, height, color);
			button = new Button(texture, text);
			button.alignPivot("center", "center");
			button.x = x;
			button.y = y;
			
			return button;
		}
		
		private function onTouchYes(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_yes, TouchPhase.ENDED);
			if(touch)
			{
				dispatchEvent(new Event("exit"));
			}
		}
		
		private function onTouchNo(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_no, TouchPhase.ENDED);
			if(touch)
			{
				this.visible = false;
				dispatchEvent(new Event("resume"));
			}
		}
	}
}