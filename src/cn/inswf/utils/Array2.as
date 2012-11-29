package cn.inswf.utils 
{
	/**
	 * ...二维数组
	 * @author liwei
	 */
	public class Array2 
	{
		private var _list:Array;
		private var _width:uint;
		private var _height:uint;
		private var _rotation:int;
		public function Array2(width:uint,height:uint) 
		{
			_list = [];
			_list.length = _width * _height;
			_width = width;_height = height;
		}
		public function getIndex(index:uint):*{
			return _list[index];
		}
		public function setIndex(index:uint, value:*):void {
			_list[index] = value;
		}
		/*数据长度*/
		public function get size():uint {
			return width * height;
		}
		public function get width():uint {
			return _width;
		}
		public function get height():uint {
			return _height;
		}
		/*设置元素的值*/
		public function set(x:uint, y:uint, value:*):void {
			_list[index(x, y)] = value;
		}
		/*返回元素的值*/
		public function get(x:uint, y:uint):* {
			return _list[index(x, y)];
		}
		/*是否包含值*/
		public function contains(value:*):Boolean {
			var len:int = _list.length;
			while (len > 0) {len--;if (_list[len] == value) {return true;}}
			return false;
		}
		/*设置一行的数据*/
		public function setRow(y:uint, ...args):void {
			if (y >= height) {return;}
			var len:uint = width;
			while (len > 0) {len--;_list[index(len, y)] = args[len];}
		}
		/*设置一列的数据*/
		public function setCol(x:uint, ...args):void {
			if (x >= width) {return;}
			var len:uint = height;
			while (len > 0) {len--;_list[index(x, len)] = args[len];}
		}
		/*返回一行的数据*/
		public function getRow(y:uint):Array {
			if (y >= height) {
				return null;
			}
			var start:int = index(0, y);
			return _list.slice(start, start + width);
		}
		/*返回一列的数据*/
		public function getCol(x:uint):Array {
			if (x >= width) {
				return null;
			}
			var arr:Array = [];
			var len:int = height;
			while (len > 0) {len--;arr[len] = _list[index(x, len)];}
			return arr;
		}
		/*删除一行的数据*/
		public function deleteRow(y:uint):void {
			if (y >= height) {
				return;
			}
			_list.splice(index(0, y), width);
			_height--;
		}
		/*删除一列的数据*/
		public function deleteCol(x:uint):void {
			if (x >= width) {
				return;
			}
			var len:int = _height;
			while (len > 0) {len--;_list.splice(index(x, len), 1);}
			_width--;
		}
		/*添加一行的数据*/
		public function appendRow(y:uint, ...args):void {
			if (y > _height) {
				return;
			}
			var len:int = args.length = width;
			var start:int = index(0, y);
			while (len > 0) {len--;_list.splice(start, 0, args[len]);}
			_height++;
		}
		/*添加一列的数据*/
		public function appendCol(x:uint, ...args):void {
			if (x > _width) {
				return;
			}
			var len:int = args.length = height;
			while (len > 0) {len--;_list.splice(index(x, len), 0, args[len]);}
			_width++;
		}
		/*返回所有数据*/
		public function getArray():Array {
			return _list;
		}
		/*清空*/
		public function clear():void {
			_list = new Array(_width * _height);
		}
		public function clone():Array2 {
			var arr:Array2 = new Array2(width, height);
			arr._list = _list.concat();
			return arr;
		}
		public function get90Index(x:int, y:int):int {
			return index(y, _height - x - 1);
		}
		public function get180Index(x:int, y:int):int {
			return index(_width - x - 1, _height - y - 1);
		}
		public function get270Index(x:int, y:int):int {
			return index(_width - y - 1, x);
		}
		/*
		 * 旋转90度
		 * 返回未旋转的实例
		 */
		public function rotation90():Array2 {
			_rotation += 90;_rotation %= 360;
			var arr:Array2 = clone(); var clone:Array = _list.concat();
			//[j][i]=[height-i-1][j]
			for (var i:int = 0; i < _height; i++) {for (var j:int = 0; j < _width; j++) {var source_index:int = get90Index(i, j);var target_index:int = j * _height + i;_list[target_index] = clone[source_index];}}
			convert();
			return arr;
		}
		/*
		 * 旋转180度
		 * 返回未旋转的实例
		 */ 
		public function rotation180():Array2 {
			_rotation += 180;_rotation %= 360;
			var arr:Array2 = clone(); var clone:Array = _list.concat();
			//[i][j]=[height-1-i][width-1-j]
			for (var i:int = 0; i < _width; i++) {for (var j:int = 0; j < _height; j++) {var source_index:int = get180Index(i, j);var target_index:int = index(i, j);_list[target_index] = clone[source_index];}}
			return arr;
		}
		/*
		 * 旋转270度
		 * 返回未旋转的实例
		 */ 
		public function rotation270():Array2 {
			_rotation += 270;_rotation %= 360;
			var arr:Array2 = clone();var clone:Array = _list.concat();
			//[j][i]=[width-j-1][i]
			for (var i:int = 0; i < _height; i++) {for (var j:int = 0; j < _width; j++) {var source_index:int = get270Index(i, j);var target_index:int = j * _height + i;_list[target_index] = clone[source_index];}}
			convert();
			return arr;
		}
		public function get rotation():int {
			return _rotation;
		}
		public function toString():String {
			var s:String = "";
			for (var i:int = 0; i < _height; i++) {var start:int = index(0, i);var arr:Array = _list.slice(start, start + width);s=s.concat("["+arr.join(",") + "]\n");}
			return s;
		}
		private function index(x:uint, y:uint):uint {
			return _width * y + x;
		}
		private function convert():void {
			_width = _width ^ _height;_height = _height ^ _width;_width = _width ^ _height;
		}
	}

}