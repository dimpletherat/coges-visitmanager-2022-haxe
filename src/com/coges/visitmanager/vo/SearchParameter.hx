package com.coges.visitmanager.vo;

import com.coges.visitmanager.vo.Country;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class SearchParameter
{
    public static var instance(get, never):SearchParameter;
    private static var _instance:SearchParameter;
    private static function get_instance():SearchParameter
    {
        if (_instance == null)
        {
            _instance = new SearchParameter();
        }
        return _instance;
    }
	
	
	
    public var name:String;
    public var day:DemandSlotDay;
    public var country:Country;	
    public var exhibitorGroup:ExhibitorGroup;
    public var order:String;
    public var hasInvitationDemand:Bool;
    public var startIndex:Int;
    public var pageSize:Int;
    
    
    
    public function new(name:String = "", day:DemandSlotDay = null, country:Country = null, exhibitorGroup:ExhibitorGroup = null, hasInvitationDemand:Bool = false, startIndex:Int = 0, pageSize:Int = 100, order:String = "ASC")
    {
        this.pageSize = pageSize;
        this.startIndex = startIndex;
        this.hasInvitationDemand = hasInvitationDemand;
        this.country = country;
        this.exhibitorGroup = exhibitorGroup;
        this.day = day;
        this.name = name;
        this.order = order;
    }
    
    
    public function toString():String
    {
        return "[PARAM]:name=" + name + "|day=" + day + "|country=" + country + "|exhibitorGroup=" + exhibitorGroup + "|hasInvitationDemand=" + hasInvitationDemand + "|startIndex=" + startIndex + "|pageSize=" + pageSize;
    }
}

