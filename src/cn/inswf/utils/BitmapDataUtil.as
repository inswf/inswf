package cn.inswf.utils {
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author hi
	 */
	public class BitmapDataUtil {
		private static const p:Point = new Point();
		private static const mat:Matrix = new Matrix();
		public static function getOpaque(source:BitmapData,mode:int=1):Rectangle {
			if (source == null) {
				return null;
			}
			var rect:Rectangle;
			if (mode == 1) {
				//把全透明的去掉
				rect=source.getColorBoundsRect(0xFF000000, 0x00000000, false);
			}else {
				//把全不透明的留下
				source.getColorBoundsRect(0xFF000000, 0xFF000000, true);
			}
			return rect;
		}
		public static function trim(source:BitmapData, rect:Rectangle):BitmapData {
			if (source == null) {
				return source;
			}
			if (rect == null) {
				return source;
			}
			var w:int = source.width;
			var h:int = source.height;
			if (rect.x <0) {
				rect.x = 0;
			}
			if (rect.y < 0) {
				rect.y = 0;
			}
			if (rect.width > w) {
				rect.width = w;
			}
			if (rect.height > h) {
				rect.height = h;
			}
			var bmd:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
			bmd.copyPixels(source, rect, p);
			return bmd;
		}
		public static function erase(source:BitmapData,eraseSource:DisplayObject,position:Point=null):void {
			if (position == null) {
				position = p;
			}
			mat.tx = position.x;
			mat.ty = position.y;
			source.draw(eraseSource, mat, null, BlendMode.ERASE);
		}
	}
}
