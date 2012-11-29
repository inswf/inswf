package cn.inswf.utils {
	import flash.system.LoaderContext;
	import cn.inswf.net.FileLoader;
	import cn.inswf.net.File;
	import cn.inswf.display.image.BitmapProxy;
	import cn.inswf.net.BitmapLoader;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	/**
	 * @author li
	 */
	public class Assets {
		private var _imageLoader:BitmapLoader;//图片加载器
		private var _fileLoader:FileLoader;
		private const _appNameDict:Dictionary = new Dictionary(true);//
		private const _definitionDict:Dictionary = new Dictionary(true);//
		private var _appIndex:int = 0;//
		public function Assets(loaderCount:uint=5) {
			_imageLoader=new BitmapLoader(loaderCount);
			_fileLoader=new FileLoader();
		}
		public function clearBitmapdata():void{
			_imageLoader.reset();
		}
		public function getImage(request:URLRequest, bitmap:Bitmap = null,loadercontext:LoaderContext=null,priority:Boolean = false):Bitmap {
			if (bitmap == null) {
				bitmap = new BitmapProxy();
			}
			_imageLoader.load(request, bitmap,loadercontext,priority);
			return bitmap;
		}
		public function setImage(url:String, value:BitmapData):void {
			_imageLoader.setBitmapData(url, value);
		}
		public  function getDefinition(name:String, applicationDomain:ApplicationDomain = null):* {
			var _applicationDomain:ApplicationDomain = applicationDomain;
			if (_applicationDomain == null) {
				_applicationDomain = ApplicationDomain.currentDomain;
			}
			if (!_applicationDomain.hasDefinition(name)) {
				trace("Resource.getDefinition(\"" + name + "\") 不存在");
				return null;
			}
			if (!_appNameDict[_applicationDomain]) {
				_appIndex++;
				_appNameDict[_applicationDomain] = "application" + _appIndex;
			}
			var cacheName:String = _appNameDict[_applicationDomain]+"#"+name;
			var myClass:Class = _applicationDomain.getDefinition(name) as Class;
			var dict:Dictionary = _definitionDict[_applicationDomain];
			if (!dict) {
				dict = new Dictionary(true);
				_definitionDict[_applicationDomain] = dict;
			}
			var type:int = dict[cacheName];
			if (type == 0) {
				var describe:XML = describeType(myClass);
				var factory:XMLList=describe.child("factory");
				var list:XMLList = factory.child("extendsClass");
				if (describe.@name != "Object" && list.length() == 0) {
					trace("Resource.getDefinition(\"" + name + "\") 参数类型不能为接口");
					return null;
				}
				if (list.(@type == "flash.display::MovieClip").length() > 0) {
					type = 1;
				}else if (list.(@type == "flash.display::BitmapData").length() > 0) {
					type = 2;
				}else if (list.(@type == "flash.display::Sprite").length() > 0) {
					type = 3;
				}else if (list.(@type == "flash.display::Bitmap").length() > 0) {
					type = 4;
				}else {
					type = 5;
				}
				dict[cacheName] = type;
			}
			var target:*;
			if (type == 1) {
				target = new myClass();
			}else if (type == 2) {
				var bm:Bitmap = new Bitmap();
				var bmd:BitmapData = _imageLoader.getBitmapData(cacheName);
				if (!bmd) {
					bmd = new myClass(0, 0);
					_imageLoader.setBitmapData(cacheName, bmd);
				}
				bm.bitmapData = bmd;
				target = bm;
			}else if (type == 3) {
				target = new myClass();
			}else if (type == 4) {
				bm = new myClass();
				_imageLoader.setBitmapData(cacheName, bm.bitmapData);
				target = bm;
			}else if (type == 5) {
				if (describe == null) {
					describe = describeType(myClass);
				}
				factory=describe.child(factory);
				list=factory.child("constructor");
				if (list.length() == 0) {
					target = new myClass();
				}else {
					trace("Resource.getDefinition(\"" + name + "\") 实例有构造参数,暂不支持实例化");
				}
			}
			return target;
		}
		public  function loadFile(url:String):File{
			return _fileLoader.load(url);
		}
	}
}
