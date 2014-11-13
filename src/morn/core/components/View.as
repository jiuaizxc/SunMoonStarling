/**
 * Morn UI Version 2.5.1215 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.components{
	import morn.core.components.interfaces.IItem;
	
	/**视图*/
	public class View extends Box {
		protected var _isAdaptScreen:Boolean;
		
		/**加载模式使用，存储uixml*/
		public static var xmlMap:Object = {};
		protected static var uiClassMap:Object = {"Box": Box, "Button": Button, "Clip": Clip, "Component": Component, 
																			"Image": Image, "View": View, "ProgressBar": ProgressBar};
		
		protected static var viewClassMap:Object = {};
		
		protected function createView(xml:XML):void {
			createComp(xml, this, this);
		}
		
		/**加载UI(用于加载模式)*/
		protected function loadUI(path:String):void {
			var xml:XML = xmlMap[path];
			if (xml) {
				createView(xml);
			}
		}
		
		/** 根据xml实例组件
		 * @param	xml 视图xml
		 * @param	comp 组件本体，如果为空，会新创建一个
		 * @param	view 组件所在的视图实例，用来注册var全局变量，为空则不注册*/
		public static function createComp(xml:XML, comp:Component = null, view:View = null):Component {
			comp = comp || getCompInstance(xml);
			comp.comXml = xml;
			for (var i:int = 0, m:int = xml.children().length(); i < m; i++) {
				var node:XML = xml.children()[i];
				comp.addChild(createComp(node, null, view));
			}
			for each (var attrs:XML in xml.attributes()) {
				var prop:String = attrs.name().toString();
				var value:String = attrs;
				if (comp.hasOwnProperty(prop)) {
					comp[prop] = (value == "true" ? true : (value == "false" ? false : value))
				} else if (prop == "var" && view && view.hasOwnProperty(value)) {
					view[value] = comp;
				}
			}
			if (comp is IItem) {
				IItem(comp).initItems();
			}
			return comp;
		}
		
		/**获得组件实例*/
		protected static function getCompInstance(xml:XML):Component {
			var runtime:String = xml.@runtime;
			var compClass:Class = Boolean(runtime) ? viewClassMap[runtime] : uiClassMap[xml.name()];
			return compClass ? new compClass() : null;
		}
		
		/**重新创建组件(通过修改组件的xml，实现动态更改UI视图)
		 * @param comp 需要重新生成的组件 comp为null时，重新创建整个视图*/
		public function reCreate(comp:Component = null):void {
			comp = comp || this;
			var dataSource:Object = comp.dataSource;
			if (comp is Box) {
				Box(comp).removeAllChild();
			}
			createComp(comp.comXml, comp, this);
			comp.dataSource = dataSource;
		}
		
		/**注册组件(用于扩展组件及修改组件对应关系)*/
		public static function registerComponent(key:String, compClass:Class):void {
			uiClassMap[key] = compClass;
		}

		public function get isAdaptScreen():Boolean
		{
			return _isAdaptScreen;
		}

		public function set isAdaptScreen(value:Boolean):void
		{
			if(_isAdaptScreen != value){
				_isAdaptScreen = value;
				setSize(App.stage.stageWidth, App.stage.stageHeight);
			}
		}
	}
}