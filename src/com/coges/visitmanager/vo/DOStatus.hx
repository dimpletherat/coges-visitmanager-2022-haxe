package com.coges.visitmanager.vo;

import com.coges.visitmanager.core.Icons;
import nbigot.utils.Collection;
import com.coges.visitmanager.core.Locale;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class DOStatus
{
    public var id(get, never):String;
    public var label(get, never):String;
    public var icon(get, never):DisplayObject;
    public static var list(get, never):Collection<DOStatus>;

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
    
    private var _idIcon:Icon;
    
    private function get_icon():DisplayObject
    {
        return Icons.getIcon(_idIcon);//32*26
    }
    
    private function new(id:String, label:String, idIcon:Icon)
    {
        _id = id;
        _label = label;
        _idIcon = idIcon;
    }
    
    
    private static var _list:Collection<DOStatus>;
    private static function get_list():Collection<DOStatus>
    {
        if (_list == null)
        {
            _list = new Collection<DOStatus>();
            _list.addItem(new DOStatus(DOStatusID.INTENDED, Locale.get("DO_STATUS_INTENDED"), Icon.DO_STATUS_INTENDED));
            _list.addItem(new DOStatus(DOStatusID.CONFIRMED, Locale.get("DO_STATUS_CONFIRMED"), Icon.DO_STATUS_CONFIRMED));
            _list.addItem(new DOStatus(DOStatusID.FULLY_CONFIRMED, Locale.get("DO_STATUS_FULLY_CONFIRMED"), Icon.DO_STATUS_FULLY_CONFIRMED));
            _list.addItem(new DOStatus(DOStatusID.CANCELED, Locale.get("DO_STATUS_CANCELED"), Icon.DO_STATUS_CANCELED));
        }
        return _list;
    }
    public static function getDOStatusByID(id:String):DOStatus
    {
        return _list.getItemBy("id", id);
    }
}

