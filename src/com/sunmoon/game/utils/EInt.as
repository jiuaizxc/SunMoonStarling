package com.sunmoon.game.utils
{

	public class EInt
	{	
		private var _value:int;
		private var X:int;
		
		public function EInt(v:int = 0)
		{
			value = v;
		}
		
		public function set value(v:int):void
		{
			X = Calculate.randomCryptoNumber();
			_value = v ^ X;
		}
		
		public function get value():int
		{
			return _value ^ X;
		}
	}
}