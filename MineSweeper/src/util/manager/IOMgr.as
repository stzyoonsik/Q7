package util.manager
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	
	import scene.Main;
	
	import starling.display.Image;
	
	import util.type.DataType;

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
		
		
		private var _path:File = File.applicationStorageDirectory.resolvePath("data");
		//private var _path:File = File.documentsDirectory.resolvePath("data");
		
		public function saveData(difficulty:int, row:int = 0, col:int = 0, mineNum:int = 0, itemNum:int = 0, chance:int = 0, datas:Array = null, images:Array = null, items:Array = null, time:int = 0):void
		{
			var value:String = "";
			var imageName:String = "";
			var item:String = "";
			
			for(var y:int = 0; y<col; ++y)
			{
				for(var x:int = 0; x<row; ++x)
				{					
					if(y == 0 && x == 0)
					{
						value = value.concat(datas[y][x].toString());
						imageName = imageName.concat("\"" + images[y][x].name + "\"");
						item = item.concat(items[y][x].toString());
					}
					else
					{
						value = value.concat("," + datas[y][x].toString());
						imageName = imageName.concat(",\"" + images[y][x].name + "\"");
						item = item.concat("," + items[y][x].toString());
					}
				}
				
			}
			
			var data:String = "{\n\t\"difficulty\" : " + difficulty.toString() + ",\n"
								+ "\t\"row\" : " + row.toString() + ",\n"
								+ "\t\"col\" : " + col.toString() + ",\n"
								+ "\t\"mineNum\" : " + mineNum.toString() + ",\n"
								+ "\t\"itemNum\" : " + itemNum.toString() + ",\n"
								+ "\t\"chance\" : " + chance.toString() + ",\n"
								+ "\t\"data\" : [" + value + "],\n"
								+ "\t\"image\" : [" + imageName + "],\n"
								+ "\t\"item\" : [" + item + "],\n"
								+ "\t\"time\" : " + time.toString() + "\n}";
			
			var stream:FileStream = new FileStream();
			var file:File = new File(_path.resolvePath("lastGame.json").url);
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(data);
			stream.close();
		}
		
		public function loadData():Dictionary
		{
			var stream:FileStream = new FileStream();
			var file:File = new File(_path.resolvePath("lastGame.json").url);
			
			if(!file.exists)
				return null;
			
			stream.open(file, FileMode.READ);
			
			var str:String = stream.readUTFBytes(stream.bytesAvailable);
			trace(str);
			
			
			var data:Object = JSON.parse(str);
			var datas:Dictionary = new Dictionary();
			datas[DataType.DIFFICULTY] = data.difficulty;
			datas[DataType.ROW] = data.row;
			datas[DataType.COL] = data.col;
			datas[DataType.MINE_NUM] = data.mineNum;
			datas[DataType.ITEM_NUM] = data.itemNum;
			datas[DataType.CHANCE] = data.chance;
			datas[DataType.DATA] = data.data;
			datas[DataType.IMAGE] = data.image;
			datas[DataType.ITEM] = data.item;
			datas[DataType.TIME] = data.time;
			
			stream.close();
			
			return datas;
		}
		
		public function removeData():void
		{
			var file:File = new File(_path.resolvePath("lastGame.json").url);
			
			if(file.exists)
				file.deleteFile();
		}
		
		public function loadRecord():Object
		{
			var stream:FileStream = new FileStream();
			var file:File = new File(_path.resolvePath("record.json").url);
			
			if(!file.exists)
				return null;
			
			stream.open(file, FileMode.READ);
			
			var str:String = stream.readUTFBytes(stream.bytesAvailable);
			trace(str);
			
			
			var data:Object = JSON.parse(str);
			
			
			return data;
		}
		
		public function saveRecord(data:Object):void
		{
			var str:String = JSON.stringify(data);
			
			var stream:FileStream = new FileStream();
			var file:File = new File(_path.resolvePath("record.json").url);
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(str);
			stream.close();
		}
	}
}