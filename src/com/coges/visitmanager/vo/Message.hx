package com.coges.visitmanager.vo;

import nbigot.utils.Collection;
import nbigot.utils.DateUtils;

/**
	 * ...
	 * @author Nicolas Bigot
	 */

typedef MessageJSON = {
    var id:Int;
    var idAuthor:Int;
    var authorFirstName:String;
    var authorLastName:String;
    var idDO:Int;
    var content:String;
    var dateString:String;
	
}





class Message
{
    public var id(get, never):Int;
    private var _id:Int;
    private function get_id():Int
    {
        return _id;
    }
	
    public var idAuthor(get, never):Int;
    private var _idAuthor:Int;
    private function get_idAuthor():Int
    {
        return _idAuthor;
    }
	
    public var authorFirstName(get, set):String;
    private var _authorFirstName:String;
    private function get_authorFirstName():String
    {
        return _authorFirstName;
    }
    private function set_authorFirstName(value:String):String
    {
        _authorFirstName = value;
        return value;
    }
	
    public var authorLastName(get, set):String;
    private var _authorLastName:String;
    private function get_authorLastName():String
    {
        return _authorLastName;
    }
    private function set_authorLastName(value:String):String
    {
        _authorLastName = value;
        return value;
    }
	
    public var content(get, set):String;
    private var _content:String;
    private function get_content():String
    {
        return _content;
    }
    private function set_content(value:String):String
    {
        _content = value;
        return value;
    }
	
    public var date(get, set):Date;
    private var _date:Date;
    private function get_date():Date
    {
        return _date;
    }
    private function set_date(value:Date):Date
    {
        _date = value;
        _dateString = DateUtils.toDBString(_date);
        return value;
    }
	
    public var dateString(get, set):String;
    private var _dateString:String;
    private function get_dateString():String
    {
        return _dateString;
    }
    private function set_dateString(value:String):String
    {
        _dateString = value;
        _date = DateUtils.fromDBString(_dateString);
        return value;
    }

    
    
    
    
    
    
    
    public function new(json:MessageJSON)
    {
        _content = json.content;
        //_idRecipient = voSource.idRecipient;
        _idAuthor = json.idAuthor;
        _authorFirstName = json.authorFirstName;
        _authorLastName = json.authorLastName;
        _id = json.id;
        
        dateString = json.dateString;
		
    }
	
    
    private static var _list:Collection<Message>;	
    public static var list(get, never):Collection<Message>;
    private static function get_list():Collection<Message>
    {
        if (_list == null)
        {
            _list = new Collection<Message>();
        }
        return _list;
    }
}

