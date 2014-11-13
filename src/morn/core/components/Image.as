/**
 * Morn UI Version 2.5.1215 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.components{
	import morn.core.utils.StringUtils;
	
	import starling.textures.Texture;
	
	/**图像类*/
	public class Image extends Component
	{
		protected var _bitmap:AutoBitmap;
		protected var _url:String;
		
		public function Image(url:String = null){
			mouseEnabled = mouseChildren = false;
			this.url = url;
		}
		
		override protected function createChildren():void {
			_bitmap = new AutoBitmap(this);
		}
		
		/**图片地址*/
		public function get url():String {
			return _url;
		}
		
		public function set url(value:String):void {
			if (_url != value) {
				_url = value;
				if (Boolean(value)){
					texture = App.asset.getTexture(StringUtils.assetsName(value));
				}
			}
		}
		
		/**源位图数据*/
		public function get texture():Texture {
			return _bitmap.texture;
		}
		
		public function set texture(value:Texture):void {
			if (value) {
				_contentWidth = value.width;
				_contentHeight = value.height;
			}
			_bitmap.texture = value;
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			_bitmap.width = width;
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			_bitmap.height = height;
		}
		
		/**九宫格信息(格式:左边距,上边距,右边距,下边距)*/
		public function get sizeGrid():String {
			if (_bitmap.sizeGrid) {
				return _bitmap.sizeGrid.join(",");
			}
			return null;
		}
		
		public function set sizeGrid(value:String):void {
			_bitmap.sizeGrid = StringUtils.fillArray(Styles.defaultSizeGrid, value);
		}
		
		/**位图控件实例*/
		public function get bitmap():AutoBitmap {
			return _bitmap;
		}
		
		override public function set dataSource(value:Object):void {
			_dataSource = value;
			if (value is String) {
				url = String(value);
			} else {
				super.dataSource = value;
			}
		}
	}
}