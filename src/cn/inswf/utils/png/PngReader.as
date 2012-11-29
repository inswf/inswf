package cn.inswf.utils.png 
{
	import flash.utils.ByteArray;
	/**
	 * ...png读取
	 * @author liwei
	 */
	public class PngReader 
	{
		//http://www.w3.org/TR/PNG/#9Filters
		//http://book.51cto.com/art/200903/112726.htm
		private static const TYPE_IHDR:int = 0x49484452;//文件头数据块
//		private static const TYPE_cHRM:int = 0x6348524d;//基色和白色点数据块
//		private static const TYPE_gAMA:int = 0x67414d41;//图像γ数据块
//		private static const TYPE_sBIT:int = 0x73424954;//样本有效位数据块
		private static const TYPE_PLTE:int = 0x504c5445;//调色板数据块
//		private static const TYPE_bKGD:int = 0x624b4744;//背景颜色数据块
//		private static const TYPE_hIST:int = 0x68495354;//图像直方图数据块
//		private static const TYPE_tRNS:int = 0x74524e53;//图像透明数据块
//		private static const TYPE_oFFs:int = 0x6f464673;//(专用公共数据块)
//		private static const TYPE_pHYs:int = 0x70485973;//物理像素尺寸数据块
//		private static const TYPE_sCAL:int = 0x7343414c;//(专用公共数据块)
		private static const TYPE_IDAT:int = 0x49444154;//图像数据块
		public static const TYPE_tIME:int = 0x74494d45;//图像最后修改时间数据块
		public static const TYPE_tEXt:int = 0x74455874;//文本信息数据块
		public static const TYPE_zTXt:int = 0x7a545874;//压缩文本数据块
		public static const TYPE_fRAc:int = 0x66524163;//(专用公共数据块)
		public static const TYPE_gIFg:int = 0x67494667;//(专用公共数据块) 
		public static const TYPE_gIFt:int = 0x67494674;//(专用公共数据块)
		public static const TYPE_gIFx:int = 0x67494678;//(专用公共数据块) 
		private static const TYPE_IEND:int = 0x49454e44;//图像结束数据
		
		private var _width:int;
		private var _height:int;
		private const _chunkList:Array = [Chunk];
		private var _chunkDict:Object = { };
		public function PngReader() 
		{
			_chunkList.length = 0;
		}
		public function reset():void {
			_chunkList.length = 0;
			_chunkDict = { };
		}
		/**
		 * 
		 * @param	bytes png图像数据
		 * @return 是否解析成功
		 */
		public function read(bytes:ByteArray):Boolean {
			bytes.position = 0;
			if (bytes.length < 21) {
				return false;
			}
			bytes.position = 8;
			var len:int = bytes.readInt();
			var type:int = bytes.readInt();
			if (type != TYPE_IHDR) {
				return false;
			}
			reset();
			_width = bytes.readInt();
			_height = bytes.readInt();
			bytes.position = 8;
			while (bytes.bytesAvailable) {
				var ba:ByteArray = new ByteArray();
				len = bytes.readInt();
				bytes.readBytes(ba, 0, len + 8);
				var chunk:Chunk = new Chunk(ba);
				_chunkDict["type" + chunk.type] = _chunkList.length;
				_chunkList.push(chunk);
			}
			return true;
		}
		public function save():ByteArray {
			if (_chunkList == null) {
				return null;
			}
			var len:int = _chunkList.length;
			var ba:ByteArray = new ByteArray();
			ba.writeInt(0x89504e47);//两个固定标记
			ba.writeInt(0x0d0a1a0a);//
			for (var i:int = 0; i < len; i++) {
				var chunk:Chunk = _chunkList[i];
				var bytes:ByteArray = chunk.bytes;
				ba.writeBytes(bytes, 0, bytes.length);
			}
			return ba;
		}
		public function getChunk(type:int):Chunk {
			if (_chunkList == null) {
				return null;
			}
			if (_chunkDict["type" + type] == undefined) {
				return null;
			}
			return _chunkList[_chunkDict["type" + type]];
		}
		public function addChunk(chunk:Chunk):void {
			if (chunk == null) {
				return;
			}
			var r:int = 1 + (_chunkList.length - 1) * Math.random();
			_chunkDict["type" + chunk.type] = r;
			_chunkList.splice(r, 0, chunk);
		}
		public function removeChunk(type:int=0):void {
			if (_chunkList == null) {
				return;
			}
			var len:int = _chunkList.length;
			while (len--) {
				var chunk:Chunk = _chunkList[len];
				var ctype:int = chunk.type;
				if (ctype == TYPE_IHDR || ctype == TYPE_IEND || ctype == TYPE_IDAT || ctype == TYPE_PLTE) {
					continue;
				}
				if (type == 0) {
					_chunkList.splice(len, 1);
				}else {
					if (chunk.type == type) {
						_chunkList.splice(len, 1);
					}
				}
			}
		}
		public function dispose():void {
			var len:int = _chunkList.length;
			while (len--) {
				var chunk:Chunk = _chunkList[len];
				if (chunk) {
					chunk.content = null;
				}
				chunk = null;
			}
			_chunkList.length = 0;
			
		}
		/**
		 * 
		 */
		public function get width():int 
		{
			return _width;
		}
		/**
		 * 
		 */
		public function get height():int 
		{
			return _height;
		}
	}

}