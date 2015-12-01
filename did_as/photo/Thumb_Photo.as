package did_as.photo{

	import flash.display.MovieClip;
	import flash.events.*;
	import did_as.com.Thumb;
	import caurina.transitions.Tweener;

	public class Thumb_Photo extends MovieClip {

		public var orgtype:String;
		public var orgurl:String;
		private var Main:Object;
		private var thumb:Thumb;
		private var _SPEED:Number = 0.8;
		private var _TRANS:String = "easeOutQuint";

		public function Thumb_Photo(main:Object, getthumbURL:XML,url:String, type:String, xPos:Number, nameSt:String) {
			
			Main = main;
			orgtype=type;
			orgurl=url;

			thumb=new Thumb(this,getthumbURL,50,50);
			holder.addChild(thumb);

			x = xPos;
			name = nameSt;
			alpha = 0.3;
			tip.img.gotoAndStop(type);
			tip.stop();
			
			addEvent();
		}
		private function mouseEvent(e:MouseEvent){
			if (e.type == "rollOver") {
					over();
					mcTipAlpha(1);
			} else if (e.type == "rollOut") {
					out();
					mcTipAlpha(0);
			} else if (e.type == "click") {
					onClick();
			}
		}
		private function over(){
			Tweener.addTween(this,{alpha:1,time:_SPEED, transition :_TRANS});
		}
		public function out(){
			Tweener.addTween(this,{alpha:0.3,time:_SPEED, transition :_TRANS});
		}
		private function onClick(){
			Main.getImage(this);
			removeEvent();
		}
		private function mcTipAlpha(num:Number){
			if(num == 1) tip.gotoAndPlay(2);
			Tweener.addTween(tip,{alpha:num,time:_SPEED, transition :_TRANS});
		}
		public function removeEvent(){
			btn.buttonMode = false;
			btn.removeEventListener(MouseEvent.ROLL_OVER,mouseEvent);
			btn.removeEventListener(MouseEvent.ROLL_OUT,mouseEvent);
			btn.removeEventListener(MouseEvent.CLICK,mouseEvent);
			mcTipAlpha(0)
		}
		public function addEvent(){
			btn.buttonMode = true;
			btn.addEventListener(MouseEvent.ROLL_OVER,mouseEvent);
			btn.addEventListener(MouseEvent.ROLL_OUT,mouseEvent);
			btn.addEventListener(MouseEvent.CLICK,mouseEvent);
		}
	}
}



