package com.coges.visitmanager.vo.remote;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ActivityVO
{
    public var num:Int;
    public var labelInt:String;
    public var labelExt:String;
    
    public function new(num:Int = 0, labelInt:String = "", labelExt:String = "")
    {
        this.num = num;
        this.labelInt = labelInt;
        this.labelExt = labelExt;
    }
    
    
}

