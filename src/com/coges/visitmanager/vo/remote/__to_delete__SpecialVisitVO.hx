package com.coges.visitmanager.vo.remote;


/**
	 * ...
	 * @author Nicolas Bigot
	 */
class SpecialVisitVO
{
    public var id:Int;
    public var label:String;
    
    public function new(id:Int = 0, label:String = "")
    {
        this.id = id;
        this.label = label;
    }
    
    
}

