package cn.inswf.utils.tag {
	import flash.utils.ByteArray;
	/**
	 * @author li
	 */
	public class Tag implements ITag{
		protected var _bytes:ByteArray;
		protected var _code:uint;

		public function Tag() {
		}

		public function get bytes() : ByteArray {
			if (_bytes == null) {
				return null;
			}
			_bytes.position = 0;
			var ba:ByteArray = new ByteArray();
			_bytes.readBytes(ba, 0, _bytes.length);
			return ba;
		}

		public function set bytes(value : ByteArray) : void {
			_bytes = value;
		}

		public function get code() : uint {
			return _code;
		}

		public function set code(code : uint) : void {
			_code = code;
		}
	}
}
