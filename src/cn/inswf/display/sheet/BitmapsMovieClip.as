package cn.inswf.display.sheet {
	import cn.inswf.display.IMovieClip;
	/**
	 * @author hi
	 */
	public class BitmapsMovieClip extends Bitmaps implements IMovieClip{
		public static const configLoader:FrameDataLoader=new FrameDataLoader();
		protected var _labelMap:LabelsMap;
		protected var _label:String;
		private var _hasContent:Boolean;
		public function BitmapsMovieClip(url:String=null) {
			if(url){
				load(url);
			}
		}
		public function load(url:String):void{
			configLoader.loadConfig(url,this);
		}
		public function gotoAndPlay(label:String):void{
			if(_label==label){
				if(_hasContent){
					return;
				}
			}
			_label=label;
			if(_labelMap==null){
				return;
			}
			var data:FrameDataList=_labelMap.getFrameList(label);
			if(data){
				setFrameData(data);
				play();
			}
		}
		public function setLabelMap(value:LabelsMap):void{
			_labelMap=value;
			if(_label){
				gotoAndPlay(_label);
			}
			_hasContent=true;
		}

		public function get currentLabel() : String {
			return _label;
		}
	}
}
