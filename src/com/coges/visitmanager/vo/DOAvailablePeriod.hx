package com.coges.visitmanager.vo;

import com.coges.visitmanager.datas.DataUpdater;
import com.coges.visitmanager.datas.DataUpdaterEvent;
import com.coges.visitmanager.vo.Period;
import haxe.Json;
import nbigot.utils.Collection;
import nbigot.utils.DateUtils;

/**
	 * ...
	 * @author Nicolas Bigot
	 */

	 
typedef DOAvailablePeriodJSON = {	
	var id:Int;
	var idDelegation:Int;
	var dayNum:Int;
	var startDateString:String;
	var endDateString:String;
}
	 
	 
	 
class DOAvailablePeriod
{
    public var id(get, never):Int;
    public var idDO(get, never):Int;
    public var dayNum(get, never):Int;
    public var startDate(get, set):Date;
    public var startDateString(get, never):String;
    public var endDate(get, set):Date;
    public var endDateString(get, never):String;
    public var period(get, never):Period;
    public static var list(get, never):Collection<DOAvailablePeriod>;

    private var _id:Int;
    private function get_id():Int
    {
        return _id;
    }
    
    private var _idDO:Int;
    private function get_idDO():Int
    {
        return _idDO;
    }
    
    private var _dayNum:Int;
    private function get_dayNum():Int
    {
        return _dayNum;
    }
    
    private var _startDate:Date;
    private function get_startDate():Date
    {
        return _startDate;
    }
    private function set_startDate(value:Date):Date
    {
        _startDate = value;
        _startDateString = DateUtils.toDBString(_startDate, true);
        //_startDateString = Utils.getDBStringFromDate(_startDate, true);
        if (_startDate != null && _endDate != null)
        {
            _period = new Period(_startDate, _endDate);
        }
        return value;
    }
    
    
    private var _startDateString:String;
    private function get_startDateString():String
    {
        return _startDateString;
    }
    
    private var _endDate:Date;
    private function get_endDate():Date
    {
        return _endDate;
    }
    private function set_endDate(value:Date):Date
    {
        _endDate = value;
        _endDateString = DateUtils.toDBString(_endDate, true);
       // _endDateString = Utils.getDBStringFromDate(_endDate, true);
        if (_startDate != null && _endDate != null)
        {
            _period = new Period(_startDate, _endDate);
        }
        return value;
    }
    
    private var _endDateString:String;
    private function get_endDateString():String
    {
        return _endDateString;
    }
    
    private var _period:Period;
    private function get_period():Period
    {
        return _period;
    }
    
    public function getJSONRepresentation():String
    {
        var start:String = ((_period.length > 0)) ? _startDateString:"0000-00-00 00:00:00";
        var end:String = ((_period.length > 0)) ? _endDateString:"0000-00-00 00:00:00";
        var json:DOAvailablePeriodJSON = { id:_id, idDelegation:_idDO, dayNum:_dayNum, startDateString:start, endDateString:end }
        
        return Json.stringify(json );
    }
    
    public function new(json:DOAvailablePeriodJSON)
    {
        //_endDateString = json.endDateString;
        //trace( "_endDateString:" + _endDateString );
        //_startDateString = json.startDateString;
        //trace( "_startDateString:" + _startDateString );
        _dayNum = json.dayNum;
        //trace( "_dayNum:" + _dayNum );
        _idDO = json.idDelegation;
        _id = json.id;
        
        _startDateString = json.startDateString;
        _startDate = DateUtils.fromDBString(_startDateString);
        //_startDate = Utils.getDateFromDBString(_startDateString);
        
        _endDateString = json.endDateString;
        _endDate = DateUtils.fromDBString(_endDateString);
        //_endDate = Utils.getDateFromDBString(_endDateString);
        
        if (_startDate != null && _endDate != null)
        {
            _period = new Period(_startDate, _endDate);
        }
    }
    
    
    
    private static var _list:Collection<DOAvailablePeriod>;
    public static function createList(list:Collection<DOAvailablePeriod>):Void
    {
        if (list != null)
        {
            _list = list;
			DataUpdater.instance.dispatchEvent(new DataUpdaterEvent(DataUpdaterEvent.DO_AVAILABLE_PERIOD_LIST_CHANGE));
        }
    }
    private static function get_list():Collection<DOAvailablePeriod>
    {
        if (_list == null)
        {
            _list = new Collection<DOAvailablePeriod>();
        }
        return _list;
    }
    
    public static function getDOAvailablePeriodByDay(day:Date, dayNum:Int):DOAvailablePeriod
    {     
        if (_list == null || _list.length == 0 )
        {
            return null;
        }
		
		//TODO: Should all of this be done when creating the list ???
        for  ( o in _list)
        {
			// if date is OK > return DOAvailablePeriod
            if (o.startDate.getDate() == day.getDate() && o.startDate.getMonth() == day.getMonth() && o.startDate.getFullYear() == day.getFullYear())
            {
                return o;
            }
			// if no date is matching, but the dayNum does > edit DOAvailablePeriod with the 'good' date
            else if (o.dayNum == dayNum)
            {
				o.startDate = new Date(day.getFullYear(), day.getMonth(), day.getDate(), o.startDate.getHours() , o.startDate.getMinutes()  , o.startDate.getSeconds() );
				o.endDate = new Date(day.getFullYear(), day.getMonth(), day.getDate(), o.endDate.getHours() , o.endDate.getMinutes()  , o.endDate.getSeconds() );
                return o;
            }
        }
		
		// if nothing matches > creation of a new DOAvailablePeriod with good date and dayNum, with a period of '0'
        var json:DOAvailablePeriodJSON = { id:0, idDelegation:_list.getItemAt(0).idDO, dayNum:dayNum, startDateString:DateUtils.toDBString(day, true), endDateString:DateUtils.toDBString(day, true) };		
        _list.addItem(new DOAvailablePeriod( json ));
		
        // recursive call will return the newly created DOAvailablePeriod
        return getDOAvailablePeriodByDay(day, dayNum);
    }
	
	/*
    public static function startEditDOAvailablePeriod():Void
    {
		DataUpdater.instance.dispatchEvent(new DataUpdaterEvent(DataUpdaterEvent.DO_AVAILABLE_PERIOD_EDIT_START));
    }
    public static function stopEditDOAvailablePeriod():Void
    {
		DataUpdater.instance.dispatchEvent(new DataUpdaterEvent(DataUpdaterEvent.DO_AVAILABLE_PERIOD_EDIT_COMPLETE));
    }*/
    /*
    private static var _eventDispatcher:EventDispatcher = new EventDispatcher();
    public static function addEventListener(type:String, listener:Function, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = true):Void
    {
        _eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }
    public static function removeEventListener(type:String, listener:Function, useCapture:Bool = false):Void
    {
        _eventDispatcher.removeEventListener(type, listener, useCapture);
    }
    */
    public function toString():String
    {
        var txt:String = "[DOAvailablePeriod]\n";
        txt += "* dayNum:" + _dayNum + "\n";
        txt += "* startDate:" + _startDate + "\n";
        txt += "* startDateString:" + _startDateString + "\n";
        txt += "* endDate:" + _endDate + "\n";
        txt += "* endDateString:" + _endDateString + "\n";
        
        return txt;
    }
}

