package did_as{

	import flash.display.*;
	import flash.xml.*;
	import flash.net.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.system.*; 

	public class Load_xml {
		
		System.useCodePage = true
		public var info:XML = new XML();
		var XML_URL_String:String;
		var XML_URL_Request:URLRequest;
		var XML_Loader:URLLoader;
		public var EventPatch:Sprite = new Sprite;
		
		public function Load_xml(xmlURL:String):void {
			XML_URL_String = xmlURL;
			XML_URL_Request = new URLRequest(XML_URL_String);
			XML_Loader= new URLLoader(XML_URL_Request);
			XML_Loader.dataFormat = URLLoaderDataFormat.BINARY;
			XML_Loader.addEventListener(Event.COMPLETE, onComplete);
		}
		public function onComplete(e:Event) {
			var bytes:ByteArray = XML_Loader.data;
   		 	var body:String = bytes.readMultiByte(bytes.length, "euc-kr");
    		info = new XML(XML_Loader.data);  
			//trace(info)
			
			EventPatch.dispatchEvent(new Event("xmlLoad"));
		}
	}
}