package com.sunmoon.game.map
{
	import flash.display.DisplayObjectContainer;

	public interface ICamera
	{
		function get SpeedX():Number;
		function get SpeedY():Number;
		function get Speed():Number;
		function get ix():Number;
		function get iz():Number;
		function get parent():DisplayObjectContainer;
	}
}