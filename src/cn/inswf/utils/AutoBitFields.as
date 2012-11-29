package cn.inswf.utils {
	/**
	 * 自动长度的bitField
	 * @author li
	 */
	public class AutoBitFields extends Object {
		private var _bitfields:Array;
		private var _size:int;
		public function AutoBitFields(size:uint=31) {
			_bitfields=[];
			this.size = size;
		}
		public function set size(value:uint):void{
			var s:int=value/31;
			if(value%31){
				s++;
			}
			_bitfields.length=s;
			_size=s;
			while(s--){
				if(_bitfields[s]==null){
					_bitfields[s]=new BitField();
				}
			}
		}
		private function getKey(index:int):int{
			index%=32;
			return index;
		}
		private function getStart(index:int):int{
			var start:int=index/31;
			if(index%31==0)start--;
			if(start<0)start=0;
			return start;
		}
		public function getValue():Array
		{
			return _bitfields.concat();
		}
		public function hasValue(index:uint):Boolean
		{
			var start:int=getStart(index);
			var value:BitField=_bitfields[start];
			if(!value)return false;
			return value.hasValue(getKey(index));
		}
		public function setValue(index:uint):void
		{
			var start:int=getStart(index);
			if(start>_size-1){
				trace("index 超出范围:"+index);
				return;
			}
			var value:BitField=_bitfields[start];
			trace(start,getKey(index));
			value.setValue(getKey(index));
		}
		public function clearValue(index:uint):void
		{
			var start:int=getStart(index);
			if(start>_size-1){
				trace("index 超出范围:"+index);
				return;
			}
			var value:BitField=_bitfields[start];
			value.clearValue(getKey(index));
		}
		
		
	}
}
