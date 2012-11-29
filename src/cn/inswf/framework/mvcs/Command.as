package cn.inswf.framework.mvcs {
	import cn.inswf.framework.core.ICommand;

	import flash.events.IEventDispatcher;


	/**
	 * @author hi
	 */
	public class Command extends Actor implements ICommand {
		public function Command() {
		}

		override protected function addActorListener(type : String, listener : Function, dispatcher : IEventDispatcher = null, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			type, listener, dispatcher, useCapture, priority, useWeakReference;
		}

		public function execute() : void {
		}
		public function get disposeAfterExecute():Boolean{
			return true;
		}
	}
}
