package did_as.selfCody{

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import did_as.selfCody.Thumb_Product;
	import com.hangunsworld.net.XMLLoader;
	import did_as.com.CollectCheck;
	import caurina.transitions.Tweener;
	import flash.external.ExternalInterface;

	public class ProductList extends MovieClip {

		private var siteURL:String;
		private var sc1:String;
		private var sc2:String;
		private var sc3:String;
		private var sc4:String;
		private var sc5:String;
		private var nPageNo:String;
		private var thumb:Thumb_Product;
		private var xml:XML = new XML();
		private var loader:XMLLoader = new XMLLoader();
		private var info:XML = new XML();
		private var Main:MovieClip;
		private var listTotalNum:Number;
		private var _SPEED:Number = 0.5;
		private var _TRANS:String = "easeOutQuint";
		public var thumbArray:Array = new Array();
		private var selectMC:MovieClip;

		public function ProductList(main:MovieClip,url:String,getSc1:String,getSc2:String,getSc3:String,getSc4:String,getSc5:String,getPN:String) {
			Main = main;
			sc1 = getSc1;
			sc2 = getSc2;
			sc3 = getSc3;
			sc4 = getSc4;
			sc5 = getSc5;
			siteURL = url;
			nPageNo = getPN;
			getXML();
		}
		private function getXML() {
			var productXML_URL:String = siteURL+"/lib/xml/product_list.asp"
			   +"?SearchCategory1="+sc1
			   +"&SearchCategory2="+sc2
			   +"&SearchCategory3="+sc3
			   +"&SearchCategory4="+sc4
			   +"&SearchCategory5="+sc5
			   +"&nPageNo="+nPageNo;

			loader.load(new URLRequest(productXML_URL), "euc-kr");
			loader.addEventListener(Event.COMPLETE, onComplete);
		}
		private function onComplete(e:Event) {
			xml = XML(loader.data);
			listTotalNum = xml.@total;
			Main.totalPage = Math.ceil(listTotalNum/7);
			makeThumbs();
			if(Main.nPageNo == 1){
				Main.direct.setBtn();
			}
		}
		private function makeThumbs() {
			for (var i:uint = 0; i<xml.product.length(); i++) {
				var temp:XML = xml.product[i];
				var oid:Number = temp.@oidProduct;
				var strName:String = temp.@strProductName;
				var model:String = temp.@strModel;
				var gubun:Number = temp.@wallpapergubun;
				var ThumbURL:String = temp.thumbfileloc;
				var orgURL:String = temp.fileloc;
				var collection:String = temp.@strECollection;

				thumb = new Thumb_Product(oid,strName,model,gubun,ThumbURL,orgURL,collection);
				thumb.x = i*65;
				thumb.num = i;
				selectBoxLineCheck(thumb);
				thumbArray.push(thumb);
				thumb.alpha = 0;
				Tweener.addTween(thumb, {alpha:1, delay:thumb.num/10 ,time:_SPEED, transition:_TRANS});
				thumb.thumb.buttonMode = true;
				thumb.thumb.addEventListener(MouseEvent.CLICK,mouseEvent);
				addChild(thumb);
			}
			if (Main.firstNum == 1) {
				Main.setWallInfo(0);
				Main.frotingBarAlpha()
				Main.firstNum = 2;
			}
		}
		private function selectBoxLineCheck(target:MovieClip) {
			if (Main.selectMC != null) {
				if (target.oidProduct == Main.selectMC.oidProduct) {
					target.boxLine.alpha = 1
					removeBtn(target);
					Main.selectMC = target;
				}
			}
		}
		private function mouseEvent(e:MouseEvent) {
	
			var mc:MovieClip = MovieClip(e.target.parent);
			if (e.type == "click") {
				Main.progress_var = true;
				Main.selectWall(mc.num);
				removeBtn(mc);
			}
		}
		private function removeBtn(target:MovieClip){
			target.thumb.buttonMode = false;
			target.thumb.removeEventListener(MouseEvent.CLICK,mouseEvent);
			selectMC = target;
		}
		public function addBtn(target:MovieClip){
			target.thumb.buttonMode = true;
			target.thumb.addEventListener(MouseEvent.CLICK,mouseEvent);
		}
		public function removeAllBtn(){
			for (var i:uint = 0; i<thumbArray.length; i++) {
				thumbArray[i].thumb.buttonMode = false;
				thumbArray[i].thumb.removeEventListener(MouseEvent.CLICK,mouseEvent);
				thumbArray[i].thumb.alpha = 0.5
			}
		}
		public function addAllBtn(){
			for (var i:uint = 0; i<thumbArray.length; i++) {
				Tweener.addTween(thumbArray[i].thumb, {alpha:1, time:0.5, transition:_TRANS, onComplete:addAllBtnAction});
			}
		}
		private function addAllBtnAction(){
			for (var i:uint = 0; i<thumbArray.length; i++) {
				if(selectMC != thumbArray[i]){
					thumbArray[i].thumb.buttonMode = true;
					thumbArray[i].thumb.addEventListener(MouseEvent.CLICK,mouseEvent);
				}
			}
		}
	}
}