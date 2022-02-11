package com.coges.visitmanager.vo.remote;


/**
	 * ...
	 * @author Nicolas Bigot
	 */
class DelegationVO
{
    public var guest:String;
    public var id:Int;
    public var label:String;
    public var idCountry:Int;
    public var idStatus:String;
    public var notes:String;
    public var isRepresented:Bool;
    public var guestRepresentative:String;
    
    public function new(id:Int = 0, label:String = "", guest:String = "", idCountry:Int = 0, idStatus:String = "",
            notes:String = "", isRepresented:Bool = false, guestRepresentative:String = "")
    {
        this.guest = guest;
        this.idCountry = idCountry;
        this.label = label;
        this.id = id;
        this.idStatus = idStatus;
        this.notes = notes;
        this.isRepresented = isRepresented;
        this.guestRepresentative = guestRepresentative;
    }
    
}

