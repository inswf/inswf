package cn.inswf.injector {
	/**
	 * @author hi
	 */
	public class Instance {
		public var key:*;
		public var name:String = "";
		public function Instance(key:*=null, name:String = "") {
			this.key = key;
			this.name = name;
		}
		public function toString() : String {
			return "Instance["+String(key)+","+name+"]";
		}
	}
}
