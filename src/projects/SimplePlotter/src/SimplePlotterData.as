package 
{
	/**
	 * ...
	 * @author Kim Jennis
	 */
	public class SimplePlotterData 
	{
		private var _lineColor:uint = 0x0000FF;
		private var _graphColor:uint = 0xFF0000;
		
		public function SimplePlotterData()
		{
			
		}
		
		public function get lineColor():uint 
		{
			return _lineColor;
		}
		
		public function set lineColor(value:uint):void 
		{
			_lineColor = value;
		}
		
		public function get graphColor():uint 
		{
			return _graphColor;
		}
		
		public function set graphColor(value:uint):void 
		{
			_graphColor = value;
		}
		
	}

}