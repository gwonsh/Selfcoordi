package {

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.utils.*;
	import did_as.*;
	import did_as.com.Load_xml;
	import did_as.com.Pattern;
	import did_as.com.FrotingBar;
	import did_as.com.DataInfo;
	import did_as.com.WaterMark;
	import caurina.transitions.Tweener;
	import com.hangunsworld.net.XMLLoader;

	public class product_Main extends MovieClip {

		// 새제품 추가는 dis_as/CollectCheck.as 부터
		private var photo:PhotoMC;//시공사례/2쪽보기/질감보기 MC
		private var self:SelfMC; //장소 스타일 선택 MC
		private var prom:PromotionMC;//베스트매치 MC
		private var bg:BG;
		public var warn:Warn;
		public var frotingBar:FrotingBar;
		public var waterMark:WaterMark;
		public var dataInfo:DataInfo;
		private var loading:Loading;
		private var selectNaviArray:Array = new Array();

		private var box:Sprite = new Sprite();// 이미지들이 붙는곳
		private var img:Sprite = new Sprite();// 간지/패턴
		private var selectBox:Sprite = new Sprite();//네비게이션 담는 박스
		private var savePrintImg:Sprite = new Sprite();
		private var imgTemp:Sprite = new Sprite();
		private var imgBox:Sprite;
		private var decoBox:Sprite = new Sprite();

		public var siteURL:String;
		public var xmlURL:String;
		public var fileURL:String;
		private var styleNum:int;
		private var placeNum:int;

		private var xml:XML = new XML();
		private var xloader:XMLLoader = new XMLLoader();

		private var _SPEED:Number = 0.8;
		private var _TRANS:String = "easeOutQuint";
		private var selectNavi:MovieClip;

		public var selectThumb:Object;
		public var wallgubun:Number;
		public var patternURL:String;
		private var selectBoxW:Number;
		private var frotingBarVisibleNum:Number = 0;
		private var interval:uint;

		public var stageW:Number;
		public var stageH:Number;
		private var blackBg:BlackBG;


		public function product_Main() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, resizeHandler);// 브라우져  따라 리사이징 하기

			siteURL = LoaderInfo(this.root.loaderInfo).parameters.siteURL;
			xmlURL =  LoaderInfo(this.root.loaderInfo).parameters.xmlURL;
			fileURL =  LoaderInfo(this.root.loaderInfo).parameters.FileURL;
			placeNum =  LoaderInfo(this.root.loaderInfo).parameters.placeNum;
			styleNum =  LoaderInfo(this.root.loaderInfo).parameters.styleNum;
			styleNum = 1;
			if(!placeNum) placeNum = -1;
			if(!styleNum) styleNum = -1;
			
			fileURL = "http://file.didwallpaper.com";
			siteURL = "http://www.didwallpaper.com";	
			xmlURL = "/lib/xml/product.asp?oidProduct=4399";			

			stageW = stage.stageWidth;
			stageH = stage.stageHeight;

			xmlLoad();
		}
		private function resizeHandler(e:Event):void {
			imgReSizie();
		}
		private function imgReSizie() {

			stageW = stage.stageWidth;
			stageH = stage.stageHeight;

			if (img.numChildren>0 && stageH > 600 && stageW > 1024) {
				setStageSize(selectThumb);
				selectThumb.imgReSizie();
				bg.width = stageW;
			}
			if (bg != null) {
				bg.width = stageW;
			}
			selectBox.y = stageH - 25;
			selectBox.x = stageW/2 - selectBoxW/2;

			if (loading != null) {
				loading.x = stageW/2;
				loading.y = stageH/2;
				blackBg.width = stageW;
				blackBg.height = stageH;
			}

			var targetW:Number = img.width/2;
			if (targetW > stageW) {
				targetW = stageW;
			}
			img.x =  stageW/2 - targetW;
		}
		private function xmlLoad() {
			xloader.load(new URLRequest(siteURL+xmlURL), "euc-kr");
			xloader.addEventListener(Event.COMPLETE, onComplete);
		}
		private function onComplete(e:Event) {
			xml = XML(xloader.data);
			dataInfo = new DataInfo(this);
			dataInfo.getDataInfo(xml.@strModel,
			xml.@strProductName,
			xml.@oidProduct,
			xml.@wallpapergubun,
			xml.@strECollection,
			xml.thumbs.pattern.thumb.@url,
			xml.thumbs.pattern.thumb,"product");
			display();
		}
		private function display() {
			waterMark = new WaterMark(this);
			photo = new PhotoMC(this, XML(xml.thumbs));
			self = new SelfMC(this);
			prom = new PromotionMC(this, XML(xml.promotion));
			frotingBar = new FrotingBar(waterMark,fileURL,img,this);
			warn = new Warn();
			bg = new BG();
			loading = new Loading();
			blackBg = new BlackBG();

			waterMark.setInfo(dataInfo, waterMark.info);
			frotingBar.getDataInfo(dataInfo);

			photo.x = 10;
			self.x = photo.x +photo.board.width + 5;						
			prom.x = self.x + self.board.width + 5;
			selectBoxW = photo.board.width+self.board.width+prom.board.width+5*3+10;
			warn.x = selectBoxW - 10;
			warn.y = - 40;
			bg.width = stageW;

			box.addChild(imgTemp);
			//매칭이미지 추가
			box.addChild(img);
			box.addChild(decoBox);
			addChild(box);

			selectBox.addChild(warn);
			selectBox.addChild(photo);
			selectBox.addChild(self);
			selectBox.addChild(prom);

			selectBox.y = stageH - 25;
			selectBox.x = stageW/2 - selectBoxW/2;

			loading.x = stageW/2;
			loading.y = stageH/2;
			blackBg.width = stage.stageWidth;
			blackBg.height = stage.stageHeight;
			blackBg.visible = false;
			blackBg.alpha = 0.6;

			frotingBar.alpha = 0;

			addChild(selectBox);
			addChild(bg);
			addChild(frotingBar);
			addChild(blackBg);
			addChild(loading);
			selectBoxBtnAction();			
		}
		private function selectBoxBtnAction() {
			selectNaviArray = [photo,self,prom];
			for (var i:uint = 0; i<selectNaviArray.length; i++) {
				selectNaviArray[i].btn.addEventListener(MouseEvent.CLICK, mouseEvent);
			}
			selectBoxY(selectNaviArray[1]);
			//최초 실행 시의 장소와 스타일			
			selectNaviArray[1].selectMain(placeNum, styleNum);
			Tweener.addTween(photo, {y:photo.ty, time:_SPEED, transition:_TRANS, onComplete:upComplete});
			Tweener.addTween(prom, {y:prom.ty, time:_SPEED, transition:_TRANS});
		}
		private function upComplete() {
			Tweener.addTween(photo, {y:0,delay:1,time:_SPEED, transition:_TRANS});
			Tweener.addTween(prom, {y:0,delay:1, time:_SPEED, transition:_TRANS, onComplete:promComplete});
		}
		private function promComplete(){
			//더 페어 일경우에만 베스트매치를 바로 보여줌
			if(xml.@strECollection == "THE PAIR"){
				prom.btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				prom.onClick(prom.promArray[0]);
			}
		}
		private function mouseEvent(e:MouseEvent) {
			var mc:MovieClip = MovieClip(e.target.parent);
			setStageSize(mc);
			otherBoxClose(mc);
			selectBoxY(mc);
		}
		private function setStageSize(target:Object) {
			target.stageW = stageW;
			target.stageH = stageH;
		}
		private function otherBoxClose(mc:MovieClip) {
			for (var i:uint = 0; i<selectNaviArray.length; i++) {
				if (selectNaviArray[i] != mc) {
					Tweener.addTween(selectNaviArray[i], {y:0, time:_SPEED, transition:_TRANS});
					selectNaviArray[i].upDown.gotoAndStop("up");
				}
			}
		}
		private function selectBoxY(mc:MovieClip) {
			if (selectNavi == mc && selectNavi != null) {
				Tweener.addTween(mc, {y:0, time:_SPEED, transition:_TRANS});
				mc.upDown.gotoAndStop("up");
				selectNavi = null;
			} else {
				Tweener.addTween(mc, {y:mc.ty, time:_SPEED, transition:_TRANS});
				mc.upDown.gotoAndStop("down");
				selectNavi = mc;
			}
		}
		public function selectClear() {
			if (selectThumb != null) {
				selectThumb.selectOut();
				selectThumb.select = null;
			}
		}
		public function loadingFn(st:String="") {
			if (st == "") {
				for (var i:uint = 0; i<img.numChildren; i++) {
					img.removeChildAt(i);
				}
				frotingBar.alpha = 0;
			}
			loading.visible = true;
			blackBg.visible = true;
			loading.play();
		}
		public function loadingEnd() {
			loading.visible = false;
			blackBg.visible = false;
			loading.gotoAndStop(1);
		}
		public function displayImg(target:Sprite, deco:Sprite = null) {
			var sp:Sprite = new Sprite();
			sp.addChild(target);
			if (deco != null) {
				if (decoBox.numChildren > 0) {
					decoBox.removeChildAt(0);
				}
				decoBox.addChild(deco);
			} else {
				if (decoBox.numChildren > 0) {
					decoBox.removeChildAt(0);
				}
			}
			drawTemp(sp);
		}
		private function drawTemp(target:Sprite) {
			for (var i:uint = 0; i<img.numChildren; i++) {
				img.removeChildAt(i);
			}
			frotingBar.alpha = 1;
			loadingEnd();
			img.alpha = 0;
			img.addChild(target);

			var targetW:Number = img.width/2;
			if (targetW > stageW) {
				targetW = stageW;
			}
			img.x =  stageW/2 - targetW;
			Tweener.addTween(img, {alpha:1, time:0.5, transition:_TRANS, onComplete:removeSprite});
		}
		private function removeSprite() {
			if (frotingBarVisibleNum == 1) {
				frotingBar.visible = true;
				warn.visible = true;
				Tweener.addTween(frotingBar,{alpha:1,time:_SPEED,transition :_TRANS});
				Tweener.addTween(warn,{alpha:1,time:_SPEED,transition :_TRANS});
				frotingBarVisibleNum = 0;
			}
		}
		public function frotingBarVisible() {
			frotingBarVisibleNum = 1;
		}
	}
}