package did_as.com{

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.LoaderContext;

	public class Pattern extends MovieClip {

		private var getImg:GetImg;
		private var Main:MovieClip;
		private var wallpapergubun:Number;
		private var stageW:Number
		private var stageH:Number
		private var loder:Loader;
		private var bitmap:BitmapData;

		public function Pattern(main:MovieClip,url:String,gubun:Number, w:Number = 1000, h:Number = 1000) {
			Main = main;
			stageW = w;
			stageH = h;
			wallpapergubun = gubun;
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;
			loder = new Loader();
			loder.load(new URLRequest(url),context);
			loder.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
		}
		private function onComplete(e:Event) {
			makePattern();
		}
		public function makePattern() {
			bitmapFn(stageW,stageH)
		}
		public function bitmapFn(w:Number, h:Number){
			var image:Bitmap = Bitmap(loder.content);
			var bitmapData:BitmapData = image.bitmapData;
			var tw:Number;
			var th:Number;
			if (wallpapergubun == 0) {
				tw = w;
				th = h;				
			}else if (wallpapergubun == 1) {
				tw = loder.width;
				th = loder.height;
			} else if (wallpapergubun == 2) {
				tw = stageW;
				th = loder.height;
			}
			with(this.graphics){
				beginBitmapFill(bitmapData,null,true,true);
				drawRect(0,0,tw,th);
				endFill();
			}
			dispatchEvent(new Event("patternEnd"));
		}
		public function removeBitmap(){
			trace("bitmapDispose")
			graphics.clear();
			//bitmap.dispose()
		}
	}
}