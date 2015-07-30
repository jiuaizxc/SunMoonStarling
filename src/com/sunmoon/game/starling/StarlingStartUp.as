package com.sunmoon.game.starling
{
	import com.sunmoon.game.utils.Mobile;
	import com.sunmoon.game.utils.ResolutionPolicy;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.events.ResizeEvent;
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
		private var _designSize:Point;
		
		public function StarlingStartUp()
		{
			super();
		}
		
		protected function initStarling(rootClass:Class, designSize:Point, resolutionPolicy:uint, isPC:Boolean = false):void
		{
			_designSize = designSize.clone();
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
					_starling = new Starling(rootClass, stage, new Rectangle(0, 0, W, H));
					_starling.stage.stageWidth = designSize.x;
					_starling.stage.stageHeight = designSize.y;
					break;
				default:
					sX = sY = Math.min(sX, sY);
					var viewPortW:Number = designSize.x * sX;
					var viewPortH:Number = designSize.y * sY;
					_starling = new Starling(rootClass, stage, new Rectangle((W - viewPortW) * 0.5, (H - viewPortH) * 0.5, viewPortW, viewPortH));
					_starling.stage.stageWidth = designSize.x;
					_starling.stage.stageHeight = designSize.y;
					break;
			}
			
			
			//_starling.stage.addEventListener(ResizeEvent.RESIZE, onResize);
			
			_starling.start();
		}
		
		private function onResize(e:ResizeEvent):void
		{
			var designSize:Point = _designSize.clone();
			var W:Number = e.width;
			var H:Number = e.height;
			var sX:Number = W / designSize.x;
			var sY:Number = H / designSize.y;
			sY = sX;
			designSize.y = Math.ceil(H / sY);
			_starling.viewPort = new Rectangle(0, 0, W, H);
			_starling.stage.stageWidth = designSize.x;
			_starling.stage.stageHeight = designSize.y;
		}
		
		protected function deBug():void
		{
			_starling.showStats = true;
			_starling.showStatsAt(HAlign.LEFT, VAlign.TOP, Starling.contentScaleFactor);
		}
	}
}