package com.coges.visitmanager.events;

import com.coges.visitmanager.vo.Visit;
import openfl.events.Event;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class VisitSaveEvent extends Event
{
    public var message(get, never):String;

    public static final ERROR:String = "visit_save_error";
    public static final ASK_FOR_CONFIRM_EXHIBITOR_AVAILABILITY:String = "visit_save_ask_for_confirm_exh_availability";
    public static final ALERT_EXHIBITOR_NON_ELIGIBLE:String = "visit_save_alert_exh_non_eligible";
    public static final ASK_FOR_CONFIRM_SERIE:String = "visit_save_ask_for_confirm_serie";
    //public static const ASK_FOR_CONFIRM:String = "visit_save_ask_for_confirm";
    public static final COMPLETE:String = "visit_save_complete";
    public static final REMOVE:String = "visit_save_remove";
    
    private var _message:String;
    private function get_message():String
    {
        return _message;
    }
    /*private var _alertPopupType:*;		
		public function get alertPopupType():String { return _alertPopupType; }*/
    
    public function new(type:String, message:String = null  /*, alertPopupType:* = null*/  ,  /*, alertPopupType:* = null*/   bubbles:Bool = false, cancelable:Bool = false)
    {
        super(type, bubbles, cancelable);
        _message = message;
    }
    
    
    override public function clone():Event
    {
        return new VisitSaveEvent(type, _message  /*, _alertPopupType*/  , bubbles, cancelable);
    }
    
    override public function toString():String
    {
        return formatToString("VisitSaveEvent", "type", "bubbles", "cancelable", "eventPhase");
    }
}

