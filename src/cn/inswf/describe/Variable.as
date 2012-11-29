package cn.inswf.describe {
	/**
	 * 成员描述
	 * @author hi
	 */
	public class Variable extends Desc{
		public var type:String;
		public var isStatic:Boolean;
		public function parse(xml:XML):void{
			this.name=xml.@name;
			this.type=xml.@type;
		}
	}
}
