package did_as.com{

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.net.*;
	import did_as.com.TextSet;
	import did_as.com.CollectCheck;
	import caurina.transitions.Tweener;
	import flash.system.LoaderContext;

	public class WaterMark extends MovieClip {

		var Main:MovieClip;
		var imgURL:URLRequest;
		var thumb_img:Loader;
		var logoSt:String;

		public var ta:Number = 0.3;
		public var over:Number = 0;

		public var orgURL:String;
		public var num:Number;
		private var textSet:TextSet = new TextSet();
		private var imgBox:MovieClip;
		private var barW:Number = 0;

		public function WaterMark(main:MovieClip) {
			Main = main;
			promotionInfo.visible = false;
			barLine.visible = false;
		}
		
		public function setInfo(mc:MovieClip, target:MovieClip) {
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;
			imgURL = new URLRequest(mc.thumbURL);
			thumb_img = new Loader();
			thumb_img.load(imgURL,context);
			thumb_img.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);

			target.txtName.text = mc.strProductName+"";
			target.txtID.text = mc.strModel;
			logoSt = mc.strECollection;
			
			textSet.setText(target.txtName, 0xFFFFFF,15,-0.3, "korFont");
			textSet.setText(target.txtID, 0xa7a7a7,10,0,"engFont");
			target.logo.gotoAndStop(getLogoNum());
			trace("Log num", logoSt, getLogoNum());
			imgBox = target
		}
		
		private function getLogoNum() {
			var collect:CollectCheck = new CollectCheck();
			return collect.returnCollectNum(logoSt);
		}
		private function onComplete(e:Event) {
			var mc:Loader = Loader(e.target.loader);
			var bmp:Bitmap = Bitmap(mc.content);
			var img:Bitmap = new Bitmap(bmp.bitmapData.clone(),"auto",true);
			img.width = 30;
			img.height = 30;
			if (imgBox.holder.numChildren>0) {
				imgBox.holder.removeChildAt(0);
			}
			if(barW != 0){
				barLine.x = bg.x - barW;
			}
			imgBox.holder.addChild(img);
			barW = barW + imgBox.width + 30;
			bg.width = barW;
			bg.x = -(logo.width-2) ;
			imgBox.x = bg.x - bg.width +10;
		}
		public function setBgW(){
			barW = info.width + 30;
			bg.width = barW;
		}
		public function setBgWInit(){
			barW = 0
		}
	}
}