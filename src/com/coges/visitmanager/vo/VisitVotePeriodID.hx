package com.coges.visitmanager.vo;


/**
	 * ...
	 * @author Nicolas Bigot
	 */
enum abstract VisitVotePeriodID(String) from String to String
{
    var AM:String = "am";
    var AM_DEJ:String = "am_dej";
    var PM:String = "pm";
    var PM_DEJ:String = "pm_dej";
}
