package cn.inswf.net {
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	/**
	 * ...
	 * @author liwei
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "ioError", type = "flash.events.IOErrorEvent")]
	[Event(name = "securityError", type = "flash.events.SecurityErrorEvent")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	public class File extends EventDispatcher {
		private var _url : String;
		private var _bytes : ByteArray;

		public function File(url : String = "") {
			_bytes=new ByteArray();
			_url=url;
		}
		override public function toString() : String {
			return "[File url=" + url + "]";
		}

		public function get bytes() : ByteArray {
			var temp:ByteArray = new ByteArray();
			_bytes.position=0;
			_bytes.readBytes(temp, 0, _bytes.bytesAvailable);
			return temp;
		}

		public function set bytes(value : ByteArray) : void {
			if(value==null){
				return;
			}
			_bytes.writeBytes(value, 0, value.length);
		}

		public function get url() : String {
			return _url;
		}
	}
}