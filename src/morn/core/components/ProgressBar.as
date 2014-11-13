/**
 * Morn UI Version 2.3.0810 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.components{
	import morn.core.handlers.Handler;
	
	import flash.events.Event;

	/**值改变后触发*/
	[Event(name="change",type="flash.events.Event")]
	
	/**进度条*/
	public class ProgressBar extends Component {
		protected var _bg:Image;
		protected var _bar:Image;
		protected var _skin:String;
		protected var _value:Number = 0.5;
		protected var _label:String;
		protected var _changeHandler:Handler;
		//需要加入位图字体
		
		public function ProgressBar(skin:String = null) {
			this.skin = skin;
		}
		
		override protected function createChildren():void {
			addChild(_bg = new Image());
			addChild(_bar = new Image());
		}
		
		/**皮肤*/
		public function get skin():String {
			return _skin;
		}
		
		public function set skin(value:String):void {
			if (_skin != value) {
				_skin = value;
				_bg.url = _skin;
				_bar.url = _skin + "$bar";
				_contentWidth = _bg.width;
				_contentHeight = _bg.height;
				callLater(changeValue);
			}
		}
		
		/**当前值(0-1)*/
		public function get value():Number {
			return _value;
		}
		
		public function set value(num:Number):void {
			if (_value != num) {
				num = num > 1 ? 1 : num < 0 ? 0 : num;
				_value = num;
				sendEvent(Event.CHANGE);
				if (_changeHandler != null) {
					_changeHandler.executeWith([num]);
				}
				callLater(changeValue);
			}
		}
		
		protected function changeValue():void {
			if (sizeGrid){
				var grid:Array = sizeGrid.split(",");
				var left:Number = grid[0];
				var right:Number = grid[2];
				var max:Number = width - left - right;
				var sw:Number = max * _value;
				_bar.width = left + right + sw;
				_bar.visible = _bar.width > left + right;
			} else {
				_bar.width = width * _value;
			}
		}
		
		/**进度条*/
		public function get bar():Image {
			return _bar;
		}
		
		/**九宫格信息(格式:左边距,上边距,右边距,下边距)*/
		public function get sizeGrid():String {
			return _bg.sizeGrid;
		}
		
		public function set sizeGrid(value:String):void {
			_bg.sizeGrid = _bar.sizeGrid = value;
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			_bg.width = _width;
			callLater(changeValue);
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			_bg.height = _height;
			_bar.height = _height;
		}
		
		override public function set dataSource(value:Object):void {
			_dataSource = value;
			if (value is Number || value is String) {
				this.value = Number(value);
			} else {
				super.dataSource = value;
			}
		}
	}
}