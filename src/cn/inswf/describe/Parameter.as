package cn.inswf.describe {
	/**
	 * 方法参数
	 * @author li
	 */
	public class Parameter {
		public var type:String;
		public var optional:Boolean;
		public function parse(xml:XML):void{
			this.optional=xml.@optional=="true";
			this.type=xml.@type;
		}
	}
}
