package loading
{
	import starling.display.Canvas;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	import scene.Main;

	public class Loading extends DisplayObjectContainer
	{
		[Embed(source="../background.png")]
		public static const Background:Class;
		
		private var _background:Image;
		private var _loadingBar:Quad;
		private var _loadingGauge:Quad;
		
		private var _maxCount:int;
		private var _currentCount:int;
		
		public function set maxCount(value:int):void { _maxCount = value; }
		
		
		public function Loading()
		{
			initBackground();
			initLoading();
		}
		
		public function refresh():void
		{			
			_loadingGauge.width = Number(++_currentCount / _maxCount) * Main.stageWidth * 0.8;
		}
		
		public function release():void
		{
			if(_background) { _background.dispose(); _background = null; removeChild(_background); }
			if(_loadingBar) { _loadingBar.dispose(); _loadingBar = null; removeChild(_loadingBar); }
			if(_loadingGauge) { _loadingGauge.dispose(); _loadingGauge = null; removeChild(_loadingGauge); }
		}
		
		

		private function initBackground():void
		{
			_background = new Image(Texture.fromEmbeddedAsset(Background));
			_background.width = Main.stageWidth;
			_background.height = Main.stageHeight;
			addChild(_background);
		}
		
		private function initLoading():void
		{
			_loadingBar = new Quad(Main.stageWidth * 0.8, Main.stageWidth * 0.025, Color.SILVER);
			_loadingBar.x = Main.stageWidth * 0.5;
			_loadingBar.y = Main.stageHeight * 0.5;
			_loadingBar.alignPivot("center", "center");
			addChild(_loadingBar);
			
			_loadingGauge = new Quad(1, Main.stageWidth * 0.025, Color.LIME);
			_loadingGauge.x = Main.stageWidth * 0.1;
			_loadingGauge.y = Main.stageHeight * 0.5;
			_loadingGauge.alignPivot("left", "center");
			addChild(_loadingGauge);
		}
	}
}