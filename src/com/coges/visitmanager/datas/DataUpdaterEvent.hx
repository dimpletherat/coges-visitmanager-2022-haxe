package com.coges.visitmanager.datas;

import openfl.events.Event;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class DataUpdaterEvent extends Event
{
    public static final VISIT_LIST_CHANGE:String = "visit_list_change";
    public static final DO_SELECTED_CHANGE:String = "do_selected_change";
    public static final PLANNING_SELECTED_CHANGE:String = "planning_selected_change";
    public static final DO_AVAILABLE_PERIOD_LIST_CHANGE:String = "do_available_period_list_change";
    public static final DO_AVAILABLE_PERIOD_EDIT_START:String = "do_available_period_edit_start";
    public static final DO_AVAILABLE_PERIOD_EDIT_COMPLETE:String = "do_available_period_edit_complete";
    public static final OPPOSITE_OWNER_SELECTED_CHANGE:String = "opposite_owner_selected_change";
    
    public function new(type:String, bubbles:Bool = false, cancelable:Bool = false)
    {
        super(type, bubbles, cancelable);
    }
    
    override public function clone():Event
    {
        return new DataUpdaterEvent(type, bubbles, cancelable);
    }
    
    override public function toString():String
    {
        return formatToString("DataUpdaterEvent", "type", "bubbles", "cancelable", "eventPhase");
    }
}

