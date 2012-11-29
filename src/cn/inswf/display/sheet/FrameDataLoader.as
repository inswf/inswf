package cn.inswf.display.sheet {
	import cn.inswf.net.StreamQueue;
	import cn.inswf.xml.XmlObject;

	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * @author li
	 * xmldata like this
	 * <data radius="60">
			<bitmaps action="tree" type="0" delay="300">
				<node src="7495.png" x="48" y="177" />
			</bitmaps>
			<bitmaps action="3510" type="0" delay="300">
				<node src="3510.png" x="10" y="91" />
			</bitmaps>
			...
		</data>
	 */
	public class FrameDataLoader {
		private var _mcDict : Dictionary;
		private var _configMap : Dictionary;
		private var _stream : StreamQueue;
		private var _dataDict:Dictionary;

		public function FrameDataLoader(count : int = 10) {
			_mcDict = new Dictionary(true);
			_configMap = new Dictionary(true);
			_dataDict=new Dictionary(true);
			_stream = new StreamQueue(count);
			_stream.addEventListener(Event.COMPLETE, completehandler);
		}
		public function getConfig(url:String):XmlObject{
			return _dataDict[url];
		}
		public function clearConfig():void{
			_configMap = new Dictionary(true);
			_dataDict=new Dictionary(true);
		}
		
		public function setLabelsMap(url:String,value:LabelsMap):LabelsMap{
			_configMap[url] = value;
			return value;
		}

		public  function loadConfig(url : String, mc : BitmapsMovieClip) : void {
			var labelmap : LabelsMap = _configMap[url];
			if (labelmap) {
				mc.setLabelMap(labelmap);
				return;
			}
			var list : Array = _mcDict[url];
			if (list == null) {
				list = _mcDict[url] = [];
				_stream.load(new URLRequest(url));
			}
			list.push(mc);
		}

		public  function setConfig(url : String, value : Object) : void {
			var xml : XmlObject = new XmlObject();
			if (value is XML) {
				xml.parse(value as XML);
			} else if (value is ByteArray) {
				xml.decode(value as ByteArray);
			} else if (value is XmlObject) {
				xml = value as XmlObject;
			}
			_dataDict[url]=xml;
			var pathlist : Array = url.split("/");
			pathlist.pop();
			var path : String = pathlist.join("/") + "/";
			var bitmaps : Array = xml.children;
			var bitmapslen : int = bitmaps.length;
			var labelmap : LabelsMap = new LabelsMap();
			while (bitmapslen--) {
				var bitmap : XmlObject = bitmaps[bitmapslen];
				var action : String = bitmap.getAttribute("action");
				var gx : int = int(bitmap.getAttribute("x"));
				var gy : int = int(bitmap.getAttribute("y"));
				var gdelay : int = int(bitmap.getAttribute("delay"));
				var gtype : int = int(bitmap.getAttribute("type"));
				var nodes : Array = bitmap.children;
				var nodelen : int = nodes.length;
				var framelist : FrameDataList = new FrameDataList();
				for (var i : int = 0;i < nodelen;i++) {
					var node : XmlObject = nodes[i];
					var src : String = path + node.getAttribute("src");
					var x : int;
					var y : int;
					var delay : int;
					var type : int;
					if (node.hasAttributes("x")) {
						x = int(node.getAttribute("x"));
					} else {
						x = gx;
					}
					if (node.hasAttributes("y")) {
						y = int(node.getAttribute("y"));
					} else {
						y = gy;
					}
					if (node.hasAttributes("delay")) {
						delay = int(node.getAttribute("delay"));
					} else {
						delay = gdelay;
					}
					if (node.hasAttributes("type")) {
						type = int(node.getAttribute("type"));
					} else {
						type = gtype;
					}
					var framedata : FrameData = new FrameData();
					framedata.x = x;
					framedata.type = type;
					framedata.y = y;
					framedata.delay = delay;

					framedata.src = src;
					framelist.addFrame(framedata);
				}
				labelmap.addFrameList(action, framelist);
			}
			_configMap[url] = labelmap;
			var list : Array = _mcDict[url];
			delete _mcDict[url];
			if (list == null) {
				return;
			}
			var len : int = list.length;
			while (len--) {
				var mc : BitmapsMovieClip = list[len];
				if (mc) {
					mc.setLabelMap(labelmap);
					if (mc.playing) {
						mc.play();
					}
				}
			}
			list = null;
		}
		private function completehandler(event : Event) : void {
			var request : URLRequest = _stream.getURLRequest();
			var url : String = request.url;
			var data : ByteArray = _stream.getBytes();
			var xml : XmlObject = new XmlObject();
			xml.parse(XML(data));
			if (xml == null) {
				delete _mcDict[url];
				return;
			}
			setConfig(url, xml);
		}
	}
}
