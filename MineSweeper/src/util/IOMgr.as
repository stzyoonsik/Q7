package util
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import starling.display.Image;

	public class IOMgr
	{
		//싱글톤
		private static var _instance:IOMgr;
		private static var _isConstructing:Boolean;
		
		public function IOMgr()
		{
			if (!_isConstructing) throw new Error("Singleton, use IOMgr.instance()");
		}
		
		public static function get instance():IOMgr 
		{
			if (_instance == null)  
			{
				_isConstructing = true;
				_instance = new IOMgr();
				_isConstructing = false;
			}
			return _instance;
		}		
		
		
		//private var _path:File = File.applicationStorageDirectory.resolvePath("data");
		private var _path:File = File.documentsDirectory.resolvePath("data");
		
		public function save(row:int, col:int, mineNum:int, itemNum:int, chance:int, datas:Array, images:Array, time:int):void
		{
			var value:String = "";
			var imageName:String = "";
			
			for(var i:int = 0; i<row; ++i)
			{
				for(var j:int = 0; j<col; ++j)
				{
					trace(i, j);
					if(i == 0 && j == 0)
					{
						value = value.concat(datas[i][j].toString());
						imageName = imageName.concat("\"" + images[i][j].name + "\"");
					}
					else
					{
						value = value.concat("," + datas[i][j].toString());
						imageName = imageName.concat(",\"" + images[i][j].name + "\"");
					}
				}
				
			}
			
			var data:String = "{\n\t\"row\" : " + row.toString() + ",\n"
								+ "\t\"col\" : " + col.toString() + ",\n"
								+ "\t\"mineNum\" : " + mineNum.toString() + ",\n"
								+ "\t\"itemNum\" : " + itemNum.toString() + ",\n"
								+ "\t\"chance\" : " + chance.toString() + ",\n"
								+ "\t\"data\" : [" + value + "],\n"
								+ "\t\"image\" : [" + imageName + "],\n"
								+ "\t\"time\" : " + time.toString() + "\n}";
			
			var stream:FileStream = new FileStream();
			var file:File = new File(_path.resolvePath("lastGame.json").url);
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(data);
			stream.close();
			
			data = null;
			stream = null;
			file = null;
		}
		
		public function load():Vector.<Object>
		{
			var stream:FileStream = new FileStream();
			var file:File = new File(_path.resolvePath("lastGame.json").url);
			stream.open(file, FileMode.READ);
			
			var str:String = stream.readUTFBytes(stream.bytesAvailable);
			trace(str);
			
			
			var data:Object = JSON.parse(str);
			var datas:Vector.<Object> = new Vector.<Object>();
			datas.push(data.row - 2);
			datas.push(data.col - 2);
			datas.push(data.mineNum);
			datas.push(data.itemNum);
			datas.push(data.chance);
			datas.push(data.data);
			datas.push(data.image);
			datas.push(data.time);
			
			stream.close();
			
			stream = null;
			file = null;
			
			return datas;
		}
	}
}