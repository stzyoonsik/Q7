package scene.modeSelect.popup.reward
{
	import scene.Main;
	import scene.modeSelect.popup.Popup;
	
	import server.UserDBMgr;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	
	import util.UserInfo;
	import util.manager.DisplayObjectMgr;

	/**
	 * 출석이나 레벨업에 대한 보상을 띄워주는 클래스
	 * 
	 */
	public class RewardPopup extends Popup
	{		
		private var _atlas:TextureAtlas;
		
		private var _textField:TextField;
		
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
			initBackground(Main.stageWidth * 0.5, Main.stageHeight * 0.5, Main.stageWidth * 0.8, Main.stageHeight * 0.4);
			initTextField();
			initClose(Main.stageWidth * 0.825, Main.stageHeight * 0.35, Main.stageWidth * 0.1, Main.stageWidth * 0.1);
		}
		
		/**
		 * 메모리 해제 메소드 
		 * 
		 */
		public override function release():void
		{
			super.release();
			
			if(_textField) { _textField = null; } 
			
			removeChildren(0, this.numChildren - 1, true);
		}
		
		/**
		 * 레벨업을 했는지 검사하고 했다면  그만큼 보상을 주는 메소드
		 * @return 레벨업했으면 true 아니면 false
		 * 
		 */
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
		
		/**
		 * 하루를 기준으로 초기화되는 출석 메소드.  
		 * @return 
		 * 
		 */
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
		
		/**
		 * 보상의 기준과 보상 종류, 양을 정하는 메소드 
		 * @param how    어떤 것에 대한 보상인지
		 * @param reward 보상의 종류
		 * @param amount 보상의 양
		 * 
		 */
		public function setReward(how:String, reward:String, amount:int):void
		{
			_how = how;
			_reward = reward;
			_amount = amount;
			_textField.text = how + " 보상으로 " + reward + " " + amount + "개 획득";
		}
		
		/**
		 * 텍스트필드 조기화 메소드 
		 * 
		 */
		private function initTextField():void
		{
			_textField = DisplayObjectMgr.instance.setTextField(Main.stageWidth * 0.5, Main.stageHeight * 0.5,
				Main.stageWidth * 0.8, Main.stageHeight * 0.2, "", "center", "center");			
			_textField.format.size = Main.stageWidth * 0.05;
			
			addChild(_textField);
		}
		
	}
}