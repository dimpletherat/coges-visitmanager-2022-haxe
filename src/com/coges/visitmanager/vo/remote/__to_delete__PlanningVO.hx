package com.coges.visitmanager.vo.remote;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class PlanningVO
{
    public var id:Int;
    public var version:Int;
    public var idDO:Int;
    public var label:String;
    public var dateCreaString:String;
    public var dateEditString:String;
    
    public function new(id:Int = 0, idDO:Int = 0, version:Int = 0, label:String = "", dateCreaString:String = "", dateEditString:String = "")
    {
        this.id = id;
        this.idDO = idDO;
        this.version = version;
        this.label = label;
        this.dateCreaString = dateCreaString;
        this.dateEditString = dateEditString;
    }
    
}

