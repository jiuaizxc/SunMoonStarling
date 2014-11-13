package com.sunmoon.game.map
{
	public interface IMap
	{
		function initData(...args):void;
		
		function destroy():void;
		
		function moveMap(X:Number, Y:Number, Zoom:Number):void;
		
		function get vo():MapVo;
		
		function get target():ICamera;
		
		function set target(value:ICamera):void;
	}
}