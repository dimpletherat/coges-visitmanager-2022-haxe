package com.coges.visitmanager.vo;

import haxe.Json;
import openfl.errors.Error;


typedef UserJSON = 
{
    var id:Int;
    var firstName:String;
    var lastName:String;
    var showChangeStatusAlert:Bool;
}
/**
	 * ...
	 * @author Nicolas Bigot
	 */ 

class User
{
    public static var instance(get, never):User;
    public var isAuthorized(get, never):Bool;
    public var id(get, never):Int;
    public var firstName(get, never):String;
    public var lastName(get, never):String;
    public var showChangeStatusAlert(get, set):Bool;
    public var type(get, never):UserType;

    private static var _initialized:Bool;
    private static var _instance:User;
    private static function get_instance():User
    {
        if (!_initialized)
        {
            throw new Error("La classe User doit être initialisée par User.createUser( args ) avant toute utilisation.");
        }
        return _instance;
    }
    public static function createUser(json:UserJSON, type:UserType):Void
    {
        //trace("User.createUser > id:" + json.id + ", firstName:" + json.firstName + ", lastName:" + json.lastName + ", type:" + type);
        _instance = new User(json.id, json.firstName, json.lastName, json.showChangeStatusAlert, type);
    }
    
    private function new(id:Int, firstName:String, lastName:String, showChangeStatusAlert:Bool, type:UserType)
    {
        _lastName = lastName;
        _firstName = firstName;
        _showChangeStatusAlert = showChangeStatusAlert;
        _initialized = true;
        _id = id;
        _type = type;
    }
    
    
    private function get_isAuthorized():Bool
    {
        return (_type == UserType.OZ || _type == UserType.PROGRAMMEUR);
    }
    
    
    
    private var _id:Int;
    private function get_id():Int
    {
        return _id;
    }
    private var _firstName:String;
    private function get_firstName():String
    {
        return _firstName;
    }
    
    private var _lastName:String;
    private function get_lastName():String
    {
        return _lastName;
    }
    
    private var _showChangeStatusAlert:Bool;
    private function set_showChangeStatusAlert(value:Bool):Bool
    {
        _showChangeStatusAlert = value;
        return value;
    }
    private function get_showChangeStatusAlert():Bool
    {
        return _showChangeStatusAlert;
    }
    
    private var _type:UserType;
    private function get_type():UserType
    {
        return _type;
    }
    
    
    
    public function getJSONRepresentation():String
    {
        var json:UserJSON = {
			id:_id, 
			firstName:_firstName, 
			lastName:_lastName, 
			showChangeStatusAlert:_showChangeStatusAlert
		}
        return Json.stringify( json );
    }
    
}
	 
	

