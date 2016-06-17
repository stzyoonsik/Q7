package util.manager
{
	import starling.display.Button;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class DisplayObjectMgr
	{
		//싱글톤
		private static var _instance:DisplayObjectMgr;
		private static var _isConstructing:Boolean;
		
		public function DisplayObjectMgr()
		{
			if (!_isConstructing) throw new Error("Singleton, use ButtonMgr.instance()");
			
		}
		
		public static function get instance():DisplayObjectMgr 
		{
			if (_instance == null)  
			{
				_isConstructing = true;
				_instance = new DisplayObjectMgr();
				_isConstructing = false;
			}
			return _instance;
		}	
		
		public function setButton(button:Button, texture:Texture, x:Number, y:Number, width:Number, height:Number, text:String = "", textSize:int = 20):Button
		{
			button = new Button(texture, text);
			button.textFormat.size = textSize;			
			button.width = width;
			button.height = height;
			button.x = x;
			button.y = y;
			button.alignPivot("center", "center");
			
			return button;
		}
		
		public function setImage(texture:Texture, x:Number, y:Number, width:Number, height:Number, horiAlign:String = "left", vertiAlign:String = "top"):Image
		{
			var image:Image = new Image(texture);
			image.x = x;
			image.y = y;
			image.width = width;
			image.height = height;
			image.alignPivot(horiAlign, vertiAlign);
			return image;
		}
		
		public function setTextField(x:Number, y:Number, width:Number, height:Number, text:String = null, horiAlign:String = "left", vertiAlign:String = "top", border:Boolean = false):TextField
		{
			var textField:TextField = new TextField(width, height, text);
			textField.x = x;
			textField.y = y;
			textField.alignPivot(horiAlign, vertiAlign);
			textField.border = border;
			return textField;
		}
	}
}