package did_as.photo{

	import flash.display.*;
	import flash.events.*;

	public class SizeCm extends MovieClip {
		var Main:Object;
		public function SizeCm(main:Object) {
			Main = main;
			addEventListener(Event.ENTER_FRAME,fn);
			btn.addEventListener(MouseEvent.CLICK,onClick);
		}
		function fn(e:Event) {
			x = Main.mouseX;
			y = Main.mouseY;
		}
		function onClick(e:MouseEvent) {
			e.target.parent.play();
		}
	}
}