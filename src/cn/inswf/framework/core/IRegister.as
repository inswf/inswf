package cn.inswf.framework.core {
	/**
	 * @author hi
	 */
	public interface IRegister {
		function onRegister():void;
		function onInject(name:String,instance:Object):void;
	}
}
