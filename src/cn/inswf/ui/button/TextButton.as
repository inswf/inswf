package cn.inswf.ui.button {
	import cn.inswf.ui.GraphicsDraw;

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author hi
	 */
	public class TextButton extends Sprite implements IButton {
		private static var _fontColorList:Array = [[0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF], [.7, .5, 0, .3, 0], [0,20, 80, 240,255]];
		private static var _bgColorAlpha:Array = [1, 1, 1];
		private static var _mat:Matrix = new Matrix();
		private static var g_bgColor:Array = [0x0080FF, 0x60AFFF, 0x006CD9];
		private static var g_leftGap:int = 2;
		private static var g_rightGap:int = 2;
		private static var g_topGap:int = 1;
		private static var g_bottomGap:int = 1;
		private static var g_tl:uint = 0;//左上角圆角
		private static var g_tr:uint = 0;
		private static var g_bl:uint = 0;
		private static var g_br:uint = 0;
		private static var g_format:TextFormat;
		private static var g_borderColor:uint = 0x000000;
		private static var g_borderAlpha:Number = 1;
		/////////////////////////////////
		private var _bgColor:Array = [0x00FF80, 0x80FF80, 0x00FF40];
		private var _leftGap:int = 2;
		private var _rightGap:int = 2;
		private var _topGap:int = 1;
		private var _bottomGap:int = 1;
		private var _tl:uint = 0;//左上角圆角
		private var _tr:uint = 0;
		private var _bl:uint = 0;
		private var _br:uint = 0;
		private var _format:TextFormat;
		private var _borderColor:uint = 0x000000;
		private var _borderAlpha:Number = 1;
		
		private var _mouseUpText:String;
		private var _mouseOverText:String;
		private var _mouseDownText:String;
		private var _shapeBG:Shape;
		private var _shapeTOP:Shape;
		protected var _label:TextField = new TextField();
		private var _autoSize:Boolean = true;
		private var _width:int;
		private var _height:int;
		private var _currentLabel:String;
		private var _currentState:String = MouseEvent.MOUSE_UP;
		
		private var _soul:ButtonSoul;
		public function TextButton(upLabel:String, overLabel:String = null, downLabel:String = null)  {
			getStyle(this);
			mouseChildren = false;
			if (upLabel == null) {
				upLabel = "click";
			}
			if (upLabel.length == 0) {
				upLabel = "click";
			}
			if (overLabel == null) {
				overLabel = upLabel;
			}
			if (downLabel == null) {
				downLabel = overLabel;
			}
			var reg:RegExp =/<img.*>/gi;
			upLabel = upLabel.replace(reg, "");
			overLabel = overLabel.replace(reg, "");
			downLabel = downLabel.replace(reg, "");
			_currentLabel=_mouseUpText = upLabel;
			_mouseOverText = overLabel;
			_mouseDownText = downLabel;
			_shapeBG = new Shape(); addChild(_shapeBG);
			addChild(_label); _label.autoSize = "left"; _label.mouseEnabled = false;
			if (_format != null) {
				_label.defaultTextFormat = _format;
			}
			_shapeTOP = new Shape(); addChild(_shapeTOP);
			initSize();
			_soul=new ButtonSoul(this);
			_soul.overEnable=true;
		}

		public function changeEvent(e : MouseEvent) : void {
			_currentState = e.type;
			var type:String = e.type;
			var g:Graphics = _shapeBG.graphics;
			g.clear();
			switch(type) {
				case MouseEvent.MOUSE_DOWN:
				showText(_mouseDownText);
				g.beginFill(_bgColor[2], _bgColorAlpha[2]);
				_label.x += 1;
				_label.y += 2;
				break;
				case MouseEvent.MOUSE_OVER:
				g.beginFill(_bgColor[1], _bgColorAlpha[1]);
				showText(_mouseOverText);
				break;
				default :
				showText(_mouseUpText);
				g.beginFill(_bgColor[0], _bgColorAlpha[0]);
				break;
			}
			GraphicsDraw.drawRoundRect(g, _width, _height, _tl, _tr, _bl, _br);
			g.endFill();
			g = null;
		}
		public function set upLabel(value:String):void {
			_mouseUpText = value;initSize();
		}
		public function set overLabel(value:String):void {
			_mouseOverText = value;initSize();
		}
		public function set downLabel(value:String):void {
			_mouseDownText = value; 
			initSize();
		}
		
		protected function initSize():void {
			if (_autoSize) {
				_width = _height = 0;
				_label.htmlText = _mouseUpText;
				var w:int = _label.width;
				var h:int = _label.height;
				if (w > _width) {
					_width = w;
				}
				if (h > _height) {
					_height = h;
				}
				_label.htmlText = _mouseOverText;
				w = _label.width;
				h = _label.height;
				if (w > _width) {
					_width = w;
				}
				if (h > _height) {
					_height = h;
				}
				_label.htmlText = _mouseDownText;
				w = _label.width;
				h = _label.height;
				if (w > _width) {
					_width = w;
				}
				if (h > _height) {
					_height = h;
				}
				var x1inc:int = _tl > _bl?_tl:_bl;
				var x2inc:int = _tr > _br?_tr:_br;
				x1inc *= .5;
				x2inc *= .5;
				var inc:int = (x1inc + x2inc) * 0.5;
				_width += _leftGap + _rightGap + inc;
				_height += _topGap + _bottomGap + inc;
			}
			resize();
		}
		public function set autoSize(value:Boolean):void {
			_autoSize = value;
			if (_autoSize) {
				initSize();
			}
		}
		override public function get width():Number 
		{
			return _width;
		}
		
		override public function set width(value:Number):void 
		{
			_width = value;
			resize();
			_autoSize = false;
		}
		override public function get height():Number 
		{
			return _height;
		}
		override public function set height(value:Number):void 
		{
			_height = value;
			resize();
			_autoSize = false;
		}
		private function resize():void {
			matrixReset();
			_mat.createGradientBox(_width, _height, Math.PI * 0.5);
			var g:Graphics = _shapeTOP.graphics;
			g.clear();
			g.lineStyle(0, _borderColor, _borderAlpha,true);
			g.beginGradientFill("linear", _fontColorList[0], _fontColorList[1], _fontColorList[2], _mat);
			GraphicsDraw.drawRoundRect(g, _width, _height, _tl, _tr, _bl, _br);
			g.endFill();
			g = null;
			showText(_currentLabel);
			drawBackGround(_currentState);
		}
		protected function matrixReset():void {
			_mat.a = _mat.d = 1;
			_mat.tx=_mat.ty=_mat.b = _mat.c = 0;
		}
		
		
		
		private function showText(label:String):void {
			_currentLabel = label;
			_label.htmlText = label;
			var w:int = _width - _leftGap - _rightGap;
			var h:int = _height - _topGap - _bottomGap;
			_label.x = _leftGap + (w - _label.width) * 0.5;
			_label.y = _topGap + (h - _label.height) * 0.5;
		}
		private function drawBackGround(type:String):void {
			var g:Graphics = _shapeBG.graphics;
			g.clear();
			switch(type) {
				case MouseEvent.MOUSE_DOWN:
				g.beginFill(_bgColor[2], _bgColorAlpha[2]);
				_label.x += 1;
				_label.y += 2;
				break;
				case MouseEvent.MOUSE_OVER:
				g.beginFill(_bgColor[1], _bgColorAlpha[1]);
				break;
				case MouseEvent.MOUSE_OUT:
				case MouseEvent.MOUSE_UP:
				g.beginFill(_bgColor[0], _bgColorAlpha[0]);
				break;
			}
			GraphicsDraw.drawRoundRect(g, _width, _height, _tl, _tr, _bl, _br);
			g.endFill();
			g = null;
		}
		
		public static function setShape(tl:int = 0, tr:int = 0, bl:int = 0, br:int = 0):void {
			g_tl = tl; g_tr = tr; g_bl = bl; g_br = br;
		}
		public static function setButtonColor(up:uint=0x0080FF, over:uint=0x60AFFF, down:uint=0x006CD9):void {
			g_bgColor = [up, over, down];
		}
		public static function setGaps(left:int = 0, right:int = 0, top:int = 0, bottom:int = 0):void {
			g_leftGap = left; g_rightGap = right; g_topGap = top; g_bottomGap = bottom;
		}
		public static function setDefaultTextFormat(value:TextFormat=null):void {
			if (value == null) {
				value = new TextFormat(null, 12, 0x000000, false, false, false);
			}
			g_format = value;
		}
		public static function setBorder(color:uint, alpha:Number):void {
			g_borderColor = color;
			g_borderAlpha = alpha;
		}
		private static function getStyle(t:TextButton):void {
			t._bgColor = g_bgColor;
			t._leftGap = g_leftGap;
			t._rightGap = g_rightGap;
			t._topGap = g_topGap;
			t._bottomGap = g_bottomGap;
			t._tl = g_tl;
			t._tr = g_tr;
			t._bl = g_bl;
			t._br = g_br;
			t._format = g_format;
			t._borderColor = g_borderColor;
			t._borderAlpha = g_borderAlpha;
		}
	}
}
