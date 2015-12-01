package did_as.com{
	
	import flash.display.*;
	import caurina.transitions.Tweener;
	
	public class Loading extends MovieClip {
		var Main:Object;
		public function Loading(main:Object,W:Number,H:Number) {
			Main = main;
			x = W/2;
			y = H/2 - 50;
			alpha = 0;
			showLoding();
		}
		private function showLoding(){
			Tweener.addTween(this, {alpha:1, time:0.8});
		}
		public function hidenLoding(){
			Main.removeChild(this);
		}
	}
}