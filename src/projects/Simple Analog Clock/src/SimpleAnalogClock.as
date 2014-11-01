package 
{
	
	import com.crestron.components.base.*;
	import com.crestron.components.data.*;
	import com.crestron.components.enums.*;
	import com.crestron.components.joins.*;
	import com.crestron.components.interfaces.*;
	import flash.display.*;
	import flash.geom.*;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	 
	public class SimpleAnalogClock extends BaseObject
	{
		private static const millisecondsPerMinute:int = 60000;
        public static const millisecondsPerHour:int = 3600000;
        public static const millisecondsPerDay:int = 86400000;
		
		protected var _width:int;
		protected var _height:int;
		protected var _bgColor:uint;
		protected var _bgAlpha:Number;
		protected var _hourHandColor:uint;
		protected var _minuteHandColor:uint;
		protected var _secondHandColor:uint;
		protected var _displaySeconds:Boolean;
		
		public override function get width():Number 
		{
			return _width;	
		}
				
		public override function get height():Number 
		{
			return _height;			
		}		
		
		/**
		 * Initializes the control/application 
		 * 
		 * @param	propertyArr
		 * @param	systemServiceManager
		 */
		override public function initializeScript(propertyArr:Array, systemServiceManager:ISystemServiceManager):void 
		{
			_systemServiceManager = systemServiceManager;
					
			var localeObj:ILocaleObject = propertyArr["PositionAndSize"][0];
			_bgColor = propertyArr["BackgroundColor"];
			_bgAlpha = propertyArr["BackgroundAlpha"];
			_hourHandColor = propertyArr["HourHandColor"];
			_minuteHandColor = propertyArr["MinuteHandColor"];
			_secondHandColor = propertyArr["SecondHandColor"];
			_displaySeconds = (propertyArr["DisplaySeconds"] ? String(propertyArr["DisplaySeconds"]).toLowerCase() == "true" : false);
			_height = localeObj.h;
			_width = _height;
			
			var clock:SimpleClock = new SimpleClock();
			clock.initClock(_width,
							_bgColor,
							_bgAlpha,
							_hourHandColor,
							_minuteHandColor,
							_secondHandColor,
							_displaySeconds);
			
			addChild(clock);
		}
	}
}