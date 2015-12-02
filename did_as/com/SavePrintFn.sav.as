package did_as.com{

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.external.ExternalInterface;
	import com.adobe.images.JPGEncoder;
	import nid.image.encoder.JPEGEncoder;
	import nid.image.encoder.PNGEncoder;
	import encoding.Base64;

	public class SavePrintFn {

		private var type:String;
		private var fileURL:String;
		private var model:String;
		private var getBtn:MovieClip;
		private var imgMC:Sprite;
		private var pageType:String;
		private var selectRoomType:String;
		private var btn:Object;
		private var waterMark:MovieClip;
		private var sp:Sprite = new Sprite();
		private var targetW:Number;
		private var targetH:Number;
		private var Main:Object;
		private var dataInfo:MovieClip;

		public function SavePrintFn(main:Object,getBtn:Object,getType:String, getImg:Sprite, FileURL:String, getDataInfo:MovieClip,mark:MovieClip,tw:Number= 800, th:Number=485) {
			Main = main;
			waterMark = mark;
			type = getType;
			btn = getBtn;
			imgMC = getImg;
			fileURL=FileURL;
			dataInfo = getDataInfo
			model = dataInfo.strModel;
			selectRoomType = dataInfo.selectRoomType;
			
			targetW = tw;
			targetH = th;
			
			if(getDataInfo.pageType == "product"){
				pageType ="";
			}else if(getDataInfo.pageType == "self"){
				pageType ="_cody";
			}

			btn.buttonMode = true;
			btn.addEventListener(MouseEvent.CLICK,onClick);
		}
		private function onClick(e:MouseEvent) {
			Main.loadingFn("save");
			setTimeout(makeBmp, 100)

		}
		private function makeBmp(){
			if(imgMC.width == 1000){
				bmpReSize(imgMC, imgMC.width, 606);
			}else{
				bmpReSize(imgMC, imgMC.width, imgMC.height);
			}
		}
		private function setBmp(target:Sprite) {
			if (target.width != targetW) {
				bmpReSize(target, targetW, 0)
			/*} else if (target.height != targetH) {
				bmpReSize(target, 0, targetH)*/
			} else {
				waterMark.x = target.width - 15;
				waterMark.y = target.height-15;
				target.addChild(waterMark);
				jpgMake(target);
			}
		}
		private function bmpReSize(target:Sprite, w:Number, h:Number){
			var tw:Number = w;
			var th:Number = h;
			if(h == 0){
				tw = target.width;
				th = target.height;
			}else if(w == 0){
				tw = target.width;
				th = h;
			}
			var bmd:BitmapData = new BitmapData (tw,th);
			var bm:Bitmap = new Bitmap(bmd, "auto", true);
			var map:Sprite = new Sprite();
			bmd.draw(target);
			if(h == 0){
				bm.height = (bm.height*w)/bm.width
				bm.width = w
			}
			map.addChild(bm);
			setBmp(map);
		}
		private var W:int;
		private var H:int;
		private function jpgMake(target:Sprite) {
			if(dataInfo.selectRoomType != ""){
				selectRoomType = "_"+dataInfo.selectRoomType;
			}
			
			W = target.width;
			H = target.height;
			var jpgSource:BitmapData = new BitmapData (target.width,target.height);
			jpgSource.draw(target);
			var byteArray:ByteArray = new JPEGEncoder().encode(jpgSource, 150);
			var b64:String = Base64.encode64(byteArray, true);			
			ExternalInterface.call('generateWin', b64, dataInfo.oidProduct, type, model+selectRoomType+pageType+".jpg");
			Main.loadingEnd();
		}
		public function loadingEnd(){
			Main.loadingEnd();
		}
		private function uploadComplete(e:Event){
			Main.loadingEnd();
			var fileName:String = escapeMultiByte(model+selectRoomType+pageType+".jpg");
			var url:String = fileURL + "/selfcodi/image_view.php?name="+ fileName +"&type="+type + "&widthNum=" + W + "&heightNum=" + H ;
			var request:URLRequest = new URLRequest(url);
			navigateToURL(request,"_blank");	
		}
	}
}