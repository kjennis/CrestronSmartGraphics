package  
{
	import com.crestron.components.data.*;
	/**
	 * ...
	 * @author Kim Jennis
	 */
	public class CLVSData extends DragAndDropData
	{
		protected var _screenPosAndSizeArray:Array = new Array();
		protected var _listLength:int;
		protected var _listThickness:int;
		
		public function CLVSData() 
		{
			
		}
		
		public function get screenPosAndSizeArray():Array 
		{
			return _screenPosAndSizeArray;
		}
		
		public function set screenPosAndSizeArray(value:Array):void 
		{
			_screenPosAndSizeArray = value;
		}
		
		public function get listLength():int 
		{
			return _listLength;
		}
		
		public function set listLength(value:int):void 
		{
			_listLength = value;
		}
		
		public function get listThickness():int 
		{
			return _listThickness;
		}
		
		public function set listThickness(value:int):void 
		{
			_listThickness = value;
		}
		
	}

}