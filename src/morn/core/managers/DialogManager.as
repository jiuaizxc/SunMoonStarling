/**
 * Morn UI Version 2.1.0623 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.managers
{
	import morn.core.components.Box;
	import morn.core.components.Dialog;
	
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**对话框管理器*/
	public class DialogManager extends Sprite {
		private var _box:Box = new Box();
		private var _mask:Box = new Box();
		private var _maskBg:Sprite = new Sprite();
		
		public function DialogManager() {
			addChild(_box);
			_mask.addChild(_maskBg);
			
			var bitmap:Shape = new Shape();
			bitmap.touchGroup = true;
			bitmap.touchable = false;
			bitmap.graphics.beginFill(0, 0.4);
			bitmap.graphics.drawRect(0,0,10,10);
			bitmap.graphics.endFill();
			_maskBg.addChild(bitmap);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize(null);
		}
		
		private function onResize(e:Event):void {
			_box.width = _mask.width = stage.stageWidth;
			_box.height = _mask.height = stage.stageHeight;
			for (var i:int = _box.numChildren - 1; i > -1; i--) {
				var item:Dialog = _box.getChildAt(i) as Dialog;
				if (item.popupCenter) {
					item.x = (stage.stageWidth - item.width) * 0.5;
					item.y = (stage.stageHeight - item.height) * 0.5;
				}
			}
			for (i = _mask.numChildren - 1; i > -1; i--) {
				item = _mask.getChildAt(i) as Dialog;
				if (item) {
					if (item.popupCenter) {
						item.x = (stage.stageWidth - item.width) * 0.5;
						item.y = (stage.stageHeight - item.height) * 0.5;
					}
				} else {
					var bitmap:Shape = _maskBg.getChildAt(0) as Shape;
					bitmap.width = stage.stageWidth;
					bitmap.height = stage.stageHeight;
				}
			}
		}
		
		/**显示对话框(非模式窗口) @param closeOther 是否关闭其他对话框*/
		public function show(dialog:Dialog, closeOther:Boolean = false):void {
			if (closeOther) {
				_box.removeAllChild();
			}
			if (dialog.popupCenter) {
				dialog.x = (stage.stageWidth - dialog.width) * 0.5;
				dialog.y = (stage.stageHeight - dialog.height) * 0.5;
			}
			_box.addChild(dialog);
		}
		
		/**显示对话框(模式窗口) @param closeOther 是否关闭其他对话框*/
		public function popup(dialog:Dialog, closeOther:Boolean = false):void {
			if (closeOther) {
				_mask.removeAllChild(_maskBg);
			}
			if (dialog.popupCenter) {
				dialog.x = (stage.stageWidth - dialog.width) * 0.5;
				dialog.y = (stage.stageHeight - dialog.height) * 0.5;
			}
			_mask.addChild(dialog);
			_mask.swapChildrenAt(_mask.getChildIndex(_maskBg), _mask.numChildren - 2);
			addChild(_mask);
		}
		
		/**删除对话框*/
		public function close(dialog:Dialog):void {
			dialog.remove();
			if (_mask.numChildren > 1) {
				_mask.swapChildrenAt(_mask.getChildIndex(_maskBg), _mask.numChildren - 2);
			} else {
				_mask.remove();
			}
		}
		
		/**删除所有对话框*/
		public function closeAll():void {
			_box.removeAllChild();
			_mask.removeAllChild(_maskBg);
			_mask.remove();
		}
	}
}