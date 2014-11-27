package  
{
	/**
	 * ...
	 * @author Kim Jennis
	 */
	public class PosAndSizeData 
	{
		private var _width:Number;
		private var _height:Number;
		private var _top:Number;
		private var _left:Number;
		
		public function PosAndSizeData() 
		{
			
		}
		
		public function get width():Number 
		{
			return _width;
		}
		
		public function set width(value:Number):void 
		{
			_width = value;
		}
		
		public function get height():Number 
		{
			return _height;
		}
		
		public function set height(value:Number):void 
		{
			_height = value;
		}
		
		public function get top():Number 
		{
			return _top;
		}
		
		public function set top(value:Number):void 
		{
			_top = value;
		}
		
		public function get left():Number 
		{
			return _left;
		}
		
		public function set left(value:Number):void 
		{
			_left = value;
		}
		
	}

}