package cn.inswf.utils 
{
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author liwei
	 */
	public class StringUtil 
	{
		private static var _byte:ByteArray = new ByteArray();
		public function StringUtil() 
		{
			
		}
		public static function Pow(str:String, length:uint):String {
			//n个相同的字符
			if (str == null || length < 1) return "";
			var tmp:String = "";
			for (var i:int = 0; i < length; i++) tmp += str;
			return tmp;
		}
		public static function toUpperCaseFirstLetter(str:String):String {
			//首字大写
			return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
		}
		public static function Ltrim(str:String):String {
			//删除左边空格
			return str.replace(/^\s*/, "");
		}
		public static function Rtrim(str:String):String {
			//删除右边空格
			return str.replace(/\s*$/, "");
		}
		public static function trim(str:String):String {
			//删除左右边空格
			return str.replace(/(^\s*|\s*$)/g, "");
		}
		public static function camelize( str:String ):String {
			//首字大写
			return str.replace(/(\s|^)(\w)/g, 
				function(...value):String { return String(value[2]).toUpperCase(); });
		}
		public static function decamelize( str:String, separater:String = " " ):String {
			//大写首字分开
			return str.replace( /(([^.\d])(\d)|[A-Z])/g, 
				function(...$):String {
					if($[2]) return $[2] + separater + String($[3]).toLowerCase();
					if($[4]==0) return String($[0]).toLowerCase();
					return separater + String($[0]).toLowerCase();
				});
		}
		public static function byteSize(str:String,charSet:String="gb2312"):uint {
			_byte.length = 0;
			_byte.writeMultiByte(str,charSet);
			return _byte.length;
		}
		static public function getImagehtmlText(referenceName:String, referenceClass:Class, width:uint = 0, height:uint = 0):String {
			//生成img标签，显示在htmlText中
			//可以结合TextField.getImageReference(referenceName)得到显示对象
			//示例
			/*
			var text:TextField = new TextField();
			addChild(text);
			text.background = true; text.backgroundColor = 0xFF80C0;
			text.htmlText = " hello" + StringUtil.getImagehtmlText("bmd", TextField, 40, 50);
			var l:TextField = text.getImageReference("bmd") as TextField;
			l.border = true;l.borderColor = 0x0000FF;
			l.htmlText = "<a href='event:'>world</a>";
			*/
			return "<img id='" + referenceName + "' src='" + getClassDefinitionName(referenceClass) + "' width='"+width+"' height='"+height+"' border='5' />";
		}
		private static function getClassDefinitionName(referenceClass:Class):String {
			var str:String = getQualifiedClassName(referenceClass);
			str = str.split("::").join(".");
			return str;
		}
	}

}