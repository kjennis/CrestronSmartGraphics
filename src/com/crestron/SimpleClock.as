package  {
	import flash.display.Sprite;
	import com.crestron.components.enums.EnvironmentMode;

	public class SimpleClock extends Sprite 
	{
		import flash.events.TimerEvent;
		import flash.utils.Timer;
		
		public var face:AnalogClockFace;
		
		public var ticker:Timer;
		
		public static const millisecondsPerMinute:int = 60000;
        public static const millisecondsPerHour:int = 3600000;
        public static const millisecondsPerDay:int = 86400000;

		public function initClock(faceSize:Number = 200,
							bgColor:uint = 0xEEFFFF,
							bgAlpha:Number = 0.5,
							hourHandColor:uint = 0x000000,
							minuteHandColor:uint = 0x000000,
							secondHandColor:uint = 0x000000,
							displaySeconds:Boolean = false):void 
		{
			face = new AnalogClockFace(faceSize,
										bgColor, 
										bgAlpha,
										hourHandColor,
										minuteHandColor,
										secondHandColor,
										displaySeconds);
			face.init();
			addChild(face);

			face.draw();

        	ticker = new Timer(1000); 
            ticker.addEventListener(TimerEvent.TIMER, onTick);
            ticker.start();
        }
        public function onTick(evt:TimerEvent):void 
        {
			//if (!EnvironmentMode.DESIGN)
			face.draw();
        }		
	}
}