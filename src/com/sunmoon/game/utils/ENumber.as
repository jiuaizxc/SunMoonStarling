package com.sunmoon.game.utils
{
	import flash.utils.ByteArray;

	public class ENumber
	{
		private var _pos:int;
		private var _b:ByteArray;
		private var _key:int;
		
		public function ENumber()
		{
			_b = new ByteArray();
			_key = Math.random() * 99999;
			value = 0;
		}
		
		public function set value(v:Number):void
		{
			_b.clear();
			_b.writeDouble(v);
			_pos = Math.random() * _b.length;
			_b[_pos] ^= _key;
		}
		
		public function get value():Number
		{
			_b[_pos] ^= _key;
			_b.position = 0;
			return _b.readDouble();
		}
	}
}