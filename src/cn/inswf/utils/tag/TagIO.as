package cn.inswf.utils.tag {
	import flash.utils.ByteArray;
	/**
	 * @author li
	 */
	public class TagIO {
		protected var _bytes:ByteArray;
		protected var _tags:Array;
		protected var _map:Object;
		public function TagIO() {
			_bytes=new ByteArray();
			_tags=[];
			_map={};
		}
		public function getBytes():ByteArray{
			_bytes.position = 0;
			var data:ByteArray=new ByteArray();
			var taginfodata:ByteArray=new ByteArray();
			taginfodata.writeInt(_tags.length);
			taginfodata.position=0;
			data.writeShort(0);//标记码
			data.writeBoolean(false);//是否压缩
			data.writeInt(taginfodata.length);//长度
			data.writeBytes(taginfodata, 0, taginfodata.bytesAvailable);//数据
			data.writeBytes(_bytes,0,_bytes.length);
			data.position=0;
			var ba:ByteArray = new ByteArray();
			data.readBytes(ba, 0, _bytes.bytesAvailable);
			return ba;
		}
		public function read(bytes:ByteArray):void{
			if (bytes != null) {
				bytes.position = 0;
				bytes.readBytes(_bytes, 0, bytes.length);
			}
			if (_bytes.length < 7) {
				//小于 （标记码，是否压缩，数据长度）
				return;
			}
			_bytes.position = 0;
			var code:uint=_bytes.readUnsignedShort();//标记码
			var zlib:Boolean=_bytes.readBoolean();//是否压缩
			var len:uint=_bytes.readUnsignedInt();//长度
			if (_bytes.length < len + 7) {
				//数据长度不够
				return;
			}
			var tagdata:ByteArray = new ByteArray();
			_bytes.readBytes(tagdata, 0, len);
			var newdata:ByteArray = new ByteArray();
			_bytes.readBytes(newdata, 0, _bytes.bytesAvailable);
			_bytes.length = 0;
			try {
				if (zlib) {
					tagdata.uncompress();
				}
			}catch (e:Error) {
				read(newdata);
				return;
			}
			if(code==0){
				var info:TagInfo=new TagInfo();
				info.decode(tagdata);
				InfoTag(info);
			}else{
				var tag:Tag = new Tag();
				tag.code = code;
				tag.bytes = tagdata;
				newTag(tag);
				if (_map[code] == undefined) {
					_map[code] = [];
				}
				var codeList:Array = _map[code];
				codeList.push(tag);
			}
			read(newdata);
		}
		public function write(tag:ITag):Boolean{
			_bytes.position = _bytes.length;
			var code:uint = tag.code;
			if (code > 0xFFFF || code<1) {
				//标记码不能大于65535
				throw new Error("标记码范围1-65535");
				return false;
			}
			var data:ByteArray = tag.bytes;
			if (data == null || data.length == 0) {
				//数据不能为空
				throw new Error("code为"+code+"的数据不能为空");
				return false;
			}
			_tags.push(tag);
			var len:uint = data.length;
			data.compress();
			var data2:ByteArray=tag.bytes;
			var zlib:Boolean = data.length < data2.length;
			if (zlib) {
				len = data.length;
			}else {
				data = data2;
			}
			data2.length=0;
			data2=null;
			data.position = 0;
			_bytes.writeShort(code);//标记码
			_bytes.writeBoolean(zlib);//是否压缩
			_bytes.writeInt(len);//长度
			_bytes.writeBytes(data, 0, data.bytesAvailable);//数据
			return true;
		}
		public function clear():void{
			_bytes.length=0;
			_tags=[];
			_map={};
		}
		protected function newTag(tag:ITag):void{
			trace("new tag",tag.code);
		}
		protected function InfoTag(tag:TagInfo):void{
			trace("taginfo",tag);
		}
	}
}
