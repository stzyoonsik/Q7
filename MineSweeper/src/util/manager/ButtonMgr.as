package util.manager
{
	import starling.display.Button;
	import starling.textures.Texture;

	public class ButtonMgr
	{
		//싱글톤
		private static var _instance:ButtonMgr;
		private static var _isConstructing:Boolean;
		
		public function ButtonMgr()
		{
			if (!_isConstructing) throw new Error("Singleton, use ButtonMgr.instance()");
			
		}
		
		public static function get instance():ButtonMgr 
		{
			if (_instance == null)  
			{
				_isConstructing = true;
				_instance = new ButtonMgr();
				_isConstructing = false;
			}
			return _instance;
		}	
		
		public function setButton(button:Button, x:int, y:int, width:int, height:int, text:String, textSize:int, color:uint):Button
		{
			var texture:Texture = Texture.fromColor(width, height, color);
			button = new Button(texture, text);
			button.textFormat.size = textSize;
			button.alignPivot("center", "center");
			button.x = x;
			button.y = y;
			
			return button;
		}
	}
}