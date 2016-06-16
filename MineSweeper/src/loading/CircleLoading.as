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
	
	/**
	 * 원형 로딩 이미지+무비클립이 담긴 클래스 
	 * 
	 * 
	 */	
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
		
		/**
		 * 로딩 시작. 스탈링 저글러에 무비클립을 추가함. 
		 * 
		 */
		public function startLoading():void
		{
			Starling.juggler.add(_loading);
			this.visible = true;			
		}
		
		/**
		 * 로딩 끝. 스탈링 저글러에서 무비클립을 제거함. 
		 * 
		 */		
		public function stopLoading():void
		{
			Starling.juggler.remove(_loading);
			this.visible = false;
		}
		
		/**
		 * 메모리 해제 메소드 
		 * 
		 */
		public function release():void
		{
			if(_background) { _background.dispose(); _background = null; removeChild(_background); }
			if(_loading) { _loading.dispose(); _loading = null; removeChild(_loading);}
		}
		
		/**
		 * 화면 전체를 검게 덮는 이미지를 초기화 하는 메소드
		 * 
		 */
		private function initBackground():void
		{
			_background = new Quad(Main.stageWidth, Main.stageHeight, Color.BLACK);
			_background.alpha = 0.5;
			addChild(_background);
		}
		
		/**
		 * 원형으로 자전하는 로딩 이미지를 무비클립으로 돌리기 위해 초기화하는 메소드 
		 * 
		 */
		private function initMovieClip():void
		{
			_loading = new MovieClip(_atlas.getTextures("loading_"), 18);
			_loading.width = Main.stageWidth * 0.1;
			_loading.height = _loading.width;
			_loading.x = Main.stageWidth * 0.5;
			_loading.y = Main.stageHeight * 0.5;
			_loading.alignPivot("center", "center"); 
			
			addChild(_loading); 
		}
	}
}