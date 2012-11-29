package cn.inswf.describe {
	import cn.inswf.describe.Desc;

	/**
	 * 方法描述
	 * @author li
	 */
	public class Method extends Desc {
		public var isStatic:Boolean;
		public var returnType:String;
		public var parameters:Array;
		public function Method() {
			parameters=[];
		}
		public function parse(xml:XML):void{
			this.name=xml.@name;
			this.returnType=xml.@returnType;
			var list:XMLList=xml.child("parameter");
			var len:int=list.length();
			for(var i:int=0;i<len;i++){
				var param:Parameter=new Parameter();
				param.parse(list[i]);
				parameters.push(param);
			}
		}
	}
}
