package scene.modeSelect.user
{	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import scene.Main;
	
	import server.UserDBMgr;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	
	import util.UserInfo;
	import util.manager.DisplayObjectMgr;

	public class Heart extends DisplayObjectContainer
	{
		private var _atlas:TextureAtlas;
		private var _heartCountTextField:TextField;
		private var _remainTime:TextField;
		private var _heart:Image;
		
		private var _timer:Timer;
		
		private var _lastDate:Number = 0;
		
		private var _remainHeartTime:int;
		
		/**
		 * 사용자의 하트 정보를 관리하는 클래스 
		 * 
		 */
		public function Heart(atlas:TextureAtlas)
		{
			_atlas = atlas;
			initImage();
			initTextField();
			
			getLastDateTime();
		}
		

		public function get remainHeartTime():int {	return _remainHeartTime; }
		public function set remainHeartTime(value:int):void { _remainHeartTime = value; }

		/**
		 * 메모리 해제 메소드 
		 * 
		 */
		public function release():void
		{
			if(_heartCountTextField) { _heartCountTextField = null; }
			if(_remainTime) { _remainTime = null; }
			if(_heart) { _heart.dispose(); _heart = null; }			
			if(_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER, onTimer);
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				_timer = null;
			}
			
			removeChildren(0, this.numChildren - 1, true);
		}
		
		/**
		 * 변경된 하트 데이터를 반영시켜 화면에 새로고침하는 메소드 
		 * 
		 */
		public function refresh():void
		{
			if(_heartCountTextField)
			{
				if(UserInfo.heart >= UserInfo.MAX_HEART)
				{
					UserInfo.heart = UserInfo.MAX_HEART;
					_heartCountTextField.text = "MAX";
					if(_timer)
						_timer.stop();
					UserInfo.remainHeartTime = UserInfo.HEART_GEN_TIME;
					_remainTime.text = "";
				}
				else
				{
					_heartCountTextField.text = UserInfo.heart.toString();
				}
			}
		}
		
		/**
		 * 마지막 접속 시간을 가져오는 메소드 
		 * 
		 */
		private function getLastDateTime():void
		{
			UserDBMgr.instance.selectData(UserInfo.id, "lastDate");
			UserDBMgr.instance.addEventListener("selectData", onSelectLastDateComplete);
		}
		
		/**
		 * 마지막 접속 시간을 가져오는것이 완료됬을떄 호출되는 콜백메소드 
		 * @param event
		 * 
		 */
		private function onSelectLastDateComplete(event:Event):void
		{
			UserDBMgr.instance.removeEventListener("selectData", onSelectLastDateComplete);
			
			_lastDate = Number(event.data);
			trace("lastDate = " + _lastDate);
			//서버에 저장된 남은시간을 가져옴
			UserDBMgr.instance.selectData(UserInfo.id, "heartTime");
			UserDBMgr.instance.addEventListener("selectData", onSelectHeartTimeComplete);
		}
		/**
		 * 하트 남은시간 데이터를 가져오는것이 완료됬을떄 호출되는 콜백메소드 
		 * @param event
		 * 
		 */
		private function onSelectHeartTimeComplete(event:Event):void
		{			
			UserDBMgr.instance.removeEventListener("selectData", onSelectHeartTimeComplete);
			_remainHeartTime = Number(event.data);
			
			//inactiveTime은 초단위
			var inactiveTime:Number = getInactiveTime();
			trace("inactiveTime = " + inactiveTime);
			
			//잠수 시간이 하트 남은 시간보다 크면
			if(inactiveTime != -1)
			{
				var count:int;
				
				if(inactiveTime >= _remainHeartTime)
				{
					//하트 ++;
					inactiveTime -= _remainHeartTime;
					count++;
					while(inactiveTime > UserInfo.HEART_GEN_TIME)
					{
						inactiveTime -= UserInfo.HEART_GEN_TIME;
						count++;
					}
					
					UserInfo.heart += count;
					
				}
					//잠수 시간이 하트 남은시간보다 작으면
				else
				{
					_remainHeartTime -= inactiveTime;
				}
				
				
				if(UserInfo.heart >= UserInfo.MAX_HEART)
				{
					UserInfo.heart = UserInfo.MAX_HEART;
					
					UserInfo.remainHeartTime = 300;
					UserDBMgr.instance.updateData(UserInfo.id, "heartTime", UserInfo.remainHeartTime);
				}
				else
				{
					if(_remainHeartTime == 0)
					{
						_timer = new Timer(1000, UserInfo.HEART_GEN_TIME);
					}
					else
					{
						_timer = new Timer(1000, _remainHeartTime);
					}
					
					trace("repeatCount = " + _timer.repeatCount);
					_timer.addEventListener(TimerEvent.TIMER, onTimer);
					_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
					
					_timer.start();
				}
				
				UserDBMgr.instance.updateData(UserInfo.id, "heart", UserInfo.heart);
				refresh();
			}
			
			dispatchEvent(new Event("loadingDone"));
		}
		
		
		/**
		 * 마지막으로 접속한 시간과 현재 시간을 비교하여 총 비활동 시간을 계산하는 메소드 
		 * @return 비활동 시간
		 * 
		 */
		private function getInactiveTime():Number
		{
			if(!isNaN(_lastDate))
			{
				var currentDate:Number = new Date().getTime();
				return Math.round((currentDate - _lastDate) / 1000);
			}
			return -1;
		}

		
		/**
		 * 이미지 초기화 메소드 
		 * 
		 */
		private function initImage():void
		{
			_heart = DisplayObjectMgr.instance.setImage(_atlas.getTexture("heart"), 
				Main.stageWidth * 0.275, Main.stageHeight * 0.04, 
				Main.stageWidth * 0.075, Main.stageWidth * 0.075, "center", "center");
			
			addChild(_heart);
		}
		
		/**
		 * 텍스트필드 초기화 메소드 
		 * 
		 */
		private function initTextField():void
		{
			_heartCountTextField = DisplayObjectMgr.instance.setTextField(Main.stageWidth * 0.275, Main.stageHeight * 0.04,
				Main.stageWidth * 0.2, Main.stageHeight * 0.1, UserInfo.heart.toString(), "center","center");
			_heartCountTextField.format.size = Main.stageWidth * 0.05;			
			addChild(_heartCountTextField);
			
			_remainTime = DisplayObjectMgr.instance.setTextField(Main.stageWidth * 0.425, Main.stageHeight * 0.04,
				Main.stageWidth * 0.2, Main.stageHeight * 0.1, "", "center","center");
			_remainTime.format.size = Main.stageWidth * 0.05;
			addChild(_remainTime);			
		}
		
		/**
		 * 1초마다 호출되는 콜백 메소드. 하트 재생의 남은 시간을 변경해줌 
		 * @param event
		 * 
		 */
		private function onTimer(event:TimerEvent):void
		{
			_remainHeartTime = _timer.repeatCount - _timer.currentCount;
			UserInfo.remainHeartTime = _remainHeartTime;
			_remainTime.text = int((_timer.repeatCount - _timer.currentCount) / 60) + " : " + (_timer.repeatCount - _timer.currentCount) % 60;
			
		}
		
		/**
		 * 타이머가 종료됬을떄 호출되는 콜백메소드. 하트를 1개 늘려주고, 세팅된 처음시간으로 다시 타이머를 시작함 
		 * @param event
		 * 
		 */
		private function onTimerComplete(event:TimerEvent):void
		{
			if(UserInfo.heart < UserInfo.MAX_HEART)
			{
				UserInfo.heart++;
				refresh();
				UserDBMgr.instance.updateData(UserInfo.id, "heart", UserInfo.heart);
			}	
			
			if(UserInfo.heart >= UserInfo.MAX_HEART)
			{
				_timer = null;
				_remainTime = null;
			}
			else
			{
				_timer.repeatCount = UserInfo.HEART_GEN_TIME;
				_timer.reset();
				_timer.start();	
			}
		}
	}
}