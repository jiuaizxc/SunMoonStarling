/**
 * Morn UI Version 2.4.1020 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package {
	import flash.geom.Point;
	
	import morn.core.managers.DialogManager;
	import morn.core.managers.DragManager;
	import morn.core.managers.LangManager;
	import morn.core.managers.RenderManager;
	import morn.core.managers.TimerManager;
	import morn.core.utils.ObjectUtils;
	
	import starling.display.Stage;
	import starling.utils.AssetManager;
	
	/**全局引用入口*/
	public class App {
		/**全局stage引用*/
		public static var stage:Stage;
		public static var designSize:Point;
		
		/**时钟管理器*/
		public static var timer:TimerManager;
		/**资源管理器*/
		public static var asset:AssetManager;
		/**渲染管理器*/
		public static var render:RenderManager;
		/**对话框管理器*/
		public static var dialog:DialogManager;
		/**拖动管理器*/
		public static var drag:DragManager;
		/**语言管理器*/
		public static var lang:LangManager;
		
		private static var _percentScale:Number;
		
		public static function init(Value:Stage, DesignSize:Point):void{
			stage = Value;
			designSize = DesignSize;
			_percentScale = Math.min(stage.stageWidth/designSize.x, stage.stageHeight/designSize.y);
			
			ObjectUtils.init();
			
			timer = new TimerManager();
			asset = new AssetManager();
			render = new RenderManager();
			dialog = new DialogManager();
			drag = new DragManager();
			lang = new LangManager();
			
			stage.addChild(dialog);
		}
		
		/**获得资源路径(此处可以加上资源版本控制)*/
		public static function getResPath(url:String):String {
			return /^http:\/\//g.test(url) ? url : Config.resPath + url;
		}
		
		public static function get percentScale():Number
		{
			return _percentScale;
		}
	}
}