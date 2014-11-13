/**
 * Morn UI Version 2.0.0526 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.events{
	import starling.events.Event;
	
	/**UI事件类*/
	public class UIEvent extends Event {
		//-----------------Component-----------------	
		/**移动组件*/
		public static const MOVE:String = "move";
		/**显示鼠标提示*/
		public static const SHOW_TIP:String = "showTip";
		/**隐藏鼠标提示*/
		public static const HIDE_TIP:String = "hideTip";
		//-----------------TextArea-----------------
		/**滚动*/
		public static const SCROLL:String = "scroll";
		//-----------------FrameClip-----------------
		/**帧跳动*/
		public static const FRAME_CHANGED:String = "frameChanged";
		//-----------------List-----------------
		/**项渲染*/
		public static const ITEM_RENDER:String = "listRender";
		
		public static const SELECT:String = "select";
		
		public function UIEvent(type:String, data:*, bubbles:Boolean = false) {
			super(type, bubbles, data);
		}
	}
}