package com.sunmoon.game.sound
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	import starling.utils.AssetManager;
	
	/**
	 * 
	 * @author SunMoon
	 * 声音播放管理类
	 */	
	public class GlobalSoundManager
	{
		public static var singleton:GlobalSoundManager = new GlobalSoundManager();
		
		private var _globalVolume:Number = 1;
		
		private var _isBackMute:Boolean;
		private var _isEffectMute:Boolean;
		
		private var _backGroundMusic:SoundChannel;
		
		private var _effectSoundChannel:SoundChannel;
		
		private var _effectContiuneList:Object;
		
		private var _sound:Object;
		
		public function GlobalSoundManager()
		{
			_effectContiuneList = new Object();
			_sound = new Object();
		}
		
		/**
		 * 添加声音 
		 * @param value
		 * 
		 */		
		public function onAddSound(Value:AssetManager):void
		{
			var names:Vector.<String> = Value.getSoundNames();
			for each(var key:String in names){
				if(_sound[key]) continue;
				_sound[key] = Value.getSound(key);
			}
		}
		
		/**
		 * 移除声音 
		 * @param Value
		 * 
		 */		
		public function onRemoveSound(Value:AssetManager):void
		{
			var names:Vector.<String> = Value.getSoundNames();
			for each(var key:String in names){
				if(_sound[key]){
					_sound[key] = null;
					delete _sound[key];
				}
			}
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
			var sound:Sound = _sound[resName];
			var souTran:SoundTransform;
			if(_isBackMute) souTran = new SoundTransform(0);
			else souTran = new SoundTransform(_globalVolume * volume);
			if(_backGroundMusic) _backGroundMusic.stop();
			_backGroundMusic = sound.play(0, int.MAX_VALUE, souTran);
		}
		
		/**
		 * 停止背景音乐 
		 * 
		 */		
		public function stopBackGroundMusic():void
		{
			if(_backGroundMusic) _backGroundMusic.stop();
			_backGroundMusic = null;
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
			var sound:Sound = _sound[resName];
			var souTran:SoundTransform;
			if(_isEffectMute) souTran = new SoundTransform(0);
			else souTran = new SoundTransform(_globalVolume * volume);
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
		public function playerEffectSoundOnce(resName:String, volume:Number = 1, startTime:int = 0):void
		{
			var sound:Sound = _sound[resName];
			var souTran:SoundTransform;
			if(_isEffectMute) return;
			else souTran = new SoundTransform(_globalVolume * volume);
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
		
		public function paused():void
		{
			SoundMixer.soundTransform = new SoundTransform(0);
		}
		
		public function resume():void
		{
			SoundMixer.soundTransform = new SoundTransform(1);
		}
		
		/**
		 * 静音背景音乐
		 * 
		 */		
		public function muteBackGround(Value:Boolean):void
		{
			if(Value){
				_isBackMute = false;
				weakBGMSound();
			}else{
				_isBackMute = true;
				sleepBGMSound();
			}
		}
		
		/**
		 * 静音音效声音 
		 * 
		 */		
		public function muteEffectGround(Value:Boolean):void
		{
			if(Value){
				_isEffectMute = false;
				weakEMSound();
			}else{
				_isEffectMute = true;
				sleepEMSound();
			}
		}
		
		/**
		 *全部静音 
		 * 
		 */		
		public function mute(Value:Boolean):void
		{
			muteBackGround(Value);
			muteEffectGround(Value);
		}
		
		private function sleepBGMSound():void
		{
			if(_backGroundMusic){
				var transform:SoundTransform = _backGroundMusic.soundTransform;
				transform.volume = 0;
				_backGroundMusic.soundTransform = transform;
			}
		}
		
		private function weakBGMSound():void
		{
			if(_backGroundMusic){
				var transform:SoundTransform = _backGroundMusic.soundTransform;
				transform.volume = _globalVolume;
				_backGroundMusic.soundTransform = transform;
			}
		}
		
		private function sleepEMSound():void
		{
			var transform:SoundTransform;
			for each(var soundChannel:SoundChannel in _effectContiuneList){
				transform = soundChannel.soundTransform;
				transform.volume = 0;
				soundChannel.soundTransform = transform;
			}
		}
		
		private function weakEMSound():void
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
		 * @return true为静音
		 * 
		 */		
		public function get isMute():Boolean
		{
			return _isBackMute && _isEffectMute;
		}
		
		/**
		 * 背景是否静音 
		 * @return true为静音
		 * 
		 */		
		public function get isBackMute():Boolean
		{
			return _isBackMute;
		}
		
		/**
		 * 音效是否静音 
		 * @return true为静音
		 * 
		 */		
		public function get isEffectMute():Boolean
		{
			return _isEffectMute;
		}
	}
}