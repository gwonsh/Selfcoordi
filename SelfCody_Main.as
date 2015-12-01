package {

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.system.System;

	import did_as.selfCody.*;
	import did_as.SelfMC;
	import did_as.com.FrotingBar;
	import did_as.com.WaterMark;
	import did_as.com.DataInfo;
	import did_as.com.BannerMotion;
	import caurina.transitions.Tweener;

	public class SelfCody_Main extends MovieClip {

		public var step1Select:Number;
		public var step2Select:Number;
		public var step1:String;
		public var step2:String;
		private var step1Str = ["거실", "안방", "서재", "주방", "아동"];
		private var bannerMotion:BannerMotion;
		private var self:SelfMC;
		public var img:Sprite = new Sprite();
		public var sp:Sprite = new Sprite();
		private var selectCount:Number = 0;
		private var _SPEED:Number = 0.5;
		private var _TRANS:String = "easeOutQuint";
		
		public var siteURL:String;
		public var fileURL:String;
		public var xmlURL:String;
		public var productXML_URL:String;
		private var productList:ProductList;

		public var SearchCategory1:String = "";
		public var SearchCategory2:String = "";
		public var SearchCategory3:String = "";
		public var SearchCategory4:String = "";
		public var SearchCategory5:String = "";
		public var nPageNo:String = "1";

		public var selectThumb:MovieClip;
		public var wallgubun:Number;
		public var patternURL:String;
		public var collection:String;
		public var model:String;
		public var pName:String;

		public var frotingBar:FrotingBar;
		private var setCategory:SetCategory;
		public var firstNum:Number = 1;
		private var currentRoom:MovieClip;

		private var currentMC:CurrentMC;
		public var waterMark:WaterMark;
		public var dataInfo:DataInfo;
		private var tempMask:MovieClip;
		private var tempMC:MovieClip;
		
		public var selectMC:MovieClip;
		private var step1IMG = [0,3,6,9,12];
		private var step2IMG:Array = new Array();
		private var step2Str:Array = new Array();

		public var direct:Direct;
		public var totalPage:Number;
		
		public var progress_var:Boolean = false;
		public var stageW:Number;
		public var stageH:Number;
		private var targetInterval:uint = 0;
		private var targetCount:Number = 0;
		public var step3Loading:Loading;
		private var blackBg:BlackBG;


		/* SearchBar click events : SetCategory /selectList(), collectionClick() */
		/* Thumb_Self : 엘레강스/모던/클래식 선택 박스 */
		/* ProductList : Thumbnails list */
		public function SelfCody_Main() {
			siteURL = LoaderInfo(this.root.loaderInfo).parameters.siteURL;
			fileURL = LoaderInfo(this.root.loaderInfo).parameters.FileURL;
			
			fileURL = "http://file.didwallpaper.com";
			siteURL = "http://www.didwallpaper.com";	
			xmlURL = siteURL+ "/lib/xml/category.asp";
			//productXML_URL = siteURL+"/lib/xml/product_list.asp";
			
			stageW = stage.stageWidth;
			stageH = 606;
			
			sp.alpha = 0;
			addChild(sp);			
		}
		public function select(selectSt:Number) {
			++selectCount;
			if (selectCount== 1) {
				step1Select = selectSt;
				step1 = step1Str[selectSt] ;
				step2Make();
			} else if (selectCount == 2) {
				step2Select = step2IMG[selectSt];
				step2 = step1Str[selectSt] ;
				Tweener.addTween(stepTitle, {alpha:0, time:_SPEED, transition:_TRANS});
				remove();
				play();
			}
		}
		public function step1Make() {
			var bannerMotion:BannerMotion = new BannerMotion(this,step1Str.length,203,160,151,128, step1Str, step1IMG);
			Tweener.addTween(stepTitle, {alpha:1, time:_SPEED, transition:_TRANS});
			Tweener.addTween(sp, {alpha:1, time:_SPEED, transition:_TRANS});			
			//trace("step1Make=",System.totalMemory);
		}
		public function step2Make() {
			var temp:Number = step1IMG[step1Select];
			if (step1 == "아동") {
				step2IMG = [temp,temp+1];
				step2Str = [step1+" 엘레강스", step1+" 모던"];
			} else {
				step2IMG = [temp,temp+1,temp+2];
				step2Str = [step1+" 엘레강스", step1+" 모던", step1+" 클래식"];
			}
			var bannerMotion:BannerMotion = new BannerMotion(this,step2Str.length,300,230,225,185, step2Str, step2IMG);
			Tweener.addTween(stepTitle, {alpha:0, time:_SPEED, transition:_TRANS, onComplete:step2Title});
			Tweener.addTween(sp, {alpha:0, time:_SPEED, transition:_TRANS, onComplete:stepRemove});
			//trace("step2Make=",System.totalMemory);
		}
		public function step3Make() {
			setCategory = new SetCategory(this,xmlURL);
			dataInfo = new DataInfo(this);
			waterMark = new WaterMark(this);
			play();
			//trace("step3Make=",System.totalMemory);
		}
		private function step2Title() {
			stepTitle.gotoAndStop(2);
			Tweener.addTween(stepTitle, {alpha:1, time:_SPEED, transition:_TRANS});
		}
		private function stepRemove() {
			remove();
			Tweener.addTween(sp, {alpha:1, time:_SPEED, transition:_TRANS});
		}
		private function remove() {
			if (sp.numChildren > 0) {
				sp.removeChildAt(0);
			}
		}
		private function step3Action() {
			makeList();			
			setLoading();			
			//trace("step3Action=",System.totalMemory);
		}
		private function setLoading(){
			step3Loading = new Loading();
			step3Loading.x = stageW/2;
			step3Loading.y = stageH/2;
			blackBg = new BlackBG();
			step3Loading.alpha = 0;
			blackBg.alpha = 0;
			addChild(blackBg);
			addChild(step3Loading);
		}
		public function loadingFn(st:String="") {
			trace("loadingFn")
			blackBg.visible = true;
			step3Loading.visible = true
			blackBg.alpha = 0.5
			step3Loading.alpha = 1
			step3Loading.play();
			step3Loading.dispatchEvent(new Event("loadingFnStart"));
		}
		public function loadingEnd(st:String = "",target:Object = null){
			trace("loadingEnd")
			blackBg.visible = false;
			step3Loading.visible = false;
			Tweener.addTween(blackBg, {alpha:0, time:0.5, transition:_TRANS});
			if(target != null){
				Tweener.addTween(step3Loading, {alpha:0, time:0.5, transition:_TRANS, onComplete:displayIMG, onCompleteParams:[st, target]});
			}
			step3Loading.gotoAndStop(1);
		}
		private function displayIMG(st:String,target:Object){
			if(st == "wall"){
				Tweener.addTween(target,{width:995,time:0.5, transition :_TRANS,onComplete:removeSprite});
			}else if(st == "room"){
				Tweener.addTween(target, {alpha:1, time:_SPEED, transition:_TRANS, onComplete:removeSprite});
			}
		}
		private function step3Display(){
			searchBar.up = 0;
			searchBar.yHome = searchBar.y;
			searchBar.btn.buttonMode = true;
			searchBar.btn.addEventListener(MouseEvent.CLICK, mouseEvent);
			//SelfMC -> SelfCody -> WallPainting()
			self = new SelfMC(this);
			self.x = -50;
			self.y = 560;
			self._STEP2Y = self.y;
			self._STEP1Y = self.y;
			
			frotingBar = new FrotingBar(waterMark,fileURL,img,this);
			frotingBar.alpha = 0;
			frotingBar.x = stage.stageWidth/2
			frotingBar.y = stage.stageHeight/2
			currentMC = new CurrentMC(waterMark,fileURL,img, this);
			currentMC.x = 500;
			
			direct = new Direct(this);
			
			imgCase.addChild(img);
			addChild(frotingBar);
			addChild(currentMC);
			addChild(direct);
			addChild(self);
			
			self.self_selectStep1Main(step1Select);
		}
		//step3Action() -> makeList() -> ProductList -> Main.setWallInfo() -> selectMCInfo()
		public function makeList() {
			productList = new ProductList(this,
										  						 siteURL,
										  						 SearchCategory1,
																 SearchCategory2,
																 SearchCategory3,
																 SearchCategory4,
																 SearchCategory5,
																 nPageNo);
			removeListBox();
			//trace("SearchCategory1=",SearchCategory1)
		}
		private function removeListBox() {
			if (listBox.numChildren > 0) {
				listBox.removeChildAt(0);
			}
			listBox.addChild(productList);
		}
		public function setWallInfo(selectNum:Number) {
			var temp:MovieClip = productList.thumbArray[selectNum];
			dataInfo.getDataInfo(temp.strModel,
								 				 temp.strProductName,
												 temp.oidProduct,
												 temp.wallpapergubun,
												 temp.strECollection,
												 temp.orgURL,
												 temp.thumbURL,
												 "self");
			selectBoxLine(temp);
			if(!currentMC){
				step3Display();
			}
			selectMCInfo();
		}
		//slefCody/ProductList.as 에서 Thumbnail 클릭했을 때
		public function selectWall(selectNum:Number) {			
			loadingFn();
			self.img.removePattern();			
			setWallInfo(selectNum);				
			self.setImage(self.select);					
			wallDisplay(self.img);
			this.progress_var = false;
		}
		public function frotingBarAlpha(){
			Tweener.addTween(frotingBar, {alpha:1 ,time:_SPEED, transition:_TRANS, onComplete:seachBarMove});
		}
		private function seachBarMove(){
			Tweener.addTween(searchBar, {y:searchBar.yHome-210, delay:1, time:_SPEED, transition:_TRANS, onComplete:serchBarHome});
		}
		private function serchBarHome(){
			Tweener.addTween(searchBar, {y:searchBar.yHome, delay:0.5 ,time:_SPEED, transition:_TRANS});
		}
		private function selectBoxLine(target:MovieClip){
			if(selectMC != null && target != selectMC){
				selectMC.boxLine.alpha = 0;
				productList.addBtn(selectMC);
			}
			target.boxLine.alpha = 1;
			selectMC = target;
		}
		private function mouseEvent(e:MouseEvent) {
			var mc:MovieClip = MovieClip(e.target.parent);
			if (mc.up == 0) {
				mc.up = 1;
				searchBar.icon.gotoAndStop(2);
				Tweener.addTween(mc, {y:mc.yHome-210, time:_SPEED, transition:_TRANS});
			} else if (mc.up == 1) {
				mc.up = 0;
				searchBar.icon.gotoAndStop(1);
				Tweener.addTween(mc, {y:mc.yHome, time:_SPEED, transition:_TRANS});
			}
		}
		public function displayImg(target:Sprite) {
			target.alpha = 0;
			img.addChild(target);
			//Tweener.addTween(target, {alpha:1, time:_SPEED, transition:_TRANS, onComplete:removeSprite});
			loadingEnd("room", target);
			//trace("displayImg=",System.totalMemory);
		}
		private function wallDisplay(target:MovieClip) {
			var imgMask:ImgMask = new ImgMask();
			var sp:Sprite = new Sprite();
			sp.addChild(target);
			sp.mask = imgMask;
			sp.addChild(imgMask);
			img.addChild(sp);
			getTargetInterval(target, imgMask,sp);
			//trace("wallDisplay=",System.totalMemory);
		}
		private function getTargetInterval(target:Sprite, maskMC:MovieClip, cont:Sprite){
			if(targetInterval > 0){
				clearInterval(targetInterval);
			}
			targetInterval = setInterval(traceWidth,100,target, maskMC,cont);
		}
		private function traceWidth(target:Sprite, maskMC:MovieClip, cont:Sprite){
			if(target.width > 0){
				clearInterval(targetInterval);				
				loadingEnd("wall",maskMC);
				maskMC.height = target.height
				//Tweener.addTween(maskMC,{width:1000,time:0.5, transition :_TRANS,onComplete:removeSprite});
			}
		}
		private function removeSprite() {
			if (img.numChildren > 1) {
				img.removeChildAt(0);
			}
			currentRoom = self.select;
			//trace("removeSprite=",System.totalMemory);
		}
		private function selectMCInfo() {
			currentMC.setInfo(dataInfo);
			waterMark.setBgWInit();
			waterMark.setInfo(dataInfo,waterMark.info);
			frotingBar.getDataInfo(dataInfo);
		}
		public function selectClear() {}
		//public function loadingFn(){}
	}
}