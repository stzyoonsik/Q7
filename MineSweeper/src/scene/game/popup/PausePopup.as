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
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	
	import util.manager.DisplayObjectMgr;

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
		
		public function release():void
		{
			if(_atlas)
			{
				_atlas.dispose();
				_atlas = null;
			}
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
		
		private function initButton():void
		{
			var text:TextField = new TextField(200,100,"PAUSE");
			text.format.size = Main.stageWidth * 0.1;
			text.alignPivot("center", "center");
			text.x = Main.stageWidth * 0.5;
			text.y = Main.stageHeight * 0.4;
			addChild(text);
			
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
		
		private function initTextField():void
		{
			var text:TextField = new TextField(200,100,"PAUSE");
			text.format.size = Main.stageWidth * 0.1;
			text.alignPivot("center", "center");
			text.x = Main.stageWidth * 0.5;
			text.y = Main.stageHeight * 0.4;
			addChild(text);
		}
		
		private function onTouchAgain(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_again, TouchPhase.ENDED);
			if(touch)
			{
				dispatchEvent(new Event("again"));
			}
		}
		
		
		private function onTouchExit(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_exit, TouchPhase.ENDED);
			if(touch)
			{
				dispatchEvent(new Event("exit"));
			}
		}
		
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