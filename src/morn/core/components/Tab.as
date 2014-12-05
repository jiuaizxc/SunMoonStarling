/**
 * Morn UI Version 2.4.1020 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.components {
	import flash.events.Event;
	
	import morn.core.components.interfaces.IItem;
	import morn.core.components.interfaces.ISelect;
	import morn.core.handlers.Handler;
	
	/**选择项改变后触发*/
	[Event(name="select",type="flash.events.Event")]
	
	/**Tab标签*/
	public class Tab extends Box implements IItem {
		/**横向的*/
		public static const HORIZENTAL:String = "horizontal";
		/**纵向的*/
		public static const VERTICAL:String = "vertical";
		protected var _items:Vector.<ISelect>;
		protected var _selectHandler:Handler;
		protected var _selectedIndex:int;
		protected var _skin:String;
		protected var _direction:String = HORIZENTAL;
		
		public function Tab(skin:String = null) {
			this.skin = skin;
		}
		
		/**批量设置Radio*/
		public function setItems(buttons:Array):void {
			removeAllChild();
			var index:int = 0;
			for (var i:int = 0, n:int = buttons.length; i < n; i++) {
				var item:Button = buttons[i];
				if (item) {
					item.name = "item" + index;
					addChild(item);
					index++;
				}
			}
			initItems();
		}
		
		/**增加Radio*/
		public function addItem(button:Button):void {
			button.name = "item" + _items.length;
			addChild(button);
			initItems();
		}
		
		/**初始化*/
		public function initItems():void {
			_items = new Vector.<ISelect>();
			for (var i:int = 0; i < int.MAX_VALUE; i++) {
				var item:ISelect = getChildByName("item" + i) as ISelect;
				if (item == null) {
					break;
				}
				_items.push(item);
				item.selected = (i == _selectedIndex);
				item.clickHandler = new Handler(itemClick, [i]);
			}
		}
		
		protected function itemClick(index:int):void {
			selectedIndex = index;
		}
		
		/**所选按钮的索引*/
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void {
			if (_selectedIndex != value) {
				setSelect(_selectedIndex, false);
				_selectedIndex = value;
				setSelect(_selectedIndex, true);
				sendEvent(Event.SELECT);
				if (_selectHandler != null) {
					_selectHandler.executeWith([_selectedIndex]);
				}
			}
		}
		
		protected function setSelect(index:int, selected:Boolean):void {
			if (_items && index > -1 && index < _items.length) {
				_items[index].selected = selected;
			}
		}
		
		/**选择被改变时执行的处理器(默认返回参数index:int)*/
		public function get selectHandler():Handler {
			return _selectHandler;
		}
		
		public function set selectHandler(value:Handler):void {
			_selectHandler = value;
		}
		
		/**Button皮肤*/
		public function get skin():String {
			return _skin;
		}
		
		public function set skin(value:String):void {
			if (_skin != value) {
				_skin = value;
				callLater(changeLabels);
			}
		}
		
		protected function createButton(skin:String):Button {
			return new Button(skin);
		}
		
		protected function changeLabels():void {
			var left:Number = 0
			for (var i:int = 0, n:int = _items.length; i < n; i++) {
				var btn:Button = _items[i] as Button;
				if (_skin)
					btn.skin = _skin;
				if (_direction == HORIZENTAL) {
					btn.y = 0;
					btn.x = left;
					left += btn.width;
				} else {
					btn.x = 0;
					btn.y = left;
					left += btn.height;
				}
			}
		}
		
		override public function commitMeasure():void {
			exeCallLater(changeLabels);
		}
		
		/**按钮集合*/
		public function get items():Vector.<ISelect> {
			return _items;
		}
		
		/**选择项*/
		public function get selection():ISelect {
			return _selectedIndex > -1 && _selectedIndex < _items.length ? _items[_selectedIndex] : null;
		}
		
		public function set selection(value:ISelect):void {
			selectedIndex = _items.indexOf(value);
		}
		
		override public function set dataSource(value:Object):void {
			_dataSource = value;
			if (value is int || value is String) {
				selectedIndex = int(value);
			} else {
				for (var prop:String in _dataSource) {
					if (hasOwnProperty(prop)) {
						this[prop] = _dataSource[prop];
					}
				}
			}
		}
		
		/**布局方向*/
		public function get direction():String {
			return _direction;
		}
		
		public function set direction(value:String):void {
			_direction = value;
			callLater(changeLabels);
		}
	}
}