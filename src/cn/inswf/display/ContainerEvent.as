package cn.inswf.display {
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	[Event(name="target_Click", type = "cn.inswf.display.ContainerEvent")]
	[Event(name="target_mouse_over", type="cn.inswf.display.ContainerEvent")]
	[Event(name="target_mouse_out", type="cn.inswf.display.ContainerEvent")]
	[Event(name="target_mouse_down", type="cn.inswf.display.ContainerEvent")]
	[Event(name="target_mouse_up", type="cn.inswf.display.ContainerEvent")]
	/**
	 * @author li
	 */
	public class ContainerEvent extends MouseEvent {
		public static const CLICK : String = "target_Click";
		public static const MOUSE_OVER : String = "target_mouse_over";
		public static const MOUSE_OUT : String = "target_mouse_out";
		public static const MOUSE_DOWN : String = "target_mouse_down";
		public static const MOUSE_UP : String = "target_mouse_up";
		public var targetObject : DisplayObject;
		public var under:Array;
		public function ContainerEvent(type : String, target : DisplayObject = null,localX : Number = undefined, localY : Number = undefined, relatedObject : InteractiveObject = null, ctrlKey : Boolean = false, altKey : Boolean = false, shiftKey : Boolean = false, buttonDown : Boolean = false, delta : int = 0) {
			super(type,true,cancelable,localX,localY,relatedObject,ctrlKey,altKey,shiftKey,buttonDown,delta);
			targetObject = target;
			under=[];
		}
		override public function clone() : Event {
			var e:ContainerEvent=new ContainerEvent(this.type,this.targetObject,localX,localY,relatedObject,ctrlKey,altKey,shiftKey,buttonDown,delta);
			e.under=this.under;
			return e;
		}
	}
}
