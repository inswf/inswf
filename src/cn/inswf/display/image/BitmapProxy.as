package cn.inswf.display.image {
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * @author hi
	 */
	public class BitmapProxy extends Bitmap {
		protected var _width : Number = 0;
		protected var _height : Number = 0;
		protected var _registrationX : Number = 0;
		protected var _registrationY : Number = 0;
		protected var _x : Number = 0;
		protected var _y : Number = 0;
		protected var _scaleX : Number = 1;
		protected var _scaleY : Number = 1;

		public function BitmapProxy(bitmapData : BitmapData = null, pixelSnapping : String = "auto", smoothing : Boolean = false) {
			super(bitmapData, pixelSnapping, smoothing);
		}

		override public function get width() : Number {
			if (bitmapData == null) {
				if (_width > 0) {
					return _width * _scaleX;
				}
				return 0;
			}
			var w:Number=bitmapData.width * _scaleX;
			if(w<0){
				w=-w;
			}
			return w;
		}

		override public function set width(value : Number) : void {
			if (value < 0) {
				value = 0;
			}
			_width = value;
			if (bitmapData) {
				scaleX = value / bitmapData.width;
			}
		}

		override public function get height() : Number {
			if (bitmapData == null) {
				if (_height > 0) {
					return _height * _scaleY;
				}
				return 0;
			}
			var h:Number=bitmapData.height * _scaleY;
			if(h<0){
				h=-h;
			}
			return h;
		}

		override public function set height(value : Number) : void {
			if (value < 0) {
				value = 0;
			}
			_height = value;
			if (bitmapData) {
				scaleY = value / bitmapData.height;
			}
		}

		public function setRegistration(registrationX : Number = 0, registrationY : Number = 0) : void {
			_registrationX = registrationX;
			_registrationY = registrationY;
			scaleX=_scaleX;
			scaleY=_scaleY;
		}
		override public function set scaleX(value : Number) : void {
			if (bitmapData) {
				super.scaleX = value;
			}
			_scaleX = value;
			super.x = -_registrationX * _scaleX + _x;
		}

		override public function set scaleY(value : Number) : void {
			if (bitmapData) {
				super.scaleY = value;
			}
			_scaleY = value;
			super.y = -_registrationY * _scaleY + _y;
		}

		override public function get scaleX() : Number {
			return _scaleX;
		}

		override public function get scaleY() : Number {
			return _scaleY;
		}
		override public function set x(value : Number) : void {
			_x = value;
			super.x = -_registrationX*_scaleX + _x;
		}

		override public function set y(value : Number) : void {
			_y = value;
			super.y = -_registrationY*_scaleY + _y;
		}
		override public function get x() : Number {
			return _x;
		}

		override public function get y() : Number {
			return _y;
		}
	}
}
