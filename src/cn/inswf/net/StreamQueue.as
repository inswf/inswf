package cn.inswf.net {
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	/**
	 * ...
	 * @author liwei
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "ioError", type = "flash.events.IOErrorEvent")]
	[Event(name = "securityError", type = "flash.events.SecurityErrorEvent")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	public class StreamQueue extends EventDispatcher {
		private var _streamList : Array;
		private var _availableList : Array;
		private var _requestList : Array;
		private var _completeList : Array;
		private var _loadDict : Object;
		private var _current : BaseURLStream;
		private var _eventTypeDict:Object;
		
		private var _enterFrame : Shape;
		private var _count : int;

		public function StreamQueue(count : int = 5) {
			_eventTypeDict={};
			count = count < 1 ? 1 : count > 30 ? 30 : count;
			_enterFrame = new Shape();
			_loadDict = {};
			_streamList = [];
			_availableList = [];
			_requestList = [];
			_completeList = [];
			var stream : BaseURLStream;
			for (var i : int = 0; i < count; i++) {
				stream = new BaseURLStream();
				_streamList.push(stream);
				_availableList.push(stream);
				stream.addEventListener(Event.COMPLETE, stream_complete);
				stream.addEventListener(IOErrorEvent.IO_ERROR, stream_ioError);
				stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, stream_securityError);
				stream.addEventListener(ProgressEvent.PROGRESS, stream_progress);
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

		private function stream_progress(e : ProgressEvent) : void {
			var stream : BaseURLStream = e.target as BaseURLStream;
			_current = stream;
			dispatchEvent(e);
		}

		public function set endian(value : String) : void {
			var len : int = _streamList.length;
			var stream : BaseURLStream;
			while (len--) {
				stream = _streamList[len];
				stream.endian = value;
			}
		}

		public function set objectEncoding(version : uint) : void {
			var len : int = _streamList.length;
			var stream : BaseURLStream;
			while (len--) {
				stream = _streamList[len];
				stream.objectEncoding = version;
			}
		}

		/**
		 * 加载剩余项数
		 */
		public function get count() : int {
			return _count;
		}

		/**
		 * 当前事件请求
		 * @return 请求对象
		 */
		public function getURLRequest() : URLRequest {
			if (_current == null) {
				return new URLRequest();
			}
			return _current.getURLRequest();
		}

		/**
		 * 当前加载的字节信息
		 * @return 字节信息
		 */
		public function getBytes() : ByteArray {
			if (_current == null) {
				return null;
			}
			return _current.getBytes();
		}

		public function load(request : URLRequest, priority : Boolean = false) : void {
			if (request == null) {
				return;
			}
			if (_loadDict[request.url] == undefined) {
				_loadDict[request.url] = true;
				var clone : URLRequest = new URLRequest(request.url);
				clone.contentType = request.contentType;
				clone.data = request.data;
				clone.digest = request.digest;
				clone.method = request.method;
				clone.requestHeaders = request.requestHeaders;
				if (priority) {
					_requestList.unshift(clone);
				} else {
					_requestList.push(clone);
				}
				loadnext();
			}
		}

		private function loadnext() : void {
			if (_requestList.length == 0) {
				return;
			}
			var stream : BaseURLStream = getAvailable();
			if (stream == null) {
				return;
			}
			var request : URLRequest = _requestList.shift();
			stream.load(request);
		}

		private function getAvailable() : BaseURLStream {
			return _availableList.shift();
		}

		private function stream_securityError(e : SecurityErrorEvent) : void {
			var stream : BaseURLStream = e.target as BaseURLStream;
			addAvailable(stream, e);
		}

		private function stream_ioError(e : IOErrorEvent) : void {
			var stream : BaseURLStream = e.target as BaseURLStream;
			addAvailable(stream, e);
		}

		private function stream_complete(e : Event) : void {
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
				if (eve) {
					var stream : BaseURLStream = eve.target as BaseURLStream;
					addAvailable(stream, eve);
				}
			}
			_completeList.length = 0;
		}

		private function addAvailable(stream : BaseURLStream, e : Event) : void {
			_count = _requestList.length + ( _streamList.length - _availableList.length) - 1;
			_current = stream;
			var request:URLRequest=getURLRequest();
			request.data = null;
			delete _loadDict[request.url];
			dispatchEvent(e);
			_availableList.push(stream);
			loadnext();
		}
	}
}