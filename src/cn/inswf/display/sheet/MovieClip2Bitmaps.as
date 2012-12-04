package cn.inswf.display.sheet {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import cn.inswf.display.image.BitmapProxy;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	/**
	 * @author li
	 */
	public class MovieClip2Bitmaps extends EventDispatcher {
		private var _bmd:BitmapData;
		private var _rect:Rectangle;
		private var _matrix:Matrix;
		private var _data:Object;
		private var _mc:MovieClip;
		private var _delay:uint;
		private var _framelist:FrameDataList;
		
		public function MovieClip2Bitmaps() {
			_bmd;
			_matrix=new Matrix();
		}
		public function getFrameListAsync(value:MovieClip,delay:uint=40,frameskip:uint=1,data:Object=null):void{
			if(value==null)return;
			_mc=value;
			_data=data;
			if(_mc.totalFrames==1){
				_framelist=getFrameList(_mc,delay,frameskip);
				dispatchEvent(new MovieClip2BitmapEvent(MovieClip2BitmapEvent.COMPLETE,_data));
				return;
			}
			_framelist=new FrameDataList();
			_delay=delay;
			_mc.addEventListener(Event.ENTER_FRAME, enterframe);
			_mc.gotoAndPlay(1);
		}

		private function enterframe(event : Event) : void {
			var c:int=_mc.currentFrame;
			var t:int=_mc.totalFrames;
			var framedata:FrameData=getFrameData(_mc);
			framedata.delay=_delay;
			_framelist.addFrame(framedata);
			if(c>=t){
				_mc.stop();
				_mc.removeEventListener(Event.ENTER_FRAME, enterframe);
				_mc=null;
				dispatchEvent(new MovieClip2BitmapEvent(MovieClip2BitmapEvent.COMPLETE,_data));
			}
		}
		public function getFrameList(value:MovieClip,delay:uint=40,frameskip:uint=1):FrameDataList{
			//加入比较列表功能。compare
			//如果以前已有bmd一样。则用以前的引用节约内存
			//不知道 compare 的效率怎么样
			var datalist:FrameDataList=new FrameDataList();
			var len:int=value.totalFrames;
			len=len/frameskip;
			var lastbmd:BitmapData;
			for(var i:int=0;i<len;i++){
				value.gotoAndStop(i*frameskip+1);
				var framedata:FrameData=getFrameData(value);
				framedata.delay=delay;
				if(lastbmd!=null){
					if(lastbmd.compare(framedata.bitmapData)==0){
						framedata.bitmapData=lastbmd;
					}
				}
				lastbmd=framedata.bitmapData;
				datalist.addFrame(framedata,i);
			}
			return datalist;
		}
		public function getLabelMap(value:MovieClip,delay:uint=40,frameskip:uint=1):LabelsMap{
			var labelname:String;
			var labels:LabelsMap=new LabelsMap();
			var datalist:FrameDataList=new FrameDataList();
			var len:int=value.totalFrames;
			len=len/frameskip;
			for(var i:int=0;i<len;i++){
				value.gotoAndStop(i*frameskip+1);
				var label:String=value.currentLabel;
				if(label==null){
					continue;
				}
				if(label!=labelname){
					datalist=new FrameDataList();
					labelname=label;
					labels.addFrameList(labelname, datalist);
				}
				var framedata:FrameData=getFrameData(value);
				framedata.delay=delay;
				datalist.addFrame(framedata,i);
			}
			return labels;
		}
		public function getFrameData(value:DisplayObject):FrameData{
			_rect=value.getBounds(value);
			var x:int=Math.round(_rect.left);
			var y:int=Math.round(_rect.top);
			var w:int=_rect.width;
			var h:int=_rect.height;
			if(w==0){
				w=1;
			}
			if(h==0){
				h=1;
			}
			var bmd:BitmapData=new BitmapData(w, h,true,0);
			_matrix.tx=-x;
			_matrix.ty=-y;
			bmd.draw(value,_matrix);
			var framedata:FrameData=new FrameData();
			framedata.x=-x;
			framedata.y=-y;
			framedata.bitmapData=bmd;
			framedata.removeCompleteEvent();
			return framedata;
		}
		public function getBitmap(value:DisplayObject):Bitmap{
			var bitmap:BitmapProxy=new BitmapProxy();
			var framedata:FrameData=getFrameData(value);
			bitmap.bitmapData=framedata.data;
			bitmap.setRegistration(framedata.x, framedata.y);
			return bitmap;
		}

		public function get framelist() : FrameDataList {
			return _framelist;
		}
	}
}
