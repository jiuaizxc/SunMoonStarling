package com.sunmoon.game.map
{
	import starling.display.DisplayObjectContainer;

	public interface ICamera
	{
		function get ix():Number;
		function get iz():Number;
		function get parent():DisplayObjectContainer;
	}
}