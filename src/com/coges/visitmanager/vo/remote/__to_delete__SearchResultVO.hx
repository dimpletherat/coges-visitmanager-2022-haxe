package com.coges.visitmanager.vo.remote;


/**
	 * ...
	 * @author Nicolas Bigot
	 */
class SearchResultVO
{
    public var idExhibitor:Int;
    public var exhibitorCode:Int;
    public var idExhibitorCountry:Int;
    public var exhibitorCompanyName:String;
    public var exhibitorWelcomeStand:String;
    public var exhibitorWelcomeCapacity:Int;
    public var exhibitorIsEligible:Bool;
    public var idDemand:Int;
    public var demandSlotDay:Int;
    public var demandSlotDuration:String;
    public var demandPriority:String;
    public var demandMotivation:String;
    public var demandComment:String;
    public var urlTrianglesIcon:String;
    public var contactName:String;
    public var contactPhone:String;
    
    
    
    public function new(idExhibitor:Int = 0, exhibitorCode:Int = 0, exhibitorCompanyName:String = "", idExhibitorCountry:Int = 0,
            exhibitorWelcomeStand:String = "", exhibitorWelcomeCapacity:Int = 0, idDemand:Int = 0, demandSlotDay:Int = 0, demandSlotDuration:String = "",
            demandPriority:String = "", demandMotivation:String = "", demandComment:String = "", urlTrianglesIcon:String = "", contactName:String = "",
            contactPhone:String = "", exhibitorIsEligible:Bool = false)
    {
        this.idExhibitor = idExhibitor;
        this.exhibitorCode = exhibitorCode;
        this.idExhibitorCountry = idExhibitorCountry;
        this.exhibitorCompanyName = exhibitorCompanyName;
        this.exhibitorWelcomeStand = exhibitorWelcomeStand;
        this.exhibitorWelcomeCapacity = exhibitorWelcomeCapacity;
        this.exhibitorIsEligible = exhibitorIsEligible;
        this.idDemand = idDemand;
        this.demandSlotDay = demandSlotDay;
        this.demandSlotDuration = demandSlotDuration;
        this.demandPriority = demandPriority;
        this.demandMotivation = demandMotivation;
        this.demandComment = demandComment;
        this.urlTrianglesIcon = urlTrianglesIcon;
        this.contactName = contactName;
        this.contactPhone = contactPhone;
    }
    
}

