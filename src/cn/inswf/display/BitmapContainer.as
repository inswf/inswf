package cn.inswf.display {
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	[Event(name="target_Click", type = "cn.inswf.display.ContainerEvent")]
	[Event(name="target_mouse_over", type="cn.inswf.display.ContainerEvent")]
	[Event(name="target_mouse_out", type="cn.inswf.display.ContainerEvent")]
	[Event(name="target_mouse_down", type="cn.inswf.display.ContainerEvent")]
	[Event(name="target_mouse_up", type="cn.inswf.display.ContainerEvent")]
	/**
	 * @author hi
	 */
	public class BitmapContainer extends Sprite {
		protected var _threshold : uint = 1;
		protected var _active : DisplayObject;
		protected var _rect:Rectangle;
		protected var _tmpList:Array;
		protected var _tmpDisplayObject:DisplayObject;
		public function BitmapContainer() {
			mouseChildren = false;
		}

		override public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			if (type == ContainerEvent.MOUSE_OVER || type == ContainerEvent.MOUSE_OUT) {
				super.addEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
			} else if (type == ContainerEvent.CLICK) {
				super.addEventListener(MouseEvent.CLICK, mouseHandler);
			} else if (type == ContainerEvent.MOUSE_DOWN) {
				super.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			} else if (type == ContainerEvent.MOUSE_UP) {
				super.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			}
		}

		override public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			if ((!hasEventListener(ContainerEvent.MOUSE_OVER)) && (!hasEventListener(ContainerEvent.MOUSE_OUT))) {
				super.removeEventListener(Event.ENTER_FRAME, check);
				super.removeEventListener(MouseEvent.MOUSE_OVER, mouseHandler, true);
				super.removeEventListener(MouseEvent.MOUSE_OUT, mouseHandler, useCapture);
			}
			super.removeEventListener(type, listener, useCapture);
			if (type == ContainerEvent.CLICK) {
				super.removeEventListener(MouseEvent.CLICK, mouseHandler, useCapture);
			} else if (type == ContainerEvent.MOUSE_DOWN) {
				super.removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler, useCapture);
			} else if (type == ContainerEvent.MOUSE_UP) {
				super.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler, useCapture);
			}
		}

		private function check(event : Event = null) : void {
			var target : DisplayObject;
			var e:ContainerEvent;
			var mx:Number=this.mouseX;
			var my:Number=this.mouseY;
			target = getTarget(mx, my);
			if (target) {
				if (_active != target) {
					if (_active != null) {
						if (hasEventListener(ContainerEvent.MOUSE_OUT)) {
							e=new ContainerEvent(ContainerEvent.MOUSE_OUT, _active,mx,my);
							e.under=getTargets(mx,my);
							dispatchEvent(e);
						}
					}
				}
				if (hasEventListener(ContainerEvent.MOUSE_OVER)) {
					if (target != _active) {
						_active = target;
						e=new ContainerEvent(ContainerEvent.MOUSE_OVER, _active,mx,my);
						e.under=getTargets(mx,my);
						dispatchEvent(e);
					}
				}
			} else {
				if (_active != null) {
					if (hasEventListener(ContainerEvent.MOUSE_OUT)) {
						e=new ContainerEvent(ContainerEvent.MOUSE_OUT, _active,mx,my);
						e.under=getTargets(mx,my);
						dispatchEvent(e);
					}
					_active = null;
				}
			}
		}

		private function mouseHandler(e : MouseEvent) : void {
			var type : String = e.type;
			var target : DisplayObject;
			var event:ContainerEvent;
			var ex:Number=e.localX;
			var ey:Number=e.localY;
			if (type == MouseEvent.MOUSE_OVER) {
				check();
				super.addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
				super.addEventListener(Event.ENTER_FRAME, check);
			} else if (type == MouseEvent.MOUSE_OUT) {
				if (_active) {
					event=new ContainerEvent(ContainerEvent.MOUSE_OUT, _active,ex,ey,e.relatedObject,e.ctrlKey,e.altKey,e.shiftKey,e.buttonDown,e.delta);
					event.under=getTargets(ex,ey);
					dispatchEvent(event);
				}
				_active = null;
				super.removeEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
				super.removeEventListener(Event.ENTER_FRAME, check);
			} else if (type == MouseEvent.MOUSE_DOWN) {
				target = getTarget(e.localX, e.localY);
				event=new ContainerEvent(ContainerEvent.MOUSE_DOWN, target,ex,ey,e.relatedObject,e.ctrlKey,e.altKey,e.shiftKey,e.buttonDown,e.delta);
				event.under=getTargets(ex,ey);
				dispatchEvent(event);
			} else if (type == MouseEvent.MOUSE_UP) {
				target = getTarget(e.localX, e.localY);
				event=new ContainerEvent(ContainerEvent.MOUSE_UP, target,ex,ey,e.relatedObject,e.ctrlKey,e.altKey,e.shiftKey,e.buttonDown,e.delta);
				event.under=getTargets(ex,ey);
				dispatchEvent(event);
			} else if (type == MouseEvent.CLICK) {
				target = getTarget(e.localX, e.localY);
				event=new ContainerEvent(ContainerEvent.CLICK, target,ex,ey,e.relatedObject,e.ctrlKey,e.altKey,e.shiftKey,e.buttonDown,e.delta);
				event.under=getTargets(ex,ey);
				dispatchEvent(event);
			}
		}
		
		protected function getTarget(x : Number = 0, y : Number = 0,threshold:int=-1) : DisplayObject {
			if(threshold<0){
				threshold=_threshold;
			}
			var len : int = numChildren;
			while (len--) {
				_tmpDisplayObject = getChildAt(len);
				if(getTargetInView(_tmpDisplayObject,x,y,threshold)){
					return _tmpDisplayObject;
				}
			}
			return null;
		}
		protected function getTargetInView(target:DisplayObject,x:Number,y:Number,threshold:int=-1):Boolean{
			if(target==null)return false;
			if(threshold<0){
				threshold=_threshold;
			}
			_rect=target.getRect(this);
			var left:Number=_rect.left;
			var top:Number=_rect.top;
			if (x >= left && y >= top) {
				if (x <= _rect.right && y <= _rect.bottom) {
					var color : uint = getPixelColor(target, x-left, y-top);
					if (color < threshold) {
						return false;
					}
					return true;
				}
			}
			return false;
		}
		protected function getPixelColor(target:DisplayObject,x:Number,y:Number):uint{
			var sx:Number=target.scaleX;
			var sy:Number=target.scaleY;
			x/=sx;
			y/=sy;
			if(sx<0){
				var w:Number=target.width/sx;
				x=w-x;
			}
			if(sy<0){
				var h:Number=target.height/sy;
				y=h-y;
			}
			if(x<0)x=-x;
			if(y<0)y=-y;
			var bm:Bitmap=(target as Bitmap);
			if(bm==null)return 0;
			var bmd:BitmapData=bm.bitmapData;
			if(bmd==null)return 0;
			return bmd.getPixel32(x, y)>>24 &0xFF;
		}
		
		protected function getTargets(x:Number=0,y:Number=0,threshold:int=-1):Array{
			if(threshold<0){
				threshold=_threshold;
			}
			_tmpList=[];
			var len : int = numChildren;
			while (len--) {
				_tmpDisplayObject = getChildAt(len);
				if(getTargetInView(_tmpDisplayObject, x, y,threshold)){
					_tmpList.push(_tmpDisplayObject);
				}
			}
			return _tmpList;
		}

		

		public function setThreshold(value : uint) : void {
			_threshold = value & 0xFF;
			if (_threshold == 255) {
				_threshold = 256;
			}
		}
		
	}
}
