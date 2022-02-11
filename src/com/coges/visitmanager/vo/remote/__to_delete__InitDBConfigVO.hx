package com.coges.visitmanager.vo.remote;


/**
	 * ...
	 * @author Nicolas Bigot
	 */
class InitDBConfigVO
{
    public var slotLength:Int;
    public var slotStartTimeString:String;
    public var slotEndTimeString:String;
    public var ratioFranceForeigner:Float;
    public var midDayTimeString:String;
    public var startDateString:String;
    public var endDateString:String;
    
    public function new(slotLength:Int = 0, slotStartTimeString:String = "", slotEndTimeString:String = "", ratioFranceForeigner:Float = 0, midDayTimeString :String = "", startDateString:String = "", endDateString:String = "")
    {
        this.slotEndTimeString = slotEndTimeString;
        this.slotStartTimeString = slotStartTimeString;
        this.slotLength = slotLength;
        this.ratioFranceForeigner = ratioFranceForeigner;
        this.midDayTimeString = midDayTimeString;
        this.startDateString = startDateString;
        this.endDateString = endDateString;
    }
    
    
}

