package did_as.com{

	import flash.display.*;
	import flash.events.*;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	import caurina.transitions.properties.FilterShortcuts;
	import did_as.com.TextSet;
	import did_as.com.Thumb;

	public class BannerMotion extends MovieClip {

		private var total:Number;
		private var pointTotal:Number;
		private var max:Number;
		private var min:Number;
		private var yMax:Number;
		private var yMin:Number;
		private var point:PointMC;
		private var banner:Banner;
		private var avg:Number;
		private var xPos:Array = new Array();
		private var pointArray:Array = new Array();
		private var bannerArray:Array = new Array();
		private var str:Array = new Array();
		private var startX:Number;
		private var startY:Number;
		private var _SPEED:Number = 0.5;
		private var _TRANS:String = "easeOutQuint";
		private var _SPACE:Number = 2;
		private var stageW:Number;
		private var stageH:Number;
		private var Main:MovieClip;
		private var thumb:Thumb;
		private var urlArray:Array = new Array();
		private var textSet:TextSet = new TextSet();

		public function BannerMotion(main:MovieClip,totalNum:Number, getMax:Number, getMin:Number,getYMax:Number,getYMin:Number,getStr:Array,tempArray:Array) {
			FilterShortcuts.init();
			ColorShortcuts.init();
			str = getStr;
			urlArray = tempArray;
			total = totalNum;
			pointTotal = total+1;
			max = getMax;
			min = getMin;
			yMax = getYMax;
			yMin = getYMin;
			Main = main;
			Main.loading.visible = true;
			Main.loading.play();
			avg = Math.floor((max + (total-1)*min)/total);
			stageW = 1000;
			stageH = 700;
			startX = stageW/2 - (total*avg)/2;
			startY = stageH/2 + 70;
			makePoint();
		}
		private function makePoint() {
			var xPosTemp:Number;
			for (var i:uint=0; i<total; i++) {
				makeXPos(i);
			}
			makeDPox(pointTotal);
			displayPoint();
		}
		private function makeXPos(num:uint) {
			var tempPos:Array = new Array();
			var tempMax;
			var tempMin;
			tempPos.push(0);
			for (var i:uint=1; i<pointTotal; i++) {
				if (num<i) {
					tempMax = max;
				} else {
					tempMax = 0;
				}
				if (num==0 && i<1) {
					tempMin = 0;
				} else {
					tempMin = min;
				}
				if (num+1>i) {
					tempPos.push(tempMax+i*tempMin);
					//trace(tempMax+"+"+i+"*"+tempMin+"="+(tempMax+i*tempMin))
				} else {
					tempPos.push(tempMax+(i-1)*tempMin);
					//trace(tempMax+"+"+(i-1)+"*"+tempMin+"="+(tempMax+(i-1)*tempMin))
				}
			}
			xPos[num] = tempPos;
		}
		private function makeDPox(num:uint) {
			var tempPos:Array = new Array();
			tempPos.push(0);
			for (var i:uint=1; i<pointTotal; i++) {
				tempPos.push(i*avg);
			}
			xPos[num] = tempPos;
		}
		private function displayPoint() {
			for (var i:uint=0; i<pointTotal; i++) {
				point = new PointMC();
				point.x = startX+xPos[pointTotal][i];
				point.y = startY;
				pointArray.push(point);
			}
			makeBanner();
		}
		private function makeBanner() {
			for (var i:uint; i<total; i++) {
				banner = new Banner();
				banner.x = startX+xPos[pointTotal][i];
				banner.y = startY;
				banner.bar.y = yMin - banner.bar.height + 20;
				banner.light.y =banner.bar.y ;
				banner.titleMC.y = yMin - banner.bar.height +30;
				banner.mc.xHome = banner.mc.x;
				banner.maskMC.yHome = banner.maskMC.y;
				banner.maskMC.height = yMin;
				banner.txtY = banner.titleMC.y;
				banner.bar.yHome = banner.bar.y;
				banner.bar.tempY = 10;
				banner.num = i;
				//Thumb(getParent:MovieClip,url:String, sizeW:Number, sizeH:Number)
				var url:String = Main.siteURL+"/swf/stepImg/render"+urlArray[i]+".jpg";
				thumb = new Thumb(this,url,max,yMax);
				banner.mc.addChild(thumb);
				banner.titleMC.txt.text = str[i];
				textSet.setText(banner.titleMC.txt, 0xFFFFFF, 16, -0.5, "korFont");
				bannerArray.push(banner);
				banner.btn.width = max;
				banner.btn.height = yMax;
				banner.btn.buttonMode = true;
				banner.btn.addEventListener(MouseEvent.CLICK,mouseEvent);
				banner.btn.addEventListener(MouseEvent.ROLL_OVER,mouseEvent);
				banner.btn.addEventListener(MouseEvent.ROLL_OUT,mouseEvent);
				Tweener.addTween(banner.mc, {_saturation:0.3, time:_SPEED, transition:_TRANS});
			}
			moveMenu();
			bannerDisplay();
		}
		private function bannerDisplay() {
			trace("bannerDisplay")
			for (var i:uint; i<total; i++) {
				showBanner(i);
			}
		}
		private function showBanner(count:Number) {
			trace(count)
			addChild(bannerArray[count]);
			bannerArray[count].alpha = 0;
			Tweener.addTween(bannerArray[count], {alpha:1, time:1, delay:count/10 , transition:"easeOutCubic" ,onComplete:nextMovie, onCompleteParams:[count]});
		}
		function nextMovie(count) {
			if (count == total-1) {
				Main.loading.gotoAndStop(1);
				Main.loading.visible = false;
				Main.sp.addChild(this);
			}
		}
		private function mouseEvent(e:Event) {
			var mc:MovieClip = MovieClip(e.target.parent);
			if (e.type == "rollOver") {
				movePoint(mc.num);
				moveMenu();
				overMenu(mc);
			} else if (e.type == "rollOut") {
				movePoint(pointTotal);
				moveMenu();
				outMenu(mc);
			} else if (e.type == "click") {
				Main.select(mc.num);
			}
		}
		private function movePoint(selectedNum:Number) {
			for (var i:uint=0; i<pointTotal; i++) {
				pointArray[i].x = startX+xPos[selectedNum][i%pointTotal];
			}
		}
		private function moveMenu() {
			for (var i:uint=0; i<total; i++) {
				var mc:MovieClip = bannerArray[i];
				Tweener.addTween(mc, {x:pointArray[i].x, time:_SPEED, transition:_TRANS});
				Tweener.addTween(mc.maskMC, {width:pointArray[i+1].x-pointArray[i].x-_SPACE, time:_SPEED, transition:_TRANS});
				Tweener.addTween(mc.titleMC, {x:(pointArray[i+1].x-pointArray[i].x-_SPACE)/2, time:_SPEED, transition:_TRANS});
			}
		}
		private function overMenu(mc:MovieClip) {
			Tweener.addTween(mc.maskMC, {height:yMax ,y:(mc.maskMC.yHome-(yMax-yMin)/2), time:_SPEED, transition:_TRANS});
			Tweener.addTween(mc.bar, {_color:0xFF6600, y:mc.bar.yHome+mc.bar.tempY, time:_SPEED, transition:_TRANS});
			Tweener.addTween(mc.light, {y:mc.bar.yHome+mc.bar.tempY, time:_SPEED, transition:_TRANS});
			Tweener.addTween(mc.titleMC, {scaleX:1.2,scaleY:1.2,y:mc.txtY+mc.bar.tempY, time:_SPEED, transition:_TRANS});
			Tweener.addTween(mc, {_DropShadow_alpha:1,_DropShadow_blurX:40,_DropShadow_blurY:40, time:_SPEED, transition:_TRANS});
			Tweener.addTween(mc.mc, {_saturation:1, time:_SPEED, transition:_TRANS});
			swapChildrenAt(getChildIndex(mc),numChildren-1);
		}
		private function outMenu(mc:MovieClip) {
			Tweener.addTween(mc.maskMC, {y:mc.maskMC.yHome, height:yMin, time:_SPEED, transition:_TRANS});
			Tweener.addTween(mc.bar, {_color:0x000000, y:mc.bar.yHome, time:_SPEED, transition:_TRANS});
			Tweener.addTween(mc.light, {y:mc.bar.yHome, time:_SPEED, transition:_TRANS});
			Tweener.addTween(mc.titleMC, {scaleX:1,scaleY:1, y:mc.txtY, time:_SPEED, transition:_TRANS});
			Tweener.addTween(mc, {_DropShadow_alpha:0,_DropShadow_blurX:0,_DropShadow_blurY:0, time:_SPEED, transition:_TRANS});
			Tweener.addTween(mc.mc, {_saturation:0.3, time:_SPEED, transition:_TRANS});
		}
	}
}