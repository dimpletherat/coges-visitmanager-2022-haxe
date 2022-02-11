package com.coges.visitmanager.core;

import com.coges.visitmanager.ui.VisitDraggerItem;
import com.coges.visitmanager.ui.VisitItem;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.MouseEvent;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class VisitDragger extends EventDispatcher
{
    public static var instance(get, never):VisitDragger;
    private static var _instance:VisitDragger;
    private static function get_instance():VisitDragger
    {
        if (_instance == null)
        {
            _instance = new VisitDragger();
        }
        return _instance;
    }
	
	
    public var origin(default, null):VisitDraggerOrigin;

    
    
    
    private var _item:VisitDraggerItem;
    public var draggerItem(get, never):VisitDraggerItem;
    private function get_draggerItem():VisitDraggerItem
    {
        return _item;
    }
    private var _stage:Stage;
    private var _offsetX:Float;
    private var _offsetY:Float;
    
    public function new()
    {
        super();
    }
    
    
    public function startDrag(targetItem:VisitItem, origin:VisitDraggerOrigin = VisitDraggerOrigin.CALENDAR):Void
    {
        _stage = targetItem.stage;
        
        this.origin = origin;
		
        _offsetX = targetItem.mouseX;
        _offsetY = targetItem.mouseY;
        
        _item = new VisitDraggerItem(targetItem, targetItem.width, targetItem.height);
        _item.x = _stage.mouseX - _offsetX;
        _item.y = _stage.mouseY - _offsetY;
        _stage.addChild(_item);
        _stage.addEventListener(MouseEvent.MOUSE_MOVE, _stageMouseMoveHandler);
        _stage.addEventListener(MouseEvent.MOUSE_UP, _stageMouseUpHandler);
        dispatchEvent(new DraggerEvent(DraggerEvent.DRAG, _item));
    }
    
    private function _stageMouseUpHandler(e:MouseEvent):Void
    {
        e.updateAfterEvent();
        _stage.removeEventListener(MouseEvent.MOUSE_MOVE, _stageMouseMoveHandler);
        _stage.removeEventListener(MouseEvent.MOUSE_UP, _stageMouseUpHandler);
        _stage.removeChild(_item);
        dispatchEvent(new DraggerEvent(DraggerEvent.DROP, _item));
    }
    
    private function _stageMouseMoveHandler(e:MouseEvent):Void
    {
		//e.updateAfterEvent();
        _item.x = _stage.mouseX - _offsetX;
        _item.y = _stage.mouseY - _offsetY;
        dispatchEvent(new DraggerEvent(DraggerEvent.MOVE, _item));
    }
}

