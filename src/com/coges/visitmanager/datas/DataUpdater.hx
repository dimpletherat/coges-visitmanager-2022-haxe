package com.coges.visitmanager.datas;

import openfl.events.EventDispatcher;
import openfl.events.IEventDispatcher;

/**
 * ...
 * @author Nicolas Bigot
 * 
 */
class DataUpdater extends EventDispatcher 
{
    public static var instance(get, never):DataUpdater;
    private static var _instance:DataUpdater;
    private static function get_instance():DataUpdater
    {
        if (_instance == null)
        {
            _instance = new DataUpdater();
        }
        return _instance;
    }

	public function new(target:IEventDispatcher=null) 
	{
		super(target);
		
	}
	
}