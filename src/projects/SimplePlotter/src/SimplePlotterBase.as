package 
{
	
	import com.crestron.components.base.*;
	import com.crestron.components.data.*;
	import com.crestron.components.enums.*;
	import com.crestron.components.joins.*;
	import com.crestron.components.interfaces.*;
	import flash.display.*;
	import flash.geom.*;	
	import flash.text.*;
	
	public class SimplePlotterBase extends BaseObject 
	{
		
		/*
		 * Protected variables
		 */ 
		protected var _width:int;
		protected var _height:int;
		protected var _simplePlotterView:SimplePlotterView;
		protected var _simplePlotterController:SimplePlotterController;
						
		/**
		 * Overrides the width getter for this object to properly report its 
		 * width for the adorners in VTPro.
		 */		
		public override function get width():Number 
		{
			return _width;	
		}
				
		/**
		 * Overrides the height getter for this object to properly report its 
		 * height for the adorners in VTPro.
		 */	
		public override function get height():Number 
		{
			return _height;			
		}	
		
		/*
		 * You should not have to do anything in the constructor.  
		 * When the object is ready to be loaded, initializeScript will
		 * be called.  This is where you perform your initialization procedure.
		 */
		public function HelloWorld():void 
		{
			/*
			 * Do nothing here.
			 */			
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
			
			super.initializeScript(propertyArr, systemServiceManager);
					
			var localeObj:ILocaleObject = propertyArr["PositionAndSize"][0];
			_width = localeObj.w;
			_height = localeObj.h;
			
			var simplePlotterData:SimplePlotterData = new SimplePlotterData();
			_simplePlotterView = new SimplePlotterView(_width, _height, _systemServiceManager, simplePlotterData);
			addChild(_simplePlotterView);
			
			var simplePlotterJoinData:SimplePlotterJoinData = new SimplePlotterJoinData();
			simplePlotterJoinData.logJoin = propertyArr["LogJoin"];
			_simplePlotterController = new SimplePlotterController(_systemServiceManager, _simplePlotterView, simplePlotterJoinData);
			
		}
	}
}