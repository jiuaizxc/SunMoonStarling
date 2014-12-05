package com.sunmoon.game.extension.display
{	
	import morn.core.utils.BitmapUtils;
	import morn.core.utils.StringUtils;
	
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.textures.Texture;
	
	/**
	 * 
	 * @author SunMoon
	 */	
	public class MyUint extends QuadBatch
	{
		private var _url:String;
		private var _num:int = -1;
		
		private var m_str:String;
		private var m_len:int;
		private var _clips:Vector.<Texture>;
		private var m_image:Image;
		
		public function MyUint(url:String)
		{
			super();
			touchable = false;
			_url = url;
			_clips = BitmapUtils.getClips(StringUtils.assetsName(url), 10, 1);
			m_image = new Image(_clips[0]);
			num = 0;
		}
		
		public function destroy():void
		{
			dispose();
			_url = null;
			_clips.length = 0;
			m_image = null;
		}

		/**
		 * 当前值 
		 * @return 
		 * 
		 */		
		public function get num():int
		{
			return _num;
		}

		/**
		 * 
		 * @private
		 * 
		 */		
		public function set num(value:int):void
		{
			if(_num != value){
				_num = value;
				m_str = String(value);
				m_len = m_str.length;
				reset();
				var i:int = 0;
				while(i < m_len){				
					m_image.texture = _clips[int(m_str.charAt(i))];
					m_image.x = i * m_image.width;
					addImage(m_image);
					i ++;
				}
			}
		}
	}
}