package com.coges.visitmanager.events;

import com.coges.visitmanager.vo.Visit;
import openfl.events.Event;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class VisitDetailEvent extends Event
{
    public var targetVisit(get, never):Visit;

    public static final CLOSE:String = "visit_detail_close";
    public static final SAVE:String = "visit_detail_save";
    public static final REMOVE:String = "visit_detail_remove";
    public static final CHANGE_STATUS:String = "visit_detail_change_status";
    public static final GET_DEMAND:String = "visit_detail_get_demand";
    
    private var _targetVisit:Visit;
    private function get_targetVisit():Visit
    {
        return _targetVisit;
    }
    
    public function new(type:String, targetVisit:Visit = null, bubbles:Bool = false, cancelable:Bool = false)
    {
        super(type, bubbles, cancelable);
        _targetVisit = targetVisit;
    }
    
    override public function clone():Event
    {
        return new VisitDetailEvent(type, _targetVisit, bubbles, cancelable);
    }
    
    override public function toString():String
    {
        return formatToString("VisitDetailEvent", "type", "bubbles", "cancelable", "eventPhase");
    }
}

