package did_as.com{

	import flash.display.*;

	public class EmptyBg extends MovieClip {
		public function EmptyBg(stageW:Number, stageH:Number) {
			var myBitmapData:BitmapData = new BitmapData(stageW, stageH, false, 0x000000);
			var bmp:Bitmap = new Bitmap(myBitmapData);
			addChild(bmp);
		}
	}
}