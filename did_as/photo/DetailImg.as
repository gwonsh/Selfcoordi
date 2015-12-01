package did_as.photo{

	import flash.display.*;
	import flash.events.*;
	import did_as.com.GetImg;

	public class DetailImg extends MovieClip {
		private var Main:Object;
		private var setImg:GetImg;
		public function DetailImg(main:Object, url:String) {
			Main = main;
			setImg = new GetImg(this,url);
			setImg.addEventListener("getImgEnd", onComplete);
		}
		private function onComplete(e:Event) {
			addChild(setImg);
			dispatchEvent(new Event("detailImgEnd"));
		}
	}
}