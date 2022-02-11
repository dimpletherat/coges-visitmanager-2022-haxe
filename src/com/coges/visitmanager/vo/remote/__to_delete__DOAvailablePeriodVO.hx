package com.coges.visitmanager.vo.remote;


/**
	 * ...
	 * @author Nicolas Bigot
	 */
class DOAvailablePeriodVO
{
    public var id:Int;
    public var idDelegation:Int;
    public var dayNum:Int;
    public var startDateString:String;
    public var endDateString:String;
    
    public function new(id:Int = 0, idDelegation:Int = 0, dayNum:Int = 0, startDateString:String = "", endDateString:String = "")
    {
        this.endDateString = endDateString;
        this.startDateString = startDateString;
        this.dayNum = dayNum;
        this.idDelegation = idDelegation;
        this.id = id;
    }
    
    
    
    
    
}

