/**********************************************************************************
 *
 *	Title: SimplePlotterController
 *
 **********************************************************************************/

/**********************************************************************************
 *
 *	About: Copyright (c) Crestron Electronics, Inc.  All rights reserved.
 *
 *	Use of this source code is subject to the terms of the Crestron Software
 *	License Agreement under which you licensed this source code.
 *	If you did not accept the terms of the license agreement,
 *	you are not authorized to use this source code. For the terms of the license,
 *	please see the license agreement between you and Crestron at http://www.crestron.com/sla.
 *	This source code may be used only for the purpose of developing software for
 *	Crestron Devices and may not be used for any other purpose.  You may not sublicense, publish, or
 *	distribute this source code in any way.
 *	THE SOURCE CODE IS PROVIDED "AS IS", WITH NO WARRANTIES OR INDEMNITIES.
 *
 **********************************************************************************/

package
{
	import com.crestron.components.interfaces.*;
	import com.crestron.components.joins.JoinTypes;

	public class SimplePlotterController implements IJoinObject
	{
		private var _prevValue:int = 0; //Workaround to prevent SIMPL update from writing 0 to view.
		private var _systemServiceManager:ISystemServiceManager;
		private var _view:SimplePlotterView;
		private var _joinData:SimplePlotterJoinData;

		public function SimplePlotterController(systemServiceManager:ISystemServiceManager, view:SimplePlotterView, joinData:SimplePlotterJoinData)
		{
			_systemServiceManager = systemServiceManager;
			_view = view;
			_joinData = joinData;

			subsribeJoins();
		}
		
		private function subsribeJoins():void
		{
			//For Smart Objects
			//_systemServiceManager.joinService.controlJoin = _joinData.control;
			_systemServiceManager.joinService.publishJoin(JoinTypes.ANALOG, _joinData.logJoin, this);
		}		

		public function joinIn(joinType:String, joinNumber:int, joinValue:Object):void 
		{
			switch (joinType)
			{
				case JoinTypes.DIGITAL:
					if (joinNumber == _joinData.visible)
					{
						_view.visible = int(joinValue) == 1;
					}
					if (joinNumber == _joinData.enable)
					{
						_view.enable = int(joinValue) == 1;
					}
					break;
				case JoinTypes.ANALOG:
					if (joinNumber == _joinData.logJoin)
					{
						if (_prevValue != 0)
						{
							_view.logValue(int(joinValue));
						}
						_prevValue = int(joinValue);
					}
					break;
				case JoinTypes.SERIAL:
					break;
			}
		}

		public function joinOut(joinType:String, joinNumber:int, joinValue:Object):void 
		{
			
		}

		public function destroy():void
		{
			
		}
	}
}