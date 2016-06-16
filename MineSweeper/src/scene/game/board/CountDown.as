package scene.game.board
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import scene.Main;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;
	
	import util.manager.SoundMgr;

	/**
	 * 게임 시작 전 3 2 1 세는 카운트다운 클래스 
	 * @author user
	 * 
	 */
	public class CountDown extends DisplayObjectContainer
	{
		private var _background:Quad;
		private var _textField:TextField;
		private var _count:int;
				
		private var _timer:Timer;		

		
		public function CountDown(count:int)
		{
			_count = count;
			initBackground();
			initTextField();
			
			
			_timer = new Timer(1000, _count);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer.start();
			SoundMgr.instance.play(_count+".mp3");
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
		 * 타이머 스톱 메소드 
		 * 
		 */
		public function stop():void
		{
			_timer.stop();
		}
		
		/**
		 * 타이머 리셋 메소드 
		 * 
		 */
		public function reset():void
		{
			_timer.reset();
		}
		
		/**
		 * 메모리 해제 메소드 
		 * 
		 */
		public function release():void
		{
			trace("CountDown Release");
			if(_background)
			{
				_background.dispose();
				_background = null;
				removeChild(_background);				
			}
			if(_textField)
			{		
				_textField = null;
				removeChild(_textField);
			}
			if(_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER, onTimer);
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				_timer = null;
			}
		}
		
		/**
		 * 백그라운드 초기화 메소드 
		 * 
		 */
		private function initBackground():void
		{
			_background = new Quad(Main.stageWidth, Main.stageHeight, Color.BLACK);
			_background.alpha = 0.5;
			addChild(_background);
		}

		/**
		 * 텍스트필드 초기화 메소드 
		 * 
		 */
		private function initTextField():void
		{
			_textField = new TextField(Main.stageWidth * 0.5, Main.stageHeight * 0.25);
			_textField.format.size = Main.stageWidth * 0.2;
			_textField.text = _count.toString();
			_textField.x = Main.stageWidth * 0.5;
			_textField.y = Main.stageHeight * 0.5;
			_textField.alignPivot("center", "center");
			addChild(_textField);
		}
		
		/**
		 * 매 초마다 시간을 갱신하는 콜백 메소드
		 * @param event 타이머 이벤트
		 * 
		 */
		private function onTimer(event:TimerEvent):void
		{			
			_count--;
			if(_count != 0)
				SoundMgr.instance.play(_count+".mp3");
			_textField.text = _count.toString();
		}
		
		/**
		 * 타이머가 끝났을때 동작하는 콜백 메소드 
		 * @param event 타이머 끝 이벤트
		 * 
		 */
		private function onTimerComplete(event:TimerEvent):void
		{
			SoundMgr.instance.play("start.mp3");
			dispatchEvent(new Event("endTimer"));
		}
	}
}