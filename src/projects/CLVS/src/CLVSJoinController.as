package  
{
	import com.crestron.components.controllers.*;
	import com.crestron.components.enums.EnvironmentMode;
	import com.crestron.components.interfaces.*;
	import com.crestron.components.interfaces.views.*;
	import com.crestron.components.joins.JoinTypes;
	/**
	 * ...
	 * @author Kim Jennis
	 */
	public class CLVSJoinController extends DragAndDropJoinController implements IJoinObject
	{
		protected var _systemServiceManager:ISystemServiceManager;
		
		protected var _useIndirectPositioning:Boolean;
		protected var _screenCount:int;
		protected var _redrawScreenJoin:int;
		protected var _sourceChangedStartJoin:int;
		protected var _numberOfVisibleScreensJoin:int;
		protected var _sourceSelectionStartJoin:int;
		protected var _screenTopLocationStartJoin:int;
		protected var _screenLeftLocationStartJoin:int;
		protected var _screenWidthStartJoin:int;
		protected var _screenHeightStartJoin:int;
		
		public function CLVSJoinController(systemServiceManager:ISystemServiceManager, dragAndDropView:IDragAndDropView, clvsJoinsObject:CLVSJoinsObject, screenJoinArray:Array, screenDigitalArray:Array = null) 
		{
			_systemServiceManager = systemServiceManager;
			
			var controlJoin:int				= clvsJoinsObject.controlJoin;
			var digitalEnableJoin:int		= clvsJoinsObject.enableJoin;
			var digitalVisibilityJoin:int	= clvsJoinsObject.visibilityJoin;
			
			var analogScreenNumberJoin:int = clvsJoinsObject.numberOfVisibleScreensJoin;
			super(systemServiceManager, dragAndDropView, controlJoin, analogScreenNumberJoin, screenJoinArray, screenDigitalArray, digitalEnableJoin, digitalVisibilityJoin);
			
			_useIndirectPositioning			= clvsJoinsObject.useIndirectPositioning;
			_screenCount 					= clvsJoinsObject.screenCount;
			_redrawScreenJoin				= clvsJoinsObject.redrawScreenJoin;
			_numberOfVisibleScreensJoin		= clvsJoinsObject.numberOfVisibleScreensJoin;
			_sourceSelectionStartJoin		= clvsJoinsObject.sourceSelectionStartJoin;
			_screenTopLocationStartJoin		= clvsJoinsObject.screenTopLocationStartJoin;
			_screenLeftLocationStartJoin	= clvsJoinsObject.screenLeftLocationStartJoin;
			_screenWidthStartJoin			= clvsJoinsObject.screenWidthStartJoin;
			_screenHeightStartJoin			= clvsJoinsObject.screenHeightStartJoin;
			
			subscribeJoins();
		}
		
		protected function subscribeJoins():void 
		{
			_joinService.publishJoin(JoinTypes.DIGITAL, _redrawScreenJoin, this);
			
			if (_useIndirectPositioning)
			{
				for (var i:int = 0; i < _screenCount; i++) 
				{
					_joinService.publishJoin(JoinTypes.ANALOG, _screenTopLocationStartJoin + i, this);
					_joinService.publishJoin(JoinTypes.ANALOG, _screenLeftLocationStartJoin + i, this);
					_joinService.publishJoin(JoinTypes.ANALOG, _screenWidthStartJoin + i, this);
					_joinService.publishJoin(JoinTypes.ANALOG, _screenHeightStartJoin + i, this);
				}
			}
		}
		
		override public function joinIn(joinType:String, joinNumber:int, joinValue:Object):void
		{
			if (!_systemServiceManager.systemEventService.environmentData.environmentMode == EnvironmentMode.LIVE) 
			{
				return;
			}
			
			if (joinType == JoinTypes.DIGITAL && joinNumber == _redrawScreenJoin && int(joinValue) == 1)
			{
				//TODO: Use the incomming analog join for set number of screens instead of design time static.
				(_dragAndDropView as ICLVSView).redrawScreens(_screenCount);
			}
			
			if (joinType == JoinTypes.ANALOG)
			{
				//TODO: Make sure we awknowledge invisible screens.
				if (inRange(_screenTopLocationStartJoin, joinNumber, _screenTopLocationStartJoin + _screenCount))
				{
					(_dragAndDropView as ICLVSView).newScreenTopPosition(joinNumber - _screenTopLocationStartJoin, int(joinValue));
				}
				else if (inRange(_screenLeftLocationStartJoin, joinNumber, _screenLeftLocationStartJoin + _screenCount))
				{
					(_dragAndDropView as ICLVSView).newScreenLeftPosition(joinNumber - _screenLeftLocationStartJoin, int(joinValue));
				}
				else if (inRange(_screenWidthStartJoin, joinNumber, _screenWidthStartJoin + _screenCount))
				{
					(_dragAndDropView as ICLVSView).newScreenWidth(joinNumber - _screenWidthStartJoin, int(joinValue));
				}
				else if (inRange(_screenHeightStartJoin, joinNumber, _screenHeightStartJoin + _screenCount))
				{
					(_dragAndDropView as ICLVSView).newScreenHeight(joinNumber - _screenHeightStartJoin, int(joinValue));
				}
			}
			
			super.joinIn(joinType, joinNumber, joinValue);
		}
		
		private function inRange(minBound:int, value:int, maxBound:int):Boolean
		{
			return minBound <= value && value <= maxBound;
		}
		
	}

}