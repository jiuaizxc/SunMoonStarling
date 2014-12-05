package com.sunmoon.game.map
{
	import flash.geom.Rectangle;
	
	/**
	 * 
	 * @author SunMoon
	 * 摄像机类 
	 */	
	
	public class MyCamera
	{
		private var _scene:ScrollScene;
		private var _bound:Rectangle;
		private var _target:ICamera;
		private var _lack:Boolean;
		
		private var _zoom:Number;
		
		private var m_lookL:Number;
		private var m_lookR:Number;
		private var m_lookT:Number;
		private var m_lookB:Number;
		
		private var m_SW:Number;
		private var m_SH:Number;
		private var m_posX:Number;
		private var m_posY:Number;
		private var m_zoom:Number;
		
		/**
		 *  
		 * @param scene ScrollScene类
		 * @param bound 边界矩形
		 * 
		 */		
		public function MyCamera(scene:ScrollScene, bound:Rectangle)
		{
			_scene = scene;
			_bound = bound;
			
			m_SW = SunMoon.stage.stageWidth;
			m_SH = SunMoon.stage.stageHeight;
			m_lookL = m_SW * 0.5;
			m_lookR = m_SW * 0.5;
			m_lookT = m_SH * 0.5;
			m_lookB = m_SH * 0.5;
			
			_zoom = 1;
			_lack = true;
		}
		
		public function destroy():void
		{
			_scene = null;
			_target = null;
			_bound = null;
		}
		
		/**
		 * 镜头跟随坐标点 
		 * @param X
		 * @param Y
		 * 
		 */		
		public function lookPos(X:Number, Y:Number, LockY:Boolean = false):void
		{
			m_lookL = X;
			m_lookR = m_SW - X;
			m_lookT = Y;
			m_lookB = m_SH - Y;
			if(LockY) _scene.lockY();
		}
		
		/**
		 * 设置镜头跟随目标 
		 * @param target
		 * 
		 */		
		public function lookAt(target:ICamera, force:Boolean = true):void
		{
			if(target){
				_target = target;
				_scene.setMapTarget(target);
				_lack = false;
				if(force) run();
			}else{
				_target = null;
				_scene.setMapTarget(null);
				_lack = true;
			}
		}
		
		public function run():void
		{
			if(_lack) return;
			moveScene(_target.ix, _target.iz);
			moveMap(_target.ix, _target.iz);
		}
		
		private function moveScene(X:Number, Y:Number):void
		{
			m_posX = X * _zoom;
			m_posY = Y * _zoom;
			if (m_posX - _bound.left * _zoom < m_lookL){
				m_posX = _bound.left * _zoom + m_lookL;
			}else if (_bound.right * _zoom - m_posX < m_lookR){
				m_posX = _bound.right * _zoom - m_lookR;
			}
			
			if (m_posY - _bound.top * _zoom < m_lookT){
				m_posY = _bound.top * _zoom + m_lookT;
			}else if (_bound.bottom * _zoom - m_posY <  m_lookB){
				m_posY = _bound.bottom * _zoom - m_lookB;
			}
			
			_scene.moveTo(m_lookL - m_posX, m_lookT - m_posY, _zoom);
		}
		
		private function moveMap(X:Number, Y:Number):void
		{
			if (X - _bound.left < m_lookL){
				X = _bound.left + m_lookL;
			}else if (_bound.right - X < m_lookR){
				X = _bound.right - m_lookR;
			}
			
			if (Y - _bound.top < m_lookT){
				Y = _bound.top + m_lookT;
			}else if (_bound.bottom - Y < m_lookB){
				Y = _bound.bottom - m_lookB;
			}
			
			_scene.moveMap(m_lookL - X, m_lookT - Y, _zoom);
		}

		/**
		 * 是否锁定镜头
		 */
		public function get lack():Boolean
		{
			return _lack;
		}

		/**
		 * @private
		 */
		public function set lack(value:Boolean):void
		{
			_lack = value;
		}

		public function get zoom():Number
		{
			return _zoom;
		}

		public function set zoom(value:Number):void
		{
			_zoom = value;
		}
	}
}