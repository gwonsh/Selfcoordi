package did_as.promotion{

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import did_as.com.Thumb;
	import caurina.transitions.Tweener;
	
	public class Thumb_Prom extends MovieClip {

		public var orgtype:String;
		public var orgurl:String;
		
		public var strModel:String;		
		public var strProductName:String;
		public var oidProduct:Number;
		public var wallpapergubun:Number;
		public var strECollection:String;
		public var patternURL:String;
		public var thumbURL:String;
		
		public var num:Number;
		private var Main:Object;
		private var thumb:Thumb;
		private var _SPEED:Number = 0.8;
		private var _TRANS:String = "easeOutQuint";

		var newFormat:TextFormat = new TextFormat();

		public function Thumb_Prom(main:Object, dataInfo:MovieClip, getNum:Number) {

			Main = main;
			
			strModel = dataInfo.strModel;
			strProductName = dataInfo.strProductName;
			oidProduct = dataInfo.oidProduct;
			wallpapergubun = dataInfo.wallpapergubun;
			strECollection = dataInfo.strECollection;
			patternURL = dataInfo.patternURL
			thumbURL = dataInfo.thumbURL;
			num = getNum;
			
			/*orgtype = orgType;
			orgurl = orgURL;
			strModel = productID;
			strProductName = productName;
			wallpapergubun = wallgubun;
			strECollection = collection;
			num = getNum;*/
			
			name = "patternMatch"

			thumb=new Thumb(this,thumbURL,50,50);
			holder.addChild(thumb);
			alpha = 0.3;
			setText();

			btn.buttonMode = true;
			btn.addEventListener(MouseEvent.ROLL_OVER,mouseEvent);
			btn.addEventListener(MouseEvent.ROLL_OUT,mouseEvent);
			btn.addEventListener(MouseEvent.CLICK,mouseEvent);
			
		}
		private function setText() {
			newFormat.bold = true;
			productid_txt.text = strModel;
			//productname_txt.text = pname;
			//productname_txt.setTextFormat(newFormat);
		}
		private function mouseEvent(e:MouseEvent){
			if(e.type == "rollOver"){
				over();
			}else if(e.type == "rollOut"){
				out();
			}else if(e.type == "click"){
				onClick();
			}
		}
		public function over() {
			Tweener.addTween(this,{alpha:1,time:_SPEED,transition:_TRANS});
		}
		public function out() {
			Tweener.addTween(this,{alpha:0.3,time:_SPEED,transition:_TRANS});
		}
		public function onClick() {
			Main.onClick(this);
			removeEvent();
		}
		private function removeEvent() {
			btn.buttonMode = false;
			btn.removeEventListener(MouseEvent.ROLL_OVER,mouseEvent);
			btn.removeEventListener(MouseEvent.ROLL_OUT,mouseEvent);
			btn.removeEventListener(MouseEvent.CLICK,mouseEvent);
		}
		public function addEvent() {
			btn.buttonMode = true;
			btn.addEventListener(MouseEvent.ROLL_OVER,mouseEvent);
			btn.addEventListener(MouseEvent.ROLL_OUT,mouseEvent);
			btn.addEventListener(MouseEvent.CLICK,mouseEvent);
		}
	}
}