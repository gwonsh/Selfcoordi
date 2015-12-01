package did_as.promotion{

	import flash.display.*;
	import flash.events.*;
	import caurina.transitions.Tweener;
	public class Comp_Direct extends MovieClip {

		private var Main:Object
		private var tx:Number;
		private var _SPEED:Number = 0.8;
		private var _TRENS:String ="easeOutQuint";
		public var openPattern:Number = 1;
		
		public var stageW:Number;
		public var stageH:Number;

		public function Comp_Direct(main:Object) {
			Main = main;
			stageW = Main.stageW;
			stageH = Main.stageH;
			
			Tweener.addTween(this, {alpha:0, time:_SPEED, transition:_TRENS});
			
			btn.buttonMode = true;
			btn.addEventListener(MouseEvent.CLICK,mouseEvent);
			btn.addEventListener(MouseEvent.ROLL_OVER,mouseEvent);
			btn.addEventListener(MouseEvent.ROLL_OUT,mouseEvent);
			
			reSizeImg();
		}
		private function mouseEvent(e:MouseEvent) {
			if (e.type == "rollOver") {
				over();
			} else if (e.type == "rollOut") {
				out();
			} else if (e.type == "click") {
				onClick();
			}
		}
		private function over() {
			Tweener.addTween(this, {alpha:1, time:_SPEED, transition:_TRENS});
		}
		private function out() {
			Tweener.addTween(this, {alpha:0, time:_SPEED, transition:_TRENS});
		}
		private function onClick() {
			var targetX:String;
			if (openPattern == 1) {
				openPattern = 2;
				targetX = "close";
				btn.removeEventListener(MouseEvent.ROLL_OUT,mouseEvent);
				over();
			} else if(openPattern == 2){
				openPattern = 1;
				targetX = "open" ;
				btn.addEventListener(MouseEvent.ROLL_OUT,mouseEvent);
				out();
			}
			Main.movePromotionPattern(targetX);
			direct.gotoAndStop(openPattern);
		}
		public function reSizeImg(){
			direct.y = stageH / 2;		
			btn.height = stageH;
		}
	}
}