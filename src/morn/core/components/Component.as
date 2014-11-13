/**
 * Morn UI Version 2.5.1215 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.components{
	import morn.core.events.UIEvent;
	import morn.core.utils.ObjectUtils;
	import morn.editor.core.IComponent;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**组件基类*/
	public class Component extends Sprite implements IComponent{
		protected var _width:Number;
		protected var _height:Number;
		protected var _contentWidth:Number = 0;
		protected var _contentHeight:Number = 0;
		protected var _disabled:Boolean;
		protected var _tag:Object;
		protected var _comXml:XML;
		protected var _dataSource:Object;
		protected var _toolTip:Object;
		protected var _mouseChildren:Boolean;
		
		//-----------------布局属性---------------
		protected var _top:Number;
		protected var _bottom:Number;
		protected var _left:Number;
		protected var _right:Number;
		protected var _centerX:Number;
		protected var _centerY:Number;
		protected var _isPercent:Boolean;
		
		public function Component(){
			mouseChildren = true;
			preinitialize();
			createChildren();
			initialize();
		}
		
		/**预初始化，在此可以修改属性默认值*/
		protected function preinitialize():void {
		
		}
		
		/**在此创建组件子对象*/
		protected function createChildren():void {
		
		}
		
		/**初始化，在此子对象已被创建，可以对子对象进行修改*/
		protected function initialize():void {
		
		}
		
		/**延迟调用，在组件被显示在屏幕之前调用*/
		public function callLater(method:Function, args:Array = null):void {
			App.render.callLater(method, args);
		}
		
		/**执行延迟调用*/
		public function exeCallLater(method:Function):void {
			App.render.exeCallLater(method);
		}
		
		/**派发事件，可以携带数据*/
		public function sendEvent(type:String, data:* = null, bubbles:Boolean = false):void {
			if(hasEventListener(type)) dispatchEvent(new UIEvent(type, data, bubbles));
		}
		
		/**从父容器删除自己，如已经被删除不会抛出异常*/
		public function remove():void {
			if (parent) {
				parent.removeChild(this);
			}
		}
		
		/**根据名字删除子对象，如找不到不会抛出异常*/
		public function removeChildByName(name:String):void {
			var display:DisplayObject = getChildByName(name);
			if (display) {
				removeChild(display);
			}
		}
		
		/**设置组件位置*/
		public function setPosition(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
		}
		
		/**宽度(值为NaN时，宽度为自适应大小)*/
		override public function get width():Number {
			if (!isNaN(_width)) {
				return _width;
			} else if (_contentWidth != 0) {
				return _contentWidth;
			} else {
				return measureWidth;
			}
		}
		
		/**显示的宽度(width * scaleX)*/
		public function get displayWidth():Number {
			return width * scaleX;
		}
		
		protected function get measureWidth():Number {
			commitMeasure();
			var max:Number = 0;
			for (var i:int = numChildren - 1; i > -1; i--) {
				var comp:DisplayObject = getChildAt(i);
				if (comp.visible) {
					max = Math.max(comp.x + comp.width * comp.scaleX, max);
				}
			}
			return max;
		}
		
		override public function set width(value:Number):void {
			if (_width != value) {
				_width = value;
			}
		}
		
		/**高度(值为NaN时，高度为自适应大小)*/
		override public function get height():Number {
			if (!isNaN(_height)) {
				return _height;
			} else if (_contentHeight != 0) {
				return _contentHeight;
			} else {
				return measureHeight;
			}
		}
		
		/**显示的高度(height * scaleY)*/
		public function get displayHeight():Number {
			return height * scaleY;
		}
		
		protected function get measureHeight():Number {
			commitMeasure();
			var max:Number = 0;
			for (var i:int = numChildren - 1; i > -1; i--) {
				var comp:DisplayObject = getChildAt(i);
				if (comp.visible) {
					max = Math.max(comp.y + comp.height * comp.scaleY, max);
				}
			}
			return max;
		}
		
		override public function set height(value:Number):void {
			if (_height != value) {
				_height = value;
			}
		}
		
		override public function set scaleX(value:Number):void {
			super.scaleX = value;
		}
		
		override public function set scaleY(value:Number):void {
			super.scaleY = value;
		}
		
		/**执行影响宽高的延迟函数*/
		public function commitMeasure():void{}
		
		/**设置组件大小*/
		public function setSize(width:Number, height:Number):void {
			this.width = width;
			this.height = height;
		}
		
		/**缩放比例(等同于同时设置scaleX，scaleY)*/
		public function set scale(value:Number):void {
			scaleX = scaleY = value;
		}
		
		public function get scale():Number {
			return scaleX;
		}
		
		/**是否禁用*/
		public function get disabled():Boolean {
			return _disabled;
		}
		
		public function set disabled(value:Boolean):void {
			if (_disabled != value) {
				_disabled = value;
				touchable = !value;
				mouseChildren = value ? false : _mouseChildren;
				ObjectUtils.gray(this, _disabled);
			}
		}
		
		public function set mouseChildren(value:Boolean):void {
			_mouseChildren = value;
			touchGroup = !value;
		}
		
		public function get mouseChildren():Boolean
		{
			return _mouseChildren;
		}
		
		public function set mouseEnabled(value:Boolean):void
		{
			touchable = value;
		}
		
		public function get mouseEnabled():Boolean
		{
			return touchable;
		}
		
		/**标签(冗余字段，可以用来储存数据)*/
		public function get tag():Object {
			return _tag;
		}
		
		public function set tag(value:Object):void {
			_tag = value;
		}
		
		/**组件xml结构(高级用法：动态更改XML，然后通过页面重新渲染)*/
		public function get comXml():XML {
			return _comXml;
		}
		
		public function set comXml(value:XML):void {
			_comXml = value;
		}
		
		/**数据赋值
		 * 简单赋值更改组件的默认属性，使用大括号可以指定组件的任意属性进行赋值
		 * @example label1和checkbox1分别为组件实例的name属性
		 * <listing version="3.0">
		 * //默认属性赋值(更改了label1的text属性，更改checkbox1的selected属性)
		 * dataSource = {label1: "改变了label", checkbox1: true}
		 * //任意属性赋值
		 * dataSource = {label2: {text:"改变了label",size:14}, checkbox2: {selected:true,x:10}}
		 * </listing>*/
		public function get dataSource():Object {
			return _dataSource;
		}
		
		public function set dataSource(value:Object):void {
			_dataSource = value;
			for (var prop:String in _dataSource) {
				if (hasOwnProperty(prop)) {
					this[prop] = _dataSource[prop];
				}
			}
		}
		
		/**鼠标提示
		 * 可以赋值为文本及函数，以实现自定义鼠标提示和参数携带等
		 * @example 下面例子展示了三种鼠标提示
		 * <listing version="3.0">
		 *	private var _testTips:TestTipsUI = new TestTipsUI();
		 *	private function testTips():void {
		 *		//简单鼠标提示
		 *		btn2.toolTip = "这里是鼠标提示&lt;b&gt;粗体&lt;/b&gt;&lt;br&gt;换行";
		 *		//自定义的鼠标提示
		 *		btn1.toolTip = showTips1;
		 *		//带参数的自定义鼠标提示
		 *		clip.toolTip = new Handler(showTips2, ["clip"]);
		 *	}
		 *	private function showTips1():void {
		 *		_testTips.label.text = "这里是按钮[" + btn1.label + "]";
		 *		App.tip.addChild(_testTips);
		 *	}
		 *	private function showTips2(name:String):void {
		 *		_testTips.label.text = "这里是" + name;
		 *		App.tip.addChild(_testTips);
		 *	}
		 * </listing>*/
		public function get toolTip():Object {
			return _toolTip;
		}
		
		public function set toolTip(value:Object):void {
			if (_toolTip != value) {
				_toolTip = value;
				if (Boolean(value)) {
					addEventListener(TouchEvent.TOUCH, onRollMouse);
				} else {
					removeEventListener(TouchEvent.TOUCH, onRollMouse);
				}
			}
		}
		
		protected var m_RollTouch:Touch;
		protected var m_Tip:Boolean;
		protected function onRollMouse(e:TouchEvent):void {
			m_RollTouch = e.getTouch(this, TouchPhase.HOVER);
			if(m_RollTouch){
				if(!m_Tip){
					m_Tip = true;
					dispatchEvent(new UIEvent(UIEvent.SHOW_TIP, {obj:_toolTip, X:m_RollTouch.globalX, Y:m_RollTouch.globalY}, true));
				}
			}else{
				if(m_Tip){
					m_Tip = false;
					dispatchEvent(new UIEvent(UIEvent.HIDE_TIP, _toolTip, true));
				}
			}
		}
		
		/**居父容器顶部的距离*/
		public function get top():Number {
			return _top;
		}
		
		public function set top(value:Number):void {
			_top = value;
			callLater(resetPosition);
		}
		
		/**居父容器底部的距离*/
		public function get bottom():Number {
			return _bottom;
		}
		
		public function set bottom(value:Number):void {
			_bottom = value;
			callLater(resetPosition);
		}
		
		/**居父容器左边的距离*/
		public function get left():Number {
			return _left;
		}
		
		public function set left(value:Number):void {
			_left = value;
			callLater(resetPosition);
		}
		
		/**居父容器右边的距离*/
		public function get right():Number {
			return _right;
		}
		
		public function set right(value:Number):void {
			_right = value;
			callLater(resetPosition);
		}
		
		/**居父容器水平居中位置的偏移*/
		public function get centerX():Number {
			return _centerX;
		}
		
		public function set centerX(value:Number):void {
			_centerX = value;
			callLater(resetPosition);
		}
		
		/**居父容器垂直居中位置的偏移*/
		public function get centerY():Number {
			return _centerY;
		}
		
		public function set centerY(value:Number):void {
			_centerY = value;
			callLater(resetPosition);
		}
		
		/**是否按百分比缩放*/
		public function get isPercent():Boolean
		{
			return _isPercent;
		}
		
		/**@private*/
		public function set isPercent(value:Boolean):void
		{
			if(_isPercent != value){
				_isPercent = value;
				scale = App.percentScale;
				callLater(resetPosition);
			}
		}
		
		/**重置位置*/
		protected function resetPosition():void {
			if (parent) {
				if (!isNaN(_centerX)) {
					x = (parent.width - displayWidth) * 0.5 + _centerX;
				} else if (!isNaN(_left)) {
					x = _left;
					if (!isNaN(_right)) {
						width = (parent.width - _left - _right) / scaleX;
					}
				} else if (!isNaN(_right)) {
					x = parent.width - displayWidth - _right;
				}
				if (!isNaN(_centerY)) {
					y = (parent.height - displayHeight) * 0.5 + _centerY;
				} else if (!isNaN(_top)) {
					y = _top;
					if (!isNaN(_bottom)) {
						height = (parent.height - _top - _bottom) / scaleY;
					}
				} else if (!isNaN(_bottom)) {
					y = parent.height - displayHeight - _bottom;
				}
			}
		}
	}
}