package cn.inswf.framework.mvcs {
	import cn.inswf.framework.core.IActor;
	import cn.inswf.injector.Singleton;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * @author hi
	 */
	public class Actor extends EventDispatcher implements IActor {
		[Inject]
		public static var singleton : Singleton;
		[Inject]
		public static var context:Context;
//		private static const class_map : Dictionary = new Dictionary();
		private static const actor_evnet : EventDispatcher = new EventDispatcher();
		private static const eventTypeMap : Dictionary = new Dictionary();

		public function Actor() {
		}

		protected function getInstance(key : *, name : String = "") : * {
			return singleton.getInstance(key, name);
		}

		protected function hasInstance(key : *, name : String = "") : Boolean {
			return singleton.hasInstance(key, name);
		}

		protected function setInstance(key : *, value : Object, name : String = "") : void {
			singleton.setInstance(key, value, name);
		}
		
		protected function addActorListener(type : String, listener : Function,dispatcher : IEventDispatcher = null, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void{
			if (dispatcher == null) {
				dispatcher = actor_evnet;
			}
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		protected function removeActorListener(type : String, listener : Function, dispatcher : IEventDispatcher = null, useCapture : Boolean = false) : void {
			if (dispatcher == null) {
				dispatcher = actor_evnet;
			}
			dispatcher.removeEventListener(type, listener, useCapture);
		}

		protected function mapCommand(type : String, commandClass : Class, eventClass : Class = null, oneshot : Boolean = false) : void {
			if (eventClass == null) {
				eventClass = Event;
			}

			var eventClassMap : Dictionary = eventTypeMap[type];
			if (eventClassMap == null) {
				eventClassMap = eventTypeMap[type] = new Dictionary();
			}

			var callbacksByCommandClass : Dictionary = eventClassMap[eventClass];
			if (callbacksByCommandClass == null) {
				callbacksByCommandClass = eventClassMap[eventClass] = new Dictionary(false);
			}

			if (callbacksByCommandClass[commandClass] != null) {
				trace(this, "has map" + ' - type (' + type + ') for Command (' + commandClass + ')');
				return;
			}
			var callback : Function = function(event : Event) : void {
				routeEventToCommand(event, commandClass, oneshot, eventClass);
			};
			actor_evnet.addEventListener(type, callback, false, 0);
			callbacksByCommandClass[commandClass] = callback;
		}

		protected function unmapCommand(type : String, commandClass : Class, eventClass : Class = null) : void {
			if (eventClass == null) {
				eventClass = Event;
			}
			var eventClassMap : Dictionary = eventTypeMap[type];
			if (eventClassMap == null) return;

			var callbacksByCommandClass : Dictionary = eventClassMap[eventClass];
			if (callbacksByCommandClass == null) return;

			var callback : Function = callbacksByCommandClass[commandClass];
			if (callback == null) return;

			actor_evnet.removeEventListener(type, callback, false);
			delete callbacksByCommandClass[commandClass];
		}

		private function routeEventToCommand(event : Event, commandClass : Class, oneshot : Boolean, eventClass : Class) : Boolean {
			if (!(event is eventClass)) return false;
			singleton.deleteInstance(eventClass);
			singleton.setInstance(eventClass, event);
			var command : Command = singleton.inject(commandClass) as Command;
			if (command) {
				command.execute();
				if(command.disposeAfterExecute){
					singleton.clearInject(commandClass);
				}
			}
			if (oneshot) {
				unmapCommand(event.type, commandClass, eventClass);
			}
			return true;
		}

		override public function dispatchEvent(event : Event) : Boolean {
			actor_evnet.dispatchEvent(event);
			return super.dispatchEvent(event);
		}

		public function onRegister() : void {
		}

		public function onInject(name : String, instance : Object) : void {
		}
	}
}
