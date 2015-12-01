package did_as.photo{

	import flash.display.*;
	import flash.events.*;
	import did_as.com.Pattern;

	public class PatternImg extends MovieClip {
		
		private var Main:Object
		private var wallgubun:Number
		private var pattern:Pattern
		
		public function PatternImg(main:Object,url:String,gubun:Number,w:Number,h:Number) {
			Main = main
			wallgubun = gubun;			
			pattern = new Pattern(this,url,wallgubun,w,h)
			pattern.addEventListener("patternEnd", onComplete)
		}
		private function onComplete(e:Event){
			addChild(pattern);
			dispatchEvent(new Event("patternImgEnd"))
		}
		public function reSizePattern(w:Number, h:Number){
			pattern.bitmapFn(w,h);
		}
	}
}