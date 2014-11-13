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
		private var _isZoom:Boolean;
		
		private var _minZoom:Number;
		private var _zoomRate:Number;
		private var _maxSpeed:Number;
		
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
			
			_isZoom = false;
			_zoom = 1;
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
		public function lookPos(X:Number, Y:Number):void
		{
			m_lookL = X;
			m_lookR = m_SW - X;
			m_lookT = Y;
			m_lookB = m_SH - Y;
		}
		
		/**
		 * 开启镜头缩放 
		 * @param MaxSpeed 开始缩放的最大速度
		 * @param ZoomRate 镜头与速度的缩放比例
		 * @param MinZoom 最小缩放的值
		 * 
		 */		
		public function startZoom(MaxSpeed:Number = 10, ZoomRate:Number = 0.015, MinZoom:Number = 0.5):void
		{
			_isZoom = true;
			_maxSpeed = MaxSpeed;
			_zoomRate = ZoomRate;
			_minZoom = MinZoom;
		}
		
		/**
		 * 关闭镜头缩放 
		 * 
		 */		
		public function stopZoom():void
		{
			_isZoom = false;
			_zoom = 1;
		}
		
		/**
		 * 设置镜头跟随目标 
		 * @param target
		 * 
		 */		
		public function lookAt(target:ICamera):void
		{
			if(target){
				_target = target;
				_scene.setMapTarget(target);
				_lack = false;
				run();
			}else{
				_target = null;
				_scene.setMapTarget(null);
				_lack = true;
			}
		}
		
		public function run():void
		{
			if(_lack) return;
			if(_isZoom) calculateZoom();
			moveScene(_target.ix, _target.iz);
			moveMap(_target.ix, _target.iz);
		}
		
		private function calculateZoom():void
		{
			m_zoom = _target.Speed - _maxSpeed;
			m_zoom = m_zoom < 0 ? 0 :  m_zoom * _zoomRate;
			_zoom = m_zoom > _minZoom ? _minZoom : 1 - m_zoom;
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
	}
}