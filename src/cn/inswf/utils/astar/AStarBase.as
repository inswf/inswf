package cn.inswf.utils.astar {
	import cn.inswf.utils.Array2;

	/**
	 * ...
	 * @author liwei
	 */
	public class AStarBase {
		private var _open : Array;
		// 待查
		private var _closed : Array;
		// 已查
		private var _startNode : PathNode;
		// 起始点
		private var _currentNode : PathNode;
		// 当前点
		private var _endNode : PathNode;
		// 目标点
		private var _map : Array2;
		private var _width : int;
		private var _height : int;
		private var _heuristic : Function = diagonal;
		// private var _heuristic:Function = manhattan;
		// private var _heuristic:Function = euclidian;
		private const _straightCost : Number = 1;
		private const _diagCost : Number = 1.4142136;
		private var _maxVisitCount : uint = 1000;
		// 最大次数
		private var _isSafeBreak : Boolean = false;
		//
		private var _cross : Boolean = true;
		// 斜行
		private var _nodeList : Array = [];

		// 缓存
		public function AStarBase() {
		}

		public function setMaxVisitCount(value : uint) : void {
			_maxVisitCount = value;
		}

		public function set cross(value : Boolean) : void {
			_cross = value;
			if (_cross == true) {
				_heuristic = diagonal;
			} else {
				_heuristic = manhattan;
			}
		}

		public function init() : void {
			_width = getMapWidth();
			_height = getMapHeight();
			_map = new Array2(_width, _height);
			var k : int = 0;
			for (var i : int = 0; i < _width; i++) {
				for (var j : int = 0; j < _height; j++) {
					var node : PathNode = _nodeList[k];
					if (node == null) {
						node = new PathNode();
						_nodeList[k] = node;
					}
					k++;
					node.x = i;
					node.y = j;
					setNodePrototype(node, i, j);
					_map.set(i, j, node);
				}
			}
		}

		public function getPath() : Array {
			var path : Array = [];
			var node : PathNode = _endNode;
			if (node != null) {
				path.push(node);
				while (node != _startNode) {
					node = node.parent;
					path.unshift(node);
				}
			}
			return path;
		}

		public function get isSafeBreak() : Boolean {
			return _isSafeBreak;
		}

		public function search(startx : int, starty : int, endx : int, endy : int) : Boolean {
			if (startx < 0 || starty < 0 || endx < 0 || endy < 0) {
				return false;
			}
			if (startx >= _width || starty >= _height || endx >= _width || endy >= _height) {
				return false;
			}
			_startNode = _map.get(startx, starty) as PathNode;
			_endNode = _map.get(endx, endy) as PathNode;
			if (_startNode == null || _endNode == null) {
				return false;
			}
			if (!_startNode.walkable) {
				return false;
			}
			if (!_endNode.walkable) {
				return false;
			}
			reset();
			_currentNode = _startNode;
			_startNode.h = _heuristic(_startNode);
			_startNode.f = _startNode.g + _startNode.h;
			return continueSearch();
		}

		public function continueSearch() : Boolean {
			_isSafeBreak = false;
			var visitCount : int = 0;
			if (_currentNode == null) {
				return false;
			}
			while (_currentNode != _endNode) {
				visitCount++;
				if (visitCount > _maxVisitCount) {
					_isSafeBreak = true;
					return false;
				}
				var startX : int = _currentNode.x - 1;
				if (startX < 0) {
					startX = 0;
				}
				var endX : int = _currentNode.x + 1;
				if (endX > _width - 1) {
					endX = _width - 1;
				}
				var startY : int = _currentNode.y - 1;
				if (startY < 0) {
					startY = 0;
				}
				var endY : int = _currentNode.y + 1;
				if (endY > _height - 1) {
					endY = _height - 1;
				}
				var x : int = _currentNode.x;
				var y : int = _currentNode.y;
				for (var i : int = startX; i <= endX; i++) {
					for (var j : int = startY; j <= endY; j++) {
						var test : PathNode = _map.get(i, j);
						if (test == _currentNode) {
							continue;
						}
						if (!test.walkable) {
							continue;
						}
						if (_cross == false) {
							var cx : int = i - x;
							var cy : int = j - y;
							var dis : int = cx + cy;
							if (dis < 0) {
								dis = -dis;
							}
							if (dis != 1) {
								continue;
							}
						}
						if (compareNode(_currentNode, test)) {
							continue;
						}
						var node:PathNode;
						node=_map.get(_currentNode.x, test.y);
						if (!node.walkable) {
							continue;
						}
						node=_map.get(test.x, _currentNode.y);
						if (!node.walkable) {
							continue;
						}
						var cost : Number = _straightCost;
						if (!((_currentNode.x == test.x) || (_currentNode.y == test.y))) {
							cost = _diagCost;
						}
						var g : Number = _currentNode.g + cost * test.costMultiplier;
						var h : Number = _heuristic(test);
						var f : Number = g + h;
						if (_open.indexOf(test) != -1 || _closed.indexOf(test) != -1) {
							if (test.f > f) {
								test.f = f;
								test.g = g;
								test.h = h;
								test.parent = _currentNode;
							}
						} else {
							test.f = f;
							test.g = g;
							test.h = h;
							test.parent = _currentNode;
							_open.push(test);
						}
					}
				}
				_closed.push(_currentNode);
				if (_open.length == 0) {
					return false;
				}
				_open.sortOn("f", Array.NUMERIC);
				_currentNode = _open.shift() as PathNode;
				if (_currentNode == null) {
					return false;
				}
			}
			return true;
		}

		protected function getMapWidth() : int {
			// 子类覆盖
			return 0;
		}

		protected function getMapHeight() : int {
			// 子类覆盖
			return 0;
		}

		protected function setNodePrototype(node : PathNode, x : int, y : int) : void {
			// 设置点的信息
		}

		protected function compareNode(current : PathNode, next : PathNode) : Boolean {
			// 比较两个点，如果返回真则中断
			current;next;
			return false;
		}

		private function reset() : void {
			_open = [];
			_closed = [];
			var len : int = _map.size;
			while (len > 0) {
				len--;
				var node : PathNode = _map.getIndex(len) as PathNode;
				if (node) {
					node.f = node.g = node.h = 0;
				}
			}
		}

		private function diagonal(node : PathNode) : Number {
			var dx : Number = node.x - _endNode.x;
			if (dx < 0) {
				dx = -dx;
			}
			var dy : Number = node.y - _endNode.y;
			if (dy < 0) {
				dy = -dy;
			}
			var diag : Number = dx < dy ? dx : dy;
			var straight : Number = dx + dy;
			return _diagCost * diag + _straightCost * (straight - 2 * diag);
		}

		private function manhattan(node : PathNode) : Number {
			var dx : Number = node.x - _endNode.x;
			if (dx < 0) {
				dx = -dx;
			}
			var dy : Number = node.y - _endNode.y;
			if (dy < 0) {
				dy = -dy;
			}
			return dx * _straightCost + dy * _straightCost;
		}
//		private function euclidian(node : PathNode) : Number {
//			var dx : Number = node.x - _endNode.x;
//			var dy : Number = node.y - _endNode.y;
//			return Math.sqrt(dx * dx + dy * dy) * _straightCost;
//		}
	}
}