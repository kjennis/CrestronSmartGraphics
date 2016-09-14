/**********************************************************************************
 *
 *	Title: SimplePlotterView
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
	import flash.display.*;
	import flash.text.*;

	public class SimplePlotterView extends Sprite
	{
		private var _enabled:Boolean = true;
		private var _width:Number;
		private var _height:Number;
		private var _systemServiceManager:ISystemServiceManager;
		private var _data:SimplePlotterData;
		private var _dataVector:Vector.<LogData>;
		
		private var _graphBG:Shape;
		private var _graph:Shape;
		private var _timeField:TextField;
		private var _maxField:TextField;
		private var _minField:TextField;
		

		public function SimplePlotterView(width:int, height:int, systemServiceManager:ISystemServiceManager, data:SimplePlotterData)
		{
			_width = width;
			_height = height;
			_systemServiceManager = systemServiceManager;
			_data = data;

			calcSizes();
			createItems();
			positionItems();
			
			_dataVector = new Vector.<LogData>();
		}
		
		public function logValue(value:int):void
		{
			var logData:LogData = new LogData(value);
			
			_dataVector.push(logData);
			
			if (_dataVector.length > 2)
			{
				redrawGraph();
			}
		}

		private function calcSizes():void
		{
			//Calculate object sizes here.	
		}

		private function createItems():void
		{
			drawGraphBG();
			_graph = new Shape();
			addChild(_graph);
			drawTextFields();
		}
		
		private function drawTextFields():void 
		{
			_timeField = new TextField(); 
			_timeField.width = 150;
			_timeField.height = 20;
			_timeField.x = _width - 150;
			_timeField.y = _height - 20;
			
			_maxField = new TextField();
			_maxField.width = 100;
			_maxField.height = 20;
			_maxField.x = 0;
			_maxField.y = 20;
			
			_minField = new TextField();
			_minField.width = 100;
			_minField.height = 20;
			_minField.x = 0;
			_minField.y = _height - 20;
			
			addChild(_timeField);
			addChild(_maxField);
			addChild(_minField);
		}
		
		private function drawGraphBG():void 
		{
			_graphBG = new Shape();
			_graphBG.graphics.beginFill(0xFF0000);
			_graphBG.graphics.drawRect(0, 0, 1, _height);
			_graphBG.graphics.drawRect(0,_height - 1, _width, 1)
			_graphBG.graphics.endFill();
		}
		
		private function redrawGraph():void
		{
			var firstTimeStamp:Number = _dataVector[0].timeStamp;
			var lastTimeStamp:Number = _dataVector[_dataVector.length - 1].timeStamp;
			var totalTimeLogged:Number = lastTimeStamp - firstTimeStamp;
			if (totalTimeLogged == 0)
			{
				totalTimeLogged = 1;
			}
			updateTimeLogged(totalTimeLogged);

			var minValue:Number = 65535
			var maxValue:Number = 0;
			var scale:Number = 10;
			
			for each (var item:LogData in _dataVector) 
			{
				if(item.value < minValue)
				{
					minValue = item.value;
				}
				if (item.value > maxValue)
				{
					maxValue = item.value;
				}
			}
			
			if (maxValue - minValue < 10)
			{
				minValue = maxValue -10;
			}
			
			scale = maxValue - minValue;
			
			updateScale(minValue, maxValue);
			
			_graph.graphics.clear();
			_graph.graphics.lineStyle(2, 0xFF0000);
			
			for (var i:int = 0; i < _dataVector.length; i++) 
			{
				var pointY:Number =  _height - _height / scale * (_dataVector[i].value - minValue);
				var pointX:Number = _width / totalTimeLogged * (_dataVector[i].timeStamp - firstTimeStamp);
				
				if (i == 0)
				{
					_graph.graphics.moveTo(0, pointY);
				}
				else
				{
					_graph.graphics.lineTo(pointX, pointY);
				}
			}
		}
		
		private function updateTimeLogged(totalTimeLogged:Number):void 
		{
			if (totalTimeLogged > 3600000)
			{
				_timeField.text = Number(totalTimeLogged / 3600000).toString() + " H";
			}
			else if (totalTimeLogged > 60000)
			{
				_timeField.text = Number(totalTimeLogged / 60000).toString() + " M";
			}
			else
			{
				_timeField.text = Number(totalTimeLogged / 1000).toString() + " S";
			}
		}
		
		private function updateScale(minValue:Number, maxValue:Number):void
		{
			_minField.text = minValue.toString();
			_maxField.text = maxValue.toString();
		}
		
		private function positionItems():void
		{
			//position children here.
			addChild(_graphBG);
		}

		public function resize(width:int, height:int):void
		{
			_width = width;
			_height = height;
		
			calcSizes();
			positionItems();
		}

		override public function get width():Number
		{
			return _width;
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		public function set enable(value:Boolean):void
		{
			_enabled = value;
			alpha = _enabled ? 1.0 : 0.4;
			//_enabled ? addListeners() : removeListeners();
		}
	}
}