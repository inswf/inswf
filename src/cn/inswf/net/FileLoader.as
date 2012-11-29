package cn.inswf.net {
	import flash.utils.ByteArray;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	/**
	 * @author hi
	 */
	public class FileLoader{
		private var _stream:StreamQueue;
		private var _map:Dictionary;
		public function FileLoader() {
			_map=new Dictionary();
			_stream=new StreamQueue();
			_stream.addEventListener(Event.COMPLETE, streamcomplete);
			_stream.addEventListener(ProgressEvent.PROGRESS, streamprogress);
			_stream.addEventListener(IOErrorEvent.IO_ERROR, streamiohandler);
		}
		public function load(url:String):File{
			var list:Array=_map[url];
			if(_map[url]==undefined){
				list=_map[url]=[];
				_stream.load(new URLRequest(url));
			}
			var file:File=new File(url);
			list.push(file);
			return file;
		}
		private function streamiohandler(event : IOErrorEvent) : void {
			action(event);
		}

		private function streamprogress(event : ProgressEvent) : void {
			action(event);
		}

		private function streamcomplete(event : Event) : void {
			action(event);
		}
		private function action(event:Event):void{
			var url:String=_stream.getURLRequest().url;
			var list:Array=_map[url];
			if(list==null){
				return;
			}
			var len:int=list.length;
			var progress:Boolean=event.type==ProgressEvent.PROGRESS;
			var data:ByteArray=null;
			if(progress){
				data=_stream.getBytes();
			}
			while(len--){
				var file:File=list[len];
				if(progress){
					file.bytes=data;
				}
				file.dispatchEvent(event);
			}
		}
	}
}
