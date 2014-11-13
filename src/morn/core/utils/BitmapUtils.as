/**
 * Morn UI Version 2.5.1215 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.utils{
	
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import starling.textures.SubTexture;
	import starling.textures.Texture;
	
	/**位图工具集*/
	public class BitmapUtils {
		private static var m:Matrix = new Matrix();
		private static var newRect:Rectangle = new Rectangle();
		private static var clipRect:Rectangle = new Rectangle();
		private static var grid:Rectangle = new Rectangle();
		
		/**获取切片资源*/
		public static function getClips(name:String, xNum:int, yNum:int):Vector.<Texture> {
			var clips:Vector.<Texture>;
			if (clips == null) {
				var bmd:Texture = App.asset.getTexture(name);
				if (bmd == null) return null;
				clips = createClips(bmd, xNum, yNum);
			}
			return clips;
		}
		
		/**创建切片资源*/
		public static function createClips(bmd:Texture, xNum:int, yNum:int):Vector.<Texture> {
			if (bmd == null) return null;
			var subText:SubTexture;
			if(bmd is SubTexture) subText = bmd as SubTexture;
			var clips:Vector.<Texture> = new Vector.<Texture>();
			var width:int; 
			var height:int; 
			var x:Number;
			var y:Number
			var item:Texture;
			var region:Rectangle = new Rectangle();
			var mat:Matrix;
			var scale:Number;
			for (var i:int = 0; i < yNum; i++) {
				for (var j:int = 0; j < xNum; j++) {
					if(subText){
						mat = subText.transformationMatrix;
						
						x = mat.tx * subText.parent.width;
						y = mat.ty * subText.parent.height;
						width = Math.max(bmd.width / xNum, 1);
						height = Math.max(bmd.height / yNum, 1);
						
						region.setTo(j * width + x, i * height + y, width, height);
						item = Texture.fromTexture(subText.parent, region);
					}else{
						//存在问题事后来验证猜想
						x = 0;
						y = 0;
						width = bmd.width;
						height = bmd.height;
						
						region.setTo(j * width + x, i * height + y, width, height);
						item = Texture.fromTexture(bmd, region);
					}
					clips.push(item);
				}
			}
			return clips;
		}
	}
}