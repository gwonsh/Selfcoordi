package did_as.com{

	import flash.display.*;
	import flash.events.*;

	public class ReSizing extends Sprite {

		private var targetMc:Sprite;
		
		public function ReSizing(target:Sprite, W:Number, H:Number) {
			targetMc = target;
			var tw:Number = W;
			var th:Number = H;
			targetMc.height = (targetMc.height*tw)/targetMc.width;
			targetMc.width = tw;
			addChild(targetMc);
		}
	}
}