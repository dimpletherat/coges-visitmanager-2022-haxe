package com.coges.visitmanager.core;

//import com.coges.visitmanager.ui.components.ScrollItemResult;
import com.coges.visitmanager.ui.SearchResultDraggerItem;
import com.coges.visitmanager.vo.SearchResult;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.MouseEvent;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class SearchResultDragger extends EventDispatcher
{
    public static var instance(get, never):SearchResultDragger;
    public var draggerItem(get, never):SearchResultDraggerItem;

    private static var _instance:SearchResultDragger;
    private static function get_instance():SearchResultDragger
    {
        if (_instance == null)
        {
            _instance = new SearchResultDragger();
        }
        return _instance;
    }
    
    
    private var _item:SearchResultDraggerItem;
    private function get_draggerItem():SearchResultDraggerItem
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
    
    
    public function startDrag(targetResult:SearchResult, stage:Stage):Void
    {
        _stage = stage;
        
        _offsetX = 40;  //targetResultItem.mouseX;  ;
        _offsetY = 10;  //targetResultItem.mouseY;  ;
        
        _item = new SearchResultDraggerItem(targetResult);
        _item.x = _stage.mouseX - _offsetX;
        _item.y = _stage.mouseY - _offsetY;
        _stage.addChild(_item);
        _stage.addEventListener(MouseEvent.MOUSE_MOVE, _stageMouseMoveHandler);
        _stage.addEventListener(MouseEvent.MOUSE_UP, _stageMouseUpHandler);
        dispatchEvent(new DraggerEvent(DraggerEvent.DRAG, _item));
    }
	/*public function startDrag(targetResultItem:ScrollItemResult):Void
    {
        _stage = targetResultItem.stage;
        
        _offsetX = 40;  //targetResultItem.mouseX;  ;
        _offsetY = 10;  //targetResultItem.mouseY;  ;
        
        _item = new SearchResultDraggerItem(targetResultItem.getData());
        _item.x = _stage.mouseX - _offsetX;
        _item.y = _stage.mouseY - _offsetY;
        _stage.addChild(_item);
        _stage.addEventListener(MouseEvent.MOUSE_MOVE, _stageMouseMoveHandler);
        _stage.addEventListener(MouseEvent.MOUSE_UP, _stageMouseUpHandler);
        dispatchEvent(new DraggerEvent(DraggerEvent.DRAG, _item));
    }*/
    
    private function _stageMouseUpHandler(e:MouseEvent):Void
    {
        e.updateAfterEvent();
        _stage.removeEventListener(MouseEvent.MOUSE_MOVE, _stageMouseMoveHandler);
        _stage.removeEventListener(MouseEvent.MOUSE_UP, _stageMouseUpHandler);
        _stage.removeChild(_item);
        dispatchEvent(new DraggerEvent(DraggerEvent.DROP, _item));
        _item = null;
    }
    
    private function _stageMouseMoveHandler(e:MouseEvent):Void
    {
        e.updateAfterEvent();
        _item.x = _stage.mouseX - _offsetX;
        _item.y = _stage.mouseY - _offsetY;
        dispatchEvent(new DraggerEvent(DraggerEvent.MOVE, _item));
    }
}

