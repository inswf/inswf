package cn.inswf.display {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;

	/**
	 * @author li
	 */
	public interface IDisplayObject extends IEventDispatcher {
		function get alpha() : Number;

		function set alpha(value : Number) : void;

		function get height() : Number;

		function set height(value : Number) : void;

		function get mouseX() : Number;

		function get mouseY() : Number;

		function get rotation() : Number;

		function set rotation(value : Number) : void;

		function get scaleX() : Number;

		function set scaleX(value : Number) : void;

		function get scaleY() : Number;

		function set scaleY(value : Number) : void;

		function get visible() : Boolean;

		function set visible(value : Boolean) : void;

		function get width() : Number;

		function set width(value : Number) : void;

		function get x() : Number;

		function set x(value : Number) : void;

		function get y() : Number;

		function set y(value : Number) : void;

		function getBounds(targetCoordinateSpace : DisplayObject) : Rectangle;

		function getRect(targetCoordinateSpace : DisplayObject) : Rectangle;

		function get mask() : DisplayObject;

		function set mask(value : DisplayObject) : void;

		function get parent() : DisplayObjectContainer;
	}
}
