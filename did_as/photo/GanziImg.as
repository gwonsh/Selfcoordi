package did_as.photo{

	import flash.display.*;
	import flash.events.*;
	import did_as.com.GetImg;
	import did_as.com.SavePrintFn;
	import did_as.com.TextSet;
	import did_as.com.CollectCheck;

	public class GanziImg extends MovieClip {

		private var Main:Object;
		private var setImg:GetImg;
		private var infoBoxhome:Number;
		private var fileURL:String;
		private var model:String;
		private var productName:String;
		private var waterMark:MovieClip;
		private var textSet:TextSet;
		private var oldSw:Number;
		private var oldSh:Number;
		private var dataInfo:MovieClip;

		public function GanziImg(main:Object, url:String, FileURL:String, getDataInfo:MovieClip, mark:MovieClip) {
			Main = main;
			fileURL = FileURL;
			dataInfo = getDataInfo;
			waterMark = mark;
			
			model = dataInfo.strModel;
			productName = dataInfo.strProductName;

			textSet = new TextSet();
			setImg = new GetImg(this,url);
			setImg.addEventListener("getImgEnd", onComplete);
			infoBox.logo.gotoAndStop(getLogoNum(dataInfo.strECollection));
			infoBoxhome = infoBox.x+50;

		}
		private function getLogoNum(logoSt:String) {
			var collect:CollectCheck = new CollectCheck();
			return collect.returnCollectNum(logoSt);
		}
		private function onComplete(e:Event) {

			infoBox.info.productName.text = productName+"  ";
			infoBox.info.model.text = model;
			textSet.setText(infoBox.info.productName,0xCCCCCC, 12, -0.5, "korFont");
			textSet.setText(infoBox.info.model,0x999999, 10, 0, "engFont");
			infoBox.btns.x = infoBox.info.width + 10;
			all.mc.mask = all.maskMC;
			all.mc.addChild(setImg);

			var saveBtn:SavePrintFn = new SavePrintFn(Main, infoBox.btns.saveBtn,"save",setImg, fileURL, dataInfo,waterMark, setImg.width, setImg.height);
			var printBtn:SavePrintFn = new SavePrintFn(Main,infoBox.btns.printBtn,"print",setImg, fileURL,dataInfo,waterMark, setImg.width, setImg.height);

			oldSw = Main.stageW;
			oldSh = Main.stageH;

			dispatchEvent(new Event("ganziEnd"));
		}
		public function imgReSize(tw:Number, th:Number) {
			
			x = tw/2 - width/2 + 100;
			y = th/2 - height/2 + 60;

			/*var oldW = all.width;
			var oldH = all.height;
			var oldBox = infoBox.x;
			var newH = (oldH*th)/oldSh;*/

			/*if (newH < 590) {
				all.width = (all.width*newH)/all.height;
				all.height = newH;
				infoBox.x= oldBox +(all.width-oldW);
			}else{
				infoBox.x=infoBoxhome;
			}*/
			
			/*oldSw = tw;
			oldSh = th;*/
		}
	}
}