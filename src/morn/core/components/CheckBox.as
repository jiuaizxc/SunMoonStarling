/**
 * Morn UI Version 2.0.0526 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.components {
	/**多选按钮*/
	public class CheckBox extends Button {
		
		public function CheckBox(skin:String = null) {
			super(skin);
		}
		
		override protected function preinitialize():void {
			super.preinitialize();
			_toggle = true;
			_autoSize = false;
		}
		
		override protected function initialize():void {
			super.initialize();
		}
		
		override public function set dataSource(value:Object):void {
			_dataSource = value;
			if (value is Boolean) {
				selected = value;
			} else if (value is String) {
				selected = value == "true";
			} else {
				super.dataSource = value;
			}
		}
	}
}