package com.coges.visitmanager.vo;

import com.coges.visitmanager.vo.Country;
import nbigot.utils.Collection;


typedef SearchResultJSON = 
{
    var idExhibitor:Int;
    var exhibitorCode:Int;
    var idExhibitorCountry:Int;
    var exhibitorCompanyName:String;
    var exhibitorWelcomeStand:String;
    var exhibitorWelcomeCapacity:Int;
    var exhibitorIsEligible:Bool;
    var idDemand:Int;
    var demandSlotDay:Int;
    var demandSlotDuration:String;
    var demandPriority:String;
    var demandMotivation:String;
    var demandComment:String;
    var urlTrianglesIcon:String;
    var contactName:String;
    var contactPhone:String;    
	
	//2022-evolution
    var exhibitorIsSensitive:Bool;
}


/**
	 * ...
	 * @author Nicolas Bigot
	 */
class SearchResult
{
    public static var list(get, never):Collection<SearchResult>;    
    private static var _list:Collection<SearchResult>;
	/*
    public static function createList(list:Collection<SearchResult>):Void
    {
        if (list != null)
        {
            _list = list;
        }
    }*/
    private static function get_list():Collection<SearchResult>
    {
        if (_list == null)
        {
            _list = new Collection<SearchResult>();
        }
        return _list;
    }
    
    public static var selected/*(get, set)*/:SearchResult;
    /*
    private static var _selected:SearchResult;
    private static function set_selected(value:SearchResult):SearchResult
    {
        _selected = value;
        return value;
    }
    private static function get_selected():SearchResult
    {
        return _selected;
    }
	*/
	
	
    public var idExhibitor(get, never):Int;
    public var exhibitorCode(get, never):Int;
    public var idExhibitorCountry(get, never):Int;
    public var exhibitorCompanyName(get, never):String;
    public var exhibitorWelcomeStand(get, never):String;
    public var exhibitorWelcomeCapacity(get, never):Int;
    public var exhibitorIsEligible(get, never):Bool;
    public var idDemand(get, never):Int;
    public var idDemandSlotDay(get, never):Int;
    public var idDemandSlotDuration(get, never):String;
    public var demandPriority(get, never):String;
    public var demandMotivation(get, never):String;
    public var demandComment(get, never):String;
    public var urlTrianglesIcon(get, never):String;
    public var contactName(get, never):String;
    public var contactPhone(get, never):String;
    public var demandSlotDay(get, never):DemandSlotDay;
    public var demandSlotDuration(get, never):DemandSlotDuration;
    public var exhibitorCountry(get, never):Country;
	
	//2022-evolution
    public var exhibitorIsSensitive(get, never):Bool;	
    private var _exhibitorIsSensitive:Bool;
    private function get_exhibitorIsSensitive():Bool
    {
        return _exhibitorIsSensitive;
    }
	

    private var _idExhibitor:Int;
    private function get_idExhibitor():Int
    {
        return _idExhibitor;
    }
    
    private var _exhibitorCode:Int;
    private function get_exhibitorCode():Int
    {
        return _exhibitorCode;
    }
    
    private var _idExhibitorCountry:Int;
    private function get_idExhibitorCountry():Int
    {
        return _idExhibitorCountry;
    }
    
    private var _exhibitorCompanyName:String;
    private function get_exhibitorCompanyName():String
    {
        return _exhibitorCompanyName;
    }
    
    private var _exhibitorWelcomeStand:String;
    private function get_exhibitorWelcomeStand():String
    {
        return _exhibitorWelcomeStand;
    }
    
    private var _exhibitorWelcomeCapacity:Int;
    private function get_exhibitorWelcomeCapacity():Int
    {
        return _exhibitorWelcomeCapacity;
    }
    
    private var _exhibitorIsEligible:Bool;
    private function get_exhibitorIsEligible():Bool
    {
        return _exhibitorIsEligible;
    }
    
    private var _idDemand:Int;
    private function get_idDemand():Int
    {
        return _idDemand;
    }
    
    private var _idDemandSlotDay:Int;
    private function get_idDemandSlotDay():Int
    {
        return _idDemandSlotDay;
    }
    
    private var _idDemandSlotDuration:String;
    private function get_idDemandSlotDuration():String
    {
        return _idDemandSlotDuration;
    }
    
