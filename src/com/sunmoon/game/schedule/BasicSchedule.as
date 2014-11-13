package com.sunmoon.game.schedule
{
	/**
	 * @author SunMoon
	 * 基本调度器类
	 * 
	 */	
	public class BasicSchedule
	{
		public static const SCHEDULE:int = 1;
		public static const TIMER:int = 2;
		public static const RENDER:int = 3;
		
		protected var _scheduleType:int;
		
		protected var _target:Object;
		
		protected var _callBackFunc:Function;
		
		protected var _priority:int;
		
		protected var _pasued:Boolean;
		
		/**
		 * 
		 * @param callBackFunc 回调函数
		 * @param target 调度对象
		 * @param scheduleType 调度器类型
		 * @param priority 调度器优先级
		 * @param pasued 调度器是否暂停
		 * 
		 */		
		public function BasicSchedule(callBackFunc:Function, target:Object, scheduleType:int, priority:int, pasued:Boolean)
		{
			_target = target;
			_callBackFunc = callBackFunc;
			_scheduleType = scheduleType;
			_priority = priority;
			_pasued = pasued;
		}
		
		/**
		 *摧毁调度器 
		 * 
		 */		
		public function destroy():void
		{
			_callBackFunc = null;
			_target = null;
		}
		
		
		public function update(dlt:int):void{}

		/**
		 *是否睡眠 
		 */
		public function get pasued():Boolean
		{
			return _pasued;
		}

		/**
		 * @private
		 */
		public function set pasued(value:Boolean):void
		{
			_pasued = value;
		}

		/**
		 *调度对象 
		 */
		public function get target():Object
		{
			return _target;
		}

		/**
		 * 调度器类型
		 */
		public function get scheduleType():int
		{
			return _scheduleType;
		}

		/**
		 * @private
		 */
		public function set scheduleType(value:int):void
		{
			_scheduleType = value;
		}

		/**
		 *回调函数 
		 */
		public function get callBackFunc():Function
		{
			return _callBackFunc;
		}

		/**
		 *优先级 
		 */
		public function get priority():int
		{
			return _priority;
		}

		/**
		 * @private
		 */
		public function set priority(value:int):void
		{
			_priority = value;
		}


	}
}