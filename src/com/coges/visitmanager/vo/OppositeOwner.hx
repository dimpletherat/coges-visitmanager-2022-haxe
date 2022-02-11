package com.coges.visitmanager.vo;

import com.coges.visitmanager.datas.DataUpdater;
import com.coges.visitmanager.datas.DataUpdaterEvent;
import haxe.Json;
import nbigot.utils.Collection;

/**
	 * ...
	 * @author Nicolas Bigot
	 */

	 
typedef OppositeOwnerJSON = {
	 
	public var id:Int;
    public var firstName:String;
    public var lastName:String;
    public var phone:String;
    public var email:String;
    public var oaList:Array<String>;
}
	 
class OppositeOwner
{
    public var id(get, never):Int;
    private var _id:Int;
    private function get_id():Int
    {
        return _id;
    }

    
    public var firstName(get, never):String;
    private var _firstName:String;
    private function get_firstName():String
    {
        return _firstName;
    }
    
    public var lastName(get, never):String;
    private var _lastName:String;
    private function get_lastName():String
    {
        return _lastName;
    }
    
    public var phone(get, never):String;
    private var _phone:String;
    private function get_phone():String
    {
        return _phone;
    }
    
    public var email(get, never):String;
    private var _email:String;
    private function get_email():String
    {
        return _email;
    }
    
    public var oaList(get, never):Array<String>;
    private var _oaList:Array<String>;
    private function get_oaList():Array<String>
    {
        return _oaList;
    }
    /*
    public function getJSONRepresentation():String
    {
        var json:OppositeOwnerJSON = {
			id:_id, 
			firstName:_firstName, 
			lastName:_lastName, 
			email:_email, 
			phone:_phone, 
			oaList:_oaList		
		};
        return Json.stringify( json );
    }*/
    
    public function getJSONRepresentation():OppositeOwnerJSON
    {
        var json:OppositeOwnerJSON = {
			id:_id, 
			firstName:_firstName, 
			lastName:_lastName, 
			email:_email, 
			phone:_phone, 
			oaList:_oaList		
		};
        return json;
    }
    
    public function new(json:OppositeOwnerJSON)
    {
        _email = json.email;
        _phone = json.phone;
        _lastName = json.lastName;
        _firstName = json.firstName;
        _id = json.id;
        _oaList = json.oaList;
    }
    
    public static var list(get, never):Collection<OppositeOwner>;
    private static var _list:Collection<OppositeOwner>;
    private static function get_list():Collection<OppositeOwner>
    {
        if (_list == null)
        {
            _list = new Collection<OppositeOwner>();
        }
        return _list;
    }
    
    
    public static var selected(get, set):OppositeOwner;
    private static var _selected:OppositeOwner;
    private static function set_selected(value:OppositeOwner):OppositeOwner
    {
        _selected = value;
        DataUpdater.instance.dispatchEvent(new DataUpdaterEvent(DataUpdaterEvent.OPPOSITE_OWNER_SELECTED_CHANGE));
        return value;
    }
    private static function get_selected():OppositeOwner
    {
        return _selected;
    }
    
}

