package com.sunmoon.game.utils
{
	import flash.net.getClassByAlias;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	/**
	 * 
	 * @author SunMoon
	 * 自定义工具类
	 */	
	public class MyUtils
	{
		private static var aliasList:Array = [];
		private static var min:int;
		
		public function MyUtils()
		{
		}
		
		/**
		 *二进制转化为字符串 
		 * @param byteArr
		 * @return 
		 * 
		 */		
		public static function createStr(byteArr:ByteArray):String
		{
			return byteArr.readUTFBytes(byteArr.bytesAvailable);
		}
		
		/**
		 *时间换算 
		 * @param time
		 * @return 
		 * 
		 */		
		public static function getClock(time:int):String
		{
			min=time/60;
			time-=min*60;
			min+=100;
			time+=100
			return min.toString().slice(1)+":"+time.toString().slice(1);
		}
		
		/**
		 *克隆VO类 
		 * @param sourceObj
		 * @param deep
		 * @return 
		 * 
		 */		
		public static  function deepClone(sourceObj:*):*
		{  
			if(!sourceObj) return null;
			
			// 得到  sourceObj的类名
			var qualifiedClassName:String = getQualifiedClassName(sourceObj);
			if(aliasList.indexOf(qualifiedClassName) == -1)
			{
				// e.g  com.gdlib.test::RegisterClassAliasTest
				var packageName:String = qualifiedClassName.replace("::", ".");
				// 得到 sourceObj的类的类定义
				var classType:Class = getDefinitionByName(qualifiedClassName) as Class;
				// 注册此别名和类
				if(classType)
				{
					registerClassAlias(packageName, classType);
					aliasList.push(qualifiedClassName);
				}
				
				// 注册类公共属性(如果是复合类)
				registerVariables(sourceObj);
			}
			
			// 复制此对象
			var b:ByteArray = new ByteArray();
			b.writeObject(sourceObj);
			b.position = 0;
			
			return b.readObject();
		}
		
		/**
		 * 注册某个类的公共属性(如果是复合类)所属的类的别名.
		 * @param sourceObj
		 */
		private static function registerVariables(sourceObj:*):void
		{
			// 注册类公共属性(如果是复合类)
			var xml:XML = describeType(sourceObj);
			var variable:XML;
			var variableType:String;
			var variablePackageName:String;
			var variableClassType:Class;
			
			var variableXml:XMLList;
			if(sourceObj is Class) variableXml = xml.factory.variable;
			else variableXml = xml.variable;
			
			for each (variable in variableXml) 
			{
				variableType = variable.@type;
				if(variableType.indexOf("::") != -1)
				{
					if(aliasList.indexOf(variableType) == -1)
					{
						// "flash.geom::Point"	转换为 	"flash.geom.Point"
						variablePackageName = variableType.replace("::", ".");
						variableClassType = getDefinitionByName(variableType) as Class;
						// 注册此别名和类
						if(variableClassType)
						{
							registerClassAlias(variablePackageName, variableClassType);
							registerVariables(variableClassType);
							aliasList.push(variableType);
						}
					}
				}
			}
		}
	}
}