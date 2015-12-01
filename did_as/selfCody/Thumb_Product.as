package did_as.selfCody{

	import flash.display.*;
	import flash.events.*;
	import did_as.com.Thumb;

	public class Thumb_Product extends MovieClip {

		public var oidProduct:Number;
		public var strProductName:String;
		public var strModel:String;
		public var wallpapergubun:Number;
		public var thumbURL:String;
		public var orgURL:String;
		public var num:Number;
		public var strECollection:String;
		public var thumb:Thumb;
		public var boxLine:BoxLine = new BoxLine();

		public function Thumb_Product(oid:Number, strName:String, model:String, gubun:Number,getThumbURL:String,getOrgURL:String,getCollection:String) {
			oidProduct = oid;
			strProductName = strName;
			strModel = model;
			wallpapergubun = gubun;
			thumbURL = getThumbURL;
			orgURL = getOrgURL;
			strECollection = getCollection;
			makeTumb();
		}
		private function makeTumb() {
			thumb = new Thumb(this,thumbURL,50,50);
			boxLine.alpha = 0;
			addChild(thumb);
			addChild(boxLine)
		}
	}
}