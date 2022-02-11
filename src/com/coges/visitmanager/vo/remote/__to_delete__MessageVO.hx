package com.coges.visitmanager.vo.remote;


/**
	 * ...
	 * @author Nicolas Bigot
	 */
class MessageVO
{
    public var id:Int;
    public var idAuthor:Int;
    //public var idRecipient:int;
    public var authorFirstName:String;
    public var authorLastName:String;
    //public var idPlanning:int;
    public var idDO:Int;
    public var content:String;
    public var dateString:String;
    
    public function new(id:Int = 0, idAuthor:Int = 0,  /*idRecipient:int = 0, */   authorFirstName:String = "", authorLastName:String = ""  /*, idPlanning:int = 0*/  ,  /*, idPlanning:int = 0*/   idDO:Int = 0, content:String = "", dateString:String = "")
    {
        this.id = id;
        this.idAuthor = idAuthor;
        //this.idRecipient = idRecipient;
        this.authorFirstName = authorFirstName;
        this.authorLastName = authorLastName;
        //this.idPlanning = idPlanning;
        this.idDO = idDO;
        this.content = content;
        this.dateString = dateString;
    }
    
}

