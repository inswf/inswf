package cn.inswf.utils.astar 
{
	/**
	 * ...
	 * @author liwei
	 */
	public class PathNode
	{
		public var x:int;
		public var y:int;
		public var f:Number;
		public var g:Number;
		public var h:Number;
		public var walkable:Boolean = true;
		public var parent:PathNode;
		public var costMultiplier:Number = 1.0;
		public function PathNode() 
		{
			
		}
		public function toString():String 
		{
			return "[PathNode x=" + x + " y=" + y + "]";
		}
	}
}