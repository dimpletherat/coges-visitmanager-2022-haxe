package com.coges.visitmanager.ui.components;

import openfl.events.Event;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class PagerEvent extends Event
{
    public var pageNum(get, never):Int;

    public static final GO_PAGE:String = "pager_go_page";
    
    
    private var _pageNum:Int;
    
    private function get_pageNum():Int
    {
        return _pageNum;
    }
    
    public function new(type:String, pageNum:Int, bubbles:Bool = false, cancelable:Bool = false)
    {
        super(type, bubbles, cancelable);
        _pageNum = pageNum;
    }
    
    override public function clone():Event
    {
        return new PagerEvent(type, _pageNum, bubbles, cancelable);
    }
    
    override public function toString():String
    {
        return formatToString("PagerEvent", "type", "bubbles", "cancelable", "eventPhase");
    }
}

