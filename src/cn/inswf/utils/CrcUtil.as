package cn.inswf.utils 
{
	import flash.utils.ByteArray;
	/**
	 * ...校验码
	 * @author liwei
	 */
	public class CrcUtil 
	{
		private static var _dict:Array;
		public function CrcUtil() 
		{
			
		}
		/**
		 * 
		 * @param	bytes 数据
		 * @param	len 长度
		 * @param	offset 偏移量
		 * @return 校验码
		 */
		public static function createCrc(bytes:ByteArray, len:int, offset:int = 0):int {
			if (_dict == null) {
				createDict();
			}
			var c:uint = 0xffffffff;
			for (var n:int = 0; n < len; n++) {
				c = _dict[(c ^ bytes[n+offset]) & 0xff] ^ (c >>> 8);
			}
			return c ^ 0xffffffff;
		}
		private static function createDict():void {
			_dict = [];
			for (var i:int = 0; i < 256; i++) {
				var c:uint = i;
				for (var k:int = 0; k < 8; k++) {
					if (c & 1) {
					   c = 0xedb88320 ^ (c >>> 1);
					}else{
					   c = c >>> 1;
					}
				}
				_dict.push(c);
			}
		}
	}

}