package scene.modeSelect.popup.reward
{
	import scene.Main;
	
	import server.UserDBMgr;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	
	import util.UserInfo;
	import util.manager.DisplayObjectMgr;

	public class RewardPopup extends DisplayObjectContainer
	{
		
		private var _atlas:TextureAtlas;
		
		private var _textField:TextField;
		
		private var _close:Button;
		
		private var _how:String;
		private var _reward:String;
		private var _amount:int;
		
		private const LEVEL_UP_REWARD:String = "코인";
		private const LEVEL_UP_AMOUNT:int = 500;
		
		private const ATTEND_REWARD:String = "코인";
		private const ATTEND_AMOUNT:int = 200;
		
		public function RewardPopup(atlas:TextureAtlas )
		{
			_atlas = atlas;
			initBackground();
			initTextField();
			initButton();
		}
		
		public function release():void
		{
			
		}
		
		public function checkLevelUp():Boolean
		{
			if(UserInfo.levelUpAmount > 0)
			{
				this.visible = true;
				setReward("레벨업", LEVEL_UP_REWARD, LEVEL_UP_AMOUNT * UserInfo.levelUpAmount);
				UserInfo.coin += LEVEL_UP_AMOUNT * UserInfo.levelUpAmount;
				
				UserDBMgr.instance.updateData(UserInfo.id, "coin", UserInfo.coin);
				UserInfo.levelUpAmount = 0;
				
				return true;
			}
			
			return false;
		}
		
		public function checkAttend():Boolean
		{
			
			var today:Date = new Date();
			today.setHours(0, 0, 0, 0);
			trace("today = " + today, today.getTime());
			trace("last = " + new Date(UserInfo.lastDate), UserInfo.lastDate);
			if(UserInfo.lastDate < today.getTime())
			{
				this.visible = true;
				setReward("출석", ATTEND_REWARD, ATTEND_AMOUNT);
				UserInfo.coin += ATTEND_AMOUNT;
				
				UserDBMgr.instance.updateData(UserInfo.id, "coin", UserInfo.coin);
				UserDBMgr.instance.updateData(UserInfo.id, "lastDate", new Date().getTime().toString());
				
				return true;
			}			
			
			return false;
		}
		
		public function setReward(how:String, reward:String, amount:int):void
		{
			_how = how;
			_reward = reward;
			_amount = amount;
			_textField.text = how + " 보상으로 " + reward + " " + amount + "개 획득";
		}
		
		private function initBackground():void			
		{
			var quad:Quad = new Quad(Main.stageWidth, Main.stageHeight, Color.BLACK);
			quad.alpha = 0.5;
			addChild(quad);
			
			var background:Image = new Image(_atlas.getTexture("popupBg"));
			background.width = Main.stageWidth * 0.8;
			background.height = Main.stageHeight * 0.4;
			background.x = Main.stageWidth * 0.5;
			background.y = Main.stageHeight * 0.5;				
			background.alignPivot("center","center");
			addChild(background);
		}
		
		private function initTextField():void
		{
			_textField = DisplayObjectMgr.instance.setTextField(Main.stageWidth * 0.5, Main.stageHeight * 0.5,
				Main.stageWidth * 0.8, Main.stageHeight * 0.2, "", "center", "center");			
			_textField.format.size = Main.stageWidth * 0.05;
			
			addChild(_textField);
		}
		
		private function initButton():void
		{
			_close = DisplayObjectMgr.instance.setButton(_close, _atlas.getTexture("close"), 
				Main.stageWidth * 0.825, Main.stageHeight * 0.35, Main.stageWidth * 0.1, Main.stageWidth * 0.1);
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