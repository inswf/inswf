package cn.inswf.ui.button {
	import flash.display.BitmapData;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	/**
	 * @author hi
	 */
	public class ButtonSoul extends Object {
		public static const MOUSE_DOWN:String = "c2b" + MouseEvent.MOUSE_DOWN;
		public static const MOUSE_OUT:String = "c2b" + MouseEvent.MOUSE_OUT;
		public static const MOUSE_UP:String = "c2b" + MouseEvent.MOUSE_UP;
		public static const MOUSE_OVER:String = "c2b" + MouseEvent.MOUSE_OVER;
		public static const MOUSE_CLICK:String = "c2b" + MouseEvent.CLICK;
		//////
		private static const AUTO : String = "auto";
		private static const BUTTON : String = "button";
		private static var _bmd:BitmapData = new BitmapData(1, 1, true, 0);
		protected static var _mat:Matrix = new Matrix();
		private static var _rect:Rectangle = new Rectangle(0, 0, 1, 1);
		private static var _stage:Stage;
		/////////////////////
		private var _button:IButton;
		private var _target:InteractiveObject;
		private var _enable:Boolean = true;
		private var _overEnable:Boolean;
		private var _checkShape:Boolean;
		private var _buttonMode:Boolean;
		private var _doubleClickTime:Number = 200;
		private var _lastDown:Number = 0;
		private var _isdown:Boolean = false;
		private var _isover:Boolean = false;
		private var _currentStatus:String = MouseEvent.MOUSE_UP;
		private var _currentEventType:String = MOUSE_UP;
		public function ButtonSoul(target:IButton) {
			setTarget(target);
		}
		public function setTarget(target:IButton = null):void {
			if(_target){
				_target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
				_target.removeEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
			}
			if (target) {
				_button = target;
				_target=target as InteractiveObject;
				if(_target){
					_target.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
					_target.addEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
				}
			}
		}
		public function release():void {
			setTarget();
			enable = false;
			_button = null;
			_target=null;
		}
		public function set enable(value:Boolean):void {
			_enable = value;
			if (_target == null) {
				return;
			}
			if (_enable) {
				_target.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
				_target.addEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
			}else {
				cursor = AUTO;
				if (_target.hasEventListener(MouseEvent.MOUSE_DOWN)) {
					_target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
				}
				if (_target.hasEventListener(MouseEvent.MOUSE_OVER)) {
					_target.removeEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
				}
				if (_target.hasEventListener(MouseEvent.MOUSE_MOVE)) {
					_target.removeEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler);
				}
				if (_target.hasEventListener(MouseEvent.MOUSE_UP)) {
					_target.removeEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
				}
				if (_target.hasEventListener(MouseEvent.MOUSE_OUT)) {
					_target.removeEventListener(MouseEvent.MOUSE_OUT, mouseEventHandler);
				}
			}
		}
		public function get enable():Boolean {
			return _enable;
		}
		public function set overEnable(value:Boolean):void {
			_overEnable = value;
		}
		public function get overEnable():Boolean {
			return _overEnable;
		}
		public function get buttonMode():Boolean 
		{
			return _buttonMode;
		}
		public function set buttonMode(value:Boolean):void 
		{
			if (value == false) {
				cursor = AUTO;
			}
			_buttonMode = value;
		}
		public function set doubleClickTime(value:Number):void {
			_doubleClickTime = value;
		}
		public function set checkShape(value:Boolean):void {
			_checkShape = value;
		}
		public function get checkShape():Boolean {
			return _checkShape;
		}
		private function mouseEventHandler(e:MouseEvent):void 
		{
			if (_enable == false) {
				return;
			}
			if (_button == null) {
				return;
			}
			var type:String = e.type;
			var target:InteractiveObject = e.currentTarget as InteractiveObject;
			var eventType:String = null;
			var showType:String = type;
			var hit:int;
			switch(type) {
				case MouseEvent.MOUSE_MOVE:
				showType = null;
				if (_checkShape) {
					hit = checkHitTest(e);
					if (hit != 0) {
						if (_isdown) {
							showType = MouseEvent.MOUSE_DOWN;
						}else {
							if (_overEnable) {
								showType = MouseEvent.MOUSE_OVER;
							}
						}
						if (_isover == false) {
							_isover = true;
							eventType = MOUSE_OVER;
						}
						if (_buttonMode) {
							cursor = BUTTON;
						}
					}else {
						if (_isover) {
							_isover = false;
							eventType = MOUSE_OUT;
						}else {
							showType = MouseEvent.MOUSE_UP;
						}
						if (_buttonMode) {
							cursor = AUTO;
						}
					}
				}else {
					if (_buttonMode) {
						cursor = BUTTON;
					}
					if (_overEnable==false) {
						showType = MouseEvent.MOUSE_UP;
					}
				}
				type = _currentStatus;
				break;
				case MouseEvent.MOUSE_OVER:
				target.addEventListener(MouseEvent.MOUSE_OUT, mouseEventHandler);
				target.addEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler);
				if (_overEnable == false) {
					showType = null;
				}
				if (_buttonMode) {
					cursor = BUTTON;
				}
				if (_checkShape) {
					hit = checkHitTest(e);
					if (hit == 0) {
						showType = MouseEvent.MOUSE_UP;
						_isover = false;
					}else {
						_isover = true;
						eventType = MOUSE_OVER;
					}
				}else {
					eventType = MOUSE_OVER;
				}
				if (_isdown) {
					showType = MouseEvent.MOUSE_DOWN;
				}
				break;
				case MouseEvent.MOUSE_OUT:
				if (target.hasEventListener(MouseEvent.MOUSE_OUT)) {
					target.removeEventListener(MouseEvent.MOUSE_OUT, mouseEventHandler);
				}
				if (target.hasEventListener(MouseEvent.MOUSE_MOVE)) {
					target.removeEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler);
				}
				showType = MouseEvent.MOUSE_UP;
				if (_checkShape) {
					if (_isover) {
						eventType = MOUSE_OUT;
					}
				}
				cursor = AUTO;
				if (_buttonMode) {
					if (_isdown) {
						cursor = BUTTON;
					}
				}
				_isover = false;
				break;
				case MouseEvent.MOUSE_UP:
				if (_stage) {
					_stage.removeEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
					_stage = null;
				}
				cursor = AUTO;
				if (_isover) {
					showType = MouseEvent.MOUSE_OVER;
					if (_buttonMode) {
						cursor = BUTTON;
					}
				}
				if (target == _target) {
					hit = checkHitTest(e);
					if (hit != 0) {
						eventType = MOUSE_CLICK;
					}
					if (_checkShape) {
						if (hit != 0) {
							showType = MouseEvent.MOUSE_OVER;
						}
					}
				}
				_isdown = false;
				break;
				case MouseEvent.MOUSE_DOWN:
				_stage = _target.stage;
				_stage.addEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
				if (_checkShape) {
					hit = checkHitTest(e);
					if (hit == 0) {
						return;
					}
				}
				eventType = MOUSE_DOWN;
				_isdown = true;
				var dis:Number = getTimer() - _lastDown;
				_lastDown = getTimer();
				if (dis < _doubleClickTime) {
					var dbe:MouseEvent = getMouseEvent(e, MouseEvent.DOUBLE_CLICK);
					dbe.delta = dis;
					_button.changeEvent(dbe);
				}
				break;
			}
			if (eventType != null) {
				if (_currentEventType != eventType) {
					_currentEventType = eventType;
					_button.changeEvent(new MouseEvent(_currentEventType));
				}
			}
			if (showType) {
				if (_currentStatus != showType) {
					_currentStatus = showType;
					_button.changeEvent(new MouseEvent(_currentStatus));
				}
			}
		}
		private function checkHitTest(e:MouseEvent):uint {
			matrixReset();
			_mat.tx = -_target.mouseX;
			_mat.ty = -_target.mouseY;
			_bmd.lock();
			_bmd.setPixel32(0, 0, 0);
			_bmd.draw(_target, _mat, null, null, _rect);
			_bmd.unlock();
			var color:uint = _bmd.getPixel32(0, 0);
			return color;
		}
		private function matrixReset():void {
			_mat.a = _mat.d = 1;
			_mat.tx=_mat.ty=_mat.b = _mat.c = 0;
		}
		private function getMouseEvent(e:MouseEvent, type:String):MouseEvent {
			e=new MouseEvent(type, e.bubbles, e.cancelable, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta);
			return e;
		}
		private function set cursor(cursor:String):void {
			Mouse.cursor = cursor;
		}
	}
}
