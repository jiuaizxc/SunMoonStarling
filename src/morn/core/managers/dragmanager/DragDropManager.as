package morn.core.managers.dragmanager
{
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	
	import morn.core.events.DragDropEvent;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class DragDropManager
	{
		private const HELPER_POINT:Point = new Point();
		private var _touchPointID:int = -1;
		
		private var _dragSource:DisplayObject;
		private var _dragImage:DisplayObject;
		private var _dropTarget:IDropTarget;
		private var _dragData:DragData;

		private var _isAccepted:Boolean = false;
		private var _isDragging:Boolean = false;
		private var _isHit:Boolean;

		private var avatarOffsetX:Number;
		private var avatarOffsetY:Number;
		private var dropTargetLocalX:Number;
		private var dropTargetLocalY:Number;
		private var avatarOldTouchable:Boolean;
		
		public function startDrag(source:DisplayObject, touch:Touch, dragAvatarOffsetX:Number = 0, dragAvatarOffsetY:Number = 0, isHit:Boolean = false, dragImage:DisplayObject = null, data:DragData = null):void
		{
			if(isDragging) cancelDrag();
			
			if(source == null) throw new ArgumentError("Drag source cannot be null.");
			
			_isDragging = true;
			_dragSource = source;
			_dragData = data;
			_touchPointID = touch.id;
			_dragImage = dragImage ? dragImage : _dragSource ;
			avatarOffsetX = dragAvatarOffsetX;
			avatarOffsetY = dragAvatarOffsetY;
			_isHit = isHit;
			
			touch.getLocation(Starling.current.stage, HELPER_POINT);
			avatarOldTouchable = dragImage.touchable;
			dragImage.touchable = false;
			
			if(_dragImage != _dragSource){
				dragImage.x = HELPER_POINT.x - avatarOffsetX;
				dragImage.y = HELPER_POINT.y - avatarOffsetY;
				App.stage.addChild(_dragImage);
			}
			
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
			_dragSource.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_START, data, false));

			if(_isHit) updateDropTarget(HELPER_POINT);
		}

		/**
		 * Tells the drag and drop manager if the target will accept the current
		 * drop. Meant to be called in a listener for the target's
		 * <code>DragDropEvent.DRAG_ENTER</code> event.
		 */
		public function acceptDrag(target:IDropTarget):void
		{
			if(_dropTarget != target)
			{
				throw new ArgumentError("Drop target cannot accept a drag at this time. Acceptance may only happen after the DragDropEvent.DRAG_ENTER event is dispatched and before the DragDropEvent.DRAG_EXIT event is dispatched.");
			}
			_isAccepted = true;
		}

		/**
		 * Immediately cancels the current drag.
		 */
		public function cancelDrag():void
		{
			if(!isDragging) return;
			completeDrag(false);
		}

		/**
		 * @private
		 */
		protected function completeDrag(isDropped:Boolean):void
		{
			if(!isDragging) throw new IllegalOperationError("Drag cannot be completed because none is currently active.");
			
			if(_dropTarget)
			{
				_dropTarget.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_EXIT, _dragData, false, dropTargetLocalX, dropTargetLocalY));
				_dropTarget = null;
			}
			var source:DisplayObject = _dragSource;
			var data:DragData = _dragData;
			cleanup();
			source.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_COMPLETE, data, isDropped));
		}

		/**
		 * @private
		 */
		protected function cleanup():void
		{
			if(_dragImage)
			{
				//may have been removed from parent already in the drop listener
				if(_dragImage != dragSource){
					if(App.stage.contains(_dragImage)){
						App.stage.removeChild(_dragImage);
					}
				}
				
				_dragImage.touchable = avatarOldTouchable;
				_dragImage = null;
			}
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
			_dragSource = null;
			_dragData = null;
			_isDragging = false;
		}

		/**
		 * @private
		 */
		protected function updateDropTarget(location:Point):void
		{
			var target:DisplayObject = Starling.current.stage.hitTest(location, true);
			while(target && !(target is IDropTarget))
			{
				target = target.parent;
			}
			
			if(target) target.globalToLocal(location, location);
			
			if(target != _dropTarget)
			{
				if(_dropTarget)
				{
					//notice that we can reuse the previously saved location
					_dropTarget.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_EXIT, _dragData, false, dropTargetLocalX, dropTargetLocalY));
				}
				_dropTarget = IDropTarget(target);
				_isAccepted = false;
				if(_dropTarget)
				{
					dropTargetLocalX = location.x;
					dropTargetLocalY = location.y;
					_dropTarget.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_ENTER, _dragData, false, dropTargetLocalX, dropTargetLocalY));
					
				}
			}
			else if(_dropTarget)
			{
				dropTargetLocalX = location.x;
				dropTargetLocalY = location.y;
				_dropTarget.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_MOVE, _dragData, false, dropTargetLocalX, dropTargetLocalY));
			}
		}

		/**
		 * @private
		 */
		protected function stage_touchHandler(event:TouchEvent):void
		{
			var stage:Stage = Starling.current.stage;
			var touch:Touch = event.getTouch(stage, null, _touchPointID);
			if(touch == null) return;
			
			if(touch.phase == TouchPhase.MOVED)
			{
				touch.getLocation(stage, HELPER_POINT);
				if(HELPER_POINT.x <= 0 || HELPER_POINT.x >= App.stage.stageWidth || HELPER_POINT.y <= 0 || HELPER_POINT.y >= App.stage.stageHeight){
					return;
				}else{
					_dragImage.x = HELPER_POINT.x - avatarOffsetX;
					_dragImage.y = HELPER_POINT.y - avatarOffsetY;
				}
				
				if(_isHit) updateDropTarget(HELPER_POINT);
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				_touchPointID = -1;
				var isDropped:Boolean = false;
				if(_dropTarget && _isAccepted)
				{
					_dropTarget.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_DROP, _dragData, true, dropTargetLocalX, dropTargetLocalY));
					isDropped = true;
				}
				_dropTarget = null;
				completeDrag(isDropped);
			}
		}
		
		public function get touchPointID():int
		{
			return _touchPointID;
		}
		
		public function get dragSource():DisplayObject
		{
			return _dragSource;
		}
		
		public function get isDragging():Boolean
		{
			return _isDragging;
		}
		
		public function get dragData():DragData
		{
			return _dragData;
		}
	}
}
