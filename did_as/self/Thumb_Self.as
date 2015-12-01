package did_as.self{

	import flash.display.*;
	import flash.events.*;
	import did_as.com.Thumb;

	public class Thumb_Self extends MovieClip {

		private var Main:Object;
		private var thumb:Thumb;
		private var overCount:Number;
		public var orgurl:String;
		public var num:Number;

		public function Thumb_Self(main:Object,url:String,orgURL:String,textNum:Number,nameSt,xPos:Number,getNum:Number) {
			Main = main;
			orgurl = orgURL;
			num = getNum;
			thumb=new Thumb(this,url,80,48);
			holder.addChild(thumb);
			txt.gotoAndStop(textNum);
			name = nameSt;
			x = xPos;
			addEvent();
		}
		private function mouseEvent(e:MouseEvent) {
			var mc:MovieClip = MovieClip(e.target.parent)
			if(e.type == "rollOver"){
				over();
			}else if(e.type == "rollOut"){
				out();
			}else if(e.type == "click"){
				onClick();
			}
		}
		public function over(){
			overCount = 1;
			addEventListener(Event.ENTER_FRAME, loopFn);
		}
		public function out(){
			overCount = 0;
			addEventListener(Event.ENTER_FRAME, loopFn);
		}
		private function loopFn(e:Event){
			if(overCount){
				nextFrame();
				if(currentFrame == totalFrames){
					removeEventListener(Event.ENTER_FRAME, loopFn);
				}
			}else{
				prevFrame();
				if(currentFrame == 1){
					removeEventListener(Event.ENTER_FRAME, loopFn);
				}
			}
		}
		public function onClick(){
			Main.getImages(this);
			removeEvent();
		}
		private function removeEvent(){
			btn.buttonMode = false;
			btn.removeEventListener(MouseEvent.CLICK,mouseEvent);
			btn.removeEventListener(MouseEvent.ROLL_OVER,mouseEvent);
			btn.removeEventListener(MouseEvent.ROLL_OUT,mouseEvent);
		}
		public function addEvent(){
			btn.buttonMode = true;
			btn.addEventListener(MouseEvent.CLICK,mouseEvent);
			btn.addEventListener(MouseEvent.ROLL_OVER,mouseEvent);
			btn.addEventListener(MouseEvent.ROLL_OUT,mouseEvent);
		}
	}
}


