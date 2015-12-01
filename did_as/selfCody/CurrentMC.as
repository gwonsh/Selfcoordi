package did_as.selfCody{

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.net.*;
	import flash.external.ExternalInterface;
	import did_as.com.SavePrintFn;
	import did_as.com.TextSet;
	import did_as.com.CollectCheck;
	import caurina.transitions.Tweener;

	public class CurrentMC extends MovieClip {

		private var imgURL:URLRequest;
		private var thumb_img:Loader;
		private var dataInfo:MovieClip;
		private var logoSt:String;
		private var orgURL:String;
		public var num:Number;
		private var waterMark:MovieClip;
		private var img:Sprite;
		private var fileURL:String;
		private var textSet:TextSet = new TextSet();
		private var Main:Object;

		public function CurrentMC(mark:MovieClip,FileURL:String, getIMG:Sprite, main:Object) {
			Main = main;
			fileURL = FileURL;
			img = getIMG;
			waterMark = mark;
		}
		
		private var saveBtn:SavePrintFn;
		private var printBtn:SavePrintFn;
		public function setInfo(mc:MovieClip) {			
			dataInfo = mc;
			imgURL = new URLRequest(dataInfo.thumbURL);
			thumb_img = new Loader();
			thumb_img.load(imgURL);
			thumb_img.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);

			txtName.text = dataInfo.strProductName;
			txtID.text = dataInfo.strModel;
			logoSt = dataInfo.strECollection;
			textSet.setText(txtName, 0xFFFFFF,16,-0.3, "korFont");
			textSet.setText(txtID, 0xa7a7a7,10.5,0,"engFont");
			logo.gotoAndStop(getLogoNum());
			btns.buttonMode = true;
			
			saveBtn = new SavePrintFn(Main,btns.imgSave,"save",img,fileURL,dataInfo,waterMark);
			btns.imgSave.buttonMode = true;
			btns.imgSave.removeEventListener(MouseEvent.CLICK, saveBtnClick);
			btns.imgSave.addEventListener(MouseEvent.CLICK, saveBtnClick);
			printBtn = new SavePrintFn(Main,btns.imgPrint,"print",img,fileURL,dataInfo,waterMark);			
			btns.imgPrint.removeEventListener(MouseEvent.CLICK, printBtnClick);
			btns.imgPrint.addEventListener(MouseEvent.CLICK, printBtnClick);	
			btns.screpBtn.addEventListener(MouseEvent.CLICK, screpFn);
		}
		
		private function saveBtnClick(e:MouseEvent){
			saveBtn.onClick(e);
		}
		
		private function printBtnClick(e:MouseEvent){
			printBtn.onClick(e);
		}
		
		private function getLogoNum() {
			var collect:CollectCheck = new CollectCheck();
			return collect.returnCollectNum(logoSt);
		}
		function screpFn(e:MouseEvent) {
			ExternalInterface.call("openUseageSelfCodi",dataInfo.oidProduct);
		}
		function onComplete(e:Event) {
			var mc:Loader = Loader(e.target.loader);
			var bmp:Bitmap = Bitmap(mc.content);
			var img:Bitmap = new Bitmap(bmp.bitmapData.clone(),"auto",true);
			img.width = 30;
			img.height = 30;
			if (holder.numChildren>0) {
				holder.removeChildAt(0);
			}
			holder.addChild(img);
			txtName.x = btns.x - txtName.textWidth - 10;
			txtID.x = txtName.x;
			holder.x = txtID.x - holder.width - 10;
			logo.x =holder.x- logo.width -10;
			light.x = logo.x- 10;
		}
	}
}