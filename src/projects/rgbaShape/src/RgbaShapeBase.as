package  
{
	import com.crestron.components.base.*;
	import com.crestron.components.interfaces.*;
	/**
	 * ...
	 * @author Kim Jennis
	 */
	public class RgbaShapeBase extends BaseObject
	{
		protected var _width:int;
		protected var _height:int;
		
		protected var _color:uint;
		protected var _alpha:Number;
		
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
			_propertyArr = propertyArr;
			
			var localeObj:ILocaleObject = _propertyArr["PositionAndSize"][0];
			_height = localeObj.h;
			_width = localeObj.w;
			
			_color = _propertyArr["Color"];
			_alpha = _propertyArr["Alpha"];
			
			var shapeView:ShapeView = new ShapeView(_color, _alpha, _width, _height);
			addChild(shapeView);
			
			//TODO: Implement a shape controller and provide analog joins.
		}
	}

}