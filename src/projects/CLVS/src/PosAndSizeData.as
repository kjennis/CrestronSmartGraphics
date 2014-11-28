package  
{
	import flash.net.*;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Kim Jennis
	 */
	public class PosAndSizeData 
	{
		private var _width:int;
		private var _height:int;
		private var _top:int;
		private var _left:int;
		
		public function PosAndSizeData() 
		{
			
		}
		
		public function clone():PosAndSizeData
		{
			registerClassAlias("PosAndSizeData", PosAndSizeData);
			
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(this);
			bytes.position = 0;
			
			return bytes.readObject() as PosAndSizeData;
		}
		
		public function get width():int 
		{
			return _width;
		}
		
		public function set width(value:int):void 
		{
			_width = value;
		}
		
		public function get height():int 
		{
			return _height;
		}
		
		public function set height(value:int):void 
		{
			_height = value;
		}
		
		public function get top():int 
		{
			return _top;
		}
		
		public function set top(value:int):void 
		{
			_top = value;
		}
		
		public function get left():int 
		{
			return _left;
		}
		
		public function set left(value:int):void 
		{
			_left = value;
		}
		
	}

}