package cn.inswf.utils {
	import flash.utils.ByteArray;
	/**
	 * @author li
	 */
	public class ByteArrayUtil {
		/**
		 * @param value 写入的值
		 * @return 返回占用字节长度
		 */
		public static function getUintLenght(value:uint):uint{
			var len:uint = 0;
			var i:uint ;
			var t:uint ;
			for (i = 0, t = value >> (7 * i); t >= 1 && i < 5; ) {
				t = value >> (7 * (++i));
				len++;
			}
			return len;
		}
		/**
		 * 从数据中读取一个数值
		 * @param bytes 数据源
		 */
		public static function readUint(bytes:ByteArray):uint{
		/*value = (128^e)*b1+(128^e-1)*b2+....(128^0)*bn;*/
			var temp:ByteArray = new ByteArray();
			var byte:int;
			do
			{
				byte = bytes.readByte();
				temp.writeByte(byte);
			}
			while(byte & 0x80);
			var value:uint = 0;
			var e:int = temp.length - 1;
			temp.position = 0;
			while(e >= 0)
			{
				value += (temp.readByte() & 0x7F) << (7*e);
				e--;
			}
			return value;
		}
		/**
		 * 将一个值写入数据中
		 * @param bytes 数据源
		 * @param value 值
		 */
		public static function writeUint(bytes:ByteArray,value:uint):void{
			if (value > uint.MAX_VALUE) {
				return;
			}
			var i:uint ;
			var t:uint ;
			var temp:ByteArray = new ByteArray();
			//bytes =[ n/(128^e)%128 | 0x80 , n/(128^e-1)%128 | 0x80 , ... n/(128^0)%128 ];
			if (value != 0) {
				for (i = 0, t = value >> (7 * i); t >= 1 && i < 5; ) {
					//变长整数最后一个字节高bit位为0。其他字节高bit位为1，低七位是余数对128求模
					//tips:If the divisor is a power of 2, the modulo (%) operation can be done with:
					//modulus = numerator & (divisor - 1);
					temp.writeByte(i?( t & (128 - 1) | 0x80 ): value & (128 - 1));
					//余数为整数除以128的e次方
					t = value >> (7 * (++i));
				}
			}else {
				temp.writeByte(0);
			}
			//trace("当前长度",temp.length)
			for (i = temp.length; i > 0; i--) {
				bytes.writeByte(temp[i - 1]);
			}
		}
	}
}
