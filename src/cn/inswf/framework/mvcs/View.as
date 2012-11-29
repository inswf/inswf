package cn.inswf.framework.mvcs {
	import cn.inswf.framework.core.IView;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;


	/**
	 * @author hi
	 */
	public class View extends Sprite implements IView {
		public function View() {
		}

		public function onShow(stage : DisplayObjectContainer) : Boolean {
			return true;
		}

		public function onRemove(stage : DisplayObjectContainer) : Boolean {
			return true;
		}

		public function setValue(value : *) : Boolean {
			return false;
		}

		public function getValue(arg : *) : * {
		}

		public function onRegister() : void {
		}

		public function setValueComplete() : void {
		}

		public function onInject(name : String, instance : Object) : void {
		}

		
	}
}
