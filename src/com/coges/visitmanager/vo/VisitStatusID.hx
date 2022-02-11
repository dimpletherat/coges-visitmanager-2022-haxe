package com.coges.visitmanager.vo;


/**
	 * ...
	 * @author Nicolas Bigot
	 */
enum abstract VisitStatusID(String) from String to String
{
    var ACCEPTED:String = "Envisage";
    var ACCEPTED_FRANCE:String = "Envisage_france";
    var PENDING:String = "Attente";
    var CANCELED:String = "Suppr";
    var LOCKED:String = "Reserve";
    var LOCKED_OFFICIAL:String = "Reserve_official";

}
