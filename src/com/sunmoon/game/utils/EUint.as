package com.sunmoon.game.utils
{
	import flash.utils.ByteArray;

	public class EUint
	{
		private var _pos:int;
		private var _b:ByteArray;
		private var _key:int;
		
		public function EUint(v:uint = 0)
		{
			_b = new ByteArray();
			//_key = Math.random() * 99999;
			value = v;
		}
		
		public function set value(v:uint):void
		{
			_b.clear();
			_b.writeUnsignedInt(v);
			_pos = Math.random() * _b.length;
			//_b[_pos] ^= _key;
		}
		
		public function get value():uint
		{
			//_b[_pos] ^= _key;
			_b.position = 0;
			return _b.readUnsignedInt();
		}
	}
}