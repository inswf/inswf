package cn.inswf.xml {
	import flash.utils.ByteArray;

	/**
	 * ...
	 * @author liwei
	 */
	public class XmlObject {
		protected var _name : String;
		protected var _attributes : Object;
		protected var _child : Array;
		protected var _content : String;

		public function XmlObject() {
		}

		public function parse(data : XML=null) : void {
			if(data==null){
				return;
			}
			_child = [];
			_name = data.localName();
			if (_name == null) {
				_content = data.toString();
				return;
			}
			var tempList : XMLList;
			var temp : XML;
			var arr : Array;
			tempList = data.attributes();
			var len : int = tempList.length();
			if (len > 0) {
				_attributes = {};
				for (var i : int = 0; i < len; i++) {
					temp = tempList[i];
					var name : String = temp.name();
					if (_attributes[name] == undefined) {
						_attributes[name] = [];
					}
					arr = _attributes[name];
					arr.push(temp.toString());
				}
			}
			tempList = data.children();
			len = tempList.length();
			if (len > 0) {
				for (var j : int = 0; j < len; j++) {
					temp = tempList[j];
					var obj : XmlObject = new XmlObject();
					obj.parse(temp);
					_child.push(obj);
				}
			}
			temp = null;
			tempList = null;
			arr = null;
		}

		public function encode() : ByteArray {
			var ba : ByteArray = new ByteArray();
			if (!_name) {
				if (_content) {
					ba.writeUTF(_content);
				}
				return ba;
			}
			ba.writeUTF(_name);
			var prototypelen : int = 0;
			var prototypelist : Array = [];
			if (_attributes != null) {
				for (var name:String in _attributes) {
					prototypelist.push(name);
				}
				prototypelen = prototypelist.length;
			}
			ba.writeByte(prototypelen);
			for (var i : int = 0; i < prototypelen; i++) {
				name = prototypelist[i];
				ba.writeUTF(name);
				ba.writeUTF(_attributes[name]);
			}
			var childlen : int = _child.length;
			ba.writeInt(childlen);
			if (childlen > 0) {
				for (var j : int = 0; j < childlen; j++) {
					var child : XmlObject = _child[j] as XmlObject;
					var childba : ByteArray = child.encode();
					ba.writeInt(childba.length);
					ba.writeBytes(childba, 0, childba.length);
				}
			}
			return ba;
		}

		public function decode(data : ByteArray) : Boolean {
			if (data == null) {
				return false;
			}
			if (data.length == 0) {
				return false;
			}
			data.position = 0;
			var str : String = data.readUTF();
			if (!data.bytesAvailable) {
				_content = str;
				return true;
			}
			_name = str;
			var prototypelen : int = data.readByte();
			if (prototypelen > 0) {
				_attributes = {};
				for (var i : int = 0; i < prototypelen; i++) {
					var name : String = data.readUTF();
					var value : String = data.readUTF();
					_attributes[name] = value;
				}
			}
			var childlen : int = data.readInt();
			if (childlen > 0) {
				_child = [];
				for (var j : int = 0; j < childlen; j++) {
					var child : XmlObject = new XmlObject();
					var childdatalen : int = data.readInt();
					var ba : ByteArray = new ByteArray();
					data.readBytes(ba, 0, childdatalen);
					child.decode(ba);
					_child.push(child);
				}
			}
			return true;
		}

		/**
		 * 
		 * @param	attributeName
		 * @return 当前属性值
		 */
		public function getAttribute(attributeName : String) : String {
			if (_attributes == null) {
				return "";
			}
			return _attributes[attributeName];
		}

		public function setAttribute(name : String, value : String) : void {
			if (_attributes == null) {
				_attributes = {};
			}
			_attributes[name] = value;
		}
		public function hasAttributes(name:String):Boolean{
			if (_attributes == null) {
				return false;
			}
			return _attributes[name]!=undefined;
		}

		public function get name() : String {
			return _name;
		}

		public function set name(value : String) : void {
			_name = value;
		}

		public function get children() : Array {
			return _child.concat();
		}

		public function set content(value : String) : void {
			_content = value;
		}

		public function addChild(child : XmlObject) : void {
			if (_child == null) {
				_child = [];
			}
			_child.push(child);
		}

		public function toString() : String {
			if (_name == null) {
				return _content;
			}
			var str : String = "<" + _name;
			var hasattribute : Boolean = false;
			if (_attributes != null) {
				for (var n:String in _attributes) {
					str += " " + n + "=\"" + _attributes[n] + "\"";
					hasattribute = true;
				}
			}
			if (_child == null) {
				//if (!hasattribute) {
					//return "";
				//}
				str += "/>";
				return str;
			}
			var len : int = _child.length;
			if (len > 0) {
				str += ">";
			}
			for (var i : int = 0; i < len; i++) {
				var obj : XmlObject = _child[i];
				str += obj;
			}
			if (_content) {
				if (_content.length == 0) {
					str += " />";
				} else {
					str += ">" + _content + "</" + _name + ">";
				}
			} else {
				if (len == 0) {
					str += " />";
				} else {
					str += "</" + _name + ">";
				}
			}
			return str;
		}
	}
}