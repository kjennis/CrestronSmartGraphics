package  
{
	import com.crestron.components.data.*;
	import com.crestron.components.interfaces.*;
	import com.crestron.components.interfaces.views.*;
	import com.crestron.components.objects.*;
	import com.crestron.components.widgets.*;
	import com.greensock.*;
	/**
	 * ...
	 * @author Kim Jennis
	 */
	public class CLSV extends DragAndDrop implements IDragAndDropView
	{
		private var _listPosition:String;
		protected var _screenPosAndSizeArray:Array = [];
		
		public function CLSV(w:Number, h:Number, systemServiceManager:ISystemServiceManager, dragAndDropData:CLSVData) 
		{
			_screenPosAndSizeArray = dragAndDropData.screenPosAndSizeArray;
			_listPosition = dragAndDropData.listPosition;
			super(w, h, systemServiceManager, dragAndDropData);
		}
		
		override protected function addScreens(numVisibleScreens:int, resizeOnly:Boolean = false):void
		{
			var canvasHeight:Number;
			var canvasWidth:Number;
			var canvasY:Number;
			
			if (_listPosition == "top" || _listPosition == "bottom")
			{
				canvasWidth = _width
				canvasHeight = _height * .7;
				if (_listPosition == "top")
				{
					canvasY = _height * .3;
				}
				else
				{
					canvasY = 0;
				}
			}
			else
			{
				canvasWidth = _width * .7
				canvasHeight = _height
			}
			//create droppable screens
			for (var i:int = 0; i < numVisibleScreens; i++)
			{
				
				var curScreen:DragAndDropScreen = _screenArr[i];
				if (curScreen != null)
				{
					curScreen.width = _screenPosAndSizeArray[i]["ScreenWidth"]/100*(canvasWidth);
					curScreen.height = _screenPosAndSizeArray[i]["ScreenHeight"]/100*(canvasHeight);
					
					//store our screen position x and y
					curScreen.x = canvasWidth * _screenPosAndSizeArray[i]["ScreenLeft"]/100 + _screenOffsetLeft;
					curScreen.y = canvasHeight *_screenPosAndSizeArray[i]["ScreenTop"]/100 + canvasY;
					
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
		
	}

}