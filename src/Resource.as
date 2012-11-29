package {
	import cn.inswf.net.File;
	import cn.inswf.utils.Resources;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * @author li
	 */
	public class Resource {
		private static const _resource:Resources=new Resources();
		public static function getImage(request:URLRequest, bitmap:Bitmap = null,priority:Boolean = false,cache:Boolean=true):Bitmap {
			return _resource.loadImage(request,bitmap,null,priority,cache);
		}
		public static function setImage(url:String, value:BitmapData,cache:Boolean=true):void {
			_resource.setImage(url, value,cache);
		}
		public static function clearImageCache():void{
			_resource.clearImageCache();
		}
		public static  function getDefinition(name:String, applicationDomain:ApplicationDomain = null):* {
			return _resource.getDefinition(name,applicationDomain);
		}
		public static function getFile(url:String):File{
			return _resource.loadFile(url);
		}
		public static function getText(text:String="",x:int=0,y:int=0,format:TextFormat=null,width:int=0,height:int=0):TextField{
			var txt:TextField = new TextField();
			txt.x=x;
			txt.y=y;
			txt.selectable=txt.mouseEnabled = false;
			if (format != null) {
				txt.defaultTextFormat = format;
			}
			if (width > 0) {
				txt.multiline = true;
				txt.wordWrap = true;
				txt.width = width;
			}
			if(height==0){
				txt.autoSize = TextFieldAutoSize.LEFT;
			}
			txt.htmlText = text;
			return txt;
		}
	}
}
