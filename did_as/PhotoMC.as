package did_as{

	import flash.display.*;
	import flash.events.*;
	import did_as.*;
	import did_as.photo.*;
	import did_as.com.EmptyBg;
	import caurina.transitions.Tweener;
	public class PhotoMC extends MovieClip {

		public var ty:Number=-85;// 클릭했을때 y축 이동범위
		public var photoArray:Array=new Array;// 썸네일 배열

		public var Main:MovieClip;
		private var sp:Sprite=new Sprite;// 썸네일 박스
		public var imgDeco:Sprite;
		public var img:Sprite;
		public var select:MovieClip;
		private var type:String;
		private var url:String;
		private var xmlTemp:XML;
		private var count:Number = 0;
		public var stageW:Number;
		public var stageH:Number;

		private var ganziImg:GanziImg;
		private var patternImg:PatternImg;
		private var thumbBox:Thumb_Photo;
		private var detailImg:DetailImg;
		private var emptyBg:EmptyBg;

		private var _SPEED:Number = 0.8;
		private var _TRANS:String = "easeOutQuint";
		private var targetType:String;

		public function PhotoMC(main:MovieClip,xml:XML) {// 메인 받아오기
			Main=main;
			stageW=Main.stageW;
			stageH=Main.stageH;
			xmlTemp = xml;
			
			sp.y = 40;
			sp.mask=maskMC;
			addChild(sp);
			numbering.visible=true;
			
			getXML(xmlTemp);
			barColor.gotoAndStop(1);
		}
		private function getXML(photoXML:XML) {//xml 로 데이타 구성
			var xml:XML=photoXML;
			var ganziLen=xml.ganzi.thumb.length();
			var patternLen=xml.pattern.thumb.length();
			var detailLen=xml.detail.thumb.length();
			var totalLen=ganziLen + patternLen + detailLen;
			var go:Number;

			if (totalLen >= 5) {// 총 이미지 갯수에 따라 넘버링 표시
				numbering.visible=true;
				numbering.nextBtn.alpha=1;
				numbering.nextBtn.buttonMode=true;
				numbering.nextBtn.addEventListener(MouseEvent.CLICK,nextBtnAction);
			} else {
				numbering.visible=false;
			}
			for (var i:uint; i < ganziLen; i++) {
				type=xml.ganzi.thumb[i].@type;
				url=xml.ganzi.thumb[i].@url;
				xmlTemp = xml.ganzi.thumb[i];
				thumbBoxDisplay();
			}
			for (var j:uint; j < patternLen; j++) {
				type=xml.pattern.thumb[j].@type;
				url=xml.pattern.thumb[j].@url;
				xmlTemp = xml.pattern.thumb[j];
				thumbBoxDisplay();
			}
			for (var k:uint; k < detailLen; k++) {
				type=xml.detail.thumb[k].@type;
				url=xml.detail.thumb[k].@url;
				xmlTemp = xml.detail.thumb[k];
				thumbBoxDisplay();
			}
		}
		private function thumbBoxDisplay() {
			var xPos:Number = count*59+28;
			var nameSt:String = "thumb"+count;
			++count;

			thumbBox = new Thumb_Photo(this,xmlTemp,url,type,xPos,nameSt);
			photoArray.push(thumbBox);
			sp.addChild(thumbBox);
		}
		public function getImage(target:MovieClip) {
			if (select != null) {
				select.out();
			}
			setSelectThumb();
			Main.frotingBar.setFrotingBarPos(stageW/2, stageH/2);
			setImg(target);// 이미지 넣기
			select = target;
		}
		private function nextBtnAction(e:MouseEvent) {
			var tx =  -(4*59);
			Tweener.addTween(sp,{x:tx,time:_SPEED,transition :_TRANS});
			Tweener.addTween(numbering.prevBtn,{alpha:1,time:_SPEED,transition :_TRANS});
			Tweener.addTween(numbering.nextBtn,{alpha:0.3,time:_SPEED,transition :_TRANS});
			numbering.nextBtn.removeEventListener(MouseEvent.CLICK,nextBtnAction);
			numbering.prevBtn.addEventListener(MouseEvent.CLICK,prevBtnAction);
			numbering.prevBtn.buttonMode = true;
			numbering.nextBtn.buttonMode = false;
		}
		private function prevBtnAction(e:MouseEvent) {// 이전버튼 클릭
			Tweener.addTween(sp,{x:0,time:0.5,transition :_TRANS});
			Tweener.addTween(numbering.nextBtn,{alpha:1,time:_SPEED,transition :_TRANS});
			Tweener.addTween(numbering.prevBtn,{alpha:0.3,time:_SPEED,transition :_TRANS});
			numbering.nextBtn.addEventListener(MouseEvent.CLICK,nextBtnAction);
			numbering.prevBtn.removeEventListener(MouseEvent.CLICK,prevBtnAction);
			numbering.nextBtn.buttonMode = true;
			numbering.prevBtn.buttonMode = false;
		}
		private function setSelectThumb() {
			if (Main.selectThumb != this) {
				Main.selectClear();
				Main.selectThumb = this;
				barColor.gotoAndStop(2);
			}
			if (select != null) {
				select.out();
				select.addEvent();
				if (select.orgtype == "ganzi") {
					Main.frotingBarVisible();
				}
			}
		}
		public function selectOut() {
			setSelectThumb();
			barColor.gotoAndStop(1);
		}
		private function setImg(target:MovieClip) {
			if(Main.loadingFn() != null){
				Main.loadingFn();
			}
			img = new Sprite;
			targetType = target.orgtype;
			if (targetType == "ganzi") {
				ganziImg = new GanziImg(this,target.orgurl, Main.fileURL, Main.dataInfo, Main.waterMark);
				if (Main.wallgubun !=0 ) {
					emptyBg = new EmptyBg(stageW,stageH);
					img.addChild(emptyBg);
				}
				img.addChild(ganziImg);
				ganziImg.addEventListener("ganziEnd", ganziImgReSizing);
				 Main.dataInfo.selectRoomType = "시공사례"
			} else if (targetType == "pattern") {

				patternImg = new PatternImg(this,Main.dataInfo.patternURL,Main.dataInfo.wallpapergubun,stageW,stageH);
				var sizeCm:SizeCm = new SizeCm(img);
				imgDeco = new Sprite;
				if (Main.wallgubun !=0 ) {
					emptyBg = new EmptyBg(stageW,stageH);
					img.addChild(emptyBg);
				}
				img.addChild(patternImg);
				imgDeco.addChild(sizeCm);
				patternImg.addEventListener("patternImgEnd", patternImgReSizing);
				Main.dataInfo.selectRoomType = "3폭보기"
			} else if (targetType == "detail") {

				detailImg = new DetailImg(this,target.orgurl);
				img.addChild(detailImg);
				detailImg.addEventListener("detailImgEnd", detailImgReSizing);
				Main.dataInfo.selectRoomType = "질감보기"
			}
		}
		private function ganziImgReSizing(e:Event) {
			imgReSizie();
			Main.displayImg(img);
			Main.frotingBar.visible = false;
			Main.frotingBar.alpha = 0;
			Main.warn.visible = false;
			Main.warn.alpha = 0;
		}
		private function detailImgReSizing(e:Event) {
			imgReSizie();
			Main.displayImg(img);
		}
		private function patternImgReSizing(e:Event) {
			if (Main.dataInfo.wallpapergubun == 1 && patternImg != null) {
				patternImg.x = stageW/2 - patternImg.width/2;
				patternImg.y = stageH/2 - patternImg.height/2;
			} else if (Main.dataInfo.wallpapergubun == 2  && patternImg != null) {
				patternImg.y = stageH/2 - patternImg.height/2;
			}
			Main.displayImg(img,imgDeco);
		}
		public function loadingFn(st:String)	{
			Main.loadingFn(st);
		}
		public function loadingEnd(){
			Main.loadingEnd();
		}
		public function imgReSizie() {
			if (targetType == "pattern") {
				Main.frotingBar.setFrotingBarPos(stageW/2, stageH/2);
				patternImg.reSizePattern(stageW,stageH)
			} else if (targetType == "ganzi") {
				ganziImg.imgReSize(stageW,stageH);
				emptyBg.width = stageW;
				emptyBg.height = stageH;
			} else if (targetType == "detail") {
				Main.frotingBar.setFrotingBarPos(stageW/2, stageH/2);
				img.width = (img.width*stageH)/img.height;
				img.height = stageH;
			}
		}
	}
}