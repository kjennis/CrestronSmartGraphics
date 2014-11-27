package  
{
	/**
	 * ...
	 * @author Kim Jennis
	 */
	public class CLVSJoinsObject 
	{
		private var _controlJoin:int;
		private var _enableJoin:int;
		private var _visibilityJoin:int;
		
		private var _useIndirectPositioning:Boolean;
		private var _screenCount:int;
		private var _redrawScreenJoin:int;
		private var _sourceChangedStartJoin:int;
		private var _numberOfVisibleScreensJoin:int;
		private var _sourceSelectionStartJoin:int;
		private var _screenTopLocationStartJoin:int;
		private var _screenLeftLocationStartJoin:int;
		private var _screenWidthStartJoin:int;
		private var _screenHeightStartJoin:int;
		
		public function CLVSJoinsObject() 
		{
			_controlJoin = 0;
			_enableJoin = 0;
			_visibilityJoin = 0;
			
			_useIndirectPositioning = false;
			_screenCount = 0;
			
			_redrawScreenJoin = 0;
			_sourceChangedStartJoin = 0;
			_numberOfVisibleScreensJoin = 0;
			_sourceSelectionStartJoin = 0;
			_screenTopLocationStartJoin = 0;
			_screenLeftLocationStartJoin = 0;
			_screenWidthStartJoin = 0;
			_screenHeightStartJoin = 0;
		}
		
		public function get useIndirectPositioning():Boolean 
		{
			return _useIndirectPositioning;
		}
		
		public function set useIndirectPositioning(value:Boolean):void 
		{
			_useIndirectPositioning = value;
		}
		
		public function get redrawScreenJoin():int 
		{
			return _redrawScreenJoin;
		}
		
		public function set redrawScreenJoin(value:int):void 
		{
			_redrawScreenJoin = value;
		}
		
		public function get sourceChangedStartJoin():int 
		{
			return _sourceChangedStartJoin;
		}
		
		public function set sourceChangedStartJoin(value:int):void 
		{
			_sourceChangedStartJoin = value;
		}
		
		public function get numberOfVisibleScreensJoin():int 
		{
			return _numberOfVisibleScreensJoin;
		}
		
		public function set numberOfVisibleScreensJoin(value:int):void 
		{
			_numberOfVisibleScreensJoin = value;
		}
		
		public function get sourceSelectionStartJoin():int 
		{
			return _sourceSelectionStartJoin;
		}
		
		public function set sourceSelectionStartJoin(value:int):void 
		{
			_sourceSelectionStartJoin = value;
		}
		
		public function get screenTopLocationStartJoin():int 
		{
			return _screenTopLocationStartJoin;
		}
		
		public function set screenTopLocationStartJoin(value:int):void 
		{
			_screenTopLocationStartJoin = value;
		}
		
		public function get screenLeftLocationStartJoin():int 
		{
			return _screenLeftLocationStartJoin;
		}
		
		public function set screenLeftLocationStartJoin(value:int):void 
		{
			_screenLeftLocationStartJoin = value;
		}
		
		public function get screenWidthStartJoin():int 
		{
			return _screenWidthStartJoin;
		}
		
		public function set screenWidthStartJoin(value:int):void 
		{
			_screenWidthStartJoin = value;
		}
		
		public function get screenHeightStartJoin():int 
		{
			return _screenHeightStartJoin;
		}
		
		public function set screenHeightStartJoin(value:int):void 
		{
			_screenHeightStartJoin = value;
		}
		
		public function get controlJoin():int 
		{
			return _controlJoin;
		}
		
		public function set controlJoin(value:int):void 
		{
			_controlJoin = value;
		}
		
		public function get enableJoin():int 
		{
			return _enableJoin;
		}
		
		public function set enableJoin(value:int):void 
		{
			_enableJoin = value;
		}
		
		public function get visibilityJoin():int 
		{
			return _visibilityJoin;
		}
		
		public function set visibilityJoin(value:int):void 
		{
			_visibilityJoin = value;
		}
		
		public function get screenCount():int 
		{
			return _screenCount;
		}
		
		public function set screenCount(value:int):void 
		{
			_screenCount = value;
		}
		
	}

}