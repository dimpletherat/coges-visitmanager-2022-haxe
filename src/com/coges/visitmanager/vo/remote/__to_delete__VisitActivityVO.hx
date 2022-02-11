package com.coges.visitmanager.vo.remote;



class VisitActivityVO
{
    public var id:Int;
    public var idVisit:Int;
    public var label:String;
    public var isChecked:Bool;
    public var comment:String;
    public var urlIcon:String;
    
    public function new(id:Int = 0, idVisit:Int = 0, label:String = "", isChecked:Bool = false, comment:String = "", urlIcon:String = "")
    {
        this.urlIcon = urlIcon;
        this.comment = comment;
        this.isChecked = isChecked;
        this.label = label;
        this.idVisit = idVisit;
        this.id = id;
    }
    
}

