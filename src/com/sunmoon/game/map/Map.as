package com.sunmoon.game.map
{
	import starling.display.Sprite;
	
	public class Map extends Sprite implements IMap
	{	
		protected var _vo:MapVo;
		
		protected var _target:ICamera;
		
		public function Map(mapVo:MapVo)
		{
			super();
			_vo = mapVo;
		}
		
		public function initData(...args):void{}
		
		public function destroy():void{}
		
		public function moveMap(X:Number, Y:Number, Zoom:Number):void
		{
			x = X * (_vo.scrollRateX - 1) + _vo.offestX;
			y = Y * (_vo.scrollRateY - 1) + _vo.offestY;
		}

		public function get target():ICamera
		{
			return _target;
		}

		public function set target(value:ICamera):void
		{
			_target = value;
		}

		public function get vo():MapVo
		{
			return _vo;
		}
	}
}