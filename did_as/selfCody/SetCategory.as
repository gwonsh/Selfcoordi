package did_as.selfCody{

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import caurina.transitions.Tweener;
	import com.hangunsworld.net.XMLLoader;
	import did_as.com.CollectCheck;
	import fl.data.DataProvider;

	public class SetCategory {

		private var xml:XML;
		private var info:XML;
		private var collection:Collection;
		private var collectionArray:Array = new Array();
		private var Main;
		private var xloader:XMLLoader = new XMLLoader();

		public function SetCategory(main:MovieClip, url:String) {
			Main = main;
			xloader.load(new URLRequest(url), "euc-kr");
			xloader.addEventListener(Event.COMPLETE, onComplete);
		}
		private function onComplete(e:Event) {
			xml = XML(xloader.data);
			setXml();
		}
		private function setXml() {
			var len=xml.category.length();
			for (var i:uint; i < len; i++) {
				if (xml.category[i].@egubun == "color") {
					info=xml.category[i];
					setCategoryList(info,xml.category[i].@egubun);
				} else if (xml.category[i].@egubun == "design") {
					info=xml.category[i];
					setCategoryList(info,xml.category[i].@egubun);
				} else if (xml.category[i].@egubun == "useage") {
					info=xml.category[i];
					setCategoryList(info,xml.category[i].@egubun);
				} else if (xml.category[i].@egubun == "style") {
					info=xml.category[i];
					setCategoryList(info,xml.category[i].@egubun);
				} else if (xml.category[i].@egubun == "collection") {
					info=xml.category[i];
					setCollection(info);
				}
			}
		}
		private function setCollection(temp_xml:XML) {
			var totalW:Number = 50;
			var len=temp_xml.item.length();
			for (var i:uint; i < len; i++) {
				/*collection=new Collection  ;
				//collection.x= i*95 + 50;
				collection.x= totalW;
				collection.y=70+(30*Math.floor(i/5));
				trace(Math.floor(i/5))
				collection.alpha=0.5;
				collection.txt.gotoAndStop(i+1);
				if(i%5 == 0){
					totalW = 50;
				}
				totalW = collection.txt.width + totalW + 30;
				Main.searchBar.addChild(collection);*/
				var collection:MovieClip = Main.searchBar["collection"+i];
				collection.alpha=0.5;
				collection.code = collectionSelect(temp_xml,i);				
				collection.addEventListener(MouseEvent.CLICK,collectionClick);
				collection.buttonMode=true;
				collectionArray.push(collection);
			}
		}
		private function collectionSelect(temp_xml:XML, num) {
			var len=temp_xml.item.length();
			var goto:Number;
			var collect:CollectCheck = new CollectCheck();
			for (var i:uint = 0; i<len; i++) {
				//trace("temp_xml.item[i].@english = ",temp_xml.item[i].@english,"/ collectionMenuArray[num]=",collectionMenuArray[num])
				if (temp_xml.item[i].@english == collect.returnCollectName(num)) {
					goto = temp_xml.item[i].@code
					//trace(goto)
				}
			}
			return goto
		}

		private function setCategoryList(temp_xml:XML,st:String) {
			var len=temp_xml.item.length();
			var dp:DataProvider=new DataProvider;
			for (var i:uint; i < len; i++) {
				dp.addItem({label:temp_xml.item[i],data:temp_xml.item[i].@code});
			}
			if (st == "color") {
				Main.searchBar.colorList.dataProvider=dp;
			} else if (st == "design") {
				Main.searchBar.designList.dataProvider=dp;
			} else if (st == "useage") {
				Main.searchBar.purposeList.dataProvider=dp;
			} else if (st == "style") {
				Main.searchBar.styleList.dataProvider=dp;
			}
			var format : TextFormat = new TextFormat();
			format.color = 0x999999;

			Main.searchBar.colorList.setRendererStyle("textFormat", format);
			Main.searchBar.designList.setRendererStyle("textFormat", format);
			Main.searchBar.purposeList.setRendererStyle("textFormat", format);
			Main.searchBar.styleList.setRendererStyle("textFormat", format);

			Main.searchBar.colorList.addEventListener(Event.CHANGE,selectList);
			Main.searchBar.designList.addEventListener(Event.CHANGE,selectList);
			Main.searchBar.purposeList.addEventListener(Event.CHANGE,selectList);
			Main.searchBar.styleList.addEventListener(Event.CHANGE,selectList);
		}
		private function selectList(e:Event) {
			if (e.target.name == "colorList") {
				Main.SearchCategory2=e.target.selectedItem.data;
			} else if (e.target.name == "designList") {
				Main.SearchCategory3=e.target.selectedItem.data;
			} else if (e.target.name == "purposeList") {
				Main.SearchCategory4=e.target.selectedItem.data;
			} else if (e.target.name == "styleList") {
				Main.SearchCategory5=e.target.selectedItem.data;
			}
			Main.nPageNo=1;
			Main.makeList();
		}
		private function collectionClick(e:MouseEvent) {
			var mc:MovieClip=MovieClip(e.currentTarget);
			if (mc.currentFrame == 1) {
				selectMC(mc);
			} else if (mc.currentFrame == 2) {
				selectedMC(mc);
			}
			Main.nPageNo=1;
			Main.makeList();
		}
		private function selectMC(mc:MovieClip) {
			for (var i:uint=0; i<collectionArray.length; i++) {
				if (mc == collectionArray[i]) {
					collectionArray[i].gotoAndStop(2);
					collectionArray[i].alpha = 1;
					Main.SearchCategory1=mc.code;
				} else {
					collectionArray[i].gotoAndStop(1);
					collectionArray[i].alpha = 0.5;
				}
			}
		}
		private function selectedMC(mc:MovieClip) {
			mc.gotoAndStop(1);
			mc.alpha = 0.5;
			Main.SearchCategory1="";
		}
	}
}