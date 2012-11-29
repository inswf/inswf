package cn.inswf.net {
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * ...队列加载
	 * @author liwei
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "ioError", type = "flash.events.IOErrorEvent")]
	[Event(name = "securityError", type = "flash.events.SecurityErrorEvent")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	public class LoaderQueue extends EventDispatcher {
		private var _loaderList : Array;
		private var _availableList : Array;
		private var _requestList : Array;
		private var _completeList : Array;
		private var _current : BaseLoader;
		private var _count : int;
		private var _enterFrame : Shape;
		private var _eventTypeDict:Object;
		public function LoaderQueue(count : int = 5) {
			_eventTypeDict={};
			_loaderList = [];
			_availableList = [];
			_requestList = [];
			_completeList = [];
			_enterFrame = new Shape();
			count = count < 1 ? 1 : count > 30 ? 30 : count;
			var loader : BaseLoader;
			for (var i : int = 0; i < count; i++) {
				loader = new BaseLoader();
				_loaderList.push(loader);
				_availableList.push(loader);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_complete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_ioError);
				loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_securityError);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loader_progress);
			}
		}

		override public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			_eventTypeDict[type]=true;
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		override public function dispatchEvent(event : Event) : Boolean {
			if(_eventTypeDict[event.type]==true){
				return super.dispatchEvent(event);
			}
			return false;
		}
		
		
		override public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			delete _eventTypeDict[type];
			super.removeEventListener(type, listener, useCapture);
		}
		public function load(request : URLRequest, context : LoaderContext = null, priority : Boolean = false) : void {
			if (request == null) {
				return;
			}
			var clone : URLRequest = new URLRequest(request.url);
			clone.contentType = request.contentType;
			clone.data = request.data;
			clone.digest = request.digest;
			clone.method = request.method;
			clone.requestHeaders = request.requestHeaders;
			if (clone.requestHeaders == null) {
				clone.requestHeaders = [];
			}
			clone.requestHeaders.push(context);
			if (priority) {
				_requestList.unshift(clone);
			} else {
				_requestList.push(clone);
			}
			loadnext();
		}

		public function getCurrent() : BaseLoader {
			return _current;
		}

		public function getURLRequest() : URLRequest {
			if (_current == null) {
				return new URLRequest();
			}
			return _current.getURLRequest();
		}

		private function loadnext() : void {
			if (_requestList.length == 0) {
				return;
			}
			var loader : BaseLoader = getAvailable();
			if (loader == null) {
				return;
			}
			var request : URLRequest = _requestList.shift();
			var context : LoaderContext = request.requestHeaders.pop();
			loader.load(request, context);
		}

		private function getAvailable() : BaseLoader {
			if (_availableList.length > 0) {
				return _availableList.shift();
			}
			return null;
		}

		private function loader_complete(e : Event) : void {
			_completeList.push(e);
			if (_enterFrame.hasEventListener(Event.ENTER_FRAME)) {
				return;
			}
			_enterFrame.addEventListener(Event.ENTER_FRAME, enterFrame_enterFrame);
		}

		private function enterFrame_enterFrame(e : Event) : void {
			_enterFrame.removeEventListener(Event.ENTER_FRAME, enterFrame_enterFrame);
			var len : int = _completeList.length;
			while (len--) {
				var eve : Event = _completeList[len];
				var info : LoaderInfo = eve.currentTarget as LoaderInfo;
				addAvailable(info.loader as BaseLoader, eve);
			}
			_completeList.length = 0;
		}

		private function loader_ioError(e : IOErrorEvent) : void {
			var info : LoaderInfo = e.target as LoaderInfo;
			addAvailable(info.loader as BaseLoader, e);
		}

		private function loader_securityError(e : SecurityErrorEvent) : void {
			var info : LoaderInfo = e.target as LoaderInfo;
			addAvailable(info.loader as BaseLoader, e);
		}

		private function addAvailable(loader : BaseLoader, e : Event) : void {
			_count = _requestList.length + ( _loaderList.length - _availableList.length) - 1;
			_current = loader;
			_current.getURLRequest().data = null;
			dispatchEvent(e);
			_availableList.push(loader);
			loadnext();
		}

		private function loader_progress(e : ProgressEvent) : void {
			var info : LoaderInfo = e.target as LoaderInfo;
			_current = info.loader as BaseLoader;
			dispatchEvent(e);
		}

		public function get count() : int {
			return _count;
		}
		public function stop():void{
			_requestList.length=0;
		}
	}
}