package com.coges.visitmanager.events;

import openfl.events.Event;

/**
	 * ...
	 * @author ...
	 */
class VMEvent extends Event
{
    public static final OPEN_INFOS:String = "vm_event_open_infos";
    public static final CLOSE_INFOS:String = "vm_event_close_infos";
    public static final OPEN_SEARCH:String = "vm_event_open_search";
    public static final CLOSE_SEARCH:String = "vm_event_close_search";
    public static final OPEN_PENDING:String = "vm_event_open_pending";
    public static final CLOSE_PENDING:String = "vm_event_close_pending";
    public static final START_WAITING:String = "vm_event_start_waiting";
    public static final STOP_WAITING:String = "vm_event_stop_waiting";
    public static final START_EDIT_DO_AVAILABLE_PERIOD:String = "vm_event_start_edit_do_available_period";
    public static final STOP_EDIT_DO_AVAILABLE_PERIOD:String = "vm_event_stop_edit_do_available_period";
    
    public function new(type:String, bubbles:Bool = false, cancelable:Bool = false)
    {
        super(type, bubbles, cancelable);
    }
    
    override public function clone():Event
    {
        return new VMEvent(type, bubbles, cancelable);
    }
    
    override public function toString():String
    {
        return formatToString("VMEvent", "type", "bubbles", "cancelable", "eventPhase");
    }
}

