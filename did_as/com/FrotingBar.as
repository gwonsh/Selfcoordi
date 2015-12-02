package did_as.com{

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.net.*;
	import did_as.com.Thumb;
	import did_as.com.SavePrintFn;
	import did_as.com.TextSet;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	import flash.external.ExternalInterface;
	import flash.system.LoaderContext;

	public class FrotingBar extends Sprite {

		public var collection:String;
		public var pName:String;
		public var model:String;
		public var oidproduct:Number;
		public var thumbURL:String;
		public var fileURL:String;
		public var img:Sprite;
		private var waterMark:MovieClip;

		private var thumb:Thumb;
		public var xHome:Number;
		public var yHome:Number;
		public var stageW:Number;
		public var stageH:Number;
		private var loder:Loader;

		private var textSet:TextSet = new TextSet();
		private var _SPEED:Number=0.8;
		private var _TRANS:String="easeOutQuint";	
		private var bgYhome:Number;
		private var bgHhome:Number;
		private var totalWidth:Number = 0;
		private var Main:Object

		public function FrotingBar(mark:MovieClip, FileURL:String, getIMG:Sprite, main:Object) {
			
			Main = main;
			
			fileURL = FileURL;
			img = getIMG;
			waterMark = mark;
			bgYhome = bg.f_bg_bg.y;
			
			bgHhome = bg.f_mask.height;
			promotionInfo.visible = false;
			alpha = 0.8
			ColorShortcuts.init();
		}
		private var saveBtn:SavePrintFn;
		private var printBtn:SavePrintFn;
		public function getDataInfo(dataInfo:MovieClip) {
			addEventListener(Event.ADDED_TO_STAGE,initHeander);				
			saveBtn = new SavePrintFn(Main,bg.saveBtn,"save",img, fileURL, dataInfo,waterMark);
			bg.saveBtn.removeEventListener(MouseEvent.CLICK, saveBtnClick);
			bg.saveBtn.addEventListener(MouseEvent.CLICK, saveBtnClick);			
			printBtn = new SavePrintFn(Main,bg.printBtn,"print",img, fileURL, dataInfo,waterMark);
			bg.printBtn.removeEventListener(MouseEvent.CLICK, printBtnClick);
			bg.printBtn.addEventListener(MouseEvent.CLICK, printBtnClick);				
			setDataInfo(info,dataInfo);
		}
		
		private function saveBtnClick(e:MouseEvent){
			saveBtn.onClick(e);
		}
		
		private function printBtnClick(e:MouseEvent){
			printBtn.onClick(e);
		}
		
		private function initHeander(e:Event) {
			init();
		}
		private function init() {
			stageW=stage.stageWidth;
			stageH=stage.stageHeight;
			x = stageW/2;
			y = stageH/2;
			removeEventListener(Event.ADDED_TO_STAGE,initHeander);
		}
		public function setDataInfo(target:MovieClip, dataInfo:MovieClip) {
			target.strProductName = dataInfo.strProductName;
			target.strModel = dataInfo.strModel;
			target.oidProduct = dataInfo.oidProduct;
			target.thumbURL = dataInfo.thumbURL;
			target.strECollection = dataInfo.strECollection;
			target.pName.text=target.strProductName;
			target.modelText.text=target.strModel;
			textSet.setText(target.pName, 0x333333, 10, 0, "korFont");
			
			thumbLoad(dataInfo.thumbURL, target);
			target.logo.gotoAndStop(setCollection(dataInfo.strECollection));
			if(target.width > totalWidth){
				bgSize(target);
			}
		}
		private function thumbLoad(url:String, target:MovieClip){
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;
			loder = new Loader();
			loder.load(new URLRequest(url),context);
			loder.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete);
			target.img.addChild(loder)
		}
		private function loadComplete(e:Event){
			loder.width = 22
			loder.height = 22
		}
		private function setCollection(logoSt:String) {
			trace(logoSt, "logo");
			var collect:CollectCheck = new CollectCheck();
			return collect.returnCollectNum(logoSt);
		}
		private function bgSize(target:MovieClip){
			totalWidth = target.width + 10;
			if(totalWidth < 170){
				totalWidth = 170;
			}
			bg.f_bg_bg.width = totalWidth - (bg.f_bg_left.width+bg.f_bg_right.width)+1;
			bg.f_bg_right.x =bg.f_bg_bg.x+bg.f_bg_bg.width;
			
			bg.f_bar_bg.width = totalWidth - (bg.f_bar_left.width+bg.f_bar_right.width)+1;
			bg.f_bar_right.x = bg.f_bar_bg.x+bg.f_bar_bg.width;
			
			bg.f_mask.width = totalWidth;
			
			bg.movBtn.width = bg.f_bar_right.x
			bg.saveBtn.x = bg.movBtn.x+bg.movBtn.width
			bg.printBtn.x = bg.saveBtn.x + bg.saveBtn.width
			bg.movBtn.buttonMode = true;			
			bg.movBtn.addEventListener(MouseEvent.MOUSE_DOWN, mouseEvent);
			bg.movBtn.addEventListener(MouseEvent.MOUSE_UP, mouseEvent);
			bg.addEventListener(MouseEvent.MOUSE_UP, mouseEvent);
		}
		public function setFrotingBarPos(xPos:Number,yPos:Number, isPromotion:String = "no", dataInfo:MovieClip = null) {
			if(isPromotion == "yes"){
				bg.f_mask.height = bg.f_bg_bg.height;
				bg.f_bg_bg.y = bg.f_bg_right.y = bg.f_bg_left.y = 18.9;				
				promotionInfo.visible = true;
				setDataInfo(promotionInfo, dataInfo);
				promotionInfo.buttonMode = true;
				promotionInfo.addEventListener(MouseEvent.CLICK, infoBtnClick);
				waterMarkPromotionSet("yes");
			}else if(isPromotion == "no" && promotionInfo.visible == true){
				promotionInfo.visible = false;
				bg.f_mask.height = bgHhome;
				bg.f_bg_bg.y = bg.f_bg_right.y = bg.f_bg_left.y = bgYhome;
				waterMarkPromotionSet("no");
			}
			xHome=xPos;
			yHome=yPos;
			Tweener.addTween(this,{x:xPos,time:_SPEED,transition:_TRANS});
			Tweener.addTween(this,{y:yPos,time:_SPEED+0.5,transition:_TRANS});
		}
		private function waterMarkPromotionSet(isPromotion:String){
			if(isPromotion == "yes"){
				waterMark.promotionInfo.visible =true;
				waterMark.barLine.visible = true;
				waterMark.setBgW();
				waterMark.setInfo(promotionInfo,waterMark.promotionInfo);
			}else if(isPromotion == "no"){
				waterMark.setBgW();
				waterMark.promotionInfo.visible =false;
				waterMark.barLine.visible = false;
			}
		}
		private function mouseEvent(e:MouseEvent) {
			if (e.type == "mouseDown") {
				startDrag();
			} else if (e.type == "mouseUp") {
				stopDrag();
			}
		}
		private function infoBtnClick(e:MouseEvent){
			var mc:MovieClip = MovieClip(e.currentTarget);
			ExternalInterface.call("goURL",'seeview',mc.oidProduct);
		}
	}
}