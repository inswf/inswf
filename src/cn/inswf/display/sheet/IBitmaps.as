package cn.inswf.display.sheet {
	import cn.inswf.display.IActive;
	/**
	 * @author hi
	 */
	public interface IBitmaps extends IActive {
		function setFrameData(value : FrameDataList):void;
		function play():void;
		function stop():void;
		function nextFrame():void;
		function prevFrame():void;
		function set reverse(value:Boolean):void;
		function get reverse():Boolean;
		function get currentFrame() : int ;
		function set currentFrame(currentFrame : int) : void;
		function set frameRate(value:Number):void;
		function get frameRate():Number;
		function get playing():Boolean;
	}
}
