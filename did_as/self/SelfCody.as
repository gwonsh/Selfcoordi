package did_as.self{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.utils.*;
	import did_as.self.Wall;
	import did_as.com.GetImg;
	import did_as.com.Pattern;
	import did_as.com.Loading;
	import did_as.com.ReSizing;
	import did_as.com.BitmapCopy;
	import caurina.transitions.Tweener;

	public class SelfCody extends MovieClip {

		private var Main:Object;
		private var wallgubun:Number;
		private var patternURL:String;
		private var selectName:String;
		private var sp:Sprite = new Sprite;
		private var container:Sprite = new Sprite;
		//private var getImg:GetImg;
		//private var pattern:Pattern;
		//private var wallPainting:WallPainting;
		private var loader:Loading;
		private var maskMC:MaskMC =  new MaskMC();
		private var loadCount:Number = 0;
		private var interval:uint;
		public var stageW:Number;
		public var stageH:Number;
		private var num:Number;
		private var bmp:BitmapCopy;
		private var targetMC:MovieClip;
		private var roomSp:Sprite;
		private var getImgCount:Number = 0;
		private var getpatternCount:Number = 0;
		private var patternTarget:MovieClip;
		private var matchURL:String;

		public function SelfCody(main:Object,target:MovieClip,gubun:Number,patternurl:String, room:String = "", matchPatternURL="") {
			Main = main;
			wallgubun = gubun;
			patternURL = patternurl;
			targetMC = target;
			selectName = target.name;
			num = target.num;
			stageW = Main.stageW;
			stageH = Main.stageH;
			maskMC.gotoAndStop(num+1);
			var imgURL:String;
			if (room == "") {
				imgURL = targetMC.orgurl
			} else {
				imgURL = room;
				matchURL = targetMC.patternURL;
			}
			makeImage(imgURL);
		}
		private function makeImage(url:String) {
			/*if (checkArray(targetMC.orgurl) != undefined) {
			roomSp.addChild(checkArray(targetMC.orgurl));
			wallPaint();
			} else {*/
			roomSp = new Sprite();
			var getImg:GetImg=new GetImg(this, url);
			if (roomSp.numChildren > 0) {
				roomSp.removeChildAt(0);
			}
			roomSp.addChild(getImg);
			getImg.addEventListener("getImgEnd", makeWallEvent);
			//}
		}
		private function checkArray(urlSt:String) {
			for (var i:uint=0; i<Main.imgArray.length; i++) {
				if (Main.imgArray[i].indexSt == urlSt) {
					return Main.imgArray[i].mc;
				}
			}
		}
		private function inputArray(urlSt,mc) {
			Main.imgArray.push({indexSt:urlSt, mc:mc});
		}
		private function makeWallEvent(e:Event) {
			wallPaint();
		}
		private function wallPaint() {
			if(selectName != "patternMatch"){
				Main.Main.dataInfo.selectRoomType = selectName;
			}
			var wallPainting:WallPainting = new WallPainting(this, patternURL, selectName, wallgubun,matchURL);
		}
		public function loadComplete(target:MovieClip) {
			sp.addChild(target);
			sp.mask = maskMC;
			container.addChild(roomSp);
			container.addChild(sp);
			patternTarget = target;
			bitmapCopy();
		}
		private function bitmapCopy() {
			var bitmap:BitmapData = new BitmapData(roomSp.width, roomSp.height);
			bitmap.draw(container);
			with (this.graphics) {
				beginBitmapFill(bitmap,null,true,true);
				drawRect(0,0,roomSp.width,roomSp.height);
				endFill();
			}
			frotingBarMove();
			dispatchEvent(new Event("selfCodyEnd"));
		}
		public function removePattern() {
			patternTarget.removeBitmap();
		}
		private function frotingBarMove() {
			Main.frotingBarMove(selectName);
		}
	}
}