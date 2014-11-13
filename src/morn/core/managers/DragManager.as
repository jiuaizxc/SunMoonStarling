/**
 * Morn UI Version 2.4.1020 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.managers
{
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**拖动管理类*/
	public class DragManager {
		private var _dragInitiator:DisplayObject;
		private var _dragImage:Sprite;
		private var _data:*;
		private var _tagPos:Point;
		
		private var m_Touch:Touch;
		public function DragManager() {
			_tagPos = new Point();
		}
		
		/**开始拖动
		 * @param dragInitiator 拖动的源对象
		 * @param dragImage 显示拖动的图片，如果为null，则是源对象本身
		 * @param data 拖动传递的数据
		 * @param offset 鼠标居拖动图片的偏移*/
		public function doDrag(dragInitiator:Sprite, tagX:Number, tagY:Number, dragImage:Sprite = null, data:* = null, offset:Point = null):void {
			_dragInitiator = dragInitiator;
			_tagPos.setTo(tagX, tagY);
			_dragImage = dragImage ? dragImage : dragInitiator;
			_data = data;
			if (_dragImage != _dragInitiator) {
				if (offset) {
					_dragImage.x = tagX - offset.x;
					_dragImage.y = tagY - offset.y;
				} else {
					var p:Point = _dragInitiator.localToGlobal(new Point());
					_dragImage.x = p.x;
					_dragImage.y = p.y;
				}
				App.stage.addChild(_dragImage);
			}
			//_dragInitiator.dispatchEvent(new DragEvent(DragEvent.DRAG_START, dragInitiator, data));			
			App.stage.addEventListener(TouchEvent.TOUCH, onDrag);
		}
		
		private function onDrag(e:TouchEvent):void
		{
			m_Touch = e.getTouch(App.stage, TouchPhase.MOVED);
			if(m_Touch){
				if(m_Touch.globalX <= 0 || m_Touch.globalX >= App.stage.stageWidth || m_Touch.globalY <= 0 || m_Touch.globalY >= App.stage.stageHeight){
					return;
				}else{
					_dragImage.x += m_Touch.globalX - _tagPos.x;
					_dragImage.y += m_Touch.globalY - _tagPos.y;
					_tagPos.setTo(m_Touch.globalX, m_Touch.globalY);
				}
				return;
			}
			
			m_Touch = e.getTouch(App.stage, TouchPhase.ENDED);
			if(m_Touch){
				App.stage.removeEventListener(TouchEvent.TOUCH, onDrag);
				
				if (_dragInitiator != _dragImage){
					if (App.stage.contains(_dragImage)) {
						App.stage.removeChild(_dragImage);
					}
				}
				
				_dragInitiator = null;
				_data = null;
				_dragImage = null;
			}
		}
	}
}