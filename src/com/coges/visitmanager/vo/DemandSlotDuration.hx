package com.coges.visitmanager.vo;

import nbigot.utils.Collection;
import com.coges.visitmanager.core.Locale;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class DemandSlotDuration
{
    public var id(get, never):String;
    public var label(get, never):String;
    public static var list(get, never):Collection<DemandSlotDuration>;

    private var _id:String;
    private function get_id():String
    {
        return _id;
    }
    
    private var _label:String;
    private function get_label():String
    {
        return _label;
    }
    
    public function new(id:String, label:String)
    {
        _id = id;
        _label = label;
    }
    
    private static var _list:Collection<DemandSlotDuration>;
    private static function get_list():Collection<DemandSlotDuration>
    {
        if (_list == null)
        {
            _list = new Collection<DemandSlotDuration>();
            _list.addItem(new DemandSlotDuration("journee", Locale.get("DURATION_ALL_DAY")));
            _list.addItem(new DemandSlotDuration("apmidi", Locale.get("DURATION_AFTERNOON")));
            _list.addItem(new DemandSlotDuration("matin", Locale.get("DURATION_MORNING")));
        }
        return _list;
    }
    
    public static function getDemandSlotDurationByID(id:String):DemandSlotDuration
    {
        return list.getItemBy("id", id);
    }
}

