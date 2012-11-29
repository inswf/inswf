package cn.inswf.describe {
	/**
	 * metadata信息
	 * @author hi
	 */
	public class Metadata extends Desc {
		private var _arg:Arg;
		public var desc:Desc;
		public function Metadata() {
		}
		/**
		 * @return 参数对象
		 */
		public function getArg():Arg{
			if(_arg==null)return new Arg();
			return _arg;
		}
		/**
		 * @param key 参数名
		 * @return 参数值
		 */
		public function getParameter(key:String):String{
			if(_arg==null)return null;
			return _arg.getarg(key);
		}
		public function parse(xml:XML):void{
			this.name=xml.@name;
			var args:XMLList=xml.child("arg");
			var len:int=args.length();
			if(len>0){
				_arg=new Arg();
			}
			var node:XML;
			while(len--){
				node=args[len];
				_arg.setarg(node.@key, node.@value);
			}
		}
	}
}
