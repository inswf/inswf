package cn.inswf.display {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;

	/**
	 * @author li
	 */
	public class DisplayContainer extends BitmapContainer {
		private var _bmd:BitmapData;
		private var _max:Matrix;
		public function DisplayContainer() {
			_bmd=new BitmapData(1, 1,true,0);
			_max=new Matrix();
		}
		override protected function getPixelColor(target : DisplayObject, x : Number, y : Number) : uint {
			_bmd.setPixel32(0, 0, 0x00000000);
			_max.tx=-x;
			_max.ty=-y;
			_bmd.draw(target,_max);
			return _bmd.getPixel32(0, 0) & 0xFF;
		}
	}
}
