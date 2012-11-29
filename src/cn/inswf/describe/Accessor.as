package cn.inswf.describe {
	import cn.inswf.describe.Desc;

	/**
	 * get set 方法
	 * @author li
	 */
	public class Accessor extends Desc {
		public var isStatic:Boolean;
		public var type:String;
		public var read:Boolean;
		public var write:Boolean;
		public function Accessor() {
		}
		public function parse(xml:XML):void{
			this.name=xml.@name;
			var access:String=xml.@access;
			this.type=xml.@type;
			if(access=="readonly"){
				read=true;
			}else if(access=="writeonly"){
				write=true;
			}else if(access=="readwrite"){
				read=true;
				write=true;
			}
		}
	}
}
