package cn.inswf.net 
{
	import flash.system.LoaderContext;
	import cn.inswf.net.LoaderQueue;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	/**
	 * ...位图加载器
	 * @author liwei
	 */
	public class BitmapLoader 
	{
		private var _loader:LoaderQueue;
		private var _bitmapDict:Dictionary;
		private var _bitmapDataDict:Dictionary;
		public function BitmapLoader(count:uint=10) 
		{
			_loader = new LoaderQueue(count);
			reset();
			_loader.addEventListener(Event.COMPLETE, loader_complete);
			_loader.addEventListener(ProgressEvent.PROGRESS, loader_progress);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioError);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_securityError);
		}
		public function setBitmapData(name:String, bitmapdata:BitmapData):void {
			_bitmapDataDict[name] = bitmapdata;
		}
		public function getBitmapData(name:String):BitmapData {
			return _bitmapDataDict[name] as BitmapData;
		}
		public function fill(bitmap:Bitmap,url:String):void{
			var bmd:BitmapData = _bitmapDataDict[url];
			if (bmd != null) {
				var w:Number = bitmap.width;
				var h:Number = bitmap.height;
				var sx:Number=bitmap.scaleX;
				var sy:Number=bitmap.scaleY;
				bitmap.bitmapData = bmd;
				bitmap.width = w > 0?w:bmd.width;
				bitmap.height = h > 0?h:bmd.height;
				bitmap.scaleX=sx;
				bitmap.scaleY=sy;
				bitmap.addEventListener(Event.ENTER_FRAME, bitmap_enterFrame);
			}
		}
		public function load(request:URLRequest, bitmap:Bitmap, loadercontext:LoaderContext=null,priority:Boolean = false):void {
			var url:String = request.url;
			if (bitmap == null) {
				return;
			}
			var has:Boolean = _bitmapDataDict[url] != undefined;
			if (has) {
				if (_bitmapDataDict[url] != true) {
					fill(bitmap,url);
					return;
				}
			}
			_bitmapDataDict[url] = true;
			var list:Vector.<Bitmap> = _bitmapDict[url];
			if (list == null) {
				list = _bitmapDict[url] = new Vector.<Bitmap>();
			}
			if(list.indexOf(bitmap)!=-1){
				return;
			}
			list.push(bitmap);
			if (!has) {
				_loader.load(request, loadercontext, priority);
			}
		}
		
		private function bitmap_enterFrame(e:Event):void 
		{
			var bitmap:Bitmap = e.target as Bitmap;
			bitmap.removeEventListener(Event.ENTER_FRAME, bitmap_enterFrame);
			bitmap.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function dispatch(e:Event):void {
			var request:URLRequest = _loader.getURLRequest();
			var url:String = request.url;
			var list:Vector.<Bitmap> = _bitmapDict[url];
			if (list == null) {
				return;
			}
			var bmd:BitmapData;
			if (e.type == Event.COMPLETE) {
				var content:Bitmap = _loader.getCurrent().content as Bitmap;
				if (content == null) {
					list.length = 0;
					list = null;
					delete _bitmapDict[url];
					return;
				}
				bmd = content.bitmapData;
			}
			var len:int = list.length;
			while (len--) {
				var bitmap:Bitmap = list[len];
				if (bitmap == null) {
					continue;
				}
				if (e is ErrorEvent) {
					bitmap.bitmapData = null;
					continue;
				}
				if (e.type == Event.COMPLETE) {
					var w:Number = bitmap.width;
					var h:Number = bitmap.height;
					var sx:Number=bitmap.scaleX;
					var sy:Number=bitmap.scaleY;
					bitmap.bitmapData = bmd;
					_bitmapDataDict[url] = bmd;
					if(sx!=1){
						bitmap.scaleX=sx;
					}else{
						if(w>0){
							bitmap.scaleX=w/bmd.width;
						}
					}
					if(sy!=1){
						bitmap.scaleY=sy;
					}else{
						if(h>0){
							bitmap.scaleY=h/bmd.height;
						}
					}
				}
				if (bitmap.hasEventListener(e.type)) {
					bitmap.dispatchEvent(e);
				}
			}
			if (e.type!=ProgressEvent.PROGRESS) {
				list.length = 0;
				list = null;
				delete _bitmapDict[url];
			}
		}
		private function loader_securityError(e:SecurityErrorEvent):void 
		{
			dispatch(e);
		}
		
		private function loader_ioError(e:IOErrorEvent):void 
		{
			dispatch(e);
		}
	
		private function loader_progress(e:ProgressEvent):void 
		{
			dispatch(e);
		}
		
		private function loader_complete(e:Event):void 
		{
			dispatch(e);
		}
		public function reset():void{
			_bitmapDataDict=new Dictionary(true);
			_bitmapDict=new Dictionary(true);
		}
	}

}