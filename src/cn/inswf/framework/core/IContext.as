package cn.inswf.framework.core {
	import cn.inswf.injector.Instance;
	/**
	 * @author hi
	 */
	public interface IContext {
		function linkActor(actor1:Instance,actor2:Instance):Boolean
//		function unlinkActor(actor1:Instance,actor2:Instance):void
	}
}
