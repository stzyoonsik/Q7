package scene.title
{	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.desktop.NativeApplication;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import loading.CircleLoading;
	
	import scene.Main;
		
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.TextureAtlas;
	
	import util.EtcExtensions;
	import util.manager.AtlasMgr;
	import util.manager.DisplayObjectMgr;
	import util.manager.FacebookExtensionMgr;
	import util.manager.GoogleExtensionMgr;
	import util.manager.SoundMgr;
	import util.manager.SwitchActionMgr;
	import util.type.PlatformType;
	import util.type.SceneType;

	public class Title extends DisplayObjectContainer
	{
		private var _atlas:TextureAtlas;
		
		private var _logInGoogle:Button;
		private var _logInFacebook:Button;
		
		private var _circleLoading:CircleLoading;
		
		
		public function Title()
		{	
			CONFIG::device
			{
				FacebookExtensionMgr.instance.addEventListener("checkDone", onCheckDone);
				FacebookExtensionMgr.instance.addEventListener("startLoading", onStartLoading);
				
				GoogleExtensionMgr.instance.addEventListener("checkDone", onCheckDone);
				GoogleExtensionMgr.instance.addEventListener("startLoading", onStartLoading);
			}
			
			SoundMgr.instance.stopAll();
			playRandomBgm("titleBgm0.mp3", "titleBgm1.mp3", "titleBgm2.mp3");
			
			_atlas = AtlasMgr.instance.getAtlas("TitleSprite");
			
			
			initBackground();
			initButton();
			_circleLoading = new CircleLoading();
			addChild(_circleLoading);
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
			
			CONFIG::local
			{
				UserInfo.test();
				SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
			}
			
					
		}
		public function release():void
		{
			if(_logInGoogle) { _logInGoogle.addEventListener(TouchEvent.TOUCH, onTouchLoginGoogle); _logInGoogle.dispose(); _logInGoogle = null; removeChild(_logInGoogle);}
			if(_logInFacebook) { _logInFacebook.addEventListener(TouchEvent.TOUCH, onTouchLoginFacebook); _logInFacebook.dispose(); _logInFacebook = null; removeChild(_logInFacebook);}
			if(_circleLoading) { _circleLoading.release(); _circleLoading = null; removeChild(_circleLoading); }
			removeChildren(0, this.numChildren - 1, true);
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onTouchKeyBoard);
		}
		
		private function onStartLoading(event:Event):void
		{
			_circleLoading.startLoading();
		}
		
		private function getRandomNum():int
		{
			var random:Number = Math.random();
			if(random < 0.3333)
			{
				return 0;
			}
			else if(random < 0.6666)
			{
				return 1;
			}
			else
			{
				return 2;
			}
		}
		
		private function playRandomBgm(...args):void
		{
			SoundMgr.instance.play(args[getRandomNum()], true);
		}
		
		
		
		/** 백그라운드 초기화 메소드	 */
		private function initBackground():void
		{
			var background:Image = new Image(_atlas.getTexture("background"));
			background.width = Main.stageWidth;
			background.height = Main.stageHeight;
			addChild(background);
			
			var title:Image = new Image(_atlas.getTexture("title"));
			title.width = Main.stageWidth;
			title.height = title.width * 0.3;
			title.x = Main.stageWidth * 0.5;
			title.y = Main.stageHeight * 0.2;
			title.alignPivot("center","center");
			
			var tempScale:Number = title.scale;
			title.scale *= 0.1;
			
			
			var titleTween:Tween = new Tween(title, 2, Transitions.EASE_IN_BOUNCE);
			titleTween.scaleTo(tempScale);
			titleTween.addEventListener(Event.REMOVE_FROM_JUGGLER, onRemoveTitleTween);
			Starling.juggler.add(titleTween);
			addChild(title);
		}
		
		private function onRemoveTitleTween(event:Event):void
		{
			trace("titleTween remove");
			var titleTween:Tween = event.target as Tween;
			event.target.removeEventListener(Event.REMOVE_FROM_JUGGLER, onRemoveTitleTween);
			titleTween = null;
			
			if(_logInGoogle && _logInFacebook)
			{
				TweenLite.to(_logInGoogle, 1, {x:Main.stageWidth*0.5, y:Main.stageHeight*0.5, ease:Back.easeOut});
				TweenLite.to(_logInFacebook, 1, {x:Main.stageWidth*0.5, y:Main.stageHeight*0.7, ease:Back.easeOut});
			}
			
		}
		

		private function initButton():void
		{
			_logInGoogle = DisplayObjectMgr.instance.setButton(_logInGoogle, _atlas.getTexture("google"), Main.stageWidth * 1.5, Main.stageHeight * 0.5, Main.stageWidth * 0.5, Main.stageWidth * 0.1); 
			_logInGoogle.addEventListener(TouchEvent.TOUCH, onTouchLoginGoogle);
			addChild(_logInGoogle);
			
			_logInFacebook = DisplayObjectMgr.instance.setButton(_logInFacebook, _atlas.getTexture("facebook"), Main.stageWidth * 1.5, Main.stageHeight * 0.7, Main.stageWidth * 0.5, Main.stageWidth * 0.1);

			_logInFacebook.addEventListener(TouchEvent.TOUCH, onTouchLoginFacebook);
			addChild(_logInFacebook);
			
			
		}
		
		private function onTouchLoginGoogle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_logInGoogle, TouchPhase.ENDED);
			if(touch)
			{				
				GoogleExtensionMgr.instance.logIn();
			}
		}
	
		private function onTouchLoginFacebook(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_logInFacebook, TouchPhase.ENDED);
			if(touch)
			{
				FacebookExtensionMgr.instance.logIn();
			}
		}
		
		private function onCheckDone(event:Event):void
		{
			_circleLoading.stopLoading();
			
			if(PlatformType.current == PlatformType.GOOGLE)
			{
				GoogleExtensionMgr.instance.removeEventListener("checkDone", onCheckDone);
				GoogleExtensionMgr.instance.removeEventListener("startLoading", onStartLoading);
			}
			else
			{
				FacebookExtensionMgr.instance.removeEventListener("checkDone", onCheckDone);
				FacebookExtensionMgr.instance.removeEventListener("startLoading", onStartLoading);
			}
			SwitchActionMgr.instance.switchSceneFadeOut(this, SceneType.MODE_SELECT, false, null, 0.5, Transitions.EASE_OUT);
		}
		
		private function onTouchKeyBoard(event:KeyboardEvent):void
		{
			
			if(event.keyCode == Keyboard.BACK || event.keyCode == 8)
			{
				event.preventDefault();		
				if(_circleLoading.visible == true)
				{
					_circleLoading.visible = false;
				}
				
				EtcExtensions.exit();
			}
		}		
	}
}