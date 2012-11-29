package cn.inswf.ui 
{
	import flash.display.Graphics;
	/**
	 * ...
	 * @author liwei
	 */
	public class GraphicsDraw
	{
		
		public function GraphicsDraw() 
		{
			throw new Error("绘图类");
		}
		public static function drawRoundRect(graphics:Graphics, width:int, height:int, tl:int = 0, tr:int = 0, bl:int = 0, br:int = 0):void {
			//画圆角矩形
			with (graphics) {
				moveTo(tl, 0);
				lineTo(width - tr, 0);
				curveTo(width, 0, width, tr);
				lineTo(width, height - br);
				curveTo(width, height, width - br, height);
				lineTo(bl, height);
				curveTo(0, height, 0, height - bl);
				lineTo(0, tl);
				curveTo(0, 0, tl, 0);
			}
		}
		public static function drawIsoRectangle(graphics:Graphics, width:uint, height:uint, depth:uint = 0, color:uint = 0xC2FF86, alpha:Number = 0.8):void {
			//画斜45度矩形
			with (graphics) {
				clear();
				beginFill(color, alpha);
				lineStyle(0, 0, alpha);
				moveTo( -width, -depth);
				lineTo(0, -height - depth);
				lineTo(width, -depth);
				if (depth > 0) {
					lineTo( width, 0);
					lineTo( 0, height);
					lineTo( -width, 0);
					lineTo( -width, -depth);
					endFill();
					lineTo(0, height - depth);	
					lineTo(width, -depth);
					moveTo(0, height - depth);
					lineTo(0, height);
				}else {
					lineTo(0, height - depth);	
					lineTo( -width, -depth);
					endFill();
				}
			}
		}
	}

}