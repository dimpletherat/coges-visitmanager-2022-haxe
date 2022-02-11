package com.coges.visitmanager.datas;

import haxe.Constraints.Function;
import openfl.events.Event;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ServiceEvent extends Event
{
    public var result(get, never):Dynamic;
    public var currentCall(get, never):Function;

    public static final COMPLETE:String = "service_complete";
    public static final ERROR:String = "service_error";
    public static final START:String = "service_start";
    
    
    private var _result:Dynamic;
    private function get_result():Dynamic
    {
        return _result;
    }
    
    private var _currentCall:Function;
    private function get_currentCall():Function
    {
        return _currentCall;
    }
    
    public function new(type:String, result:Dynamic, currentCall:Function = null, bubbles:Bool = false, cancelable:Bool = false)
    {
        super(type, bubbles, cancelable);
        _result = result;
        _currentCall = currentCall;
    }
    
    override public function clone():Event
    {
        return new ServiceEvent(type, _result, _currentCall, bubbles, cancelable);
    }
    
    override public function toString():String
    {
        return formatToString("ServiceEvent", "type", "bubbles", "cancelable", "eventPhase");
    }
}

