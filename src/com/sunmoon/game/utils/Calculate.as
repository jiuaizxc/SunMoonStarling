package com.sunmoon.game.utils
{
	import flash.geom.Rectangle;

	/**
	 * 
	 * @author SunMoon
	 * 计算工具类
	 */	
	public class Calculate
	{
		private static var dx:Number;
		private static var dy:Number;
		
		public function Calculate()
		{
		}
		
		/**
		 *角度转弧度 
		 * @param value
		 * @return 
		 * 
		 */		
		public static function angleToRadian(value:Number):Number
		{
			return value * Math.PI / 180;
		}
		
		/**
		 *弧度转角度 
		 * @param value
		 * @return 
		 * 
		 */		
		public static function radianToAngle(value:Number):Number
		{
			return value * 180 / Math.PI;
		}
		
		/**
		 *随机vA,vB之间的数字 , vA要小于vB
		 * @param vA
		 * @param vB
		 * @return 返回一个整形数
		 * 
		 */		
		public static function randomValue(vA:int, vB:int):int
		{
			var temp2:int = vB-vA;
			return int(Math.random()*(temp2 + 1)) + vA;
		}
		
		/**
		 *随机一个0到value - 1的整数
		 * @param value
		 * @return 
		 * 
		 */		
		public static function random(value:uint):uint
		{
			return uint(Math.random() * value);
		}
		
		public static function randomCryptoNumber():int
		{
			return Math.random() * 1999999998 - 999999999;
		}
		
		/**
		 *时间比较 
		 * @param date
		 * @param str
		 * @return 
		 * 
		 */		
		public static function timeCompare(date:Date, str:String):Boolean
		{
			var temp:Date = new Date(str);
			if(temp.getFullYear() < date.getFullYear()) return true;
			if(temp.getMonth() < date.getMonth()) return true;
			if(temp.getDate() < date.getDate()) return true;
			return false;
		}
		
		/**
		 *整型取绝对值 
		 * @param value
		 * @return 
		 * 
		 */	
		public static function myAbs_A(value:Number):uint
		{
			return (value^(value>>31))-(value>>31);
		}
		
		/**
		 *浮点取绝对值 
		 * @param value
		 * @return 
		 * 
		 */		
		public static function myAbs_B(value:Number):Number
		{
			return value < 0 ? -value : value;
		}
		
		/**
		 *计算几个矩形重叠后的最小矩形大小 
		 * @param rects
		 * @return 
		 * 
		 */		
		public static function calculateMinRect(rects:Vector.<Rectangle>):Rectangle
		{
			var resultRect:Rectangle = new Rectangle();
			var temp:Rectangle;
			for each(temp in rects){
				resultRect = resultRect.union(temp);
			}
			temp = null;
			return resultRect;
		}
		
		/**
		 *计算两点之间的距离 
		 * @param ax
		 * @param ay
		 * @param bx
		 * @param by
		 * @return 
		 * 
		 */		
		public static function twoPointDistance(ax:Number, ay:Number, bx:Number, by:Number):Number
		{
			dx = ax - bx;
			dy = ay - by;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		/**
		 *计算两点之间的距离平方
		 * @param ax
		 * @param ay
		 * @param bx
		 * @param by
		 * @return 
		 * 
		 */		
		public static function twoPointDistanceSQ(ax:Number, ay:Number, bx:Number, by:Number):Number
		{
			dx = ax - bx;
			dy = ay - by;
			return dx * dx + dy * dy;
		}
	}
}