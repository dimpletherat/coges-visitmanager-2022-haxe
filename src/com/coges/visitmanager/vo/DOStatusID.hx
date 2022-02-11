package com.coges.visitmanager.vo;


/**
	 * ...
	 * @author Nicolas Bigot
	 */
enum abstract DOStatusID(String) from String to String
{
    var CANCELED:String = "Annule";
    var INTENDED:String = "Prevu";
    var CONFIRMED:String = "confirme";
    var FULLY_CONFIRMED:String = "DateConf";
}
