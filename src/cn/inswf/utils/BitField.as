package cn.inswf.utils {
	/**
	 * @author li
	 * 存储开关
	 * 最多保存32个开关
	 * var bf:BitField=new BitField();
	 * bf.setValue(3);
	 * bf.setValue(31);
	 * trace(bf.hasValue(3),bf.hasValue(31));
	 * trace(bf.getValue());
	 */
	public class BitField {
		private var _value:int=0;
		public function BitField(value:uint=0) {
			_value=value;
		}
		public function getValue():uint
		{
			return _value;
		}
		public function hasValue(value:uint):Boolean
		{
			var key:int=getKey(value);
			return (_value & key) == key;
		}
		public function setValue(value:uint):void
		{
			_value |= getKey(value);
		}
		public function clearValue(value:uint):void
		{
			_value &= ~getKey(value);
		}   
		private function getKey(index:uint):int{
			index%=32;
			return 1<<index;
		}
		public function toString() : String {
			return String(getValue());
		}
	}
}
