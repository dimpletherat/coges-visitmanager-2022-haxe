package com.coges.visitmanager.vo.remote;


/**
	 * ...
	 * @author Nicolas Bigot
	 */
class OppositeOwnerVO
{
    public var id:Int;
    public var firstName:String;
    public var lastName:String;
    public var phone:String;
    public var email:String;
    public var oaList:Array<Dynamic>;
    
    public function new(id:Int = 0, firstName:String = "", lastName:String = "", email:String = "", phone:String = "", oaList:Array<Dynamic> = null)
    {
        this.email = email;
        this.phone = phone;
        this.lastName = lastName;
        this.firstName = firstName;
        this.id = id;
        this.oaList = oaList;
    }
    
}

