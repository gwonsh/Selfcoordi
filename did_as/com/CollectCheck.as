package did_as.com{

	public class CollectCheck  {
		
		private var arr:Array = ["THE PAIR", "The One","D&D","4U","COLORS","SIDUS VELVET","EPISODE","ECO"]
		
		public function CollectCheck(){
			
		}
		public function returnCollectNum(logoSt:String):Number{
			var num:Number;
			if (logoSt == arr[0]) {
				num=1;
			} else if (logoSt == arr[1]) {
				num=2;
			} else if (logoSt == arr[2]) {
				num=3;
			} else if (logoSt == arr[3]) {
				num=4;
			} else if (logoSt == arr[4]) {
				num=5;
			} else if (logoSt == arr[5]) {
				num=6;
			}else if (logoSt == arr[6]) {
				num=7;
			}
			else if (logoSt == arr[7]) {
				num=8;
			}
			return num;
		}
		public function returnCollectName(num:Number):String{
			return arr[num];
		}
	}
}