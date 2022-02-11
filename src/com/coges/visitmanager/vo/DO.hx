package com.coges.visitmanager.vo;

import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.datas.DataUpdater;
import com.coges.visitmanager.datas.DataUpdaterEvent;
import nbigot.utils.Collection;

/**
	 * ...
	 * @author Nicolas Bigot
	 */

	 
	 
	 
	 
typedef DOJSON = 
{
    var guest:String;
    var id:Int;
    var label:String;
    var idCountry:Int;
    var idStatus:String;
    var notes:String;
    var isRepresented:Bool;
    var guestRepresentative:String;    
}

@:keep
class DO
{
    public var id(get, never):Int;
    public var label(get, never):String;
    public var labelWithGuest(get, never):String;
    public var labelRepresented(get, never):String;
    public var labelFullForButton(get, never):String;
    public var guest(get, never):String;
    public var idCountry(get, never):Int;
    public var country(get, never):Country;
    public var idStatus(get, set):String;
    public var notes(get, set):String;
    public var isRepresented(get, never):Bool;
    public var guestRepresentative(get, never):String;
    public static var list(get, never):Collection<DO>;
    public static var selected(get, set):DO;

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
	/*
    private function get_labelFull():String
    {
        var out:String = _label;
        if (_guest.length > 0)
        {
            out += " (" + _guest + ")";
        }
        if (_isRepresented)
        {
            out += "<br>" + Locale.get("LBL_DO_REPRESENTED_HTML");
            out = StringTools.replace(out, "{guestRepresentative}", _guestRepresentative);
            out = StringTools.replace(out, "{guest}", _guest);
        }
        return out;
    }
	*/
    private function get_labelWithGuest():String
    {
        var out:String = _label;
        if (_guest.length > 0)
        {
            out += " (" + _guest + ")";
        }
        return out;
    }
    private function get_labelRepresented():String
    {
        var out:String = "";
        if (_isRepresented)
        {
            out += Locale.get("LBL_DO_REPRESENTED_HTML");
            out = StringTools.replace(out, "{guestRepresentative}", _guestRepresentative);
            out = StringTools.replace(out, "{guest}", _guest);
        }
        return out;
    }
    private function get_labelFullForButton():String
    {
        var out:String = _label;
        if (_guest.length > 0)
        {
            out += " (" + _guest + ")";
        }
        if (_isRepresented)
        {
            out += "\n" + Locale.get("LBL_DO_REPRESENTED");
            out = StringTools.replace(out, "{guestRepresentative}", _guestRepresentative);
            out = StringTools.replace(out, "{guest}", _guest);
        }
        return out;
    }
    
    private var _guest:String;
    private function get_guest():String
    {
        return _guest;
    }
    
    private var _idCountry:Int;
    private function get_idCountry():Int
    {
        return _idCountry;
    }
    
    private var _country:Country;
    private function get_country():Country
    {
        if (_country == null)
        {
            _country = Country.getCountryById(_idCountry);
        }
        return _country;
    }
    
    private var _idStatus:String;
    private function get_idStatus():String
    {
        return _idStatus;
    }
    
    
    private var _notes:String;
    private function set_notes(value:String):String
    {
        _notes = value;
        return value;
    }
    private function get_notes():String
    {
        return _notes;
    }
    
    private var _isRepresented:Bool;
    private function get_isRepresented():Bool
    {
        return _isRepresented;
    }
    
    private var _guestRepresentative:String;
    private function get_guestRepresentative():String
    {
        return _guestRepresentative;
    }
    
    private function set_idStatus(value:String):String
    {
        _idStatus = value;
        return value;
    }
    
    public function new(json:DOJSON)
    {
        _idCountry = json.idCountry;
        _label = json.label;
        _id = json.id;
        _guest = json.guest;
        _idStatus = json.idStatus;
        _notes = json.notes;
        _isRepresented = json.isRepresented;
        _guestRepresentative = json.guestRepresentative;
    }
    
    private static var _list:Collection<DO>;
    private static function get_list():Collection<DO>
    {
        if (_list == null)
        {
            _list = new Collection<DO>();
        }
        return _list;
    }
    public static function getDOByID(id:Int):DO
    {
        return _list.getItemBy("id", id);
    }
    
    private static var _selected:DO;
    private static function set_selected(value:DO):DO
    {
        _selected = value;
        if (_selected != null)
        {			
			DataUpdater.instance.dispatchEvent(new DataUpdaterEvent(DataUpdaterEvent.DO_SELECTED_CHANGE));
        }
        return value;
    }
    private static function get_selected():DO
    {
        return _selected;
    }
    
    /*
    private static var _eventDispatcher:EventDispatcher = new EventDispatcher();
    public static function addEventListener(type:String, listener:Function, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = true):Void
    {
        _eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }
    public static function removeEventListener(type:String, listener:Function, useCapture:Bool = false):Void
    {
        _eventDispatcher.removeEventListener(type, listener, useCapture);
    }*/
	
	public function toString():String
	{
		return '[DO]:$id,$label,$country';
	}
}

