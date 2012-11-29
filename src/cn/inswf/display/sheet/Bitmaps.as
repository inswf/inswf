package cn.inswf.display.sheet {
	import cn.inswf.display.image.BitmapProxy;

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.net.URLRequest;

	/**
	 * @author hi
	 */
	public class Bitmaps extends BitmapProxy implements IBitmaps {
		public static var time:Number=0;
		protected var _frames : FrameDataList;
		protected var _currentFrame : int;
		protected var _totalFrame : int;
		protected var _playing : Boolean;
		protected var _endTime : Number;
		protected var _rate : Number = 1;
		protected var _step : int = 1;
		protected var _active:Boolean;
		protected var _multiFrame:Boolean;
		public function Bitmaps(bitmapData : BitmapData = null, pixelSnapping : String = "auto", smoothing : Boolean = false) {
			super(bitmapData, pixelSnapping, smoothing);
			_endTime =time;
			_playing = false;
		}

		public function dispose() : void {
			stop();
			_frames = null;
		}
		
		public function play() : void {
			if (_playing) {
				setFrame(_currentFrame);
				return;
			}
			if (_totalFrame < 1) {
				setFrame(0);
			}
			_playing = true;
			addEventListener(Event.ENTER_FRAME, loop);
		}

		public function stop() : void {
			if (!_playing) {
				setFrame(_currentFrame);
				_playing=false;
				return;
			}
			_playing = false;
			removeEventListener(Event.ENTER_FRAME, loop);
		}

		public function nextFrame() : void {
			setFrame(_currentFrame + 1);
		}

		public function prevFrame() : void {
			setFrame(_currentFrame - 1);
		}

		public function set reverse(value : Boolean) : void {
			_step = value ? -1 : 1;
		}

		public function get reverse() : Boolean {
			return _step == -1;
		}

		protected function getBitmapData(frame : int) : FrameData {
			if (_frames) {
				return _frames.getFrame(frame);
			}
			return null;
		}

		protected function frameChange(frame : int) : void {
		}

		protected function setFrame(frame : int) : void {
			if (frame < 0) frame = _totalFrame;
			if (frame > _totalFrame) {
				frame = 0;
			}
			if (frame != _currentFrame) {
				frameChange(frame);
			}
			_currentFrame = frame;
			var framedata : FrameData = getBitmapData(frame);
			if (framedata) {
				setRegistration(framedata.x, framedata.y);
				var bmd : BitmapData = framedata.data;
				this.bitmapData = bmd;
				if (bmd == null) {
					Resource.getImage(new URLRequest(framedata.src), framedata);
				}else{
					if(!_multiFrame){
						_playing=true;
						stop();
					}
				}
				var delay : uint = framedata.delay;
				if (delay < 1) {
					stop();
					delay = 0;
				}
				_endTime = time + delay / _rate;
			}
		}

		public function get currentFrame() : int {
			return _currentFrame;
		}

		public function set currentFrame(currentFrame : int) : void {
			setFrame(currentFrame);
		}

		public function get frameRate() : Number {
			return _rate;
		}

		public function set frameRate(value : Number) : void {
			if (value < 0) {
				value = -value;
			}
			if (value == 0) {
				value = 1;
			}
			var framedata : FrameData = getBitmapData(_currentFrame);
			if (framedata) {
				var delay : uint = framedata.delay;
				if (delay < 1) {
					delay = 1;
				}
				var realDelay : Number = delay / value;
				var totalTime : Number = delay / _rate;
				var passTime : Number = _endTime - time;
				var realPassTime : Number = (totalTime - passTime) * value;
				if (realPassTime < realDelay) {
					_endTime = time + realDelay - realPassTime;
				} else {
					_endTime = time;
				}
			}
			_rate = value;
		}

		private function loop(e : Event) : void {
			if (!_playing) {
				return;
			}
			update();
		}

		public function setFrameData(value : FrameDataList) : void {
			if(_frames==value){
				return;
			}
			_frames = value;
			var len : int = value.length - 1;
			if (len < 0) {
				len = 0;
			}
			_totalFrame = len;
			play();
			_multiFrame=_totalFrame==0?false:true;
			setFrame(0);
		}

		public function get playing() : Boolean {
			return _playing;
		}

		public function setActive(value : Boolean) : void {
			_active=value;
			if(_active){
				if(_playing){
					addEventListener(Event.ENTER_FRAME, loop);
				}
			}else{
				removeEventListener(Event.ENTER_FRAME, loop);
			}
		}

		public function getActive() : Boolean {
			return _active;
		}
		public function update():void{
			if (time - _endTime >= 0) {
				setFrame(_currentFrame + _step);
			}
		}
		
	}
}
