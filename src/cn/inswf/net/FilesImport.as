package cn.inswf.net {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;

	/**
	 * ...
	 * @author liwei
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "cancel", type = "flash.events.Event")]
	[Event(name="select", type="flash.events.Event")]
	public class FilesImport extends EventDispatcher {
		private var _multiSelect : Boolean = false;
		private var _fileReference : FileReference;
		private var _fileReferenceList : FileReferenceList;
		private var _list : Array;
		// FileReference列表
		private var file_data : Array;
		private var _filefilter : FileFilter = new FileFilter("files", "*.*");

		public function FilesImport(multi : Boolean = false) {
			_multiSelect = multi;
		}

		public function browse(description : String = "所有文件", extension : String = "*.*", macType : String = null) : void {
			if (_list != null) {
				return;
			}
			_filefilter = new FileFilter(description, extension, macType);
			var typefilter : Array = [_filefilter];
			if (_multiSelect == true) {
				_fileReferenceList = new FileReferenceList();
				_fileReferenceList.addEventListener(Event.SELECT, selectHandler);
				_fileReferenceList.addEventListener(Event.CANCEL, cancelHandler);
				_fileReferenceList.browse(typefilter);
			} else {
				_fileReference = new FileReference();
				_fileReference.addEventListener(Event.SELECT, selectHandler);
				_fileReference.addEventListener(Event.CANCEL, cancelHandler);
				_fileReference.browse(typefilter);
			}
		}

		public function getFile() : File {
			return file_data.shift();
		}

		public function getFileCount() : int {
			if (_list) {
				return _list.length;
			}
			return 0;
		}

		public function release() : void {
			file_data = null;
			_filefilter = null;
			if (_multiSelect == true) {
				if (_fileReferenceList != null) {
					_fileReferenceList.removeEventListener(Event.SELECT, selectHandler);
					_fileReferenceList.removeEventListener(Event.CANCEL, cancelHandler);
				}
			} else {
				if (_fileReference != null) {
					_fileReference.removeEventListener(Event.SELECT, selectHandler);
					_fileReference.removeEventListener(Event.CANCEL, cancelHandler);
				}
			}
		}

		public function set multiSelect(value : Boolean) : void {
			_multiSelect = value;
		}

		private function cancelHandler(e : Event = null) : void {
			release();
			if (e != null) {
				dispatchEvent(e);
			}
		}

		private function selectHandler(e : Event) : void {
			cancelHandler();
			if (_multiSelect == true) {
				_list = _fileReferenceList.fileList;
				_fileReferenceList = null;
			} else {
				_list = [_fileReference];
				_fileReference = null;
			}
			file_data = [];
			dispatchEvent(e);
		}
		public function getfiles():Array{
			var list:Array=[];
			if(_list==null){
				return list;
			}
			var len:int=_list.length;
			for(var i:int=0;i<len;i++){
				var f:FileReference=_list[i];
				list.push(new File(f.name));
			}
			return list;
		}

		public function load() : void {
			if (_list.length < 1) {
				_list = null;
				return;
			}
			_fileReference = _list.shift();
			if (_fileReference != null) {
				_fileReference.addEventListener(Event.COMPLETE, completeHandler);
				_fileReference.load();
			} else {
				throw new Error("文件加载出错");
			}
		}

		private function completeHandler(e : Event) : void {
			var file : File = new File(_fileReference.name);
			file.bytes = _fileReference.data;
			file_data.push(file);
			_fileReference.removeEventListener(Event.COMPLETE, completeHandler);
			_fileReference = null;
			dispatchEvent(new Event(Event.COMPLETE));
			load();
		}
	}
}