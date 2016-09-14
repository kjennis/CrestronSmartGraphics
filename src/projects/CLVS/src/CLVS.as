package  
{
	import com.crestron.components.data.*;
	import com.crestron.components.diagnostics.*;
	import com.crestron.components.enums.*;
	import com.crestron.components.events.SourceDropEvent;
	import com.crestron.components.interfaces.*;
	import com.crestron.components.interfaces.views.*;
	import com.crestron.components.objects.*;
	import com.crestron.components.widgets.*;
	import com.greensock.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	/**
	 * ...
	 * @author Kim Jennis
	 */
	public class CLVS extends DragAndDrop implements IDragAndDropView, ICLVSView
	{
		private var _listPosition:String;
		protected var _screenPosAndSizeArrayRelative:Array = [];
		protected var _screenPosAndSizeArrayAbsolute:Vector.<PosAndSizeData> = new Vector.<PosAndSizeData>();
		protected var _diagnosticService:IDiagnosticService;
		
		//base calls the addScreens method twice on initialize, the first time we are not ready to check providing false negatives.
		protected var _dontCheckLayoutOnInitialize:Boolean = true;
		
		protected var _invalidLayoutSprite:Sprite;
		protected var _invalidLayoutTimer:Timer = new Timer(200);
		
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
			_diagnosticService = systemServiceManager.diagnosticService;
			
			_invalidLayoutSprite = new Sprite();
			_invalidLayoutSprite.graphics.beginFill(0xFF0000, 0.3);
			_invalidLayoutSprite.graphics.drawRect(0, 0, w, h);
			_invalidLayoutSprite.graphics.endFill();
			
			_invalidLayoutTimer.addEventListener(TimerEvent.TIMER, onFlashOverEvent);
			
			_screenPosAndSizeArrayRelative = dragAndDropData.screenPosAndSizeArray;
			_listPosition = dragAndDropData.listPosition;			
			_listLength = dragAndDropData.listLength;
			_listThickness = dragAndDropData.listThickness;
			
			super(w, h, systemServiceManager, dragAndDropData);
		}
		
		protected function onFlashOverEvent(e:TimerEvent):void 
		{
			_invalidLayoutTimer.stop();
			if (contains(_invalidLayoutSprite))
				removeChild(_invalidLayoutSprite);
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
			
			//When designing we want the flexibility to move the screens arround freely at runtime the screens need to go through a check.
			if (!_systemServiceManager.systemEventService.environmentData.environmentMode == EnvironmentMode.DESIGN && !_dontCheckLayoutOnInitialize)
				layoutOK = verifyLayout();
				
			_dontCheckLayoutOnInitialize = false;
			//if the layout is not OK we fall back to the base class automated layout.
			if (layoutOK)
			{
				addScreensCustom(numVisibleScreens, resizeOnly);
			}
			else
			{
				super.addScreens(numVisibleScreens, resizeOnly);
				layoutInvalidFlash();
			}
		}
		
		protected function layoutInvalidFlash():void 
		{
			addChild(_invalidLayoutSprite);
			_invalidLayoutTimer.start();
		}
		
		protected function addScreensCustom(numVisibleScreens:int, resizeOnly:Boolean = false):void
		{	
			//create droppable screens
			for (var i:int = 0; i < numVisibleScreens; i++)
			{
				
				var curScreen:DragAndDropScreen = _screenArr[i];
				if (curScreen != null)
				{
					curScreen.width = _screenPosAndSizeArrayRelative[i]["ScreenWidth"]/100*(_canvasWidth);
					curScreen.height = _screenPosAndSizeArrayRelative[i]["ScreenHeight"]/100*(_canvasHeight);
					
					//store our screen position x and y
					curScreen.x = _canvasWidth * _screenPosAndSizeArrayRelative[i]["ScreenLeft"]/100 + _canvasX;
					curScreen.y = _canvasHeight *_screenPosAndSizeArrayRelative[i]["ScreenTop"]/100 + _canvasY;
					
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
			_screenPosAndSizeArrayAbsolute = new Vector.<PosAndSizeData>;
			
			var errorMessage:DiagnosticMessage;
			var noErrors:Boolean = true;
			var posAndSize:PosAndSizeData = new PosAndSizeData();
			
			for (var i:int = 0; i < _numVisibleScreens; i++)
			{
				if (_screenArr[i])
				{
					posAndSize.width = _screenPosAndSizeArrayRelative[i]["ScreenWidth"] / 100 * (_canvasWidth);
					posAndSize.height = _screenPosAndSizeArrayRelative[i]["ScreenHeight"]/100*(_canvasHeight);
					posAndSize.top = _canvasHeight *_screenPosAndSizeArrayRelative[i]["ScreenTop"]/100 + _canvasY;
					posAndSize.left = _canvasWidth * _screenPosAndSizeArrayRelative[i]["ScreenLeft"]/100;
					
					//Check if screen is wide enough.
					if (posAndSize.width < _minScreenWidth)
					{
						errorMessage = new DiagnosticMessage(DiagnosticMessage.ERROR, "screen " + (i+1) + " not wide enough, width: " +  posAndSize.width)
						_diagnosticService.log(errorMessage);
						noErrors = false;
					}
					
					//Check if screen is high enough.
					if (posAndSize.height < _minScreenHeight)
					{
						errorMessage = new DiagnosticMessage(DiagnosticMessage.ERROR, "screen " + (i+1) + " not high enough, height: " +  posAndSize.height)
						_diagnosticService.log(errorMessage);
						noErrors = false;
					}
					
					//Check if screen is positioned outside of the canvas(Right)
					if (posAndSize.left + posAndSize.width > _canvasWidth)
					{
						errorMessage = new DiagnosticMessage(DiagnosticMessage.ERROR, "screen " + (i+1) + " is placed out of bounds, right coordinate: " +  posAndSize.left + posAndSize.width + " canvasWidth: " + _canvasWidth)
						_diagnosticService.log(errorMessage);
						noErrors = false;
					}
					
					//Check if screen is positioned outside of the canvas(Left)
					if (posAndSize.left < 0)
					{
						errorMessage = new DiagnosticMessage(DiagnosticMessage.ERROR, "screen " + (i+1) + " is placed out of bounds, left coordinate: " +  posAndSize.left)
						_diagnosticService.log(errorMessage);
						noErrors = false;
					}
					
					//Check if screen is positioned outside of the canvas(Top)
					if (posAndSize.top < 0)
					{
						errorMessage = new DiagnosticMessage(DiagnosticMessage.ERROR, "screen " + (i+1) + " is placed out of bounds, top coordinate: " +  posAndSize.top)
						_diagnosticService.log(errorMessage);
						noErrors = false;
					}
					
					//Check if screen is positioned outside of the canvas(Bottom)
					if (posAndSize.top < 0)
					{
						errorMessage = new DiagnosticMessage(DiagnosticMessage.ERROR, "screen " + (i+1) + " is placed out of bounds, bottom coordinate: " +   posAndSize.top + posAndSize.height + " canvasHeight: " + _canvasHeight)
						_diagnosticService.log(errorMessage);
						noErrors = false;
					}
					
					_screenPosAndSizeArrayAbsolute.push(posAndSize.clone());
					
					for (var j:int = 0; j < i; j++) 
					{
						if (posAndSize.left >= _screenPosAndSizeArrayAbsolute[j].left + _screenPosAndSizeArrayAbsolute[j].width || _screenPosAndSizeArrayAbsolute[j].left >= posAndSize.left + posAndSize.width)
						{
							//Screens don't overlap horizontally.
							break;
						}
						if (posAndSize.top >= _screenPosAndSizeArrayAbsolute[j].top + _screenPosAndSizeArrayAbsolute[j].height || _screenPosAndSizeArrayAbsolute[j].top >= posAndSize.top + posAndSize.height)
						{
							//Screens don't overlap vertically.
							break;
						}
							errorMessage = new DiagnosticMessage(DiagnosticMessage.ERROR, "screen " + (i+1) + " overlaps with screen " + (j+1))
							_diagnosticService.log(errorMessage);
							noErrors = false;
					}
					
				}
				
			}
			return noErrors
		}
		
		override public function set visibleScreens(numVisibleScreens:int):void
		{
			//we cant have more screens visible than our max number of screens
			if (numVisibleScreens >= _numScreens || numVisibleScreens <= 0)
				numVisibleScreens = _numScreens;
				
			_numVisibleScreens = numVisibleScreens;
				
			//remove all our screens from the stage
			var screenCounter:int = _numScreens;

			for each (var removableScreen:DragAndDropScreen in _screenArr)
			{
				if (contains(removableScreen))
				{
					//if the screen isnt on the screen right now, remove the icon.
					
					var index:int = _screenArr.indexOf(removableScreen)
					if (index >= numVisibleScreens)
					{
						removableScreen.removeSourceFromScreen(false);
						//removeChild(removableScreen.sourceIcon);
						//removableScreen.sourceIcon
						//removableScreen.dispatchEvent(new SourceDropEvent(removableScreen.screenIndex, 0));
					}
							
					TweenLite.to(removableScreen, .20, {alpha: 0, onCompleteParams: [removableScreen], onComplete: function(params:DragAndDropScreen):void
					{
						// in case this callback gets called after the parent object is destroyed,
						// after rotation in design time.  Then there is no parent to call removeChild on.
						if ((params as DragAndDropScreen).parent == null)
						{
							return;
					}
							
						removeChild(params);
						screenCounter--;
						
						//add our screens back in
						if (screenCounter == 0)
						{
							addScreens(numVisibleScreens);
						}
					}});
					
				}
				else
				{
					screenCounter--;
					if (screenCounter == 0)
					{
						addScreens(numVisibleScreens);
					}
				}
				
			}
			
			for each (var targetScreen:DragAndDropScreen in _screenArr)
			{
				for each(var source:DragAndDropIcon in _sourceArr)
				{
					targetScreen.sourceIcon = source.clone();
				}
			}
		}
		
		public function redrawScreens():void
		{
			addScreens(_numVisibleScreens);
		}
	
		public function newScreenTopPosition(screenIndex:int, value:int):void
		{
			_screenPosAndSizeArrayRelative[screenIndex]["ScreenTop"] = value / 655.35;
		}
		
		public function newScreenLeftPosition(screenIndex:int, value:int):void
		{
			_screenPosAndSizeArrayRelative[screenIndex]["ScreenLeft"] = value / 655.35;
		}
		public function newScreenWidth(screenIndex:int, value:int):void
		{
			_screenPosAndSizeArrayRelative[screenIndex]["ScreenWidth"] = value / 655.35;
		}
		public function newScreenHeight(screenIndex:int, value:int):void
		{
			_screenPosAndSizeArrayRelative[screenIndex]["ScreenHeight"] = value / 655.35;
		}
		
	}

}