package cn.inswf.utils 
{
	/**
	 * ...
	 * @author liwei
	 */
	public class ObjectUtil 
	{
		
		public function ObjectUtil() 
		{
			
		}
		public static function hasOwnProperties( target:Object, ...param):Boolean
		{
			//是否包含属性
			var len:uint = param.length;
			for ( var i:uint = 0; i < len;i++ ) {
				if ( !target.hasOwnProperty(param[i]) ) return false;
			}
			return true;
		}
		
		public static function Length( target:Object ):uint
		{
			//属性长度
			var n:uint = 0;
			var val:String;
			for (val in target) n++;
			return n;
		}
		public static function getPropNames(target:Object):Array
		{
			//属性名
			var a:Array = [];
			for (var val:String in target) a.push(val);
			return a;
		}
		public static function getPropValues(target:Object):Array
		{
			//值
			var a:Array = [];
			for each(var val:* in target) a.push(val);
			return a;
		}
	}

}