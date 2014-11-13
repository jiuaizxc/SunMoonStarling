/**
 * Morn UI Version 2.4.1027 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.components {
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**单选框按钮*/
	public class RadioButton extends Button {
		protected var _value:Object;
		
		public function RadioButton(skin:String = null) {
			super(skin);
		}
		
		override protected function preinitialize():void {
			super.preinitialize();
			_toggle = false;
			_autoSize = false;
		}
		
		override protected function initialize():void {
			super.initialize();
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(e:Event):void {
			selected = true;
		}
		
		/**组件关联的可选用户定义值*/
		public function get value():Object {
			return _value;
		}
		
		public function set value(obj:Object):void {
			_value = obj;
		}
	}
}