package cn.inswf.display.sheet {
	/**
	 * @author hi
	 */
	public class FrameDataList {
		private var _name:String;
		private var _list:Array;
		public function FrameDataList(name:String="") {
			_list=[];
			_name=name;
		}
		public function addFrame(value:FrameData,index:int=-1):void{
			if(index==-1){
				index=_list.length;
			}
			_list.splice(index,0,value);
		}
		public function getFrame(index:int):FrameData{
			return _list[index];
		}
		public function get name():String{
			return _name;
		}
		public function get length():int{
			return _list.length;
		}
		public function concat(value:FrameDataList):void{
			_list=_list.concat(value._list);
		}
	}
}
