package scene.modeSelect.popup.shop
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
	
	public class ShopPopup extends DisplayObjectContainer
	{
		private var _atlas:TextureAtlas;
		
		private var _close:Button;
		
		private var _itemSpr:Sprite;
		
		
		public function ShopPopup(atlas:TextureAtlas)
		{
			_atlas = atlas;
			
			initBackground();
			initTextField();
			initSpr();
			initButton();
		}
		
		public function release():void
		{
			if(_close) { _close.removeEventListener(TouchEvent.TOUCH, onTouchClose); _close.dispose(); _close = null; }
			if(_itemSpr) { _itemSpr.dispose(); _itemSpr = null; }
			
			removeChildren(0, this.numChildren - 1, true);
		}
		
		private function initBackground():void
		{			
			var quad:Quad = new Quad(Main.stageWidth, Main.stageHeight, Color.BLACK);
			quad.alpha = 0.5;
			addChild(quad);
			
			var background:Image = DisplayObjectMgr.instance.setImage(_atlas.getTexture("popupBg"), Main.stageWidth * 0.5, Main.stageHeight * 0.5,
				Main.stageWidth * 0.8, Main.stageHeight * 0.8, "center", "center");
			
			addChild(background);
		}
		
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
		
		private function initButton():void
		{
			_close = DisplayObjectMgr.instance.setButton(_close, _atlas.getTexture("close"), 
				Main.stageWidth * 0.8, Main.stageHeight * 0.175, Main.stageWidth * 0.1, Main.stageWidth * 0.1);
			_close.addEventListener(TouchEvent.TOUCH, onTouchClose);
			addChild(_close);
		}
		
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
		
		private function addItem(num:int, goods:Texture, price:Texture, value:int, buy:Texture):ShopItem
		{
			return new ShopItem(num, goods, price, value, buy);
		}
		 
		private function onTouchClose(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_close, TouchPhase.ENDED);
			if(touch)
			{
				this.visible = false;
			}
		}
		
		private function onBoughtHeart(event:Event):void
		{
			dispatchEvent(new Event("boughtItem"));
		}
		
		private function onBoughtExpBoost(event:Event):void
		{
			dispatchEvent(new Event("boughtExpBoost"));
		}
	}
}