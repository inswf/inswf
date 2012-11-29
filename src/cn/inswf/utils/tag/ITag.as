package cn.inswf.utils.tag {
	import flash.utils.ByteArray;
	/**
	 * @author li
	 */
	public interface ITag {
		function set bytes(bytes : ByteArray) : void
		function get bytes():ByteArray
		function set code(code : uint) : void
		function get code() : uint
	}
}
