package cn.inswf.display.sheet {
	/**
	 * @author hi
	 */
	public dynamic class LabelsMap extends Object {
		private var _labelList:Array;
		public function LabelsMap() {
			_labelList=[];
		}
		public function getFrameList(label:String):FrameDataList{
			return this[label];
		}
		public function addFrameList(label:String,value:FrameDataList):void{
			if(this[label]==undefined){
				_labelList.push(label);
			}
			this[label]=value;
		}
		public function get length():int{
			return _labelList.length;
		}
		public function get labels():Array{
			return _labelList;
		}
		public function getList():FrameDataList{
			var len:int=_labelList.length;
			var list:FrameDataList=new FrameDataList();
			for(var i:int=0;i<len;i++){
				list.concat(getFrameList(_labelList[i]));
			}
			return list;
		}
	}
}
