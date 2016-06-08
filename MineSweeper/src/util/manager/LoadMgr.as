package util.manager
{
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import util.EmbeddedAssets;

	public class LoadMgr
	{
		//싱글톤
		private static var _instance:LoadMgr;
		private static var _isConstructing:Boolean;
		
		public function LoadMgr()
		{
			if (!_isConstructing) throw new Error("Singleton, use LoadMgr.instance()");
			
		}
		
		public static function get instance():LoadMgr 
		{
			if (_instance == null)  
			{
				_isConstructing = true;
				_instance = new LoadMgr();
				_isConstructing = false;
			}
			return _instance;
		}
		
		/**
		 * 스프라이트시트와 xml을 로드하는 메소드 
		 * 
		 */
		public function load(inTexture:Class, inXml:Class):TextureAtlas
		{			
			var texture:Texture = Texture.fromEmbeddedAsset(inTexture);
			var xml:XML = XML(new inXml());
			var atlas:TextureAtlas = new TextureAtlas(texture, xml);
						
			texture = null;
			xml = null;
			
			return atlas;
		}
	}
}