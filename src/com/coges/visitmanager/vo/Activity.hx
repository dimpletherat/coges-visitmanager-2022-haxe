package com.coges.visitmanager.vo;

import nbigot.utils.Collection;

/**
	 * ...
	 * @author Nicolas Bigot
	 */

	 
	 
typedef ActivityJSON = {	
	
    var num:Int;
    var labelInt:String;
    var labelExt:String;
}
	 
	 
class Activity
{
    public var num(get, never):Int;
    private var _num:Int;
    private function get_num():Int
    {
        return _num;
    }
	
    public var labelInt(get, never):String;
    private var _labelInt:String;
    private function get_labelInt():String
    {
        return ((_labelInt != null)) ? _labelInt:"";
    }
	
    public var labelExt(get, never):String;
    private var _labelExt:String;
    private function get_labelExt():String
    {
        return ((_labelExt != null)) ? _labelExt:"";
    }
    
    
    public function new(json:ActivityJSON)
    {
        _num = json.num;
        _labelInt = json.labelInt;
        _labelExt = json.labelExt;
    }
    
	
	
	
    private static var _list:Collection<Activity>;
    public static var list(get, never):Collection<Activity>;
    private static function get_list():Collection<Activity>
    {
        if (_list == null)
        {
            _list = new Collection();
        }
        return _list;
    }    
    public static function getActivityListByType(type:ActivityType):Collection<Activity>
    {  
        var field:String;
        switch (type)
        {
            case ActivityType.EXT:
                field = "labelExt";
            default:
                field = "labelInt";
        }
		// TODO: verify if the filter works as intended  
		// especially with the use of Reflect.field vs Reflect.getProperty
		var result:Collection<Activity> = list.filter( field, "", true, FilterOperator.NOT_EQUAL);
        return result;		
		
		
		/*
        var result:Collection<Activity> = list.clone();
        
        var field:String;
        switch (type)
        {
            case ActivityType.EXT:
                field = "labelExt";
            default:
                field = "labelInt";
        }
        var i:Int = result.length;
        while (--i >= 0)
        {
            if (Reflect.field(result.getItemAt(i),field) == "")
            {
                result.removeItemAt(i);
            }
        }
        return result;*/
    }
    
    
    public function toString():String
    {
        return "[Object Activity] _num:" + _num + " - _labelInt:" + _labelInt + " - _labelExt:" + _labelExt;
    }
}

