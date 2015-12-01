package did_as.com{

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.LoaderContext;

	public class Thumb extends MovieClip {

		private var imgURL:URLRequest;
		private var thumb_img:Loader;
		private var imgW:Number;
		private var imgH:Number;
		private var urlStr:String;
		private var thisParent:MovieClip;

		public function Thumb(getParent:MovieClip,url:String, sizeW:Number, sizeH:Number) {
			thisParent = getParent;
			imgW = sizeW;
			imgH = sizeH;
			urlStr = url;
			getThumbImg();
		}
		private function getThumbImg(){
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;
			imgURL = new URLRequest(urlStr);
			thumb_img = new Loader();
			thumb_img.load(imgURL,context);
			thumb_img.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
		}
		private function onComplete(e:Event) {
			var mc:Loader = Loader(e.target.loader);
			var bmp:Bitmap = Bitmap(mc.content);
			var img:Bitmap = new Bitmap(bmp.bitmapData.clone(),"auto",true);
			img.width = imgW;
			img.height = imgH;
			addChild(img);
		}
	}
}