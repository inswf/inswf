package cn.inswf.utils.png 
{
	import cn.inswf.utils.CrcUtil;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author liwei
	 */
	public class Chunk 
	{
		private var _type:int;
		private var _bytes:ByteArray;
		public function Chunk(bytes:ByteArray,chunkType:int=0) 
		{
			if (chunkType != 0) {
				_type = chunkType;
				content = bytes;
				return;
			}
			if (bytes.length < 8) {
				bytes.length = 8;
			}
			bytes.position = 0;
			_type = bytes.readInt();
			_bytes = new ByteArray();
			bytes.position = 4;
			bytes.readBytes(_bytes, 0, bytes.length - 8);
			bytes.length = bytes.length - 4;
			
		}
		public function get type():int 
		{
			return _type;
		}
		public function get content():ByteArray {
			_bytes.position = 0;
			return _bytes;
		}
		public function set content(bytes:ByteArray):void {
			_bytes = bytes;
		}
		public function get bytes():ByteArray {
			var ba:ByteArray = new ByteArray();
			ba.writeInt(_bytes.length);
			ba.writeInt(_type);
			ba.writeBytes(_bytes, 0, _bytes.length);
			var crc:int = CrcUtil.createCrc(ba, ba.length - 4, 4);
			ba.writeInt(crc);
			return ba;
		}
	}
}