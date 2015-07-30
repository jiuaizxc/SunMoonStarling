package com.sunmoon.game.map
{
	import com.sunmoon.game.map.Map;
	import com.sunmoon.game.map.MapVo;
	
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.textures.Texture;
	
	public class BackGround extends Map
	{
		private var _quadBatch:QuadBatch;
		private var _texture:Texture;
		private var _ground1:Image;
		private var _ground2:Image;
		
		private var m_width:Number;
		private var m_X:Number;
		private var m_Y:Number;
		
		public function BackGround(texture:Texture, vo:MapVo)
		{
			_texture = texture;
			super(vo);
		}
		
		override public function initData(...args):void{
			_quadBatch = new QuadBatch();
			m_width = _texture.width - 2;
			
			_ground1 = new Image(_texture);
			_ground1.x = -1;
			_ground2 = new Image(_texture);
			_ground2.x = m_width;
			_quadBatch.addImage(_ground1);
			_quadBatch.addImage(_ground2);
			addQuickChild(_quadBatch);
			
			x = _vo.offestX;
			y = _vo.offestY;
		}
		
		override public function destroy():void
		{
			dispose();
			_ground1= null;
			_ground2 = null;
			_texture = null;
			_quadBatch = null;
		}
		
		override public function moveMap(X:Number, Y:Number, Zoom:Number):void
		{
			super.moveMap(X, Y, Zoom);
			if(-X * _vo.scrollRateX > _quadBatch.x + m_width + 1) _quadBatch.x += m_width;
		}
	}
}