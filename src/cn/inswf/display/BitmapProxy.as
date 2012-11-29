package cn.inswf.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * @author lee
	 */
	public class BitmapProxy extends Bitmap {
		public static const PI_180:Number=Math.PI/180;
		protected var _width:Number=0;
		protected var _height:Number=0;
		protected var _x:Number=0;
		protected var _y:Number=0;
		protected var _scaleX:Number=1;
		protected var _scaleY:Number=1;
		protected var _registrationX:Number=0;
		protected var _registrationY:Number=0;
		protected var _rotation:Number=0;
		protected var _update:Boolean;
		public function BitmapProxy(bitmapData : BitmapData = null, pixelSnapping : String = "auto", smoothing : Boolean = false) {
			super(bitmapData, pixelSnapping, smoothing);
			if(bitmapData){
				_width=bitmapData.width;
				_height=bitmapData.height;
				_update=true;
				update();
			}
		}
		public function update():void{
			if(!_update)return;
			if(this.bitmapData==null)return;
			var regx:Number=_registrationX*_scaleX;
			var regy:Number=_registrationY*_scaleY;
			var angle:Number=Math.atan2(regy, regx)+_rotation*PI_180;
			var r:Number=Math.sqrt(regx*regx+regy*regy);
			super.x=_x-Math.cos(angle)*r;
			super.y=_y-Math.sin(angle)*r;
			super.scaleX=_scaleX;
			super.scaleY=_scaleY;
			super.rotation=_rotation;
			_update=false;
		}

		override public function set bitmapData(value : BitmapData) : void {
			super.bitmapData = value;
			if(value){
				_width=value.width;
				_height=value.height;
				_update=true;
				update();
			}
		}

		override public function get x() : Number {
			return _x;
		}

		override public function get y() : Number {
			return _y;
		}
		override public function get scaleX() : Number {
			return _scaleX;
		}

		override public function get scaleY() : Number {
			return _scaleY;
		}

		override public function get rotation() : Number {
			return _rotation;
		}

		override public function set x(value : Number) : void {
			_x=value;
			_update=true;
		}

		override public function set y(value : Number) : void {
			_y = value;
			_update=true;
		}

		override public function set width(value : Number) : void {
			_width=value;
			if(bitmapData!=null){
				_scaleX=_width/bitmapData.width;
			}
			_update=true;
		}

		override public function set height(value : Number) : void {
			_height=value;
			if(bitmapData!=null){
				_scaleY=_height/bitmapData.height;
			}
			_update=true;
		}

		override public function set scaleX(value : Number) : void {
			_scaleX = value;
			_update=true;
		}

		override public function set scaleY(value : Number) : void {
			_scaleY = value;
			_update=true;
		}

		override public function set rotation(value : Number) : void {
			_rotation = value;
			_update = true;
		}

		public function get registrationX() : Number {
			return _registrationX;
		}

		public function set registrationX(registrationX : Number) : void {
			_registrationX = registrationX;
			_update=true;
		}

		public function get registrationY() : Number {
			return _registrationY;
		}

		public function set registrationY(registrationY : Number) : void {
			_registrationY = registrationY;
			_update=true;
		}
	}
}
