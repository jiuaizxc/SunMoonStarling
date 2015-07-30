package 
{
	import com.sunmoon.game.schedule.Schedule;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.utils.AssetManager;

	/**
	 * 
	 * @author SunMoon
	 * 引擎核心主类 
	 */	
	public class SunMoon 
	{
		/**全局stage引用*/
		public static var stage:Stage;
		
		private static var _instance:SunMoon;
		
		private static var _assets:AssetManager; 
		
		private var _main:DisplayObjectContainer;
		private var _designSize:Point; 
		
		private var _schedule:Schedule;
		
		private var _mainLayer:Sprite;
		private var _uiLayer:Sprite;
		private var _isPaused:Boolean;
		
		private var m_deltaTime:int;
		private var m_preTime:int;
		private var m_curTime:int;
		
		public function SunMoon(value:Singleton)
		{
			if(!value){
				throw new Error("单例类！");
			}
		}
		
		public static function get singleton():SunMoon
		{
			if(_instance) return _instance;
			_instance = new SunMoon(new Singleton());
			return _instance;
		}
		
		public function init(main:DisplayObjectContainer, DesignSize:Point):void
		{
			_main = main;
			_designSize = DesignSize;
			stage = _main.stage;
			_isPaused = true;
			_mainLayer = new Sprite();
			_main.addChild(_mainLayer);
			
			_uiLayer = new Sprite();
			_main.addChild(_uiLayer);
			
			_assets = new AssetManager();
			
			App.init(stage, _designSize);
			App.asset = _assets;
			
			_schedule = new Schedule();
			
			Starling.current.nativeStage.addEventListener(Event.ENTER_FRAME, mainLoop);
		}
		
		/** 暂停 */		
		public function pasued():void
		{
			_isPaused = false;
		}
		
		/**  继续 */		
		public function resume():void
		{
			_isPaused = true;
		}
		
		private function mainLoop(event:Event):void
		{
			m_curTime = getTimer();
			m_deltaTime = m_curTime - m_preTime;
			m_preTime = m_curTime;
			if(_isPaused) _schedule.update(m_deltaTime);
		}
		
		/**
		 * 是否暂停 
		 * @return 
		 * 
		 */		
		public function get isPasued():Boolean
		{
			return !_isPaused;
		}

		/**
		 * 调度器 
		 * @return 
		 * 
		 */		
		public function get schedule():Schedule{return _schedule;}

		/**
		 * 主层 
		 * @return 
		 * 
		 */		
		public function get mainLayer():Sprite{return _mainLayer;}

		/**
		 * UI层 
		 * @return 
		 * 
		 */		
		public function get uiLayer():Sprite
		{
			return _uiLayer;
		}

		/** 资源管理类 */
		public static function get assets():AssetManager
		{
			return _assets;
		}

		/** 设计分辨率 */
		public function get designSize():Point
		{
			return _designSize;
		}
	}
}

class Singleton{
	public function Singleton(){}
}