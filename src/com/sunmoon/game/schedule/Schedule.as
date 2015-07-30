package com.sunmoon.game.schedule
{
	import flash.utils.Dictionary;

	/**
	 * @author SunMoon
	 * 调度器
	 * 
	 */	
	public class Schedule
	{
		private var _scheduleAllObject:Dictionary;
		
		private var _scheduleList:Vector.<BasicSchedule>;
		private var _addList:Vector.<BasicSchedule>;
		private var _removeList:Vector.<BasicSchedule>;
		
		private var _addLen:int;
		
		public function Schedule()
		{
			_scheduleAllObject = new Dictionary(true);
			
			_scheduleList = new Vector.<BasicSchedule>();
			_addList = new Vector.<BasicSchedule>();
			_removeList = new Vector.<BasicSchedule>();
		}
		
		/**
		 * 增加一个调度器 
		 * @param value BasicSchedule一个基本的调度器封装类（可以使继承此类的任何子类）
		 * 
		 */		
		public function addSchedule(value:BasicSchedule):BasicSchedule
		{
			checkObject(value);
			
			var basic:BasicSchedule = _scheduleAllObject[value.target][value.callBackFunc];
			var index:int;
			if(basic != null){
				index = _removeList.indexOf(basic);
				if(index >= 0) _removeList.splice(index, 1);
				switch(basic.scheduleType)
				{
					case BasicSchedule.TIMER:
						var _st:ScheduleTimer = value as ScheduleTimer;
						ScheduleTimer(basic).resetTimer(_st.pasued, _st.interval, _st.delay, _st.repeat);
					case BasicSchedule.SCHEDULE:
					case BasicSchedule.RENDER:
						basic.pasued = value.pasued;
						break;
					default:
						throw new Error("没有此调度类型!");
						return null;
				}
				value.destroy();
			}else{
				_scheduleAllObject[value.target][value.callBackFunc] = value;
				_addList.push(value);
				_addLen = _addList.length;
				basic = value;
			}
			return basic;
		}
		
		/**
		 *删除一个调度器 
		 * @param target 调度器对象
		 * @param callBackFunc 回调函数
		 * 
		 */		
		public function removeScheduleToCallBackFunc(target:Object, callBackFunc:Function):void
		{
			var basic:BasicSchedule = _scheduleAllObject[target][callBackFunc];
			var index:int;
			if(basic){
				basic.pasued = true;
				
				index = _removeList.indexOf(basic);
				if(index < 0) _removeList.push(basic);
				
				index = _addList.indexOf(basic);
				if(index >= 0) _addList.splice(index, 1);
			}
		}
		
		/**
		 *删除对象的所有调度器 
		 * @param target 调度对象
		 * 
		 */		
		public function removeObjectAllSchedule(target:Object):void
		{
			var dic:Dictionary = _scheduleAllObject[target];
			var index:int;
			for each(var basic:BasicSchedule in dic){
				if(basic){
					basic.pasued = true;
					
					index = _removeList.indexOf(basic);
					if(index < 0) _removeList.push(basic);
					
					index = _addList.indexOf(basic);
					if(index >= 0) _addList.splice(index, 1);
				}
			}
		}
		
		/**
		 *睡眠一个调度器 
		 * @param target 调度对象
		 * @param callBackFunc 睡眠的函数
		 * 
		 */		
		public function sleepScheduleToCallBackFunc(target:Object, callBackFunc:Function):void
		{
			var basic:BasicSchedule = _scheduleAllObject[target][callBackFunc];
			if(basic) basic.pasued = true;
		}
		
		/**
		 *唤醒一个调度器 
		 * @param target 调度对象
		 * @param callBackFunc 唤醒的函数
		 * 
		 */		
		public function weakScheduleToCallBackFunc(target:Object, callBackFunc:Function):void
		{
			var basic:BasicSchedule = _scheduleAllObject[target][callBackFunc];
			if(basic) basic.pasued = false;
		}
		
		/**
		 *强制移除所有在移除列表的函数 
		 * 
		 */		
		public function forceRemoveAllSchedule():void
		{
			_runLen = _removeList.length;
			while(--_runLen >= 0){
				clearFunc(_removeList[_runLen]);
				if(_runLen == 0) _removeList.length = 0;
			}
		}
		
		private var _runLen:int;
		private var _runList:Vector.<BasicSchedule>;
		private var _runSchedule:BasicSchedule;
		public function update(dlt:int):void
		{
			if(_addLen > 0){
				_scheduleList = _scheduleList.concat(_addList);
				_addList.length = 0;
				_addLen = 0;
				_scheduleList.sort(compare);
			}
			
			_runLen = _scheduleList.length;
			while(--_runLen >= 0){
				_runSchedule = _scheduleList[_runLen];
				if(_runSchedule.pasued) continue;
				_runSchedule.update(dlt);
			}
			
			forceRemoveAllSchedule();
		}
		
		private function checkObject(value:BasicSchedule):void
		{
			if(value.target in _scheduleAllObject) return;
			_scheduleAllObject[value.target] = new Dictionary();
		}
		
		private var removeBasicSchedule:BasicSchedule;
		private var removeIndex:int;
		private function clearFunc(value:BasicSchedule):void
		{
			removeBasicSchedule = _scheduleAllObject[value.target][value.callBackFunc];
			if(removeBasicSchedule && removeBasicSchedule == value){
				removeIndex = _scheduleList.indexOf(value);
				if(removeIndex >= 0){
					_scheduleList.splice(removeIndex, 1);
					delete _scheduleAllObject[value.target][value.callBackFunc];
					value.destroy();
				}
			}
			removeBasicSchedule = null;
			removeIndex = 0;
		}
		
		private function compare(a1:BasicSchedule, a2:BasicSchedule):int
		{
			if(a1.priority > a2.priority) return -1;
			else if(a1.priority < a2.priority) return 1;
			else return 0;
		}
	}
}