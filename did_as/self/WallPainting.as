package did_as.self{

	import flash.display.*;
	import flash.events.*;
	import did_as.self.Wall;
	import did_as.com.Pattern;
	import did_as.promotion.MatchPattern;

	public class WallPainting extends MovieClip {

		private var left:Wall;
		private var right:Wall;
		private var center:Wall;
		private var oneWall:Wall;
		private var empty:Wall;
		private var sp:Sprite = new Sprite();
		private var leftSp:Sprite = new Sprite();
		private var rightSp:Sprite = new Sprite();
		private var centerSp:Sprite = new Sprite();

		private var mapWidth:Number;
		private var mapHeight:Number;
		public var select:String;
		private var map:Sprite;
		public var patternURL:String;
		public var wallgubun:Number;
		private var matchURL:String;

		public var stageW:Number;
		public var stageH:Number;
		private var xPos:Number;
		private var yPos:Number;
		private var Main:Object;
		private var wallNum:Number = 0;
		private var wallCount:Number = 0;

		public var pattern:MovieClip;
		public var patternPosX:Number;
		private var tw:Number;
		private var th:Number;
		private var leftArray:Array = new Array();
		private var rightArray:Array = new Array();
		private var centerArray:Array = new Array();
		private var oneWallArray:Array = new Array();

		// 0-일반 / 1-전폭/ 2-띠
		public function WallPainting(main:Object, url:String, getSelect:String, gubun:Number, matchPatternURL = "") {
			Main = main;
			select = getSelect;
			patternURL = url;
			wallgubun = gubun;
			stageW = Main.stageW;
			stageH = Main.stageH;
			matchURL = matchPatternURL;
			sizeInfo();
		}
		private function sizeInfo() {
			if (select == "거실_엘레강스") {
				// width / height / x / y / YRot / zom
				th = 560;
				leftArray = [700,th,-350,40,-50,15.5];
				rightArray = [950,th,340,40,11,13.3];
				oneWallArray = rightArray;

			} else if (select == "거실_모던") {

				th = 600;
				leftArray = [980,th,-95,50,-41,15];
				rightArray = [600,th,410,50,62,14.5];
				oneWallArray = leftArray;

			} else if (select == "거실_클래식") {

				th = 600;
				leftArray = [618,th,-1197.1,98,9,7.2];
				rightArray = [1440,th,109,85,12.5,10.8];
				centerArray = [165,th,-884,99,-80,6.9];
				oneWallArray = rightArray;

			} else if (select == "안방_엘레강스") {

				th = 560;
				leftArray = [900,th,-280,102,-43,17.9];
				rightArray = [500,th,650,101,55,17.1];
				centerArray = [465,th,280,102,4,13.9];
				oneWallArray = leftArray;

			} else if (select == "안방_모던") {
				
				th = 560;
				leftArray = [900,th,-554,74,-28,16.1];
				rightArray = [1000,th,286,74,26,16.2];
				oneWallArray = rightArray;
				
			} else if (select == "안방_클래식") {
				
				th = 560;
				leftArray = [550,th,-555,45,-90.3,13.5];
				rightArray = [960,th,572,48,90.5,15.6];
				centerArray = [1150,th,6,48,0,10.45];
				oneWallArray = centerArray;
				
			} else if (select == "서재_엘레강스") {
				
				th = 560;
				leftArray = [930,th,-325,48,-48,17.7];
				rightArray = [930,th,274,48,50,18.1];
				oneWallArray = rightArray;
				
			} else if (select == "서재_모던") {
				
				th = 600;
				leftArray = [1200,th,-112,13,-15,14];
				rightArray = [500,th,584,12,62,14.8];
				oneWallArray = leftArray;
				
			} else if (select == "서재_클래식") {
				
				th = 560;
				leftArray = [350,th,-391,72,-72,21.5];
				rightArray = [930,th,476,72,44,18];
				centerArray = [568,th,-98,73,-32,15.6];
				oneWallArray = rightArray;
				
			} else if (select == "주방_엘레강스") {
				
				th = 560;
				leftArray = [437,th,-287.5,-38.3,9,21.3];
				rightArray = [435,th,356,-36.5,39,18];
				centerArray = [414,th,57,-38,-51.5,18.5];
				oneWallArray = leftArray;
				
			} else if (select == "주방_모던") {
				
				th = 560;
				leftArray = [827,th,-170,-10.5,-37,15.5];
				oneWallArray = leftArray;
				
			} else if (select == "주방_클래식") {
				
				th = 560;
				leftArray = [520,th,-537.5,-48,-35,12];
				rightArray = [1090,th,55,-49,45.5,14.4];
				oneWallArray = rightArray;
				
			} else if (select == "아동_엘레강스") {
				
				th = 560;
				leftArray = [950,th,-122.5,57,-60,17];
				rightArray = [1000,th,524,57,35,15.5];
				oneWallArray = rightArray;
				
			} else if (select == "아동_모던") {
				
				th = 560;
				leftArray = [530,th,-448.8,24,-100,18.9];
				rightArray = [547,th,462,23,75,14.3];
				centerArray = [930,th,-50,23,-18,12.9];
				oneWallArray = centerArray;
				
			} else if(select == "patternMatch"){
				th = 560;
				leftArray = [555,th,-554,-10,-90.3,13.5];
				rightArray = [526,th,571,-9,90.5,13.4];
				centerArray = [1144,th,10,-9,0,10.45];
				oneWallArray = centerArray;
			}
			
			if(leftArray[0] == null){
				leftArray[0] = 0
			}
			if(rightArray[0] == null){
				rightArray[0] = 0
			}
			if(centerArray[0] == null){
				centerArray[0] = 0
			}
			tw = leftArray[0] + rightArray[0] + centerArray[0];
			if(select != "patternMatch"){
				makePattern();
			}else{
				makeMatchPattern();
			}
		}
		private function makePattern() {
			if(pattern == null){
				pattern = new Pattern(this,patternURL,wallgubun,tw,th);
			}else{
				pattern.bitmapFn(tw, th)
			}
			pattern.addEventListener("patternEnd", makePatternComplete);
		}
		private function makeMatchPattern(){
			pattern = new MatchPattern(this,patternURL,matchURL,wallgubun,leftArray[0] ,rightArray[0] ,centerArray[0],th);
			pattern.addEventListener("patternEnd", makePatternComplete);
		}
		public function  removeBitmap(){
			pattern.removeBitmap();
		}
		private function makePatternComplete(e:Event) {
			if(wallgubun != 1|| select == "patternMatch"){
				makeWallPaper();
			}else if(wallgubun == 1 && select != "patternMatch"){
				makeOneWallPaper();
			}
		}
		private function makeOneWallPaper(){
			wallNum = 2;
			patternPosX = 0;
			oneWall = new Wall(this,oneWallArray[0],oneWallArray[1],oneWallArray[2],oneWallArray[3],oneWallArray[4],oneWallArray[5]);
			empty = new Wall(this,10,10,0,0,0,0);
		}
		private function makeWallPaper() {
			
			var leftPos:Number;
			var rightPos:Number;
			var centerPos:Number;
			
			if(leftArray[0] != 0){
				++wallNum;
				patternPosX = 0;
				left = new Wall(this,leftArray[0],leftArray[1],leftArray[2],leftArray[3],leftArray[4],leftArray[5]);
				leftPos = leftArray[0];
			}else{
				leftPos = 0;
			}
			
			if(centerArray[0] != 0){
				++wallNum;
				patternPosX = leftPos;
				center = new Wall(this,centerArray[0],centerArray[1],centerArray[2],centerArray[3],centerArray[4],centerArray[5]);
				centerPos = centerArray[0];
			}else{
				centerPos = 0;
			}
			
			if(rightArray[0] != 0){
				++wallNum;
				patternPosX = leftPos+centerPos;
				right = new Wall(this,rightArray[0],rightArray[1],rightArray[2],rightArray[3],rightArray[4],rightArray[5]);
				rightPos = rightArray[0];
			}else{
				rightPos = 0;
			}
			
			++wallNum;
			empty = new Wall(this,10,10,0,0,0,0);
		}
		public function onComplete() {
			if (++wallCount == wallNum) {
				display();
			}
		}
		private function display() {
			if (left != null) {
				sp.addChild(left);
			}
			if (right != null) {
				sp.addChild(right);
			}
			if (center != null) {
				sp.addChild(center);
			}
			if(oneWall != null){
				sp.addChild(oneWall)
			}
			addChild(sp);
			blendMode = BlendMode.MULTIPLY;
			dispatchEvent(new Event("wallPaintingEnd"));
			Main.loadComplete(this);
		}
	}
}