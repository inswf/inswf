package cn.inswf.display.sheet {
	import flash.display.Bitmap;
	import cn.inswf.utils.BitmapDataUtil;

	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author hi
	 */
	public class FrameData extends Bitmap {
		public static const PNG:int=0;//不处理透明
		public static const JPG:int=1;//处理jpg透明
		public var type:int;
		public var delay:int;
		public var src:String;
		public var data:BitmapData;
		public function FrameData() {
			this.addEventListener(Event.COMPLETE, activehandler);
		}
		public function removeCompleteEvent():void{
			activehandler();
		}
		private function activehandler(event : Event=null) : void {
			this.removeEventListener(Event.COMPLETE, activehandler);
			var bmd:BitmapData=this.bitmapData;
			if(bmd==null){
				return;
			}
			data=bmd;
			if(type==JPG){
				var w:int=bmd.width;
				var h:int=bmd.height;
				var xinc:int=w*0.5;
				data=new BitmapData(xinc, h);
				data.draw(bmd);
				data.copyChannel(bmd, new Rectangle(xinc,0,xinc,h), new Point(), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
			}
			var rect:Rectangle=BitmapDataUtil.getOpaque(data);
			if(rect.width<1 || rect.height<1){
				return;
			}
			data=BitmapDataUtil.trim(data, rect);
			this.x-=rect.left;
			this.y-=rect.top;
			this.bitmapData=data;
			src=null;
		}
	}
}
