/**
 * Morn UI Version 2.5.1215 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.managers{
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import starling.core.Starling;
	
	/**渲染管理器*/
	public class RenderManager {
		private var _methods:Dictionary = new Dictionary();
		
		private function invalidate():void {
			Starling.current.nativeStage.addEventListener(Event.ENTER_FRAME, onValidate);
		}
		
		private function onValidate(e:Event):void {
			Starling.current.nativeStage.removeEventListener(Event.ENTER_FRAME, onValidate);
			renderAll();
		}
		
		/**执行所有延迟调用*/
		public function renderAll():void {
			for (var method:Object in _methods) {
				exeCallLater(method as Function);
			}
		}
		
		/**延迟调用*/
		public function callLater(method:Function, args:Array = null):void {
			if (_methods[method] == null) {
				_methods[method] = args || [];
				invalidate();
			}
		}
		
		/**执行延迟调用*/
		public function exeCallLater(method:Function):void {
			if (_methods[method] != null) {
				var args:Array = _methods[method];
				delete _methods[method];
				method.apply(null, args);
			}
		}
	}
}