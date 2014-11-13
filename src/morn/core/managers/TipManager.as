/**
 * Morn UI Version 2.5.1215 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.managers{
	import morn.core.events.UIEvent;
	import morn.core.handlers.Handler;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**鼠标提示管理类*/
	public class TipManager extends Sprite {
		public static var offsetX:int = 10;
		public static var offsetY:int = 15;
		private var _tipBox:Sprite;
		private var _defaultTipHandler:Function;
		
		private var m_Touch:Touch;
		public function TipManager() {
			_tipBox = new Sprite();
			touchable = false;
			touchGroup = true;
			_defaultTipHandler = showDefaultTip;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(UIEvent.SHOW_TIP, onStageShowTip);
			stage.addEventListener(UIEvent.HIDE_TIP, onStageHideTip);
		}
		
		private function onStageHideTip(e:UIEvent):void {
			closeAll();
		}
		
		private function onStageShowTip(e:UIEvent):void {
			App.timer.doOnce(Config.tipDelay, showTip, [e.data]);
		}
		
		private function showTip(tip:Object):void {
			if (tip.obj is String) {
				var text:String = String(tip);
				if (Boolean(text)) {
					_defaultTipHandler(text);
				}
			} else if (tip.obj is Handler) {
				(tip.obj as Handler).execute();
			} else if (tip is Function) {
				(tip.obj as Function).apply();
			}
			if (Config.tipFollowMove) {
				stage.addEventListener(TouchEvent.TOUCH, onStage);
			}
			onStageMouseMove(tip.X, tip.Y);
		}
		
		private function onStageMouseMove(x:Number, y:Number):void
		{
			x = x + offsetX;
			y = y + offsetY;
			if (x < 0) {
				x = 0;
			} else if (x > stage.stageWidth - width) {
				x = stage.stageWidth - width;
			}
			if (y < 0) {
				y = 0;
			} else if (y > stage.stageHeight - height) {
				y = stage.stageHeight - height;
			}
			this.x = x;
			this.y = y;
		}
		
		private function onStage(e:TouchEvent):void
		{
			m_Touch = e.getTouch(stage, TouchPhase.MOVED);
			if(m_Touch){
				onStageMouseMove(m_Touch.globalX, m_Touch.globalY);
				return;
			}
			
			m_Touch = e.getTouch(stage, TouchPhase.ENDED);
			if(m_Touch){
				closeAll();
			}
		}
		
		/**关闭所有鼠标提示*/
		public function closeAll():void {
			App.timer.clearTimer(showTip);
			stage.removeEventListener(TouchEvent.TOUCH, onStage);
			for (var i:int = numChildren - 1; i > -1; i--) {
				removeChildAt(i);
			}
		}
		
		private function showDefaultTip(text:String):void{
			trace("默认回调！");
			/*var g:Graphics = _tipBox.graphics;
			g.clear();
			g.lineStyle(1, Styles.tipBorderColor);
			g.beginFill(Styles.tipBgColor);
			g.drawRoundRect(0, 0, _tipText.width + 10, _tipText.height + 10, 4, 4);
			g.endFill();
			addChild(_tipBox);*/
		}
		
		/**默认鼠标提示函数*/
		public function get defaultTipHandler():Function {
			return _defaultTipHandler;
		}
		
		public function set defaultTipHandler(value:Function):void {
			_defaultTipHandler = value;
		}
	}
}