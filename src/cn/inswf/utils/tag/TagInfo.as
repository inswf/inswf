package cn.inswf.utils.tag {
	import flash.utils.ByteArray;
	import cn.inswf.utils.tag.Tag;

	/**
	 * @author hi
	 */
	public class TagInfo extends Tag {
		public var length:int;
		public function TagInfo() {
			
		}
		public function decode(value:ByteArray):void{
			length=value.readInt();
		}
		public function toString() : String {
			return "TagInfo length="+length;
		}
	}
}
