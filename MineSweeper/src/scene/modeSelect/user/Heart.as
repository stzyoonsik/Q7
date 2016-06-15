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
		
		public function Heart(atlas:TextureAtlas)
		{
			_atlas = atlas;
			initImage();
			initTextField();
			
			getLastDateTime();
		}
		

		public function get remainHeartTime():int {	return _remainHeartTime; }
		public function set remainHeartTime(value:int):void { _remainHeartTime = value; }

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
		
		private function getLastDateTime():void
		{
			UserDBMgr.instance.selectData(UserInfo.id, "lastDate");
			UserDBMgr.instance.addEventListener("selectData", onSelectLastDateComplete);
		}
		
		private function onSelectLastDateComplete(event:Event):void
		{
			UserDBMgr.instance.removeEventListener("selectData", onSelectLastDateComplete);
			
			_lastDate = Number(event.data);
			trace("lastDate = " + _lastDate);
			//서버에 저장된 남은시간을 가져옴
			UserDBMgr.instance.selectData(UserInfo.id, "heartTime");
			UserDBMgr.instance.addEventListener("selectData", onSelectHeartTimeComplete);
		}
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
		
		
		private function getInactiveTime():Number
		{
			if(!isNaN(_lastDate))
			{
				var currentDate:Number = new Date().getTime();
				return Math.round((currentDate - _lastDate) / 1000);
			}
			return -1;
		}

		
		private function initImage():void
		{
			_heart = DisplayObjectMgr.instance.setImage(_atlas.getTexture("heart"), 
				Main.stageWidth * 0.275, Main.stageHeight * 0.04, 
				Main.stageWidth * 0.075, Main.stageWidth * 0.075, "center", "center");
			
			addChild(_heart);
		}
		
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
		
		private function onTimer(event:TimerEvent):void
		{
			_remainHeartTime = _timer.repeatCount - _timer.currentCount;
			UserInfo.remainHeartTime = _remainHeartTime;
			_remainTime.text = int((_timer.repeatCount - _timer.currentCount) / 60) + " : " + (_timer.repeatCount - _timer.currentCount) % 60;
			
		}
		
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