    private var _demandPriority:String;
    private function get_demandPriority():String
    {
        return _demandPriority.toUpperCase();
    }
    
    private var _demandMotivation:String;
    private function get_demandMotivation():String
    {
        return _demandMotivation;
    }
    
    private var _demandComment:String;
    private function get_demandComment():String
    {
        return _demandComment;
    }
    
    private var _urlTrianglesIcon:String;
    private function get_urlTrianglesIcon():String
    {
        return _urlTrianglesIcon;
    }
    
    private var _contactName:String;
    private function get_contactName():String
    {
        return _contactName;
    }
    
    private var _contactPhone:String;
    private function get_contactPhone():String
    {
        return _contactPhone;
    }
    
    private var _demandSlotDay:DemandSlotDay;
    private function get_demandSlotDay():DemandSlotDay
    {
        if (_demandSlotDay == null)
        {
            _demandSlotDay = DemandSlotDay.getDemandSlotDayByID(_idDemandSlotDay);
        }
        return _demandSlotDay;
    }
    
    private var _demandSlotDuration:DemandSlotDuration;
    private function get_demandSlotDuration():DemandSlotDuration
    {
        if (_demandSlotDuration == null)
        {
            _demandSlotDuration = DemandSlotDuration.getDemandSlotDurationByID(_idDemandSlotDuration);
        }
        return _demandSlotDuration;
    }
    
    private var _exhibitorCountry:Country;
    private function get_exhibitorCountry():Country
    {
        if (_exhibitorCountry == null)
        {
            _exhibitorCountry = Country.getCountryById(_idExhibitorCountry);
        }
        return _exhibitorCountry;
    }
	
	
    
    
    public function new(json:SearchResultJSON)
    {
        _idExhibitor = json.idExhibitor;
        _exhibitorCode = json.exhibitorCode;
        _idExhibitorCountry = json.idExhibitorCountry;
        _exhibitorCompanyName = json.exhibitorCompanyName;
        _exhibitorWelcomeStand = json.exhibitorWelcomeStand;
        _exhibitorWelcomeCapacity = json.exhibitorWelcomeCapacity;
        _exhibitorIsEligible = json.exhibitorIsEligible;
        _idDemand = json.idDemand;
        _idDemandSlotDay = json.demandSlotDay;
        _idDemandSlotDuration = json.demandSlotDuration;
        _demandPriority = json.demandPriority;
        _demandMotivation = json.demandMotivation;
        _demandComment = json.demandComment;
        _urlTrianglesIcon = json.urlTrianglesIcon;
        _contactName = json.contactName;
        _contactPhone = json.contactPhone;
		
		//2022-evolution  
		_exhibitorIsSensitive = json.exhibitorIsSensitive;		
		//TODO:TEST
		//if ( Math.round( Math.random() ) == 1 )
		//	_exhibitorIsSensitive = true;
		
    
    //keep .. remember init values
    /*
    public function new(idExhibitor:Int = 0, exhibitorCode:Int = 0, exhibitorCompanyName:String = "", idExhibitorCountry:Int = 0,
            exhibitorWelcomeStand:String = "", exhibitorWelcomeCapacity:Int = 0, idDemand:Int = 0, demandSlotDay:Int = 0, demandSlotDuration:String = "",
            demandPriority:String = "", demandMotivation:String = "", demandComment:String = "", urlTrianglesIcon:String = "", contactName:String = "",
            contactPhone:String = "", exhibitorIsEligible:Bool = false)*/
	}
	
	public static function createDummy( name:String ):SearchResult
	{
		var json = {			
			idExhibitor:0,
			exhibitorCode:0,
			idExhibitorCountry:0,
			exhibitorCompanyName:name,
			exhibitorWelcomeStand:"",
			exhibitorWelcomeCapacity:0,
			exhibitorIsEligible:false,
			idDemand:0,
			demandSlotDay:0,
			demandSlotDuration:"",
			demandPriority:"",
			demandMotivation:"",
			demandComment:"",
			urlTrianglesIcon:"",
			contactName:"",
			contactPhone:"",
			exhibitorIsSensitive:false
		}
		return new SearchResult( json );
	}
}

