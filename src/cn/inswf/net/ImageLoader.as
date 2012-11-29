package cn.inswf.net {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	/**
	 * @author li
	 */
	public class ImageLoader {
		private var _loader:LoaderQueue;
		private var _bitmapDict:Dictionary;//加载图片列表
		private var _bitmapDataDict:Dictionary;//位图缓存
		private var _notcacheList:Array;//未缓存的位图
		public function ImageLoader(count:int=10) {
			reset();
			_loader = new LoaderQueue(count);
			_loader.addEventListener(Event.COMPLETE, loader_complete);
			_loader.addEventListener(ProgressEvent.PROGRESS, loader_progress);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioError);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_securityError);
		}
		public function setBitmapData(name:String, bitmapdata:BitmapData,cache:Boolean=true):void {
			_bitmapDataDict[name] = bitmapdata;
			if(!cache){
				addNoCache(name);
			}
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
//				bitmap.smoothing=true;
				bitmap.bitmapData = bmd;
				bitmap.width = w > 0?w:bmd.width;
				bitmap.height = h > 0?h:bmd.height;
				bitmap.scaleX=sx;
				bitmap.scaleY=sy;
				bitmap.addEventListener(Event.ENTER_FRAME, bitmap_enterFrame);
			}
		}
		public function load(request:URLRequest, bitmap:Bitmap, loadercontext:LoaderContext=null,priority:Boolean = false,cache:Boolean=true):void {
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
				if(!cache){
					addNoCache(url);
				}
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
				delete _bitmapDict[url];
				delete _bitmapDataDict[url];
				var content:Bitmap = _loader.getCurrent().content as Bitmap;
				if (content == null) {
					list.length = 0;
					list = null;
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
		private function addNoCache(url:String):void{
			if(_notcacheList.indexOf(url)==-1){
				_notcacheList.push(url);
			}
		}
		public function reset():void{
			_bitmapDataDict=new Dictionary(true);
			_bitmapDict=new Dictionary(true);
			_notcacheList=[];
		}
		public function clearCache():void{
			var len:int=_notcacheList.length;
			while(len--){
				var url:String=_notcacheList[len] as String;
				var value:Object=_bitmapDataDict[url];
				delete _bitmapDataDict[url];
				if(value is BitmapData){
					var bmd:BitmapData=value as BitmapData;
					bmd.dispose();
				}
			}
			
		}
	}
}
