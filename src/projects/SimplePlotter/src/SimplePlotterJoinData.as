package 
{
	/**
	 * ...
	 * @author Kim Jennis
	 */
	public class SimplePlotterJoinData 
	{
		private var _logJoin:int;
		private var _visible:int;
		private var _enable:int;
		
		public function SimplePlotterJoinData()
		{
			
		}
		
		public function get logJoin():int 
		{
			return _logJoin;
		}
		
		public function set logJoin(value:int):void 
		{
			_logJoin = value;
		}
		
		public function get visible():int 
		{
			return _visible;
		}
		
		public function set visible(value:int):void 
		{
			_visible = value;
		}
		
		public function get enable():int 
		{
			return _enable;
		}
		
		public function set enable(value:int):void 
		{
			_enable = value;
		}
	}

}