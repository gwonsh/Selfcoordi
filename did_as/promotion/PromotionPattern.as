package did_as.promotion{

	import flash.display.*;
	import flash.events.*;
	
	import did_as.com.Pattern;
	import did_as.com.BitmapCopy;
	import did_as.promotion.Comp_Direct;
	import caurina.transitions.Tweener;

	public class PromotionPattern extends MovieClip {

		private var Main:Object;
		private var _SPEED:Number=0.8;
		private var _TRANS:String="easeOutQuint";

		private var imgURL:String;
		private var wallgubun:Number;
		private var stageW:Number;
		private var stageH:Number;
		
		private var promotionPattern:Pattern;
		
		private var isOpen:String = "open";
		private var patternMask:Sprite = new Sprite();
		private var direct:Comp_Direct;
		private var img:Pattern;

		public function PromotionPattern(main:Object,url:String,gubun:Number) {
			Main=main;
			imgURL=url;
			wallgubun=gubun;
			
			stageW=Main.stageW;
			stageH=Main.stageH;

			direct=new Comp_Direct(this);
		}
		
		private function makeMask() {
			if(isOpen == "open"){
				
			}else if(isOpen == "close"){
				
			}
			with(patternMask.graphics){
				clear();
				beginFill(0xFF0000);
				drawRect(0,0,stageW/2, stageH);
				endFill();
			}
			patternMask.x = stageW/2
		}
		
		private function makePromoctionPattern(){
			makePattern();
			promotionPattern = new Pattern(this,target.orgurl,target.gubun,stageW,stageH);
			promotionPattern.addEventListener("patternEnd", onComplete);			
			makeMask()			
			promotionPattern.mask = patternMask;
		}
	}
}