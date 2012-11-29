package cn.inswf.framework.core {

	/**
	 * @author hi
	 */
	public interface ICommand extends IActor {
		function execute():void;
		function get disposeAfterExecute():Boolean;
	}
}
