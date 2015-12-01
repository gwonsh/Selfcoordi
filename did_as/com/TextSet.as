package did_as.com{
	
	import flash.text.*;
	
	public class TextSet {

		public function TextSet() {	}
		public function setText(txt:TextField, color16:Number, size:Number, spaceW:Number, fontName:String){
			var f_fmt:TextFormat = new TextFormat();			
			var font:Font 
			if(fontName == "korFont"){
				font= new KorFont();
				f_fmt.font = font.fontName;
			}else if(fontName == "engFont"){
				font= new EngFont();
				f_fmt.font = font.fontName;
			}
			f_fmt.letterSpacing = spaceW;
			f_fmt.size = size;
			f_fmt.color = color16;
			txt.embedFonts = true;
			txt.autoSize = "left";
			txt.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			txt.setTextFormat(f_fmt);
		}
	}
}