package scene.modeSelect.popup.shop
{	
	import scene.Main;
	import scene.modeSelect.popup.Popup;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import util.manager.DisplayObjectMgr;
	
	/**
	 * 상점 버튼을 터치했을때 열리는 상점 클래스 
	 * 
	 */
	public class ShopPopup extends Popup
	{
		private var _atlas:TextureAtlas;
		
		private var _close:Button;
		
		private var _itemSpr:Sprite;
		
		
		public function ShopPopup(atlas:TextureAtlas)
		{
			_atlas = atlas;
			
			initBackground(Main.stageWidth * 0.5, Main.stageHeight * 0.5, Main.stageWidth * 0.8, Main.stageHeight * 0.8);
			initTextField();
			initSpr();
			initClose(Main.stageWidth * 0.8, Main.stageHeight * 0.175, Main.stageWidth * 0.1, Main.stageWidth * 0.1);
		}
		
		/**
		 * 메모리 해제 메소드 
		 * 
		 */
		public override function release():void
		{
			super.release();
			
			if(_itemSpr) { _itemSpr.dispose(); _itemSpr = null; }
			
			removeChildren(0, this.numChildren - 1, true);
		}
		
		/**
		 * 텍스트필드 조기화 메소드 
		 * 
		 */
		private function initTextField():void
		{
			var goods:TextField = DisplayObjectMgr.instance.setTextField(Main.stageWidth * 0.25, Main.stageHeight * 0.2,
								  Main.stageWidth * 0.3, Main.stageHeight * 0.1, "물품", "center", "center");
			goods.format.size = Main.stageWidth * 0.05;
			
			addChild(goods);
			
			
			var price:TextField = DisplayObjectMgr.instance.setTextField(Main.stageWidth * 0.5, Main.stageHeight * 0.2,
				Main.stageWidth * 0.3, Main.stageHeight * 0.1, "가격", "center", "center");
			price.format.size = Main.stageWidth * 0.05;
			addChild(price);
		}
		
		/**
		 * 상점에 아이템을 등록하는 메소드 
		 * 
		 */
		private function initSpr():void
		{
			_itemSpr = new Sprite();
			_itemSpr.x = Main.stageWidth * 0.5;
			_itemSpr.y = Main.stageHeight * 0.5;
			_itemSpr.width = Main.stageWidth * 0.8;
			_itemSpr.height = Main.stageHeight * 0.6;
			_itemSpr.alignPivot("center", "center");			

			
			var heartX1:ShopItem = addItem(0, _atlas.getTexture("heartX1"), _atlas.getTexture("coin"), 100, _atlas.getTexture("button"));
			heartX1.y = -Main.stageHeight * 0.2;
			heartX1.addEventListener("boughtHeart", onBoughtHeart);
			_itemSpr.addChild(heartX1);
			
			var heartX5:ShopItem = addItem(1, _atlas.getTexture("heartX5"), _atlas.getTexture("coin"), 450, _atlas.getTexture("button"));
			heartX5.y = -Main.stageHeight * 0.1;
			heartX5.addEventListener("boughtHeart", onBoughtHeart);
			_itemSpr.addChild(heartX5);
			
			var expBoost:ShopItem = addItem(2, _atlas.getTexture("expBoost"), _atlas.getTexture("coin"), 1000, _atlas.getTexture("button"));
			expBoost.y = Main.stageHeight * 0.0;
			expBoost.addEventListener("boughtExpBoost", onBoughtExpBoost);
			_itemSpr.addChild(expBoost);
			
			addChild(_itemSpr);
		}
		
		/**
		 *  
		 * @param num   아이템 번호
		 * @param goods 판매할 물품
		 * @param price 구매할 재화
		 * @param value 판매할 가격
		 * @param buy   구입 버튼
		 * @return  
		 * 
		 */
		private function addItem(num:int, goods:Texture, price:Texture, value:int, buy:Texture):ShopItem
		{
			return new ShopItem(num, goods, price, value, buy);
		}
		
		/**
		 * 하트 구입을 터치했을때 호출되는 콜백메소드 
		 * @param event
		 * 
		 */
		private function onBoughtHeart(event:Event):void
		{
			dispatchEvent(new Event("boughtHeart"));
		}
		
		/**
		 * 경험치 부스트 구입을 터치했을떄 호출되는 콜백메소드 
		 * @param event
		 * 
		 */
		private function onBoughtExpBoost(event:Event):void
		{
			dispatchEvent(new Event("boughtExpBoost"));
		}
	}
}