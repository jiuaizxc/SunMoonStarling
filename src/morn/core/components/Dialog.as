/**
 * Morn UI Version 2.0.1027 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.components{
	import flash.geom.Rectangle;
	
	import morn.core.events.UIEvent;
	import morn.core.handlers.Handler;
	import morn.core.utils.StringUtils;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**对话框*/
	public class Dialog extends View
	{
		private static const MAP:Object = {"close":0, "cancel":0, "no":0, "sure":0, "ok":0, "yes":0};
		protected var _dragArea:Rectangle;
		protected var _popupCenter:Boolean = true;
		protected var _closeHandler:Handler;
		
		private var m_Touch:Touch;
		override protected function initialize():void {
			var dragTarget:DisplayObject = getChildByName("drag");
			if (dragTarget) {
				dragArea = dragTarget.x + "," + dragTarget.y + "," + dragTarget.width + "," + dragTarget.height;
				removeElement(dragTarget);
			}
			
			var com:Button;
			for(var key:String in MAP){
				com = getChildByName(key) as Button;
				if(com) com.addEventListener(UIEvent.SELECT, onClick);
			}		
		}
		
		/**默认按钮处理*/
		protected function onClick(e:UIEvent):void{
			if(e.data.name in MAP) close(e.data.name);
		}
		
		/**显示对话框(非模式窗口)
		 * @param closeOther 是否关闭其他对话框*/
		public function show(closeOther:Boolean = false):void {
			App.dialog.show(this, closeOther);
		}
		
		/**显示对话框(模式窗口)
		 * @param closeOther 是否关闭其他对话框*/
		public function popup(closeOther:Boolean = false):void {
			App.dialog.popup(this, closeOther);
		}
		
		/**关闭对话框*/
		public function close(type:String = null):void {
			App.dialog.close(this);
			if (_closeHandler != null) {
				_closeHandler.executeWith([type]);
			}
		}
		
		/**拖动区域(格式:x:Number=0, y:Number=0, width:Number=0, height:Number=0)*/
		public function get dragArea():String {
			return StringUtils.rectToString(_dragArea);
		}
		
		public function set dragArea(value:String):void{
			if (Boolean(value)) {
				var a:Array = StringUtils.fillArray([0, 0, 0, 0], value);
				_dragArea = new Rectangle(a[0], a[1], a[2], a[3]);
				addEventListener(TouchEvent.TOUCH, onMouseDown);
			} else {
				_dragArea = null;
				removeEventListener(TouchEvent.TOUCH, onMouseDown);
			}
		}
		
		private function onMouseDown(e:TouchEvent):void
		{
			m_Touch = e.getTouch(this, TouchPhase.BEGAN);
			if(m_Touch){
				if(_dragArea.contains(m_Touch.globalX, m_Touch.globalY)){
					App.drag.doDrag(this, m_Touch.globalX, m_Touch.globalY);
				}
			}
		}
		
		/**是否弹出*/
		public function get isPopup():Boolean {
			return parent != null;
		}
		
		/**是否居中弹出*/
		public function get popupCenter():Boolean {
			return _popupCenter;
		}
		
		public function set popupCenter(value:Boolean):void {
			_popupCenter = value;
		}
		
		/**关闭回调(返回按钮名称name:String)*/
		public function get closeHandler():Handler {
			return _closeHandler;
		}
		
		public function set closeHandler(value:Handler):void {
			_closeHandler = value;
		}
	}
}