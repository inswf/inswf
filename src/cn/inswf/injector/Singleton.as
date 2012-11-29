package cn.inswf.injector {
	import cn.inswf.describe.Accessor;
	import cn.inswf.describe.Description;
	import cn.inswf.describe.Metadata;
	import cn.inswf.describe.Method;
	import cn.inswf.describe.Parameter;
	import cn.inswf.describe.Variable;

	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author hi
	 * -keep-as3-metadata+=Inject
	 */
	[Event(name = "instance_create", type = "cn.inswf.injector.SingletonEvent")]
	[Event(name = "instance_notset", type = "cn.inswf.injector.SingletonEvent")]
	public class Singleton extends EventDispatcher {
		private static const singletonDict : Dictionary = new Dictionary();
		private const INJECT : String = "Inject";
		private var _applicationDomain : ApplicationDomain;
		private var _singletonDict : Dictionary;
		private var _definitionEnable : Boolean = true;

		public function Singleton(name : String = "share") {
			_applicationDomain = ApplicationDomain.currentDomain;
			_singletonDict = singletonDict[name];
			if (_singletonDict == null) {
				_singletonDict = singletonDict[name] = new Dictionary();
			}
		}

		public function getInstance(key : *, name : String = "") : * {
			var qcn : String = getQCN(key, name);
			if (qcn == null) {
				return null;
			}
			var obj : * = _singletonDict[qcn];
			if (obj) {
				return obj;
			}

			if (key is String) {
				qcn = (key as String).split("::").join(".");
				if (!_applicationDomain.hasDefinition(qcn)) {
					return null;
				}
				if (_definitionEnable) {
					return getInstance(_applicationDomain.getDefinition(qcn) as Class, name);
				} else {
					return null;
				}
			}
			if (!obj) {
				var desc : Description = getDescription(key);
				if (desc) {
					obj = createInstance(desc, key, name);
					if (obj) {
						var event : SingletonEvent = new SingletonEvent(SingletonEvent.INSTANCE_CREATE);
						event.instance = new Instance(key, name);
						dispatchEvent(event);
					}
				}
				desc = null;
			}
			return obj;
		}

		public function inject(key : *, name : String = "") : * {
			var obj : Object = getInstance(key, name);
			autoinject(obj, key);
			return obj;
		}

		public function hasInstance(key : *, name : String = "") : Boolean {
			var qcn : String = qcn = getQCN(key, name);
			if (qcn) {
				return _singletonDict[qcn] != undefined;
			}
			return false;
		}

		public function setInstance(key : *, value : Object, name : String = "") : void {
			if (key == null) {
				return;
			}
			if (value == null) {
				return;
			}
			var qcn : String;
			if (key is Class) {
				qcn = getQCN(key, name);
			} else if (key is String) {
				qcn = (key as String).split("::").join(".");
				if (name) {
					if (name != "") {
						qcn += "#" + name;
					}
				}
			}
			if (qcn == null) {
				return;
			}
			if (_singletonDict[qcn]) {
				trace("setInstance error:has a value" + qcn + "] use deleteInstance remove a key");
				return;
			}
			_singletonDict[qcn] = value;
		}

		public function deleteInstance(key : *, name : String = "") : void {
			var qcn : String = qcn = getQCN(key, name);
			if (qcn == null) {
				return;
			}
			delete _singletonDict[qcn];
		}

		public function clearInject(key : *, name : String = "") : void {
			var obj : Object = getInstance(key, name);
			var desc : Description = getDescription(key);
			if (desc == null) {
				return;
			}
			var list : Array = desc.getMeta(INJECT);
			if (list == null) return;
			var len : int = list.length;
			for (var i : int = 0;i < len;i++) {
				var meta : Metadata = list[i];
				if (meta.desc is Variable) {
					var variable : Variable = meta.desc as Variable;
					obj[variable.name]=null;
				}
			}
		}

		// // //
		private function getQCN(key : *, name : String = "") : String {
			var qcn : String;
			if (key is Class) {
				qcn = getQualifiedClassName(key);
				qcn = qcn.split("::").join(".");
			} else if (key is String) {
				qcn = (key as String).split("::").join(".");
				if (!_applicationDomain.hasDefinition(qcn)) {
					return null;
				}
				return getQCN(_applicationDomain.getDefinition(qcn) as Class, name);
			}
			if (name) {
				if (name != "") {
					qcn += "#" + name;
				}
			}
			return qcn;
		}

		private function getDescription(key : Class) : Description {
			return Description.getDescription(key);
		}

		private function autoinject(obj : Object, key : Class) : Boolean {
			var desc : Description = getDescription(key);
			if (desc == null) {
				return false;
			}
			var varobj : Object;
			var event : SingletonEvent;
			var list : Array = desc.getMeta(INJECT);
			if (list == null) return true;
			var len : int = list.length;
			var param:Array;
			for (var i : int = 0;i < len;i++) {
				var meta : Metadata = list[i];
				param=null;
				var id:String="";
				if (meta.desc is Variable) {
					var vari : Variable = meta.desc as Variable;
					param= meta.getArg().getValues();
					if (param != null) id = param.join("");
					varobj = getInstance(vari.type, id);
					if (varobj == null) {
						event = new SingletonEvent(SingletonEvent.INSTANCE_NOTSET);
						event.singleton = key;
						event.variable = vari.name;
						event.instance = new Instance(vari.type, id);
						dispatchEvent(event);
						continue;
					}
					if (vari.isStatic) {
						key[vari.name] = varobj;
					} else {
						obj[vari.name] = varobj;
					}
				}else if(meta.desc is Accessor){
					var acc:Accessor=meta.desc as Accessor;
					if(!acc.write)continue;
					param= meta.getArg().getValues();
					if (param != null) id = param.join("");
					varobj = getInstance(acc.type, id);
					if (varobj == null) {
						event = new SingletonEvent(SingletonEvent.INSTANCE_NOTSET);
						event.singleton = key;
						event.variable = vari.name;
						event.instance = new Instance(acc.type, id);
						dispatchEvent(event);
						continue;
					}
					if (acc.isStatic) {
						key[vari.name] = varobj;
					} else {
						obj[acc.name] = varobj;
					}
				}
			}
			return true;
		}

		private function createInstance(desc : Description, key : Class, name : String = "") : * {
			if (desc == null) {
				return;
			}
			var obj : Object;
			var conlist : Array = desc.getMeta("Constructor");
			var constructor : Array;
			if (conlist != null) {
				if (conlist.length > 0) {
					var meta : Metadata = conlist[0];
					var method : Method = meta.desc as Method;
					if (method == null) return null;
					var params : Array = method.parameters;
					if (params != null) {
						var len : int = params.length;
						constructor = [];
						for (var i : int = 0;i < len;i++) {
							var par : Parameter = params[i];
							if(par.optional==false){
								constructor.push(par.type);
							}
						}
					}
				}
			}

			if (constructor) {
				len = constructor.length;
				switch(len) {
					case 1:
						obj = new key(getInstance(constructor[0]));
						break;
					case 2:
						obj = new key(getInstance(constructor[0]), getInstance(constructor[1]));
						break;
					case 3:
						obj = new key(getInstance(constructor[0]), getInstance(constructor[1]), getInstance(constructor[2]));
						break;
					case 4:
						obj = new key(getInstance(constructor[0]), getInstance(constructor[1]), getInstance(constructor[2]), getInstance(constructor[3]));
						break;
					case 5:
						obj = new key(getInstance(constructor[0]), getInstance(constructor[1]), getInstance(constructor[2]), getInstance(constructor[3]), getInstance(constructor[4]));
						break;
					case 6:
						obj = new key(getInstance(constructor[0]), getInstance(constructor[1]), getInstance(constructor[2]), getInstance(constructor[3]), getInstance(constructor[4]), getInstance(constructor[5]));
						break;
					case 7:
						obj = new key(getInstance(constructor[0]), getInstance(constructor[1]), getInstance(constructor[2]), getInstance(constructor[3]), getInstance(constructor[4]), getInstance(constructor[5]), getInstance(constructor[6]));
						break;
					case 8:
						obj = new key(getInstance(constructor[0]), getInstance(constructor[1]), getInstance(constructor[2]), getInstance(constructor[3]), getInstance(constructor[4]), getInstance(constructor[5]), getInstance(constructor[6]), getInstance(constructor[7]));
						break;
					case 9:
						obj = new key(getInstance(constructor[0]), getInstance(constructor[1]), getInstance(constructor[2]), getInstance(constructor[3]), getInstance(constructor[4]), getInstance(constructor[5]), getInstance(constructor[6]), getInstance(constructor[7]), getInstance(constructor[8]));
						break;
					case 10:
						obj = new key(getInstance(constructor[0]), getInstance(constructor[1]), getInstance(constructor[2]), getInstance(constructor[3]), getInstance(constructor[4]), getInstance(constructor[5]), getInstance(constructor[6]), getInstance(constructor[7]), getInstance(constructor[8]), getInstance(constructor[9]));
						break;
					case 0:
						obj = new key();
						break;
				}
				constructor = null;
			} else {
				obj = new key();
			}
			_singletonDict[getQCN(key, name)] = obj;
			autoinject(obj, key);
			return obj;
		}

		public function set definitionEnable(definitionEnable : Boolean) : void {
			_definitionEnable = definitionEnable;
		}
	}
}
