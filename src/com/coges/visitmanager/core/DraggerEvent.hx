package com.coges.visitmanager.core;

import com.coges.visitmanager.core.IDraggerItem;
import openfl.events.Event;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class DraggerEvent extends Event
{
    public var draggerItem(get, never):IDraggerItem;

    public static final DRAG:String = "dragevent_drag";
    public static final MOVE:String = "dragevent_move";
    public static final DROP:String = "dragevent_drop";
    
    
    private var _draggerItem:IDraggerItem;
    private function get_draggerItem():IDraggerItem
    {
        return _draggerItem;
    }
    
    
    public function new(type:String, draggerItem:IDraggerItem, bubbles:Bool = false, cancelable:Bool = false)
    {
        super(type, bubbles, cancelable);
        _draggerItem = draggerItem;
    }
    
    override public function clone():Event
    {
        return new DraggerEvent(type, _draggerItem, bubbles, cancelable);
    }
    
    override public function toString():String
    {
        return formatToString("DraggerEvent", "type", "bubbles", "cancelable", "eventPhase");
    }
}

