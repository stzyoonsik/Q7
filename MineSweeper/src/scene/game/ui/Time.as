package scene.game.ui
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import scene.Main;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;

	/**
	 * 게임 내에서 흘러가는 시간 클래스 
	 * 
	 */
	public class Time extends Sprite
	{
		private var _atlas:TextureAtlas;
		private var _second:int;
		private var _minute:int;
		
		private var _addTime:int
		private var _realTime:int;
		
		private var _timer:Timer;
		
		private var _10minuteImage:Image;
		private var _1minuteImage:Image;
		private var _10secondImage:Image;
		private var _1secondImage:Image;
		
		public function get realTime():int { return _realTime; }
		public function set realTime(value:int):void { _realTime = value; }
		
		public function Time(atlas:TextureAtlas, addTime:int = 0)
		{
			_atlas = atlas;
			_addTime = addTime;
			init();
			
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			
		}
		
		/**
		 * 시간 이미지 초기화 메소드
		 * 
		 */
		private function init():void			
		{
			_second = _addTime % 60;
			_minute = _addTime / 60;
			
			if(_addTime == 0)
			{
				_10minuteImage = new Image(_atlas.getTexture("number0"));
				_1minuteImage = new Image(_atlas.getTexture("number0"));
				_10secondImage = new Image(_atlas.getTexture("number0"));
				_1secondImage = new Image(_atlas.getTexture("number0"));
			}
			else
			{
				_10minuteImage = new Image(_atlas.getTexture("number"+(int(_minute / 10)).toString()));
				_1minuteImage = new Image(_atlas.getTexture("number"+(_minute % 10).toString()));
				_10secondImage = new Image(_atlas.getTexture("number"+(int(_second / 10)).toString()));
				_1secondImage = new Image(_atlas.getTexture("number"+(_second % 10).toString()));
			}
			_10minuteImage.width = Main.stageWidth * 0.1;
			_10minuteImage.height = Main.stageHeight * 0.1;
			_10minuteImage.x = Main.stageWidth * 0.1;
			
			_1minuteImage.width = Main.stageWidth * 0.1;
			_1minuteImage.height = Main.stageHeight * 0.1;
			_1minuteImage.x = Main.stageWidth * 0.2;
			
			_10secondImage.width = Main.stageWidth * 0.1;
			_10secondImage.height = Main.stageHeight * 0.1;
			_10secondImage.x = Main.stageWidth * 0.35;
			
			_1secondImage.width = Main.stageWidth * 0.1;
			_1secondImage.height = Main.stageHeight * 0.1;
			_1secondImage.x = Main.stageWidth * 0.45;
			
			addChild(_10minuteImage);
			addChild(_1minuteImage);
			addChild(_10secondImage);
			addChild(_1secondImage);
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
			
			if(_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER, onTimer);
				_timer = null;
			}
			
			if(_10minuteImage)
			{
				_10minuteImage.dispose();
				_10minuteImage = null;
			}
			
			if(_1minuteImage)
			{
				_1minuteImage.dispose();
				_1minuteImage = null;				
			}
			
			if(_10secondImage)
			{
				_10secondImage.dispose();
				_10secondImage = null;
			}
			
			if(_1secondImage)
			{
				_1secondImage.dispose();
				_1secondImage = null;
			}
			
			removeChildren(0, this.numChildren - 1, true);
		}
		
		/**
		 * 타이머 시작 메소드 
		 * 
		 */
		public function start():void
		{
			_timer.start();
		}
		
		/**
		 * 타이머 정지 메소드 
		 * 
		 */
		public function stop():void
		{
			_timer.stop();
		}

		/**
		 * 매 초마다 시간을 갱신하는 콜백 메소드
		 * @param event 타이머 이벤트
		 * 
		 */
		private function onTimer(event:TimerEvent):void
		{
			_realTime = _timer.currentCount + _addTime;
			_second = _realTime % 60;
			_minute = _realTime / 60;
			changeImage();
		}
		
		/**
		 * 매 초마다 갱신된 시간값을 토대로 이미지를 바꿔주는 메소드 
		 * 
		 */
		private function changeImage():void
		{
			_1secondImage.texture = _atlas.getTexture("number"+(_second % 10).toString());
			_10secondImage.texture = _atlas.getTexture("number"+(int(_second / 10)).toString());
			
			_1minuteImage.texture = _atlas.getTexture("number"+(_minute % 10).toString());
			_10minuteImage.texture = _atlas.getTexture("number"+(int(_minute / 10)).toString());
		}
	}
}