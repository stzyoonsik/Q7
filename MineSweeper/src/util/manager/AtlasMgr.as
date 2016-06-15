package util.manager
{
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class AtlasMgr
	{
		private var _atlases:Dictionary;
		
		//싱글톤
		private static var _instance:AtlasMgr;
		private static var _isConstructing:Boolean;
		
		public function AtlasMgr()
		{
			if (!_isConstructing) throw new Error("Singleton, use AtlasMgr.instance()");
			
			_atlases = new Dictionary();
		}
		
		public static function get instance():AtlasMgr 
		{
			if (_instance == null)  
			{
				_isConstructing = true;
				_instance = new AtlasMgr();
				_isConstructing = false;
			}
			return _instance;
		}	
		
		public function addAtlas(name:String, texture:Texture, xml:XML):void
		{
			_atlases[name] = new TextureAtlas(texture, xml);
		}
		
		public function removeAtlas(name):void
		{
			_atlases[name] = null;
			delete _atlases[name];
		}
		
		public function getAtlas(name:String):TextureAtlas
		{
			return _atlases[name];
		}
	}
}