package  
{
	import com.crestron.components.data.*;
	/**
	 * ...
	 * @author Kim Jennis
	 */
	public class CLSVData extends DragAndDropData
	{
		protected var _screenPosAndSizeArray:Array = new Array();
		
		public function CLSVData() 
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
		
	}

}