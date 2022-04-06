package com.coges.visitmanager.vo;


/**
	 * ...
	 * @author Nicolas Bigot
	 */
enum abstract VisitStatusByOA(String) from String to String
{
    var DONE:String = "DONE";
    var CANCEL_LATE:String = "CANCEL_LATE";
    var CANCEL_OFFICIAL:String = "CANCEL_OFFICIAL";
    var CANCEL_OTHER:String = "CANCEL_OTHER";
}
