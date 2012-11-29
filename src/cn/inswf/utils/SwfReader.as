package cn.inswf.utils 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	/**
	 * ...压缩和未压缩互换
	 * @author liwei
	 */
	public class SwfReader 
	{
//		private static const UNCOMPRESSED:int = 0x46;//未压缩
		private static const COMPRESSED:int = 0x43;//压缩
		private static const FULL:int = 0x3F;
		private static const SYMBOLCLASS:int = 0x4C;
//		private static const FILEATTRIBUTES:int = 0x45;
		public static const CLASSES:String = "classes";
		public static const ACCELERATION:String = "acceleration";
		public static const NONE:int = 0;
		public static const DIRECT:int = 0x1;
		public static const GPU:int = 0x2;
		private var stream:ByteArray;
		private var compressed:int;//压缩标记
//		private var nBits:int;
		private var version:int;
		private var length:int;
		private var swf:ByteArray;
		private var frameRate:uint;
		private var frameCount:int;
		private var dictionary:Array;
		private var arrayClasses:Array;
		private var criteria:int;
//		private var currentByte:int;
//		private var bitPosition:int;
		private var buffer:uint = 0;
		private var pointer:uint = 0;
		private var source:uint;
		public function SwfReader() 
		{
			arrayClasses = [];
		}
		public function getVersion():int {
			return version;
		}
		public function getLength():int {
			return length;
		}
		public function getFrameRate():int {
			return frameRate;
		}
		public function getTotalFrame():int {
			return frameCount;
		}
		public function getCompressed():Boolean {
			return compressed == COMPRESSED;
		}
		public function getDefinitions():Array {
			return  arrayClasses.concat();
		}
		public function read(bytes:ByteArray):Boolean {
			arrayClasses = [];
			if (bytes.length <= 8) {
				return false;
			}
			stream= bytes;
			stream.position = 0;
			compressed = stream.readUnsignedByte();
			stream.position = 3;
			version = stream.readUnsignedByte();
			//trace("版本", version);
			stream.endian = Endian.LITTLE_ENDIAN;
			length = stream.readUnsignedInt();
			//trace("总文件长度", length);
			stream.endian = Endian.BIG_ENDIAN;
			swf = new ByteArray();
			stream.readBytes(swf,0,stream.bytesAvailable);
			if (compressed == COMPRESSED) swf.uncompress();
			//trace("swf数据长度", swf.length);
			var firstBRect:uint = swf.readUnsignedByte();
			var size:uint = firstBRect >> 3; 
			var offset:uint = (size-3);
			var threeBits:uint = firstBRect & 0x7;
			source = swf.readUnsignedByte();
			var xMin:uint = readBits(offset) | (threeBits << offset) / 20;
			var yMin:uint = readBits(size) / 20;
			var wMin:uint = readBits(size) / 20;
			var hMin:uint = readBits(size) / 20;
			trace(xMin, yMin, wMin, hMin);
			frameRate= swf.readShort() & 0xFF;
			//trace("帧频", frameRate);
			var numFrames:uint = swf.readShort();
			frameCount = (numFrames >> 8) & 0xFF | ((numFrames & 0xFF) << 8);
			swf.endian = Endian.LITTLE_ENDIAN;
			dictionary = browseTables();
			var symbolClasses:Array;
			
			criteria = SYMBOLCLASS;
			symbolClasses = dictionary.filter(filter);
			var i:int;
			var count:int;
			var char:int;
			var name:String;
			if (symbolClasses.length > 0) {
				swf.position = TagInfos(symbolClasses[0]).offset;
				count = swf.readUnsignedShort();
				for (i = 0; i < count; i++) {
					swf.readUnsignedShort();
					char = swf.readByte();
					name = "";
					while (char != 0)
					{
						name += String.fromCharCode(char);
						char = swf.readByte();
					}
					arrayClasses.push (name);
				}
			} 
			return true;
		}
		private function readBits(numBits:uint):uint
		{
			buffer = 0;
			var currentMask:uint;
			var bitState:uint;
			for ( var i:uint = 0; i < numBits; i++) {
				currentMask = (1 << 7) >> pointer++;
				bitState = uint((source & currentMask) != 0);
				buffer |= bitState << ((numBits - 1) - i);
				if ( pointer == 8 ) {
					source = swf.readUnsignedByte();
					pointer = 0;
				}
			}
			return buffer;
		}
		private function browseTables():Array
		{
			var currentTag:int;
			var step:int;
			var dictionary:Array = new Array();
			var infos:TagInfos;
			while ( currentTag = ((swf.readShort() >> 6) & 0x3FF) ) {
				infos = new TagInfos();
				infos.tag = currentTag; 
				infos.offset = swf.position;
				swf.position -= 2;
				step = swf.readShort() & 0x3F;
				if ( step < FULL )
					swf.position += step;
				else 
				{
					step = swf.readUnsignedInt();
					infos.offset = swf.position;
					swf.position += step;
				}
				infos.endOffset = swf.position;		
				dictionary.push ( infos );	
			}
			return dictionary;
		}
		private function filter (element:TagInfos, index:int, array:Array):Boolean {
			return element.tag == criteria;	
			index;array;
			
		}
	}

}
final class TagInfos
{
	public var offset:int;
	public var endOffset:int;
	public var tag:int;	
}