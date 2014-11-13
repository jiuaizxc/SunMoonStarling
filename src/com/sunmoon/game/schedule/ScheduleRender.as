package com.sunmoon.game.schedule
{
	
	/**
	 * @author SunMoon
	 *渲染调度器
	 * 用于图像的渲染 
	 */	
	public class ScheduleRender extends BasicSchedule
	{
		public static const RENDER_PRIORITY:int = 5000;
		
		/**
		 * 
		 * @param callBackFunc 回调函数
		 * @param target 调度对象
		 * @param pasued 调度器是否暂停
		 * @param priority 优先级
		 */		
		public function ScheduleRender(callBackFunc:Function, target:Object, pasued:Boolean, priority:int = RENDER_PRIORITY)
		{
			super(callBackFunc, target, BasicSchedule.RENDER, priority, pasued);
		}
		
		override public function update(dlt:int):void
		{
			_callBackFunc();
		}
	}
}