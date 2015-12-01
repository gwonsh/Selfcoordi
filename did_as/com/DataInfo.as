package did_as.com{

	import flash.display.*;

	public class DataInfo extends MovieClip{

		private var Main:Object;
		public var strModel:String;
		public var strProductName:String;
		public var oidProduct:Number;
		public var wallpapergubun:Number;
		public var strECollection:String;
		public var patternURL:String;
		public var thumbURL:String;
		public var pageType:String;
		public var selectRoomType:String;

		public function DataInfo(main:Object) {
			Main = main;
		}
		public function getDataInfo(model:String, productName:String, oid:Number, gubun:Number, collection:String, url:String, thumgUrl:String, _pageType:String, _selectRoomType:String = "") {
			strModel = model;
			strProductName = productName;
			oidProduct = oid;
			wallpapergubun = gubun;
			strECollection = collection;
			patternURL = url
			thumbURL = thumgUrl;
			pageType = _pageType;
			selectRoomType = _selectRoomType;
		}
	}
}