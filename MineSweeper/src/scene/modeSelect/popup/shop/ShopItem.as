package scene.modeSelect.popup.shop
{	
	import scene.Main;
	
	import server.UserDBMgr;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	import util.UserInfo;
	import util.manager.SoundMgr;

	public class ShopItem extends Sprite
	{		
		private var _goods:Image;
		private var _price:Image;
		private var _value:TextField;
		private var _buy:Button;
		
		private var _num:int;
		
		private const HEART_PRICE:int = 100;
		private const HEART_X5_PRICE:int = 450;
		private const EXP_BOOST_PRICE:int = 1000;
		private const EXP_BOOST_TERM:Number = 3600000;				//밀리세컨드
		
		public function ShopItem(num:int, goods:Texture, price:Texture, value:int , buy:Texture)
		{
			this.width = Main.stageWidth;
			this.height = Main.stageHeight;
			
			_num = num;
			
			setGoods(goods);
			setPrice(price);
			setValue(value);
			setBuy(buy);
		}
		
		private function setGoods(texture:Texture):void
		{
			_goods = new Image(texture);
			_goods.x = -Main.stageWidth * 0.325;
			_goods.width = Main.stageWidth * 0.05;
			_goods.height = _goods.width;
			addChild(_goods);
		}
		
		private function setPrice(texture:Texture):void
		{
			_price = new Image(texture);
			_price.x = -Main.stageWidth * 0.05;
			_price.width = Main.stageWidth * 0.05;
			_price.height = _price.width;
			addChild(_price);
		}
		
		private function setValue(value:int):void
		{
			_value = new TextField(Main.stageWidth * 0.2, Main.stageHeight * 0.1, value.toString());
			_value.format.size = Main.stageWidth * 0.05;
			_value.y = -Main.stageHeight * 0.035;
			addChild(_value);
		}
		
		private function setBuy(texture:Texture):void
		{
			_buy = new Button(texture, "구입");
			_buy.textFormat.size = Main.stageWidth * 0.025;
			_buy.x = Main.stageWidth * 0.25;
			_buy.width = Main.stageWidth * 0.1;
			_buy.height = Main.stageHeight * 0.0375;
			_buy.addEventListener(TouchEvent.TOUCH, onTouchBuy);
			addChild(_buy);
		}
		
		private function onTouchBuy(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_buy, TouchPhase.ENDED);
			if(touch)
			{
				switch(_num)
				{
					case 0:						
						if(UserInfo.coin >= HEART_PRICE && UserInfo.heart < UserInfo.MAX_HEART)
						{
							SoundMgr.instance.play("buyItem.mp3");
							UserInfo.heart += 1;
							UserInfo.coin -= HEART_PRICE;
							UserDBMgr.instance.updateData(UserInfo.id, "heart", UserInfo.heart);
							UserDBMgr.instance.updateData(UserInfo.id, "coin", UserInfo.coin);
							dispatchEvent(new Event("boughtHeart"));
						}
						
						break;
					case 1:
						if(UserInfo.coin >= HEART_X5_PRICE && UserInfo.heart < UserInfo.MAX_HEART)
						{
							SoundMgr.instance.play("buyItem.mp3");
							UserInfo.heart += 5;
							UserInfo.coin -= HEART_X5_PRICE;
							UserDBMgr.instance.updateData(UserInfo.id, "heart", UserInfo.heart);
							UserDBMgr.instance.updateData(UserInfo.id, "coin", UserInfo.coin);
							dispatchEvent(new Event("boughtHeart"));
						}
						
						break;
					case 2:
						if(UserInfo.coin >= EXP_BOOST_PRICE)
						{
							SoundMgr.instance.play("buyItem.mp3");
							UserInfo.coin -= EXP_BOOST_PRICE;
							UserDBMgr.instance.updateData(UserInfo.id, "coin", UserInfo.coin);
							UserInfo.expRatio = 2;
							UserDBMgr.instance.updateData(UserInfo.id, "expRatio", UserInfo.expRatio);
							UserDBMgr.instance.updateData(UserInfo.id, "itemOverTime", new Date().getTime() + EXP_BOOST_TERM);
							dispatchEvent(new Event("boughtExpBoost"));
						}
					default:
						break;
				}
				
				
			}
		}
	}
}