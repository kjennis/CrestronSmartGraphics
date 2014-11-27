package  
{
	/**
	 * ...
	 * @author Kim Jennis
	 */
	public interface ICLVSView 
	{
		function redrawScreens(numVisibleScreens:int):void;
	
		function newScreenTopPosition(screenIndex:int, value:int):void;
		function newScreenLeftPosition(screenIndex:int, value:int):void;
		function newScreenWidth(screenIndex:int, value:int):void;
		function newScreenHeight(screenIndex:int, value:int):void;
		
	}
	
}