package com.sunmoon.game.extension.display
{
	import com.sunmoon.game.schedule.ScheduleTimer;
	
	import flash.desktop.NativeApplication;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.core.Starling;

	public class ExitPanel
	{
		private var _textField:TextField;
		
		private var _isExit:Boolean;
		
		public function ExitPanel()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_textField = new TextField();
			_textField.width = 300;
			_textField.height = 100;
			_textField.background = true;
			_textField.backgroundColor = 0x000000;
			_textField.wordWrap = true;
			_textField.multiline = true;
			var textFormat:TextFormat = new TextFormat("Arial", "36", 0xffffff);
			textFormat.align = TextFormatAlign.CENTER;
			_textField.defaultTextFormat = textFormat;
			_textField.text = "Double-click back to exit the game";
		}
		
		public function close():void
		{
			if(_isExit){
				NativeApplication.nativeApplication.exit();
			}else{
				_isExit = true;
				SunMoon.singleton.schedule.addSchedule(new ScheduleTimer(onExit, this, 3000, false, 1500, 0, 1));
				var stage:Stage = Starling.current.nativeStage;
				_textField.scaleX = _textField.scaleY = stage.fullScreenWidth/1280;
				_textField.x = (stage.fullScreenWidth - _textField.width) * 0.5
				_textField.y = (stage.fullScreenHeight - _textField.height) * 0.5;
				stage.addChild(_textField);
			}
		}
		
		private function onExit():void
		{
			_isExit = false;
			if(_textField.parent) _textField.parent.removeChild(_textField);
		}
	}
}