package did_as.promotion{

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.LoaderContext;

	public class MatchPattern extends MovieClip {

		private var Main:MovieClip;
		private var wallpapergubun:Number;
		private var stageW:Number;
		private var stageH:Number;
		private var loder:Loader;
		private var bitmap:BitmapData;
		private var matchURL:String;
		private var patternURL:String;
		private var leftW:Number;
		private var rightW:Number;
		private var centerW:Number;
		private var count:Number = 0;
		private var totalW:Number;

		public function MatchPattern(main:MovieClip , url:String, matchPatternURL:String, gubun:Number, leftWidth:Number = 0, rightWidth:Number=0, centerWidth:Number = 0, th:Number = 0) {
			Main = main;
			stageW = Main.stageW;
			stageH = th;

			leftW = leftWidth;
			rightW = rightWidth;
			centerW = centerWidth;
			totalW = leftW+rightW+centerW;

			wallpapergubun = gubun;
			matchURL = matchPatternURL;
			patternURL = url;

			loader(matchURL);
		}
		private function loader(url) {
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;
			loder = new Loader();
			loder.load(new URLRequest(url),context);
			loder.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
		}
		private function onComplete(e:Event) {
			makePattern();
			++count;
		}
		public function makePattern() {
			if (count == 0) {
				matchPatternFill();
			} else {
				bitmapFn(centerW,stageH);
			}
		}
		private function matchPatternFill() {
			var image:Bitmap = Bitmap(loder.content);
			var bitmapData:BitmapData = image.bitmapData;
			with (this.graphics) {
				beginBitmapFill(bitmapData,null,true,true);
				drawRect(0,0,totalW,stageH);
				endFill();
			}
			loader(patternURL);
		}
		public function bitmapFn(w:Number, h:Number) {
			var image:Bitmap = Bitmap(loder.content);
			var bitmapData:BitmapData = image.bitmapData;
			var tw:Number;
			var th:Number;
			var posX:Number;
			var posY:Number;
			var pointPattern:Sprite;
			if (wallpapergubun == 0) {
				tw = centerW;
				th = h;
				posX = leftW;
				posY = 0;
			} else if (wallpapergubun == 1) {
				tw = image.width;
				if(tw > 1140){
					tw = 1140;
				}
				th = image.height;
				posX = leftW+(centerW-tw)/2;
				posY = 0;
			} else if (wallpapergubun == 2) {
				tw = totalW;
				th = image.height;
				posX = 0;
				posY = h/2;
			}
			pointPattern = new Sprite();
			with (pointPattern.graphics) {
				beginBitmapFill(bitmapData,null,true,true);
				drawRect(0,0,tw,th);
				endFill();
			}
			pointPattern.x = posX;
			pointPattern.y = posY;
			addChild(pointPattern);
			dispatchEvent(new Event("patternEnd"));
		}
		public function removeBitmap() {
			if (getChildByName("pointPattern")) {
				removeChild(getChildByName("pointPattern"));
			}
			graphics.clear();
		}
	}
}