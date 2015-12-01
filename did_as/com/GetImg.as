package did_as.com{

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.LoaderContext;

	public class GetImg extends Sprite {

		private var imgURL:URLRequest;
		private var loder:Loader;
		private var Main:Object;
		private var urlSt:String;

		public function GetImg(main:Object, url:String) {
			Main = main;
			urlSt = url;
			onLoadEvent();
		}
		
		private function onLoadEvent() {
			imgURL = new URLRequest(urlSt);
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;
			loder = new Loader();
			loder.load(imgURL,context);
			loder.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
		}
		private function onComplete(e:Event) {
			//var image:Bitmap = Bitmap(loder.content);
			//var bitmap:BitmapData = image.bitmapData;
			addChild(loder);
			dispatchEvent(new Event("getImgEnd"));
		}
	}
}