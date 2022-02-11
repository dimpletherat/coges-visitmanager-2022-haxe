package com.coges.visitmanager.vo;


/**
	 * ...
	 * @author Nicolas Bigot
	 */
class Period
{
    public var startABSOLUTE(get, never):Float;
    public var start(get, never):Float;
    public var endABSOLUTE(get, never):Float;
    public var end(get, never):Float;
    public var length(get, never):Float;
    public var startDate(get, never):Date;
    public var endDate(get, never):Date;

    private var SECONDE_TIME(default, never):Float = 1000;
    private var MINUTE_TIME(default, never):Float = 1000 * 60;
    private var HOUR_TIME(default, never):Float = 1000 * 60 * 60;
    
    
    private var _startABSOLUTE:Float;
    private function get_startABSOLUTE():Float
    {
        return _startABSOLUTE;
    }
    
    private var _start:Float;
    private function get_start():Float
    {
        return _start;
    }
    
    private var _endABSOLUTE:Float;
    private function get_endABSOLUTE():Float
    {
        return _endABSOLUTE;
    }
    
    private var _end:Float;
    private function get_end():Float
    {
        return _end;
    }
    
    private var _length:Float;
    private function get_length():Float
    {
        return _length;
    }
    
    private var _startDate:Date;
    private function get_startDate():Date
    {
        return _startDate;
    }
    
    private var _endDate:Date;
    private function get_endDate():Date
    {
        return _endDate;
    }
    
    
    public function new(startDate:Date, endDate:Date)
    {
        _endDate = endDate;
        _startDate = startDate;
        
        _startABSOLUTE = _startDate.getTime();
        _start = _startDate.getHours() * HOUR_TIME + _startDate.getMinutes() * MINUTE_TIME + _startDate.getSeconds() * SECONDE_TIME/* + _startDate.milliseconds*/;
		
        _endABSOLUTE = _endDate.getTime();  // + HOUR_TIME;  ;
        _end = _endDate.getHours() * HOUR_TIME + _endDate.getMinutes() * MINUTE_TIME + _endDate.getSeconds() * SECONDE_TIME/* +_endDate.milliseconds*/;
        
        
        _length = _endABSOLUTE - _startABSOLUTE;
    }
    
    public function toString():String
    {
        return "[Period] " + _startDate + ":" + _endDate;
    }
}

