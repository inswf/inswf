package cn.inswf.utils {
	import flash.display.DisplayObjectContainer;
	/**
	 * @author hi
	 */
	public class DisplayObjectUtil {
		public static function removeAll(target:DisplayObjectContainer):void{
			if(target==null){
				return;
			}
			var len:int=target.numChildren;
			while(len--){target.removeChildAt(len);}
		}
	}
}
