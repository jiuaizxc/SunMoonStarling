package com.sunmoon.game.sound
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	/**
	 * 
	 * @author SunMoon
	 * 声音播放管理类
	 */	
	public class GlobalSoundManager
	{
		public static var singleton:GlobalSoundManager = new GlobalSoundManager();
		
		private var _globalVolume:Number = 1;
		private var _isMute:Boolean;
		
		private var _isBackMute:Boolean;
		private var _isEffectMute:Boolean;
		
		private var _backGroundMusic:SoundChannel;
		
		private var _effectSoundChannel:SoundChannel;
		
		private var _effectContiuneList:Object;
		
		public function GlobalSoundManager()
		{
			_effectContiuneList = new Object();
		}
		
		/**
		 * 播放背景音乐 
		 * @param resName 声音名称
		 * @param volume 声音大小
		 * @param startTime 开始位置
		 * 
		 */		
		public function playBackGroundMusic(resName:String, volume:Number = 1, startTime:int = 0):void
		{
			var sound:Sound = App.asset.getSound(resName);
			var souTran:SoundTransform;
			if(_isMute){
				souTran = new SoundTransform(0);
			}else{
				souTran = new SoundTransform(_globalVolume * volume);
			}
			if(_backGroundMusic) _backGroundMusic.stop();
			_backGroundMusic = sound.play(0, int.MAX_VALUE, souTran);
		}
		
		/**
		 * 播放持续音效
		 * @param resName 声音名称
		 * @param volume 声音大小
		 * @param startTime 开始位置
		 * 
		 */		
		public function playerEffectSoundContinue(resName:String, volume:Number = 1, startTime:int = 0):void
		{
			var sound:Sound = App.asset.getSound(resName);
			var souTran:SoundTransform;
			if(_isMute || _isEffectMute){
				souTran = new SoundTransform(0);
			}else{
				souTran = new SoundTransform(_globalVolume * volume);
			}
			stopEffectSoundContinue(resName);
			var soundChannel:SoundChannel = sound.play(0, int.MAX_VALUE, souTran);
			_effectContiuneList[resName] = soundChannel;
		}
		
		/**
		 * 播放一次性音效
		 * @param resName 声音名称
		 * @param volume 声音大小
		 * @param startTime 开始位置
		 * 
		 */		
		public function playerEffectSound(resName:String, volume:Number = 1, startTime:int = 0):void
		{
			var sound:Sound = App.asset.getSound(resName);
			var souTran:SoundTransform;
			if(_isMute || _isEffectMute){
				return;
			}else{
				souTran = new SoundTransform(_globalVolume * volume);
			}
			sound.play(0, 0, souTran);
		}
		
		/**
		 * 停止持续音效 
		 * @param resName 声音名称
		 * 
		 */		
		public function stopEffectSoundContinue(resName:String):void
		{
			var soundChannel:SoundChannel = _effectContiuneList[resName];
			if(soundChannel){
				soundChannel.stop();
				delete _effectContiuneList[resName];
			}
		}
		
		/**
		 * 静音背景音乐
		 * 
		 */		
		public function muteBackGround():void
		{
			var transform:SoundTransform;
			if(_isBackMute){
				_isBackMute = false;
				if(_backGroundMusic){
					transform = _backGroundMusic.soundTransform;
					transform.volume = _globalVolume;
					_backGroundMusic.soundTransform = transform;
				}
			}else{
				_isBackMute = true;
				if(_backGroundMusic){
					transform = _backGroundMusic.soundTransform;
					transform.volume = 0;
					_backGroundMusic.soundTransform = transform;
				}
			}
		}
		
		/**
		 * 静音音效声音 
		 * 
		 */		
		public function muteEffectGround():void
		{
			var transform:SoundTransform;
			if(_isEffectMute){
				_isEffectMute = false;
				muteBEffectSound();
			}else{
				_isEffectMute = true;
				muteAEffectSound();
			}
		}
		
		/**
		 *全部静音 
		 * 
		 */		
		public function mute():void
		{
			var transform:SoundTransform;
			if(_isMute){
				_isMute = false;
				if(_backGroundMusic){
					transform = _backGroundMusic.soundTransform;
					transform.volume = _globalVolume;
					_backGroundMusic.soundTransform = transform;
				}
				muteBEffectSound();
			}else{
				_isMute = true;
				if(_backGroundMusic){
					transform = _backGroundMusic.soundTransform;
					transform.volume = 0;
					_backGroundMusic.soundTransform = transform;
				}
				muteAEffectSound();
			}
		}
		
		private function muteAEffectSound():void
		{
			var transform:SoundTransform;
			for each(var soundChannel:SoundChannel in _effectContiuneList){
				transform = soundChannel.soundTransform;
				transform.volume = 0;
				soundChannel.soundTransform = transform;
			}
		}
		
		private function muteBEffectSound():void
		{
			var transform:SoundTransform;
			for each(var soundChannel:SoundChannel in _effectContiuneList){
				transform = soundChannel.soundTransform;
				transform.volume = _globalVolume;
				soundChannel.soundTransform = transform;
			}
		}
		
		/**
		 * 全部静音 
		 * @return 
		 * 
		 */		
		public function get isMute():Boolean
		{
			return _isMute;
		}

		/**
		 * 背景是否静音 
		 * @return 
		 * 
		 */		
		public function get isBackMute():Boolean
		{
			return _isBackMute;
		}

		/**
		 * 音效是否静音 
		 * @return 
		 * 
		 */		
		public function get isEffectMute():Boolean
		{
			return _isEffectMute;
		}
	}
}