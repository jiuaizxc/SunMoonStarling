package com.sunmoon.game.map
{
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;

	public class ScrollScene
	{
		private var _canvas:DisplayObjectContainer;
		private var _mapList:Vector.<IMap>;
		
		private var _lockY:Boolean;
		
		private var m_map:IMap;
			
		public function ScrollScene(canvas:DisplayObjectContainer)
		{
			_canvas = canvas;
			_mapList = new Vector.<IMap>();
		}
		
		public function destory():void
		{
			for each(var map:IMap in _mapList){
				_canvas.removeChild(map as DisplayObject);
				map.destroy();
			}
			_mapList.length = 0;
			_mapList = null;
			_canvas = null;
		}
		
		public function addMap(scrollMap:IMap):void
		{
			_mapList.push(scrollMap);
			_canvas.addChild(scrollMap as DisplayObject);
		}
		
		public function lockY():void{_lockY = true;}
		
		public function moveTo(X:Number, Y:Number, Zoom:Number):void
		{
			_canvas.x = X;
			_canvas.scaleX = Zoom;
			if(_lockY) return;
			_canvas.y = Y;
			_canvas.scaleY = Zoom;
		}
		
		public function moveMap(X:Number, Y:Number, Zoom:Number):void
		{
			for each(m_map in _mapList){
				m_map.moveMap(X, Y, Zoom);
			}
		}
		
		public function setMapTarget(target:ICamera):void
		{
			for each(var temp:IMap in _mapList){
				temp.target = target;
			}
		}

		public function get canvas():DisplayObjectContainer
		{
			return _canvas;
		}
	}
}