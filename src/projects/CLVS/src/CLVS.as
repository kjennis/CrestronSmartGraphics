package  
{
	import com.crestron.components.data.*;
	import com.crestron.components.enums.*;
	import com.crestron.components.interfaces.*;
	import com.crestron.components.interfaces.views.*;
	import com.crestron.components.objects.*;
	import com.crestron.components.widgets.*;
	import com.greensock.*;
	/**
	 * ...
	 * @author Kim Jennis
	 */
	public class CLVS extends DragAndDrop implements IDragAndDropView
	{
		private var _listPosition:String;
		protected var _screenPosAndSizeArray:Array = [];
		
		protected var _listLength:int;
		protected var _listThickness:int;
		protected var _listWidth:Number;
		protected var _listHeight:Number;
		protected var _listXpos:Number;
		protected var _listYpos:Number;
		protected var _canvasHeight:Number;
		protected var _canvasWidth:Number;
		protected var _canvasY:Number;
		protected var _canvasX:Number;
		
		public function CLVS(w:Number, h:Number, systemServiceManager:ISystemServiceManager, dragAndDropData:CLVSData) 
		{
			_screenPosAndSizeArray = dragAndDropData.screenPosAndSizeArray;
			_listPosition = dragAndDropData.listPosition;			
			_listLength = dragAndDropData.listLength;
			_listThickness = dragAndDropData.listThickness;
			
			super(w, h, systemServiceManager, dragAndDropData);
			
			//layout();
		}
		
		protected function layout():void 
		{
			switch (_listPosition) {
			
			case "top":
				_listWidth = _width * _listLength / 100;
				_listHeight = _height * _listThickness / 100;
				_listXpos = (_width - _listWidth) / 2;
				_listYpos = 0;
				
				_canvasWidth = _width
				_canvasHeight = _height - _listHeight;
				_canvasY = _listHeight;
				_canvasX = 0;
			break;
					
			case "bottom":
				_listWidth = _width * _listLength / 100;
				_listHeight = _height * _listThickness / 100;
				_listXpos = (_width - _listWidth) / 2;
				_listYpos = _height - _listHeight;
				
				_canvasWidth = _width
				_canvasHeight = _height - _listHeight;
				_canvasY = 0;
				_canvasX = 0;
			break;
					
			case "left":
				_listWidth = _width * _listThickness / 100;
				_listHeight = _height * _listLength / 100;
				_listXpos = 0;
				_listYpos = (_height - _listHeight) / 2;
				
				_canvasWidth = _width - _listWidth;
				_canvasHeight = _height;
				_canvasY = 0;
				_canvasX = _listWidth;
			break;
					
			case "right":
				_listWidth = _width * _listThickness / 100;
				_listHeight = _height * _listLength / 100;
				_listYpos = (_height - _listHeight) / 2;
				_listXpos = _width - _listWidth;
				
				_canvasWidth = _width - _listWidth;
				_canvasHeight = _height;
				_canvasY = 0;
				_canvasX = 0;
			break;
			
			}
			
			_list.resize(_listWidth, _listHeight);
			_list.x = _listXpos;
			_list.y = _listYpos;
		}
		
		override protected function addScreens(numVisibleScreens:int, resizeOnly:Boolean = false):void
		{
			layout();
			
			var layoutOK:Boolean = true;
			
			//When designing we want the flexibility to move the screens arround freely at runtime the screens need to go trough a check.
			if (!_systemServiceManager.systemEventService.environmentData.environmentMode == EnvironmentMode.DESIGN)
				layoutOK = verifyLayout();
				
			//if the layout is not OK we fall back to the base class automated layout.
			if (!layoutOK)
			{
				super.addScreens(numVisibleScreens, resizeOnly);
			}
			else
			{
				addScreensCustom(numVisibleScreens, resizeOnly)
			}
		}
		
		protected function addScreensCustom(numVisibleScreens:int, resizeOnly:Boolean = false):void
		{	
			//create droppable screens
			for (var i:int = 0; i < numVisibleScreens; i++)
			{
				
				var curScreen:DragAndDropScreen = _screenArr[i];
				if (curScreen != null)
				{
					curScreen.width = _screenPosAndSizeArray[i]["ScreenWidth"]/100*(_canvasWidth);
					curScreen.height = _screenPosAndSizeArray[i]["ScreenHeight"]/100*(_canvasHeight);
					
					//store our screen position x and y
					curScreen.x = _canvasWidth * _screenPosAndSizeArray[i]["ScreenLeft"]/100 + _canvasX;
					curScreen.y = _canvasHeight *_screenPosAndSizeArray[i]["ScreenTop"]/100 + _canvasY;
					
					//add our screen to the stage
					if (resizeOnly)
					{
						if (curScreen.sourceIcon != null)
						{
							curScreen.fadeInSource(false);
						}
					}
					else
					{
						addChildAt(curScreen, 1);
						TweenLite.to(curScreen, 0, {alpha: 0});
						TweenLite.to(curScreen, .25, {alpha: 1});
						if (curScreen.sourceIcon != null)
						{
							curScreen.fadeInSource();
						}
					}
				}
			}
			setChildIndex(_list, numChildren - 1);
		}
		
		protected function verifyLayout():Boolean 
		{
			//Check if the layout is OK, no screens are outside of the control, no screens overlap, no screens are too small.
			return true;
		}
		
	}

}