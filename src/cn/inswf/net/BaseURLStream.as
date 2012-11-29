package cn.inswf.net 
{
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author liwei
	 */
	public class BaseURLStream extends URLStream 
	{
		private var _request:URLRequest;
		public function BaseURLStream() 
		{
			
		}
		override public function load(request:URLRequest):void 
		{
			super.load(request);
			if (request != null) {
				_request = request;
			}
		}
		public function getBytes():ByteArray {
			var temp:ByteArray = new ByteArray();
			readBytes(temp, 0, bytesAvailable);
			return temp;
		}
		public function getURLRequest():URLRequest 
		{
			if (_request == null) {
				_request = new URLRequest();
			}
			return _request;
		}
	}

}