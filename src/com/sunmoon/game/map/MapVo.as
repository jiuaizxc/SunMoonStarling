package com.sunmoon.game.map
{
	public class MapVo
	{
		public var scrollRateX:Number;
		public var scrollRateY:Number;
		public var offestX:Number;
		public var offestY:Number;
		
		public function MapVo(scrollRateX:Number, scrollRateY:Number, offestX:Number = 0, offestY:Number = 0)
		{
			this.scrollRateX = scrollRateX;
			this.scrollRateY = scrollRateY;
			this.offestX = offestX;
			this.offestY = offestY;
		}
	}
}