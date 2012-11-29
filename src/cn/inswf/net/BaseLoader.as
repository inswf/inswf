package cn.inswf.net 
{
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author liwei
	 */
	public class BaseLoader extends Loader 
	{
		private var _request:URLRequest;
		public function BaseLoader() 
		{
			
		}
		override public function load(request:URLRequest, context:LoaderContext = null):void 
		{
			_request = request;
			if (request.data is ByteArray) {
				super.loadBytes(request.data as ByteArray, context);
			}else {
				super.load(request, context);
			}
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