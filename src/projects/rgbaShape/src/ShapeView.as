package  
{
	import flash.display.*;
	/**
	 * ...
	 * @author Kim Jennis
	 */
	public class ShapeView extends Sprite
	{
		protected var _color:uint;
		protected var _alpha:Number;
		protected var _width:int;
		protected var _height:int;
		
		public function ShapeView(color:uint, alpha:Number, width:int, height:int) 
		{
			_color = color;
			_alpha = alpha;
			_width = width;
			_height = height;
			
			draw();
		}
		private function combineRGB(r:uint, g:uint, b:uint):uint 
		{
			return ( ( r << 16 ) | ( g << 8 ) | b );
		}
		
		public function draw():void
		{
			graphics.beginFill(_color, _alpha);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
		}
	}

}