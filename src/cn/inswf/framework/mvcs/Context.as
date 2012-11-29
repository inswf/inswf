package cn.inswf.framework.mvcs {
	import cn.inswf.framework.core.IContext;
	import cn.inswf.framework.core.IRegister;
	import cn.inswf.injector.Instance;
	import cn.inswf.injector.Singleton;
	import cn.inswf.injector.SingletonEvent;

	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;


	/**
	 * @author hi
	 * 
	 */
	public class Context extends Actor implements IContext {
		private static const singleton : Singleton = new Singleton("framework");
		singleton.setInstance(Singleton, singleton);
		singleton.getInstance(Actor);
		private var map_dict : Dictionary;
		private var notset_dict:Dictionary;

		public function Context(container : DisplayObjectContainer) {
			map_dict = new Dictionary();
			notset_dict=new Dictionary();
			singleton.addEventListener(SingletonEvent.INSTANCE_CREATE, createlistener);
			singleton.addEventListener(SingletonEvent.INSTANCE_NOTSET, notsethandler);
			singleton.setInstance(DisplayObjectContainer, container);
			singleton.setInstance(Context, this);
		}

		private function notsethandler(event : SingletonEvent) : void {
			var instance:Instance=event.instance;
			var qcn:String=getQCN(instance.key,instance.name);
			var list:Array=notset_dict[qcn];
			if(list==null){
				list=notset_dict[qcn]=[];
			}
			var notset:NotSet=new NotSet();
			notset.instance=event.singleton;
			notset.variable=event.variable;
			list.push(notset);
			
		}
		public function set definitionEnable(value:Boolean):void{
			singleton.definitionEnable = value;
		}

		private function createlistener(event : SingletonEvent) : void {
			var instance : Instance = event.instance;
			var key : Class = instance.key;
			var name : String = instance.name;
			var has : Boolean;
			var obj : Object;
			var actor : IRegister;
			obj = getInstance(key, name);
			var qn : String = getQCN(key, name);
			if (obj) {
				fillInstance(qn, obj);
				if (obj is IRegister) {
					actor = obj as IRegister;
					actor.onRegister();
				}
			}
			var len:int;
			var list : Array = map_dict[qn];
			if (list == null) {
				return;
			}
			len = list.length;
			while (len--) {
				var _instance : Instance = list[len];
				has = hasInstance(_instance.key, _instance.name);
				if (!has) {
					getInstance(_instance.key, _instance.name);
				}
			}
			delete map_dict[qn];
		}
		private function fillInstance(qcn:String,object:Object):void{
			var len:int;
			var notsetlist:Array=notset_dict[qcn];
			if(notsetlist){
				len=notsetlist.length;
				while(len--){
					var notset:NotSet=notsetlist[len];
					if(notset){
						var key:Object=notset.instance;
						if(key){
							var varname:String=notset.variable;
							if(varname!=null){
								key[varname]=object;
								if (key is IRegister) {
									var actor:IRegister = key as IRegister;
									actor.onInject(varname, object);
								}
							}
						}
						
					}
				}
			}
		}

		protected function getQCN(key : *, name : String = "") : String {
			var qcn : String;
			if (key is Class) {
				qcn = getQualifiedClassName(key);
				qcn = qcn.split("::").join(".");
			} else if (key is String) {
				qcn = (key as String).split("::").join(".");
			}
			if (qcn == null) {
				return null;
			}
			if (name) {
				qcn += name;
			}
			return qcn;
		}

		
		public function linkActor(actor1 : Instance, actor2 : Instance) : Boolean {
			var qcn : String = getQCN(actor1.key, actor1.name);
			if (qcn == null) {
				return false;
			}
			var list : Array = map_dict[qcn];
			if (list == null) {
				list = map_dict[qcn] = [];
			}
			list.push(actor2);
			return true;
		}

//		public function unlinkActor(actor1 : Instance, actor2 : Instance) : void {
//			var qcn : String = getQCN(actor1.key, actor1.name);
//			if (qcn == null) {
//				return;
//			}
//			var list : Array = map_dict[qcn];
//			if (list == null) {
//				return;
//			}
//			var len : int = list.length;
//			while (len--) {
//				var actor : Instance = list[len];
//				if (actor == null) {
//					continue;
//				}
//				if (actor.key == actor2.key) {
//					if (actor.name == actor2.name) {
//						list.splice(len, 1);
//					}
//				}
//			}
//			if (list.length == 0) {
//				delete map_dict[qcn];
//			}
//		}
		
	}
}
