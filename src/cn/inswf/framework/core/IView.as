package cn.inswf.framework.core {
	import flash.display.DisplayObjectContainer;

	/**
	 * @author hi
	 */
	public interface IView extends IData,IRegister {
		function onShow(stage:DisplayObjectContainer):Boolean;
		function onRemove(stage:DisplayObjectContainer):Boolean;
		function setValueComplete():void;
	}
}
