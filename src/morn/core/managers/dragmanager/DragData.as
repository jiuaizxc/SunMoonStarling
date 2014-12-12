package morn.core.managers.dragmanager
{
	/**
	 * Stores data associated with a drag and drop operation.
	 *
	 * @see DragDropManager
	 */
	public class DragData
	{
		private var _targetFormat:String;
		
		private var _data:Object;
		
		public function DragData(Format:String)
		{
			_targetFormat = Format;
			_data = {};
		}
		
		public function destroy():void
		{
			_data = null;
			_targetFormat = null;
		}

		public function get targetFormat():String
		{
			return _targetFormat;
		}

		public function get data():Object
		{
			return _data;
		}

	}
}
