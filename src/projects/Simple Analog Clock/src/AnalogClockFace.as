package 
{
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.*;
    import flash.text.TextField;
    import flash.text.TextFormat;
	
    public class AnalogClockFace extends Sprite 
    {
		private var w:uint = 200;
		private var h:uint = 200;
		
        private var radius:uint;

        private var centerX:int;
        private var centerY:int;

        private var hourHand:Shape;
        private var minuteHand:Shape;
        private var secondHand:Shape;
		private var CenterShape:Shape;
        
        private var _bgColor:uint = new uint();
		private var _bgAlpha:Number = new Number();
        private var _hourHandColor:uint = new uint();
        private var _minuteHandColor:uint = new uint();
        private var _secondHandColor:uint = new uint();
		private var _displaySeconds:Boolean = new Boolean();

        private var currentTime:Date;

        public function AnalogClockFace(w:uint,
										bgColor:uint,
										bgAlpha:Number,
										hourHandColor:uint,
										minuteHandColor:uint,
										secondHandColor:uint,
										displaySeconds:Boolean) 
        {
			_bgColor = bgColor;
			_bgAlpha = bgAlpha
			_hourHandColor = hourHandColor;
			_minuteHandColor = minuteHandColor;
			_secondHandColor = secondHandColor;
			_displaySeconds = displaySeconds;
			this.w = w;
			this.h = w;
			
			this.radius = Math.round(this.w / 2);
			
			this.centerX = this.radius;
			this.centerY = this.radius;
        }
        
        public function init():void 
        {
        	drawBackground();
        	drawLabels();
        	createHands();
        }
        private function drawBackground():void
        {
        	//graphics.lineStyle(0.5, 0x999999);
        	graphics.beginFill(_bgColor,_bgAlpha);
        	graphics.drawCircle(centerX, centerY, radius);
        	graphics.endFill();
        }
		
		 
        public function drawLabels():void
        {
        	for (var i:Number = 1; i <= 12; i++)
        	{
        		var label:TextField = new TextField();
        		label.text = i.toString();
				label.selectable = false;
        		
        		var angleInRadians:Number = i * 30 * (Math.PI/180)

        		label.x = centerX + (0.9 * radius * Math.sin( angleInRadians )) - 5*w/200;
        		label.y = centerY - (0.9 * radius * Math.cos( angleInRadians )) - 9*w/200;
        		
        		var tf:TextFormat = new TextFormat();
        		tf.font = "Arial";
        		tf.bold = "true";
        		tf.size = 12*w/200;
        		label.setTextFormat(tf);
        		
	        	addChild(label);
        	}
        }
		
		
        private function createHands():void
        {
        	var hourHandShape:Shape = new Shape();
        	drawHand(hourHandShape, Math.round(radius * 0.7), _hourHandColor, w/50);
        	this.hourHand = Shape(addChild(hourHandShape));
        	this.hourHand.x = centerX;
        	this.hourHand.y = centerY;
        	
          	var minuteHandShape:Shape = new Shape();
        	drawHand(minuteHandShape, Math.round(radius * 0.9), _minuteHandColor, w/150);
        	this.minuteHand = Shape(addChild(minuteHandShape));
         	this.minuteHand.x = centerX;
        	this.minuteHand.y = centerY;
 
			if (_displaySeconds) 
			{
				var secondHandShape:Shape = new Shape();
				drawHand(secondHandShape, Math.round(radius * 0.95), _secondHandColor, w/300);
				this.secondHand = Shape(addChild(secondHandShape));
				this.secondHand.x = centerX;
				this.secondHand.y = centerY;
			}
			
			var center:Shape = new Shape();
			center.graphics.beginFill(_hourHandColor);
			center.graphics.drawCircle(0, 0, hourHand.width*0.75);
			center.graphics.endFill();
			this.CenterShape = Shape(addChild(center));
			this.CenterShape.x = centerX;
			this.CenterShape.y = centerY;
        }
        private function drawHand(hand:Shape, distance:uint, color:uint, thickness:Number):void
        {
			hand.graphics.beginFill(color);
			hand.graphics.drawRect(0-thickness/2, 0, thickness, distance);
			hand.graphics.endFill();
        }
        public function draw():void
        {
        	currentTime = new Date();
        	showTime(currentTime);
        }
        private function showTime(time:Date):void 
        {
	        if (_displaySeconds)var seconds:uint = time.getSeconds();
	        var minutes:uint = time.getMinutes();
	        var hours:uint = time.getHours();
	        
	        if(_displaySeconds)this.secondHand.rotation = 180 + (seconds * 6);
	        this.minuteHand.rotation = 180 + (minutes * 6);
	        this.hourHand.rotation = 180 + (hours * 30) + (minutes * 0.5);
		}
    }
}