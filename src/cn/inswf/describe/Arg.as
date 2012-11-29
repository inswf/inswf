package cn.inswf.describe {
	/**
	 * metadata 参数
	 * @author hi
	 */
	public class Arg {
		private var _dict:Object;
		private var _keys:Array;
		public function setarg(key:String,value:String):void{
			if(_dict==null){
				_dict={};
				_keys=[];
			}
			if(_keys.indexOf(key)==-1){
				_dict[key]=value;
				_keys.push(key);
			}
		}
		/**
		 * @param key 参数
		 * @return 值
		 */
		public function getarg(key:String):String{
			if(_dict){
				return _dict[key];
			}
			return null;
		}
		/**
		 * @return 所有键
		 */
		public function getKeys():Array{
			return _keys;
		}
		/**
		 * @return 所有值
		 */
		public function getValues():Array{
			if(_keys==null)return null;
			var len:int=_keys.length;
			var values:Array=[];
			while(len--){
				values.push(this.getarg(_keys[len]));
			}
			return values;
		}
	}
}
