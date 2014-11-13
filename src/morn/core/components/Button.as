/**
 * Morn UI Version 2.4.1027 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.components{
	import flash.geom.Point;
	
	import morn.core.components.interfaces.ISelect;
	import morn.core.events.UIEvent;
	import morn.core.handlers.Handler;
	import morn.core.utils.BitmapUtils;
	import morn.core.utils.ObjectUtils;
	import morn.core.utils.StringUtils;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	/**选择改变后触发*/
	[Event(name="select",type="flash.events.Event")]
	
	/**按钮类*/
	//为了效率，可考虑是否重写触目HitTest检测
	public class Button extends Component implements ISelect {
		protected static var stateMap:Object = {"rollOver": 1, "rollOut": 0, "mouseDown": 2, "mouseUp": 1, "selected": 2};
		protected var _bitmap:AutoBitmap;
		protected var _clickHandler:Handler;
		protected var _state:int;
		protected var _toggle:Boolean;
		protected var _selected:Boolean;
		protected var _skin:String;
		protected var _autoSize:Boolean = true;
		
		private var m_Touch:Touch;
		private var m_GlobalPos:Point = new Point();
		private var m_LocalPos:Point = new Point();
		public function Button(skin:String = null){
			mouseChildren = false;
			this.skin = skin;
		}
		
		override protected function createChildren():void {
			_bitmap = new AutoBitmap(this);
		}
		
		override protected function initialize():void 
		{
			addEventListener(TouchEvent.TOUCH, onMouse);
		}
		
		protected function onMouse(e:TouchEvent):void {
			if ((_toggle == false && _selected) || _disabled) return;
			
			m_Touch = e.getTouch(this, TouchPhase.ENDED);
			if(m_Touch){
				m_GlobalPos.setTo(m_Touch.globalX, m_Touch.globalY);
				m_Touch.target.globalToLocal(m_GlobalPos, m_LocalPos);
				if(m_Touch.target.hitTest(m_LocalPos)){
					e.stopPropagation();
					state = stateMap["mouseUp"];
					if (_toggle) {
						selected = !_selected;
					}
					if (_clickHandler) {
						_clickHandler.execute();
					}
					sendEvent(UIEvent.SELECT, this);
					return;
				}
			}
			
			if (_selected == false){
				m_Touch = e.getTouch(this, TouchPhase.BEGAN);
				if(m_Touch){
					e.stopPropagation();
					state = stateMap["mouseDown"];
					return;
				}
				
				m_Touch = e.getTouch(this, TouchPhase.HOVER);
				if(m_Touch) state = stateMap["rollOver"];
				else state = stateMap["rollOut"];
			}
		}
		
		/**皮肤*/
		public function get skin():String {
			return _skin;
		}
		
		public function set skin(value:String):void {
			if (_skin != value) {
				_skin = value;
				var clips:Vector.<Texture> = BitmapUtils.getClips(StringUtils.assetsName(value), 1, 3);
				_bitmap.clips = clips;
				if (_autoSize) {
					_contentWidth = _bitmap.width;
					_contentHeight = _bitmap.height;
				}
			}
		}
		
		/**是否是选择状态*/
		public function get selected():Boolean {
			return _selected;
		}
		
		public function set selected(value:Boolean):void {
			if (_selected != value) {
				_selected = value;
				state = _selected ? stateMap["selected"] : stateMap["rollOut"];
			}
		}
		
		protected function get state():int {
			return _state;
		}
		
		protected function set state(value:int):void {
			_state = value;
			callLater(changeState);
		}
		
		protected function changeState():void {
			_bitmap.index = _state;
		}
		
		/**是否是切换状态*/
		public function get toggle():Boolean {
			return _toggle;
		}
		
		public function set toggle(value:Boolean):void {
			_toggle = value;
		}
		
		override public function set disabled(value:Boolean):void {
			if (_disabled != value) {
				super.disabled = value;
				state = _selected ? stateMap["selected"] : stateMap["rollOut"];
				ObjectUtils.gray(this, _disabled);
			}
		}
		
		/**点击处理器(无默认参数)*/
		public function get clickHandler():Handler {
			return _clickHandler;
		}
		
		public function set clickHandler(value:Handler):void {
			_clickHandler = value;
		}
		
		/**九宫格信息(格式:左边距,上边距,右边距,下边距)*/
		public function get sizeGrid():String {
			if (_bitmap.sizeGrid) {
				return _bitmap.sizeGrid.join(",");
			}
			return null;
		}
		
		public function set sizeGrid(value:String):void {
			_bitmap.sizeGrid = StringUtils.fillArray(Styles.defaultSizeGrid, value);
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			if (_autoSize) {
				_bitmap.width = value;
			}
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			if (_autoSize) {
				_bitmap.height = value;
			}
		}
		
		override public function set dataSource(value:Object):void {
			_dataSource = value;
			super.dataSource = value;
		}
	}
}