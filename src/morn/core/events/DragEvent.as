/**
 * Morn UI Version 2.0.0526 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.events{
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	/**拖动事件类*/
	public class DragEvent extends Event {
		public static const DRAG_START:String = "dragStart";
		public static const DRAG_DROP:String = "dragDrop";
		public static const DRAG_COMPLETE:String = "dragComplete";
		
		protected var _dragInitiator:DisplayObject;
		
		public function DragEvent(type:String, dragInitiator:DisplayObject = null, data:* = null, bubbles:Boolean = true) {
			super(type, bubbles, data);
			_dragInitiator = dragInitiator;
		}
		
		/**拖动的源对象*/
		public function get dragInitiator():DisplayObject {
			return _dragInitiator;
		}
		
		public function set dragInitiator(value:DisplayObject):void {
			_dragInitiator = value;
		}
	}
}