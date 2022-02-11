package com.coges.visitmanager.vo;


/**
	 * ...
	 * @author Nicolas Bigot
	 */
enum abstract NotificationAction(String) from String to String
{
    var CLEAR:String = "vider";
    var INCREASE:String = "increment";
}

