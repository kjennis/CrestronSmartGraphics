/**********************************************************************************
 *
 *	Title: CustomLayoutVideoSwitcherBase
 *	Similar to the DragAndDropControlBase with added x/y/width/height properties for your screens.
 *
 **********************************************************************************/
package 
{
	import com.crestron.components.base.*;
	import com.crestron.components.buttons.*;
	import com.crestron.components.controllers.*;
	import com.crestron.components.data.*;
	import com.crestron.components.enums.*;
	import com.crestron.components.images.*;
	import com.crestron.components.interfaces.*;
	import com.crestron.components.joins.*;
	import com.crestron.components.lists.*;
	import com.crestron.components.objects.*;
	import com.crestron.components.text.*;
	import com.crestron.components.widgets.*;
	import com.greensock.*;
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	
	
	public class CLVSBase extends BaseObject
	{
		protected var _clvs:CLVS;
		protected var _clvsJoinController:CLVSJoinController;
		
		/****************************************************************************
		   Constructor: DragAndDropControlBase
		
		   Handles the DataRequest heartbeat, and waits for DataUpdateEvent.
		 *****************************************************************************/
		public function CLVSBase()
		{			
			super();
		}
		
		/**********************************************************************************
		   Function: initializeScript
		
		   Initializes the script.  Processes the Crestron Data Structure and creates necessary screen elements.
		   This function is intended to be overridden
		
		   Parameters:
		   @param		propertyArr				Array					Property Array for this object
		   @param		systemServiceManager 	ISystemServiceManager	The system service manager
		 **********************************************************************************/
		public override function initializeScript(propertyArr:Array, systemServiceManager:ISystemServiceManager):void
		{
			var controlWidth:Number 			= propertyArr["PositionAndSize"][0].w;
			var controlHeight:Number 			= propertyArr["PositionAndSize"][0].h;
			
			//cap control dimensions to w:240 h:200
			if (controlWidth < 240)
			{
				controlWidth = 240;
			}
			if (controlHeight < 200)
			{
				controlHeight = 200;
			}
			
			//get our data arrays
			var screensArr:Array 				= propertyArr["Screens"];
			var sourcesArr:Array 				= propertyArr["Sources"];
			var listPropertiesArr:Array 		= propertyArr["ListProperties"] != null ? propertyArr["ListProperties"] : propertyArr;
			
			//get our icon style
			var styleObj:IStyleObject 			= sourcesArr["IconStyle"][0];
			
			//create an array or analogs to publish per screen
			var screenAnalogArr:Array 			= [];
			//create an array of screen labels
			var screenLabelArr:Array 			= [];
			
			//Create array of digital "Source Changed" joins
			var screenDigitalArr:Array          = [];
			
			for each (var screen:Array in screensArr["Screen"])
			{
				screenLabelArr.push(screen["Name"]);
				//screenAnalogArr.push(int(screen["SourceSelection"] ? screen["SourceSelection"]["JoinNumber"] : 0));
				////Populate digital array
				//screenDigitalArr.push(int(screen["SourceChanged"] ? screen["SourceChanged"]["JoinNumber"] : 0));
			}
			
			var listPosition:String 			= String(listPropertiesArr["ListPosition"]).toLowerCase();
			var listMargin:Number 				= screensArr["Margin"];
			
			//create our drag and drop data object
			var dragAndDropData:CLVSData = new CLVSData();
			dragAndDropData.displayLabels 		= String(screensArr["DisplayLabels"]).toLowerCase() == "true";
			dragAndDropData.screenMargin 		= listMargin;
			dragAndDropData.screenNameArr 		= screenLabelArr;
			dragAndDropData.enforceGeometry 	= String(screensArr["EnforceGeometry"]).toLowerCase() == "true";
			dragAndDropData.localMode 			= String(screensArr["LocalMode"]).toLowerCase() == "true";

			var dragAndDropPosAndSizeArr:Array = new Array();
			for each (screen in screensArr["Screen"])
			{
				dragAndDropPosAndSizeArr.push(screen["ScreenPositionAndSize"]);
			}
			
			dragAndDropData.screenPosAndSizeArray	= dragAndDropPosAndSizeArr;
			
			//get our aspect ratio
			var aspectRatio:Array 				= String(screensArr["ScreenAspectRatio"]).split(":");
			if (aspectRatio[0] != "Stretch")
			{
				dragAndDropData.aspectRatio 	= int(aspectRatio[0]) / int(aspectRatio[1]);
			}
			
			//store our preview state for the list
			var previewState:int 				= propertyArr["PreviewState"];
			
			//these are the list properties
			dragAndDropData.listPosition 		= listPosition;
			dragAndDropData.listLength			= listPropertiesArr["ListLength"];
			dragAndDropData.listThickness		= listPropertiesArr["ListThickness"];
			dragAndDropData.itemSpacing 		= listPropertiesArr["ItemSpacing"];
			dragAndDropData.endlessScrolling 	= String(listPropertiesArr["EndlessScrolling"]).toLowerCase() == "true";
			dragAndDropData.clickTime 			= listPropertiesArr["ClickTime"];
			dragAndDropData.margin 				= listPropertiesArr["Margin"];
			dragAndDropData.displayBackground 	= String(listPropertiesArr["DisplayBackground"]).toLowerCase() == "true";
			dragAndDropData.numDivisions 		= listPropertiesArr["NumDivisions"];
			
			//Read scrollbar properties
			dragAndDropData.enableScrollbar 	= String(listPropertiesArr["ShowScrollbar"]).toString() == "true";
			dragAndDropData.scrollbarPosition 	= String(listPropertiesArr["Position"]).toString();
			
			//Read numUserColumns property
			dragAndDropData.numUserColums       = int(screensArr["ColumnCount"]);
			
			//get our style data 
			dragAndDropData.listBackgroundStyle = listPropertiesArr["ListBackground"][0].bitmapObject;
			dragAndDropData.screenStyle 		= screensArr["ScreenStyle"] ? screensArr["ScreenStyle"][0] : propertyArr["ScreenStyle"][0];
			
			//new up our drag and drop
			_clvs = new CLVS(controlWidth, controlHeight, systemServiceManager, dragAndDropData);
			
			addChild(_clvs);
			
			var index:int = 1;
			
			for each (var source:Array in sourcesArr["Source"])
			{
				//set up the subpage reference for each item
				var itemSubpage:IPageObject = null;
				var digitalOffset:int = 0;
				var analogOffset:int = 0;
				var serialOffset:int = 0;
				if (systemServiceManager.systemEventService.environmentData.environmentMode != EnvironmentMode.DESIGN)
				{
					var subpagePropertiesArr:Array = source["SubpageProperties"];
					itemSubpage = (subpagePropertiesArr["Subpage"] != 0) ? subpagePropertiesArr["Subpage"][0] : null;
					if (itemSubpage != null)
					{
						digitalOffset = subpagePropertiesArr["DigitalJoinOffset"];
						analogOffset = subpagePropertiesArr["AnalogJoinOffset"];
						serialOffset = subpagePropertiesArr["SerialJoinOffset"];
					}
				}
				
				//check to see if we are using external images or themed images.
				var imageTypeArr:Array = source["ImageType"];
				
				var stateStyleObject:IStyleObject = styleObj.clone();
				var styleBitmapObject:IBitmapObject;
				if (imageTypeArr != null)
				{
					if (imageTypeArr["UseState"])
					{
						
						var curStateID:int = imageTypeArr["UseState"]["IconFrame"];
						styleBitmapObject = stateStyleObject.bitmapObject;
						
						//request our bitmapObejct from the service
						var imageMap:Dictionary = new Dictionary();
						var scalingConstraintsMap:Dictionary = new Dictionary();
						imageMap[0] = styleBitmapObject.getFrame(curStateID);
						scalingConstraintsMap[0] = styleBitmapObject.getScalingConstraints(curStateID);
						
						styleBitmapObject = systemServiceManager.bitmapService.getBitmapObject(imageMap, scalingConstraintsMap);
						
					}
					else if (imageTypeArr["UseImage"])
					{
						styleBitmapObject = imageTypeArr["UseImage"]["Image"][0];
					}
				}
				
				//create our drag and drop icon data
				var dragAndDropIconData:DragAndDropIconData 	= new DragAndDropIconData();
				dragAndDropIconData.fontStyleObj 				= stateStyleObject.fontStyleObject;
				dragAndDropIconData.iconBitmapObject 			= styleBitmapObject;
				dragAndDropIconData.labelArr 					= [source["Label"]];
				dragAndDropIconData.index 						= source["SourceIndex"];
				dragAndDropIconData.subpageRef 					= itemSubpage;
				if (itemSubpage != null)
				{
					dragAndDropIconData.subpageRefDigitalJoinOffset = digitalOffset;
					dragAndDropIconData.subpageRefAnalogJoinOffset = analogOffset;
					dragAndDropIconData.subpageRefSerialJoinOffset = serialOffset;
				}				
				
				var dragAndDropSource:DragAndDropIcon 			= _clvs.createListItem(dragAndDropIconData);
				//create a join controller to handle cip tag joins	
				dragAndDropSource.cipJoinController = new CIPJoinController(systemServiceManager, dragAndDropSource.formattedTextObj);
				//add our icons here
				_clvs.addIcon(dragAndDropSource);
			}
			
			//create our drag an drop join controller
			
			var clvsJoinsObject:CLVSJoinsObject					= new CLVSJoinsObject();
			clvsJoinsObject.controlJoin							= _propertyArr["ControlJoin"];
			clvsJoinsObject.enableJoin							= _propertyArr["DigitalEnableJoin"];
			clvsJoinsObject.visibilityJoin 						= _propertyArr["DigitalVisibilityJoin"];
			
			clvsJoinsObject.useIndirectPositioning 				= String(listPropertiesArr["useIndirectPositioning"]).toLowerCase() == "true";
			clvsJoinsObject.screenCount							= _propertyArr["Screens"]["ScreenCount"];
			clvsJoinsObject.redrawScreenJoin					= _propertyArr["RedrawScreensJoin"]["JoinNumber"];
			clvsJoinsObject.numberOfVisibleScreensJoin			= _propertyArr["ScreenSwitching"]["JoinNumber"];
			
			var encapsulatedJoinGroupsArr:Array					= _propertyArr["Screens"];
			clvsJoinsObject.sourceChangedStartJoin				= (encapsulatedJoinGroupsArr["SourceChanged"][0] as EncapsulatedJoinGroupObject).joinNumber;
			clvsJoinsObject.sourceSelectionStartJoin			= (encapsulatedJoinGroupsArr["SourceSelection"][0] as EncapsulatedJoinGroupObject).joinNumber;
			clvsJoinsObject.screenTopLocationStartJoin			= (encapsulatedJoinGroupsArr["ScreenTopLocations"][0] as EncapsulatedJoinGroupObject).joinNumber;
			clvsJoinsObject.screenLeftLocationStartJoin			= (encapsulatedJoinGroupsArr["ScreenLeftLocations"][0] as EncapsulatedJoinGroupObject).joinNumber;
			clvsJoinsObject.screenWidthStartJoin				= (encapsulatedJoinGroupsArr["ScreenWidths"][0] as EncapsulatedJoinGroupObject).joinNumber;
			clvsJoinsObject.screenHeightStartJoin				= (encapsulatedJoinGroupsArr["ScreenHeights"][0] as EncapsulatedJoinGroupObject).joinNumber;
			
			for (var i:int = 0; i < clvsJoinsObject.screenCount; i++) 
			{
				screenAnalogArr.push(clvsJoinsObject.sourceSelectionStartJoin + i);
				screenDigitalArr.push(clvsJoinsObject.sourceChangedStartJoin + i);
			}
			
			screenAnalogArr.push(int(screen["SourceSelection"] ? screen["SourceSelection"]["JoinNumber"] : 0));
				//Populate digital array
				screenDigitalArr.push(int(screen["SourceChanged"] ? screen["SourceChanged"]["JoinNumber"] : 0));
			
			_clvsJoinController = new CLVSJoinController(systemServiceManager, _clvs, clvsJoinsObject, screenAnalogArr, screenDigitalArr);
			
			//create our CIP join controlers for the screens
			for each(var dragAndDropScreen:DragAndDropScreen in _clvs.droppableTargets)
			{
				if (dragAndDropScreen.formattedTextObj)
				{
					var screenCIPJoinController:CIPJoinController = new CIPJoinController(systemServiceManager, dragAndDropScreen.formattedTextObj);
				}
			}
			
			_clvs.reorganizeLayout();
			
			//scroll to the preview state
			if (systemServiceManager.systemEventService.environmentData.environmentMode == EnvironmentMode.DESIGN)
			{
				_clvs.scrollSpeed = 0;
				_clvs.scrollToItemIndex(previewState);
			}
		}
		
		/**********************************************************************************
		   Property: width
		
		   Overrides the width getter for this object to properly report its
		   width for the adorners in VTPro.
		   @return		width		Number		Returned width of the control.
		 **********************************************************************************/
		public override function get width():Number
		{
			return _clvs ? _clvs.width : 0;
		}
		
		/**********************************************************************************
		   Property: height
		
		   Overrides the height getter for this object to properly report its
		   height for the adorners in VTPro.
		   @return		height		Number		Returned height of the control.
		 **********************************************************************************/
		public override function get height():Number
		{
			return _clvs ? _clvs.height : 0;
		}
	
		public override function set width(value:Number):void
		{
			if (_clvs)
			{
				_clvs.width = value;
			}
		}
		
		public override function set height(value:Number):void
		{
			if (_clvs)
			{
				_clvs.height = value;
			}
		}
	}

}