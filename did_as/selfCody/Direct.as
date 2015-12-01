package did_as.selfCody{

	import flash.display.*;
	import flash.events.*;

	public class Direct extends Sprite {

		private var Main:Object;
		private var nextBtn = new NextDirect;
		private var prevBtn = new PrevDirect;

		public function Direct(main:Object) {
			Main = main;
			addChild(nextBtn);
			addChild(prevBtn);
			nextBtn.x = 920;
			prevBtn.x = 430;
			if (Main.totalPage > 1) {
				prevBtn.alpha = 0.5;
				nextBtn.alpha = 1;
			}
			prevBtn.buttonMode = false;
			nextBtn.buttonMode = true;
			nextBtn.addEventListener(MouseEvent.CLICK, pageMove);
			y = 640;
		}
		private function pageMove(e:MouseEvent) {
			if (e.target.parent ==  nextBtn) {
				nextFn();
			} else if (e.target.parent ==  prevBtn) {
				prevFn();
			}
			setBtn();
			Main.makeList();
		}
		private function prevFn() {
			--Main.nPageNo;				
		}
		private function nextFn() {
			++Main.nPageNo;
		}
		public function setBtn(){
			btnAdd();
			if (Main.nPageNo >= Main.totalPage) {
				Main.nPageNo = Main.totalPage;
				nextBtnRemove();
			}
			if (Main.nPageNo <= 1) {
				Main.nPageNo = 1;
				prevBtnRemove();
			}
		}
		public function prevBtnRemove() {
			prevBtn.alpha = 0.5;
			prevBtn.buttonMode = false;
			prevBtn.removeEventListener(MouseEvent.CLICK, pageMove);
		}
		public function nextBtnRemove() {
			nextBtn.alpha = 0.5;
			nextBtn.buttonMode = false;
			nextBtn.removeEventListener(MouseEvent.CLICK, pageMove);
		}
		private function btnAdd() {
			prevBtn.alpha = 1;
			nextBtn.alpha = 1;
			prevBtn.buttonMode = true;
			nextBtn.buttonMode = true;
			prevBtn.addEventListener(MouseEvent.CLICK, pageMove);
			nextBtn.addEventListener(MouseEvent.CLICK, pageMove);
		}
	}
}