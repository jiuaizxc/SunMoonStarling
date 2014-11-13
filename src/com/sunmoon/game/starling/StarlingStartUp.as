package com.sunmoon.game.starling
{
	import com.sunmoon.game.utils.Mobile;
	import com.sunmoon.game.utils.ResolutionPolicy;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * 启动引擎类 
	 * 文档类通过继承此类来快速创建Starling
	 * @author SunMoon
	 */	
	public class StarlingStartUp extends Sprite
	{
		protected var _starling:Starling;
		
		public function StarlingStartUp()
		{
			super();
		}
		
		protected function initStarling(rootClass:Class, designSize:Point, resolutionPolicy:uint, isPC:Boolean = false):void
		{
			if(Mobile.isAndroid()) Starling.handleLostContext = true;
			
			var W:Number = isPC ? stage.stageWidth : stage.fullScreenWidth;
			var H:Number = isPC ? stage.stageHeight : stage.fullScreenHeight;
			var sX:Number = W / designSize.x;
			var sY:Number = H / designSize.y;
			
			switch(resolutionPolicy)
			{
				case ResolutionPolicy.FIXED_WIDTH:
					sY = sX;
					designSize.y = Math.ceil(H / sY);
					break;
			}
			
			_starling = new Starling(rootClass, stage, new Rectangle(0, 0, W, H));
			_starling.stage.stageWidth = designSize.x;
			_starling.stage.stageHeight = designSize.y;
			
			_starling.start();
		}
		
		protected function deBug():void
		{
			_starling.showStats = true;
			_starling.showStatsAt(HAlign.LEFT, VAlign.TOP, Starling.contentScaleFactor);
		}
	}
}