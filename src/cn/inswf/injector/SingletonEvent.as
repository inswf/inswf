package cn.inswf.injector {
	import flash.events.Event;
	[Event(name = "instance_create", type = "cn.inswf.injector.SingletonEvent")]
	[Event(name = "instance_notset", type = "cn.inswf.injector.SingletonEvent")]

	/**
	 * @author hi
	 */
	public class SingletonEvent extends Event {
		public static const INSTANCE_CREATE : String = "instance_create";
		public static const INSTANCE_NOTSET:String="instance_notset";
		public var singleton:Object;
		public var variable:String;
		public var instance:Instance;
		public function SingletonEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
