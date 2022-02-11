package com.coges.visitmanager.vo;

import nbigot.utils.Collection;
import com.coges.visitmanager.core.Locale;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class DemandSlotDay
{
    public var id(get, never):Int;
    public var label(get, never):String;
    public static var list(get, never):Collection<DemandSlotDay>;

    private var _id:Int;
    private function get_id():Int
    {
        return _id;
    }
    
    private var _label:String;
    private function get_label():String
    {
        return _label;
    }
    
    public function new(id:Int, label:String)
    {
        _id = id;
        _label = label;
    }
    
    private static var _list:Collection<DemandSlotDay>;
    private static function get_list():Collection<DemandSlotDay>
    {
        if (_list == null)
        {
            _list = new Collection<DemandSlotDay>();
            _list.addItem(new DemandSlotDay(1, Locale.get("DAY_MONDAY")));
            _list.addItem(new DemandSlotDay(2, Locale.get("DAY_TUESDAY")));
            _list.addItem(new DemandSlotDay(3, Locale.get("DAY_WEDNESDAY")));
            _list.addItem(new DemandSlotDay(4, Locale.get("DAY_THURSDAY")));
            _list.addItem(new DemandSlotDay(5, Locale.get("DAY_FRIDAY")));
            _list.addItem(new DemandSlotDay(6, Locale.get("DAY_SATURDAY")));
            _list.addItem(new DemandSlotDay(7, Locale.get("DAY_SUNDAY")));
        }
        return _list;
    }
    
    public static function getDemandSlotDayByID(id:Int):DemandSlotDay
    {
        return list.getItemBy("id", id);
    }
}

