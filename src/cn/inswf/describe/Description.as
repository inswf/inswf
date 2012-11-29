package cn.inswf.describe {
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	/**
	 * 类描述信息
	 * @author hi
	 */
	public class Description extends Object {
		private static const _dict : Dictionary = new Dictionary();
		private var _metaList : Array;
		private var _metaDict : Dictionary;
		private var _metaNameList : Array;
		public function Description() {
			_metaList = [];
			_metaDict = new Dictionary();
			_metaNameList = [];
		}
		/**
		 * @param name 标签名
		 * @return 返回使用当前标签的列表
		 */
		public function getMeta(name : String) : Array {
			return _metaDict[name];
		}
		/**
		 * @param name 标签名
		 * @return 是否有此标签
		 */

		public function hasMeta(name : String) : Boolean {
			return _metaDict[name] != null;
		}
		/**
		 * @return 返回所有使用标签
		 */

		public function getMetaNames() : Array {
			return _metaNameList.concat();
		}
		/**
		 * @param value 类
		 * @return 当前类的描述
		 */

		public static function getDescription(value : *,save:Boolean=true) : Description {
			var qcn:String=getQualifiedClassName(value);
			var desc : Description = _dict[qcn];
			if (desc != null) return desc;
			desc = new Description();
			desc.parse(describeType(value));
			if(save)
			{
				_dict[qcn] = desc;
			}
			return desc;
		}
		/**
		 * @param value 删除的类
		 *
		 */

		public static function deleteDescription(value : *) : void {
			delete _dict[getQualifiedClassName(value)];
		}

		private function parse(xml : XML) : void {
			var node : XML;
			var nodelist : XMLList;
			var len : int;
			var isclass:Boolean;
			var factory : XMLList = xml.child("factory");
			isclass=factory.length()>0;
			if(isclass){
				nodelist = factory.child("extendsClass");
				if (xml.@name != "Object" && nodelist.length() == 0) {
					// interface
					return;
				}
			}
			var variablelist : XMLList;
			variablelist = xml.child("variable");
			len = variablelist.length();
			var variable : Variable;
			while (len--) {
				node = variablelist[len];
				nodelist = node.child("metadata");
				if (nodelist.length() > 0) {
					variable = new Variable();
					variable.isStatic = isclass;
					variable.parse(node);
					createMetadata(nodelist, variable);
				}
			}
			if(isclass){
				variablelist = factory.child("variable");
				len = variablelist.length();
				while (len--) {
					node = variablelist[len];
					nodelist = node.child("metadata");
					if (nodelist.length() > 0) {
						variable = new Variable();
						variable.parse(node);
						createMetadata(nodelist, variable);
					}
				}
			}
				
			variablelist = null;
			var accessorlist : XMLList;

			accessorlist = xml.child("accessor");
			var acessor : Accessor;
			len = accessorlist.length();
			while (len--) {
				node = accessorlist[len];
				nodelist = node.child("metadata");
				if (nodelist.length() > 0) {
					acessor = new Accessor();
					acessor.isStatic = isclass;
					acessor.parse(node);
					createMetadata(nodelist, acessor);
				}
			}
			
			if(isclass){
				accessorlist = factory.child("accessor");
				len = accessorlist.length();
				while (len--) {
					node = accessorlist[len];
					nodelist = node.child("metadata");
					if (nodelist.length() > 0) {
						acessor = new Accessor();
						acessor.parse(node);
						createMetadata(nodelist, acessor);
					}
				}
			}
			accessorlist = null;
			var nethodlist : XMLList;
			var method : Method;

			nethodlist = xml.child("method");
			len = nethodlist.length();
			while (len--) {
				node = nethodlist[len];
				nodelist = node.child("metadata");
				if (nodelist.length() > 0) {
					method = new Method();
					method.isStatic = isclass;
					method.parse(node);
					createMetadata(nodelist, method);
				}
			}
			if(isclass){
				nethodlist = factory.child("method");
				len = nethodlist.length();
				while (len--) {
					node = nethodlist[len];
					nodelist = node.child("metadata");
					if (nodelist.length() > 0) {
						method = new Method();
						method.parse(node);
						createMetadata(nodelist, method);
					}
				}
			}
			if(isclass){
				nethodlist = factory.child("constructor");
			}else{
				nethodlist = xml.child("constructor");
			}
			
			len = nethodlist.length();
			while (len--) {
				node = nethodlist[len];
				var constructor:XML=<method name="Constructor"  returnType="void"></method>;
				constructor.appendChild(node.children());
				constructor.appendChild(<metadata name="Constructor"/>);
				
				method = new Method();
				method.parse(constructor);
				nodelist = constructor.child("metadata");
				if (nodelist.length() > 0) {
					createMetadata(nodelist, method);
				}
			}
			nethodlist=null;
			node=null;
		}

		private function createMetadata(xml : XMLList, desc : Desc) : void {
			var len : int = xml.length();
			while (len--) {
				var meta : Metadata = new Metadata();
				meta.parse(xml[len]);
				meta.desc = desc;
				_metaList.push(meta);
				var n : String = meta.name;
				var list : Array = _metaDict[n];
				if (list == null) {
					list = _metaDict[n] = [];
					_metaNameList.push(n);
				}
				list.push(meta);
			}
		}
//		private function createDummyInstance(key : Class, len : int) : void {
//			try {
//				switch(len) {
//					case 1:
//						new key(null);
//						break;
//					case 2:
//						new key(null, null);
//						break;
//					case 3:
//						new key(null, null, null);
//						break;
//					case 4:
//						new key(null, null, null, null);
//						break;
//					case 5:
//						new key(null, null, null, null, null);
//						break;
//					case 6:
//						new key(null, null, null, null, null, null);
//						break;
//					case 7:
//						new key(null, null, null, null, null, null, null);
//						break;
//					case 8:
//						new key(null, null, null, null, null, null, null, null);
//						break;
//					case 9:
//						new key(null, null, null, null, null, null, null, null, null);
//						break;
//					case 9:
//						new key(null, null, null, null, null, null, null, null, null, null);
//						break;
//				}
//			} catch (e : Error) {
//			}
//		}
	}
}
