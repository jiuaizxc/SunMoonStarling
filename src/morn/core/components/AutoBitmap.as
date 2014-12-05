/**
 * Morn UI Version 2.4.1020 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.components{
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**增强的Bitmap，封装了位置，宽高及9宫格的处理，供组件使用*/
	public final class AutoBitmap{
		private var _image:starling.display.Image;
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _width:Number;
		private var _height:Number;
		private var _sizeGrid:Array;
		private var _clips:Vector.<Texture>;
		private var _index:int;
		private var _content:DisplayObjectContainer;
		
		public function AutoBitmap(parent:DisplayObjectContainer) {
			_content = parent;
		}
		
		/**X坐标(显示时四舍五入)*/
		public function get x():Number {
			return _x;
		}
		
		public function set x(value:Number):void {
			_x = value;
			_image && (_image.x = Math.round(value));
		}
		
		/**Y坐标(显示时四舍五入)*/
		public function get y():Number {
			return _y;
		}
		
		public function set y(value:Number):void {
			_y = value;
			_image && (_image.y = Math.round(value));
		}
		
		/**宽度(显示时四舍五入)*/
		public function get width():Number
		{
			return isNaN(_width) ? _image.width : _width; 
		}
		
		/**高度(显示时四舍五入)*/
		public function get height():Number
		{
			return isNaN(_height) ? _image.height : _height;
		}
		
		public function set width(value:Number):void {
			if (_width != value) {
				_width = value;
				changeSize();
			}
		}
		
		public function set height(value:Number):void {
			if (_height != value) {
				_height = value;
				changeSize();
			}
		}
		
		/**9宫格(格式：左间距,上间距,右间距,下间距)*/
		public function get sizeGrid():Array {
			return _sizeGrid;
		}
		
		public function set sizeGrid(value:Array):void {
			_sizeGrid = value;
			changeSize();
		}
		
		public function get texture():Texture
		{
			return _image.texture;
		}
		
		public function set texture(value:Texture):void {
			if (value) {
				clips = new <Texture>[value];
			}else{
				removeImage();
			}
		}
		
		/**位图切片集合*/
		public function get clips():Vector.<Texture> {
			return _clips;
		}
		
		public function set clips(value:Vector.<Texture>):void {
			if(value){
				disposeTempBitmapdata();
				_clips = value;
				if(addImage(value[_index])){
					_image.texture = value[_index];
					_image.readjustSize();
				}
			}else{
				removeImage();
			}
		}
		
		/**销毁临时位图*/
		private function disposeTempBitmapdata():void {
			if (_clips) _clips = null;
		}
		
		/**当前切片索引*/
		public function get index():int {
			return _index;
		}
		
		public function set index(value:int):void {
			_index = value;
			if (_clips && _clips.length > 0) {
				_index = (_index < _clips.length && _index > -1) ? _index : 0;
				_image.texture = _clips[_index];
			}
		}
		
		private function changeSize():void
		{
			if(_image){
				var w:int = Math.round(width);
				var h:int = Math.round(height);
				_image.width = w == 0 ? 0.000001 : w;
				_image.height = h == 0 ? 0.000001 : h;
			}
		}
		
		private function addImage(value:Texture):Boolean
		{
			if(_image) return true;
			_image = new starling.display.Image(value);
			_image.x = _x;
			_image.y = _y;
			_content.addChild(_image);
			return false;
		}
		
		private function removeImage():void
		{
			_clips = null;
			if(_image){
				_content.removeChild(_image);
				_image = null;
			}
		}
	}
}