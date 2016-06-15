package loading
{
	import scene.Main;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	
	import util.manager.AtlasMgr;

	public class CircleLoading extends DisplayObjectContainer
	{
		private var _atlas:TextureAtlas;
		private var _background:Quad;
		private var _loading:MovieClip;
		
		public function CircleLoading()
		{
			_atlas = AtlasMgr.instance.getAtlas("ModeSprite");
			
			initBackground();
			initMovieClip();
			
			this.visible = false;
		}
		
		public function release():void
		{
			if(_background) { _background.dispose(); _background = null; removeChild(_background); }
			if(_loading) { Starling.juggler.remove(_loading); _loading.dispose(); _loading = null; removeChild(_loading);}
		}
		
		private function initBackground():void
		{
			_background = new Quad(Main.stageWidth, Main.stageHeight, Color.BLACK);
			_background.alpha = 0.5;
			addChild(_background);
		}
		
		private function initMovieClip():void
		{
			_loading = new MovieClip(_atlas.getTextures("loading_"), 18);
			_loading.x = Main.stageWidth * 0.5;
			_loading.y = Main.stageHeight * 0.5;
			_loading.alignPivot("center", "center"); 
			Starling.juggler.add(_loading);
			addChild(_loading); 
		}
	}
}