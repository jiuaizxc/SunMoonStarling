/**
 * Morn UI Version 2.1.0623 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.managers
{
	import morn.core.components.Dialog;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Stage;
	
	/**对话框管理器*/
	public class DialogManager{
		private var _root:DisplayObjectContainer;
		private var _mask:Quad;
		private var _isStage:Boolean;
		
		private var _dialogList:Vector.<Dialog>;
		
		private var _width:Number;
		private var _height:Number;
		
		public function DialogManager(root:Stage){
			_isStage = false;
			_dialogList = new Vector.<Dialog>();
			
			_root = root;
			_width = root.stageWidth;
			_height = root.stageHeight;
			
			_mask = new Quad(_width, _height, 0x000000);
			_mask.alpha = 0.5;
		}
		
		/**显示对话框(非模式窗口) @param closeOther 是否关闭其他对话框*/
		public function show(dialog:Dialog, closeOther:Boolean = false):void {
			if(closeOther) removeAllChild();
			
			if (dialog.popupCenter){
				dialog.x = (_width - dialog.width) * 0.5;
				dialog.y = (_height - dialog.height) * 0.5;
			}
			_root.addChild(dialog);
			_dialogList.push(dialog);
		}
		
		private function removeAllChild():void
		{
			for each(var t:Dialog in _dialogList){
				t.remove();
			}
		}
		
		/**显示对话框(模式窗口) @param closeOther 是否关闭其他对话框*/
		public function popup(dialog:Dialog, closeOther:Boolean = false):void {
			if(closeOther) removeAllChild();
			
			if (dialog.popupCenter) {
				dialog.x = (_width - dialog.width) * 0.5;
				dialog.y = (_height - dialog.height) * 0.5;
			}
			
			if(!_isStage){
				_isStage = true;
				_root.addQuickChild(_mask);
			}
			_root.addChild(dialog);
			_dialogList.push(dialog);
		}
		
		/**删除对话框*/
		public function close(dialog:Dialog):void {
			dialog.remove();
			var index:int = _dialogList.indexOf(dialog);
			if(index >= 0) _dialogList.splice(index, 1);
			
			if(_dialogList.length == 0){
				_root.removeQuickChild(_mask);
				_isStage = false;
			}
		}
		
		/**删除所有对话框*/
		public function closeAll():void {
			removeAllChild();
			_root.removeQuickChild(_mask);
			_isStage = false;
		}
	}
}