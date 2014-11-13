package com.sunmoon.game.schedule
{
	
	/**
	 * @author SunMoon
	 * 
	 * 实体调用器
	 * 回调函数必须含有一个int型的参数
	 * 用来传入每帧间隔时间
	 */	
	public class ScheduleEntry extends BasicSchedule
	{
		
		/**
		 * @param callBackFunc 回调函数（回调函数必须含有一个int型的参数）
		 * @param target 调度对象
		 * @param priority 调度器优先级
		 * @param pasued 调度器是否暂停
		 * 
		 */		
		public function ScheduleEntry(callBackFunc:Function, target:Object, priority:int, pasued:Boolean)
		{
			super(callBackFunc, target, BasicSchedule.SCHEDULE, priority, pasued);
		}
		
		override public function update(dlt:int):void
		{
			_callBackFunc(dlt);
		}
	}
}