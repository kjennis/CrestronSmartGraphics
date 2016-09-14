package 
{
	/**
	 * ...
	 * @author Kim Jennis
	 */
	public class LogData 
	{
		private var _date:Date;
		private var _timeStamp:Number;
		private var _value:int;
		
		public function LogData(value:int) 
		{
			_value = value;
			_date = new Date();
		}
		
		public function get value():int 
		{
			return _value;
		}
		
		public function get date():Date 
		{
			return _date;
		}
		
		public function get timeStamp():Number
		{
			return _date.valueOf();
		}
	}
}