package com.sunmoon.game.schedule
{
	
	/**
	 * @author SunMoon
	 * 计时调度器
	 */	
	public class ScheduleTimer extends BasicSchedule
	{
		private var _interval:int;
		
		private var _delay:int;
		
		private var _repeat:int;
		
		private var _useDelay:Boolean;
		
		private var _forever:Boolean;
		
		private var _elapsed:int;
		
		private var _timerExecuted:int;
		
		/**
		 * 
		 * @param callBackFunc 回调函数
		 * @param target 调度对象
		 * @param priority 调度器优先级
		 * @param pasued 调度器是否暂停
		 * @param interval 时间间隔(以毫秒为单位)
		 * @param delay 时间延迟(以毫秒为单位)
		 * @param repeat 重复次数(一直循环设置为小于等于0)
		 * 
		 */		
		public function ScheduleTimer(callBackFunc:Function, target:Object, priority:int, pasued:Boolean, interval:int, delay:int, repeat:int)
		{
			super(callBackFunc, target, BasicSchedule.TIMER, priority, pasued);
			_interval = interval;
			_delay = delay;
			_repeat = repeat;
			
			_useDelay = delay > 0 ? true : false;
			_forever = repeat <= 0 ? true : false;
			
			_elapsed = 0;
			_timerExecuted = 0;
		}
		
		/**
		 *重置时间调度器的属性 
		 * @param pasued 是否睡眠
		 * @param interval 时间间隔
		 * @param delay 时间延迟
		 * @param repeat 重复次数
		 * 
		 */		
		public function resetTimer(pasued:Boolean, interval:int, delay:int, repeat:int):void
		{
			_pasued = pasued;
			_interval = interval;
			_delay = delay;
			_repeat = repeat;
			
			_useDelay = delay > 0 ? true : false;
			_forever = repeat <= 0 ? true : false;
			
			_elapsed = 0;
			_timerExecuted = 0;
		}
		
		override public function update(dlt:int):void
		{
			if(_forever && !_useDelay){
				_elapsed += dlt;
				if(_elapsed >= _interval){
					_elapsed = 0;
					_callBackFunc();
				}
			}else{
				_elapsed += dlt;
				if(_useDelay){
					if(_elapsed >= _delay){
						_elapsed = _elapsed - dlt;
						_timerExecuted += 1;
						_useDelay = false;
						_callBackFunc();
					}
				}else{
					if(_elapsed >= _interval){
						_elapsed = 0;
						_timerExecuted += 1;
						_callBackFunc();
					}
				}
				
				if(!_forever && _timerExecuted >= _repeat){
					SunMoon.singleton.schedule.removeScheduleToCallBackFunc(_target, _callBackFunc);
				}
			}
		}

		/**
		 *时间间隔 
		 */
		public function get interval():int
		{
			return _interval;
		}

		/**
		 * 时间延迟
		 */
		public function get delay():int
		{
			return _delay;
		}

		/**
		 *重复次数 
		 */
		public function get repeat():int
		{
			return _repeat;
		}
	}
}