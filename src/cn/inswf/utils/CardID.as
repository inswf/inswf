package cn.inswf.utils 
{
	/**
	 * ...
	 * @author liwei
	 */
	public class CardID 
	{
		private const IW:Array = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1];
		private const IS:Array = [1, 0, "x", 9, 8, 7, 6, 5, 4, 3, 2];
		public function CardID() 
		{
			
		}
		public function getID(id:String):String {
			if (id.length < 17) {
				return "";
			}
			var id_arr:Array = id.split("");
			if (id_arr.length < 17) {
				return "";
			}
			id_arr.length = 17;
			var sum:int = 0;
			for (var i:int = 0; i < 17; i++) {
				if (isNaN(id_arr[i])) {
					return "";
				}
				var n:int = id_arr[i];
				sum += n * IW[i];
			}
			return id_arr.join("") + IS[sum % 11];
		}
	}

}