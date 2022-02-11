package com.coges.visitmanager.core;

import openfl.events.EventDispatcher;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class Controler extends EventDispatcher
{
    public static var instance(get, never):Controler;

    private static var _instance:Controler;
    private static function get_instance():Controler
    {
        if (_instance == null)
        {
            _instance = new Controler();
        }
        return _instance;
    }
    
    public function new()
    {
        super();
    }
}

