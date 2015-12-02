package did_as{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.*;
	import flash.utils.*;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	import did_as.self.*;
	import did_as.com.EmptyBg;

	public class SelfMC extends MovieClip {

		public var ty:Number = _STEP1Y;// y축 이동 범위
		public var select:MovieClip;// 현재 선택중인 step2
		public var imgSp:Sprite;
		public var stageW:Number;
		public var stageH:Number;

		public var _STEP1Y:Number = -55;// step1일때 이동범위
		public var _STEP2Y:Number = -130;// step2일때 이동범위
		private var thumb:Thumb_Self;//썸네일

		private var selfArray_step1:Array = new Array;
		private var selfArray_step2:Array = new Array;
		public var imgArray:Array = new Array;
		private var step1Name:Array = ["거실","안방","서재","주방","아동"];
		private var step2Name:Array = ["엘레강스","모던","클래식"];

		private var sp:Sprite = new Sprite();
		private var select_step1:MovieClip;// 현재 선택중인 step1
		private var select_step2:MovieClip;// 현재 선택중인 step1
		private var oldSelect:MovieClip;// step1 이전 값

		private var step1_num:Number;
		private var step2_num:Number;
		private var gep:Number;
		public var Main:MovieClip;

		private var speed:Number = 0.8;
		private var trans:String = "easeOutQuint";
		//public var selfCody:SelfCody;
		private var step1RandNum:Number;
		private var txPos:Number;
		private var tyPos:Number;
		public var img:MovieClip;
		private var interval:uint;
		private var oldW:Number = 1000;
		private var oldH:Number = 570;
		
		private var emptyBg:EmptyBg;

		public function SelfMC(main:MovieClip) {
			ColorShortcuts.init();
			Main = main;
			
			stageW=Main.stageW;
			stageH=Main.stageH;			
			trace("stageW=",stageW,"stageH=",stageH)
			display();
			step2MakeThumb();
			step1BtnAction();
			//barColor.gotoAndStop(1)
		}
		public function self_selectStep1Main(num:Number) {
			step1RandNum = num;
			step1ClickFn(selfArray_step1[num]);
			step1Over(selfArray_step1[num]);
			addEventListener("step1MoveComplete", self_selectSetp2Main);
		}
		public function self_selectSetp2Main(e:Event) {
			if (Main.step2Select != null) {
				selfArray_step2[Main.step2Select].over();
				selfArray_step2[Main.step2Select].onClick();
			}
			removeEventListener("step1MoveComplete", self_selectSetp2Main);
		}
		//최초 실행시 장소 랜덤 선택
		private var firstStyle:int;
		public function selectMain(place:int = -1, style:int = -1) {
			firstStyle = style;
			//최초 받아온 값이 없을 때는 랜덤으로
			if(place == -1){
				place = Math.floor(Math.random()*5);
			}
			step1RandNum = place;
			step1ClickFn(selfArray_step1[place]);
			step1Over(selfArray_step1[place]);
			addEventListener("step1MoveComplete", selectSetp2Main);
		}
		//최초 실행시 스타일 랜덤 선택
		private function selectSetp2Main(e:Event) {
			if(firstStyle == -1){
				firstStyle = Math.floor(Math.random()*2);
				if (step1RandNum == 5) {
					firstStyle = Math.floor(Math.random()*1);
				}
			}
			var go:Number = step1RandNum *3 + firstStyle;
			selfArray_step2[go].over();
			selfArray_step2[go].onClick();
			removeEventListener("step1MoveComplete", selectSetp2Main);
		}
		private function display() {
			sp.x = maskMC.x;
			sp.y = maskMC.y;
			sp.mask = maskMC;
			addChild(sp);
		}
		private function step1BtnAction() {
			for (var i:uint=0; i<5; i++) {
				this["space" + i].num = i;
				this["space" + i].txt.gotoAndStop(i+1);
				this["space" + i].btn.addEventListener(MouseEvent.ROLL_OVER,mouseEvent);
				this["space" + i].btn.addEventListener(MouseEvent.ROLL_OUT,mouseEvent);
				this["space" + i].btn.addEventListener(MouseEvent.CLICK,mouseEvent);
				selfArray_step1.push(this["space" + i]);
			}
		}
		
		//거실, 안방, 서재, 주방, 아동을 클릭 했을 경우
		private function mouseEvent(e:MouseEvent) {
			var mc:MovieClip = MovieClip(e.target.parent);
			if (e.type == "rollOver") {
				step1Over(mc);
			} else if (e.type == "rollOut") {
				step1Out(mc);
			} else if (e.type == "click") {
				step1ClickFn(mc);
			}
		}
		private function step1Over(target:MovieClip) {
			Tweener.addTween(target,{_color:0xE27B05,time:speed,transition :trans});
		}
		private function step1Out(target:MovieClip) {
			Tweener.addTween(target,{_color:0x4F4F4F,time:speed,transition :trans});
		}		
		//장소 클릭시
		private function step1ClickFn(target:MovieClip) {
			setSelectThumb();
			select_step1 = target;
			Tweener.addTween(sp,{x:-(target.num*3)*102+92,time:speed,transition :trans});
			step1removeEvent(select_step1);
			ty = _STEP2Y;
			Tweener.addTween(this,{y:ty,time:speed,transition :trans, onComplete:step1MoveComplete});
		}
		private function step1removeEvent(target:MovieClip) {
			target.btn.removeEventListener(MouseEvent.ROLL_OVER,mouseEvent);
			target.btn.removeEventListener(MouseEvent.ROLL_OUT,mouseEvent);
			target.btn.removeEventListener(MouseEvent.CLICK,mouseEvent);
			step1Over(target);
		}
		private function step1addEvent(target:MovieClip) {
			target.btn.addEventListener(MouseEvent.ROLL_OVER,mouseEvent);
			target.btn.addEventListener(MouseEvent.ROLL_OUT,mouseEvent);
			target.btn.addEventListener(MouseEvent.CLICK,mouseEvent);
			step1Out(target);
		}
		private function step1MoveComplete() {
			dispatchEvent(new Event("step1MoveComplete"));
		}
		
		private function step2MakeThumb() {
			var total = 14;
			for (var i:uint = 0; i<total; i++) {
				var url:String = Main.siteURL+"/swf/product_thumb/thumb_render"+i+".jpg";
				var orgURL:String = Main.siteURL+"/swf/product_render/render"+i+".jpg";
				var textNum:Number = (i%3)+1;
				var nameSt:String = step1Name[Math.floor(i/3)]+"_"+step2Name[(i%3)];
				var xPos:Number =  i*102;

				//엘레강스, 모던, 클래식등 아이콘 주가
				thumb = new Thumb_Self(this,url,orgURL,textNum,nameSt,xPos,i);
				selfArray_step2.push(thumb);
				sp.addChild(thumb);
			}
		}
		public function setImage(target:MovieClip) {			
			if(Main.loadingFn() != null){
				Main.loadingFn();
			}
			var selfCody:SelfCody = new SelfCody(this,target,Main.dataInfo.wallpapergubun,Main.dataInfo.patternURL);
			selfCody.addEventListener("selfCodyEnd", selfCodyEnd);			
			img = selfCody;
		}
		private function selfCodyEnd(e:Event) {
			imgReSizie();
		}
		//엘레강스, 모던, 클래식을 클릭했을 때
		public function getImages(target:MovieClip) {	
			step2Out();
			select = target;			
			setImage(select);
			beginInterval();
		}
		private function beginInterval(){
			if(interval>0){
				clearInterval(interval);
			}			
			interval = setInterval(displayImg, 100);
		}
		private function displayImg(){	
			if(img.width != 0 && img.height != 0){
				clearInterval(interval);
				img.removePattern();
				imgReSizie();				
				Main.displayImg(img);
			}else{
				return;
			}
		}
		public function frotingBarMove(nameSt:String) {
			var select:String = nameSt;
			if (select == "거실_엘레강스") {
				txPos = 200;
				tyPos = -150;
			} else if (select == "거실_모던") {
				txPos = 1;
				tyPos = -150;
			} else if (select == "거실_클래식") {
				txPos = 200;
				tyPos = -150;
			} else if (select == "안방_엘레강스") {
				txPos = -100;
				tyPos =-150;
			} else if (select == "안방_모던") {
				txPos = 100;
				tyPos = -150;
			} else if (select == "안방_클래식") {
				txPos = 100;
				tyPos = -150;
			} else if (select == "서재_엘레강스") {
				txPos = 200;
				tyPos = -160;
			} else if (select == "서재_모던") {
				txPos = 20;
				tyPos = -150;
			} else if (select == "서재_클래식") {
				txPos = 180;
				tyPos = -150;
			} else if (select == "주방_엘레강스") {
				txPos = -280;
				tyPos = -130;
			} else if (select == "주방_모던") {
				txPos = -50;
				tyPos = -150;
			} else if (select == "주방_클래식") {
				txPos = 200;
				tyPos = -150;
			} else if (select == "아동_엘레강스") {
				txPos = 200;
				tyPos = -180;
			} else if (select == "아동_모던") {
				txPos = -50;
				tyPos = -150;
			}
		}
		private function setSelectThumb() {
			if (Main.selectThumb != this) {
				Main.selectClear();//  이전선택된 값 지우기
				Main.selectThumb = this;
				//barColor.gotoAndStop(2)
			}
			if (select_step1 != null) {
				step1addEvent(select_step1);
			}
		}
		public function selectOut() {
			setSelectThumb();
			//barColor.gotoAndStop(1);
			ty = _STEP1Y;
			step2Out();
		}
		private function step2Out() {
			if (select != null) {
				select.out();
				select.addEvent();
				clearInterval(interval);
				if(img.numChildren > 0){
					img.removeChildAt(0)
				}
			}
		}
		public function imgReSizie() {
			var xPos:Number = (txPos*stageW)/oldW;
			var yPos:Number = (tyPos*stageH)/oldH;
			Main.frotingBar.setFrotingBarPos(stageW/2+xPos, stageH/2+yPos);
			img.width =Math.ceil((img.width*stageH)/img.height);
			img.height = stageH;
		}
	}
}