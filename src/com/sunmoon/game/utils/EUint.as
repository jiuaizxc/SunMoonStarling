package com.sunmoon.game.utils
{
	public class EUint
	{
		private var _value:uint;
		private var X:uint;
		
		public function EUint(v:uint = 0)
		{
			value = v;
		}
		
		public function set value(v:uint):void
		{
			X = uint(Math.random() * 999999999);
			_value = v ^ X;
		}
		
		public function get value():uint
		{
			return _value ^ X;
		}
	}
}