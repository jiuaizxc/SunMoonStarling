/**
 * Morn UI Version 2.2.0707 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.utils{
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.utils.ByteArray;
	
	import morn.core.starling.filters.AnselFilter;
	
	import starling.display.DisplayObject;
	import starling.filters.ColorMatrixFilter;
	import starling.filters.FragmentFilter;
	
	/**对象工具集*/
	public class ObjectUtils{
		
		public static function init():void
		{
			grayFilter = new ColorMatrixFilter();
			grayFilter.adjustSaturation(-1);
		}
		
		/**添加滤镜*/
		public static function addFilter(target:flash.display.DisplayObject, filter:BitmapFilter):void {
			var filters:Array = target.filters || [];
			filters.push(filter);
			target.filters = filters;
		}
		
		/**清除滤镜*/
		public static function clearFilter(target:flash.display.DisplayObject, filterType:Class):void {
			var filters:Array = target.filters;
			if (filters != null && filters.length > 0) {
				for (var i:int = filters.length - 1; i > -1; i--) {
					var filter:* = filters[i];
					if (filter is filterType) {
						filters.splice(i, 1);
					}
				}
				target.filters = filters;
			}
		}
		
		/**添加Starling滤镜*/
		public static function addStarlingFilter(target:starling.display.DisplayObject, filter:FragmentFilter):void {
			target.filter = filter;
		}
		
		/**清除Starling滤镜*/
		public static function clearStarlingFilter(target:starling.display.DisplayObject):void {
			target.filter = null;
		}
		
		/**clone副本*/
		public static function clone(source:*):* {
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(source);
			bytes.position = 0;
			return bytes.readObject();
		}
		
		private static var grayFilter:ColorMatrixFilter;
		
		public static function gray(traget:starling.display.DisplayObject, isGray:Boolean = true):void
		{
			if (isGray){
				addStarlingFilter(traget, grayFilter);
			}else{
				clearStarlingFilter(traget);
			}
		}
	}
}