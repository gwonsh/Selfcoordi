package did_as.com{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.*;

	public class BitmapCopy extends MovieClip {
		public function BitmapCopy(container:Sprite, tw:Number, th:Number, targetW:Number = 1000, targetH:Number = 570) {
			trace("BitmapCopy / tw=",tw,"/ th=",th)
			var myBitmapData:BitmapData = new BitmapData(tw, th);
			myBitmapData.draw(container);
			var bmp:Bitmap = new Bitmap(myBitmapData,"auto",true);
			bmp.width = targetW;
			bmp.height=targetH;
			addChild(bmp);
		}
	}
}