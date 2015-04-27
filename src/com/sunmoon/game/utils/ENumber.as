package com.sunmoon.game.utils
{

	public class ENumber
	{
		private var _value:Number;
		private var X:int;
		
		public function ENumber(v:Number = 0)
		{
			value = v;
		}
		
		public function set value(v:Number):void
		{
			X = Calculate.randomCryptoNumber();
			_value = v + X;
		}
		
		public function get value():Number
		{
			return _value - X;
		}
	}
}