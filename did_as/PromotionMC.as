package did_as{

	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import did_as.promotion.*;
	import did_as.com.DataInfo;
	import did_as.self.SelfCody;
	import caurina.transitions.Tweener;

	public class PromotionMC extends MovieClip {

		public var Main:MovieClip;
		private var xml:XML;
		
		private var thumb:Thumb_Prom;		
		public var ty:Number=-85;// 클릭시 y축 범위
		public var select:MovieClip;
		
		public var promArray:Array=new Array;// 썸네일 배열
		private var dataInfoArray:Array=new Array;
		
		private var sp:Sprite=new Sprite;// 썸네일 박스
		private var img:MovieClip;
		
		private var _SPEED:Number=0.8;
		private var _TRENS:String="easeOutQuint";
		
		public var stageW:Number;
		public var stageH:Number;
		private var targetX:Number;
		private var interval:uint;
		private var txPos:Number = 100;
		private var tyPos:Number = 30;
		private var oldW:Number = 1000;
		private var oldH:Number = 570;
		
		private var roomURL:String;
		
		private var dataInfo:DataInfo;

		public function PromotionMC(main:MovieClip,getXml:XML) {
			Main=main;
			xml=getXml;
			
			stageW=Main.stageW;
			stageH=Main.stageH;
			targetX = stageW/2;
			
			roomURL = Main.siteURL+"/swf/product_render/render"+14+".jpg";
			
			getXML();
			barColor.gotoAndStop(1);
		}
		private function getXML() {//xml 데이터 구성
			var len=xml.thumb.length();
			for (var i:uint; i < len; i++) {

				var url=xml.thumb[i];
				var orgType=xml.thumb[i].@type;
				var orgURL=xml.thumb[i].@url;
				var productName=xml.thumb[i].@strProductName;
				var model=xml.thumb[i].@strModel;
				var oid=xml.thumb[i].@oidProduct;
				var collection=xml.thumb[i].@strECollection;
				var wallgubun=xml.thumb[i].@wallpapergubun;
				var num=15;

				dataInfo=new DataInfo(this);
				dataInfo.getDataInfo(model,productName,oid,wallgubun,collection,orgURL,url,"product");
				thumb=new Thumb_Prom(this,dataInfo,num);

				promArray.push(thumb);
				dataInfoArray.push(dataInfo);
			}
			display();
		}
		private function display() {// 데이터 디스플래이
			for (var i:uint; i < promArray.length; i++) {
				var mc=promArray[i];
				mc.x=i * 120 + 30;
				mc.y=40;
				sp.addChild(mc);
			}
			sp.mask=maskMC;
			addChild(sp);
		}
		public function onClick(target:MovieClip) {
			setSelectThumb();
			setImg(target);
			select=target;
			beginInterval();
		}
		private function setSelectThumb() {
			if (Main.selectThumb != this) {
				Main.selectClear();
				Main.selectThumb=this;
				barColor.gotoAndStop(2);
			}
			if (select != null) {
				select.out();
				select.addEvent();
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
			Main.dataInfo.selectRoomType = target.strProductName+"_베스트매치"
			var selfCody:SelfCody = new SelfCody(this,target,Main.dataInfo.wallpapergubun,Main.dataInfo.patternURL,roomURL,"pattern");
			selfCody.addEventListener("selfCodyEnd", selfCodyEnd);
			img = selfCody;
		}
		private function selfCodyEnd(e:Event) {
			//imgReSizie();
		}
		private function beginInterval(){
			if(interval>0){
				clearInterval(interval);
			}
			interval = setInterval(displayImg, 100);
		}
		private function displayImg(){			
			if(img.width != 0 && img.height != 0){
				clearInterval(interval);
				img.removePattern();
				imgReSizie();
				Main.displayImg(img);
			}else{
				return;
			}
		}
		public function imgReSizie() {
			var xPos:Number = (txPos*stageW)/oldW;
			var yPos:Number = (tyPos*stageH)/oldH;
			Main.frotingBar.setFrotingBarPos(stageW/2+xPos, stageH/2+yPos , "yes",select);
			img.width =Math.ceil((img.width*stageH)/img.height);
			img.height = stageH;
		}
		public function frotingBarMove(nameSt:String) {
			trace(nameSt)
		}
	}
}