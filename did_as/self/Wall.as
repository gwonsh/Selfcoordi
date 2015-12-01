package did_as.self{
	import flash.display.*;
	import flash.events.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import org.papervision3d.scenes.*;
	import org.papervision3d.cameras.*;
	import org.papervision3d.objects.*;
	import org.papervision3d.objects.special.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.materials.special.*;
	import org.papervision3d.materials.shaders.*;
	import org.papervision3d.materials.utils.*;
	import org.papervision3d.lights.*;
	import org.papervision3d.view.*;
	import org.papervision3d.render.*;
	import org.papervision3d.events.*;
	import org.papervision3d.core.utils.*;
	import org.papervision3d.core.utils.virtualmouse.VirtualMouse;
	import org.papervision3d.objects.primitives.*;
	import flash.external.ExternalInterface;
	import flash.system.System;


	public class Wall extends MovieClip {

		private var Main:MovieClip;
		private var tw:Number;
		private var th:Number;
		private var txn:Number;
		private var tyn:Number;
		private var trot:Number;
		private var tzom:Number;
		private var xRot:Number;
		private var zRot:Number;
		private var focus:Number;
		private var pattern:Sprite = new Sprite();

		public function Wall(main:MovieClip,getTw:Number,getTh:Number,getTx:Number=0,getTy:Number=0,getRot:Number=45,getZom:Number=20, xrot:Number=0, zrot:Number=0,getFocue:Number = 62) {
			Main=main;
			tw=getTw;
			th=getTh;
			txn=getTx;
			tyn=getTy;
			trot=getRot;
			tzom=getZom;
			xRot = xrot;
			zRot = zrot;
			focus = getFocue;
			//try {
				makePattern();
			//} catch (erroObject:Error) {
				//trace("Catcherror");
				//ExternalInterface.call("window.close");
				//makePattern();
			//}
		}
		private function makePattern() {
			var tempBmd:BitmapData = new BitmapData(Main.pattern.width, Main.pattern.height,false,0xFFFFFF);
			tempBmd.draw(Main.pattern);
			
			var bmd:BitmapData = new BitmapData(tw, th, false, 0xFFFFFF);
			var rect:Rectangle;
			var pt:Point;
			if (Main.wallgubun == 0 || Main.select == "patternMatch") {
				rect = new Rectangle(Main.patternPosX, 0, tw, th);
				pt = new Point(0, 0);
			} else if (Main.wallgubun == 1&&Main.select != "patternMatch") {
				rect = new Rectangle(Main.patternPosX, 0, Main.pattern.width, Main.pattern.height);
				pt = new Point(tw/2-Main.pattern.width/2, 0);
			} else if (Main.wallgubun == 2&&Main.select != "patternMatch") {
				rect = new Rectangle(Main.patternPosX, 0, tw, th);
				pt = new Point(0, th/2);
			}
			bmd.copyPixels(tempBmd, rect, pt);
			var bm:Bitmap = new Bitmap(bmd);
			
			tempBmd.dispose();

			pattern.addChild(bm);
			viewRander();
		}
		private function viewRander() {
			var viewport:Viewport3D=new Viewport3D(1280,776,false,false);//(width, height, scaleMode, activeMode)
			addChild(viewport);

			var renderer:BasicRenderEngine=new BasicRenderEngine(this);
			var scene:Scene3D=new Scene3D;
			var camera:Camera3D=new Camera3D;

			camera.zoom=tzom;
			camera.focus=focus;

			var mm:MovieMaterial=new MovieMaterial(pattern);
			mm.smooth=true;

			if (Main.wallgubun == 1) {
				var planeW = (pattern.width*th)/pattern.height;
				var planeH = th;
			}
			var planes:Plane=new Plane(mm,planeW,planeH,10,10);
			scene.addChild(planes);

			planes.rotationY=trot;
			planes.rotationX=xRot;
			planes.rotationZ=zRot;

			planes.x = txn;
			planes.y = tyn;

			renderer.renderScene(scene,camera,viewport);
		}
		public function reanderComplete() {
			Main.onComplete();
		}
		public function removeBitmap(){
			if(pattern.numChildren > 0){
				pattern.removeChildAt(0);
			}
		}
	}
}