package cn.inswf.display.sheet {
	import flash.events.Event;

	/**
	 * @author lee
	 */
	public class MovieClip2BitmapEvent extends Event {
		public static const COMPLETE:String="complete";
		private var _data:Object;
		public function MovieClip2BitmapEvent(type : String,data:Object=null) {
			super(type);
			_data = data;
		}

		public function get data() : Object {
			return _data;
		}
	}
}
