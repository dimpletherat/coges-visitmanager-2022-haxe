package com.coges.visitmanager.vo;

import com.coges.visitmanager.datas.DataUpdater;
import com.coges.visitmanager.core.Utils;
import com.coges.visitmanager.datas.DataUpdaterEvent;
import com.coges.visitmanager.vo.Period;
import haxe.Json;
import nbigot.utils.Collection;
import nbigot.utils.DateUtils;

/**
	 * ...
	 * @author Nicolas Bigot
	 */

	 

typedef VisitActivityJSON = 
{
	var id:Int;
	var idVisit:Int;
	var label:String;
	var isChecked:Bool;
	var comment:String;
	var urlIcon:String;
}
	
typedef VisitJSON = 
{
    var id:Int;
    var idPlanning:Int;
    var idDemand:Int;
    var demandPriority:String;
    var idSpecialVisit:Int;
    var idExhibitor:Int;
    var exhibitorCode:Int;
    var idDO:Int;
    var dateStartString:String;
    var dateEndString:String;
    var contact:String;
    var phone:String;
    var isLocked:Bool;
    var location:String;
    var motivation:String;
    var comment:String;
    var isValdidateByProgrammer:Bool;
    var isValdidateByOZ:Bool;
    var name:String;
    var notes:String;
    var notesProg:String;
    var idStatus:String;
    var exhibitorName:String;
    var exhibitorWelcomeCapacity:Int;
    var idExhibitorCountry:Int;
    var specialVisitName:String;
    var visitActivityList:Array<VisitActivityJSON>;
    var idVotePeriod:String;    
}
	 
	 
class Visit
{
    public var id(default, null):Int;
    public var idPlanning(default, null):Int;
    public var idDemand(default, null):Int;
    public var demandPriority(get, null):String;
    private function get_demandPriority():String
    {
        return demandPriority.toUpperCase();
    }
    public var idSpecialVisit(default, default):Int;
    public var idExhibitor(default, default):Int;
    public var exhibitorCode(default, null):Int;
    public var idDO(default, null):Int;
    public var dateStart(default, set):Date;
    private function set_dateStart(value:Date):Date
    {
        dateStart = value;
        dateStartString = DateUtils.toDBString(dateStart, true);
        if (dateStart != null && dateEnd != null)
        {
            period = new Period(dateStart, dateEnd);
        }
        return value;
    }
    public var dateStartString(default, null):String;
    public var dateEnd(default, set):Date;
    private function set_dateEnd(value:Date):Date
    {
        dateEnd = value;
        dateEndString = DateUtils.toDBString(dateEnd, true);
        if (dateStart != null && dateEnd != null)
        {
            period = new Period(dateStart, dateEnd);
        }
        return value;
    }
    public var dateEndString(default, null):String;
    public var period(default, null):Period;
    public var idVotePeriod(default, null):String;
    public var isOfficial(default, default):Bool;
    public var contact(default, default):String;
    public var phone(default, default):String;
    public var isLocked(default, default):Bool;
    public var location(default, default):String;
    public var motivation(default, null):String;
    public var comment(default, default):String;
    public var isValdidateByProgrammer(default, default):Bool;
    public var isValdidateByOZ(default, default):Bool;
    public var name(get, default):String;
    private function get_name():String
    {
        if (isSpecialVisit)
        {
            if (idSpecialVisit > 0)
            {
                return _specialVisitName;
            }
            else
            {
                return name;
            }
        }
		return _exhibitorName;
    }
    public var notes(default, default):String;
    public var notesProg(default, default):String;
    public var idStatus(default, set):VisitStatusID;
    private function set_idStatus(value:VisitStatusID):VisitStatusID
    {
        idStatus = value;
        if (idStatus == VisitStatusID.ACCEPTED || idStatus == VisitStatusID.CANCELED)
        {
            isValdidateByOZ = (User.instance.type == UserType.OZ);
            isValdidateByProgrammer = (User.instance.type == UserType.PROGRAMMEUR);
        }
        return value;
    }
    public var exhibitorWelcomeCapacity(default, null):Int;
    public var idExhibitorCountry(default, default):Int;
    public var visitActivityList(get, null):Collection<VisitActivityJSON>;
    private function get_visitActivityList():Collection<VisitActivityJSON>
    {
        if (visitActivityList == null)
        {
            visitActivityList = new Collection<VisitActivityJSON>();
        }
        return visitActivityList;
    }
    public var exhibitorCountry(get, null):Country;
    private function get_exhibitorCountry():Country
    {
        if (exhibitorCountry == null)
        {
            exhibitorCountry = Country.getCountryById(idExhibitorCountry);
        }
        return exhibitorCountry;
    }
    public var isFrenchExhibitor(get, null):Bool;
    private function get_isFrenchExhibitor():Bool
    {
        if (exhibitorCountry == null)
        {
            return false;
        }
		//TODO: check id
        // 197 = id union européenne
        return ((exhibitorCountry.label.toLowerCase() == "france") || idExhibitorCountry == 197);
    }
    public var isForeignExhibitor(get, null):Bool;
    private function get_isForeignExhibitor():Bool
    {
        if (exhibitorCountry == null)
        {
            return false;
        }
		//TODO: check id
        // 197 = id union européenne
        return ((exhibitorCountry.label.toLowerCase() != "france") && idExhibitorCountry != 197);
    }	
    public var isSpecialVisit(get, null):Bool;
    private function get_isSpecialVisit():Bool
    {
        return (idExhibitor == 0);
    }
    
    
    
    private var _exhibitorName:String;
    private var _specialVisitName:String;
    
    
    
    //TODO: CHECK visitActivityList. potential issue with types ( Collection vs Array, Dynamic vs VisitActivityJSON etc )
    //TODO: CHECK values for incoming jsons. Only null check are done here. Could lead to bug if strings are empty but not null ( ex for dates)
    public function new(json:VisitJSON)
    {		
        id = ( json.id == null ) ? 0 : json.id;
        idPlanning = ( json.idPlanning == null ) ? 0 : json.idPlanning;
        idDemand = ( json.idDemand == null ) ? 0 : json.idDemand;
        demandPriority = ( json.demandPriority == null ) ? "" : json.demandPriority;
        idSpecialVisit = ( json.idSpecialVisit == null ) ? 0 : json.idSpecialVisit;
        idExhibitor = ( json.idExhibitor == null ) ? 0 : json.idExhibitor;
        exhibitorCode = ( json.exhibitorCode == null ) ? 0 : json.exhibitorCode;
        idDO = ( json.idDO == null ) ? 0 : json.idDO;
		
		//TODO: check if it goes within the setter 
		// It goes.. it ALWAYS goes.. with or without 'this'
		//TODO: how to (do we want) initialize this value ?
		//setters for dateStart and dateEnd will populate dateStartString, dateEndString and period values
        dateStart = ( json.dateStartString == null ) ? new Date(1900, 0,1,0,0,0) : DateUtils.fromDBString(json.dateStartString);
        dateEnd = ( json.dateEndString == null ) ? new Date(1900, 0,1,0,0,0) : DateUtils.fromDBString(json.dateEndString);
        contact = ( json.contact == null ) ? "" : json.contact;
        phone = ( json.phone == null ) ? "" : json.phone;
        isLocked = ( json.isLocked == null ) ? false : json.isLocked;
        location = ( json.location == null ) ? "" : json.location;
        motivation = ( json.motivation == null ) ? "" : json.motivation;
        comment = ( json.comment == null ) ? "" : json.comment;
        isValdidateByProgrammer = ( json.isValdidateByProgrammer == null ) ? false : json.isValdidateByProgrammer;
        isValdidateByOZ = ( json.isValdidateByOZ == null ) ? false : json.isValdidateByOZ;
        name = ( json.name == null ) ? "" : json.name;
        notes = ( json.notes == null ) ? "" : json.notes;
        notesProg = ( json.notesProg == null ) ? "" : json.notesProg;
		//TODO: how to (do we want) initialize this value ?
        idStatus = ( json.idStatus == null ) ? null : json.idStatus;
        _exhibitorName = ( json.exhibitorName == null ) ? "" : json.exhibitorName;
        exhibitorWelcomeCapacity = ( json.exhibitorWelcomeCapacity == null ) ? 0 : json.exhibitorWelcomeCapacity;
        idExhibitorCountry = ( json.idExhibitorCountry == null ) ? 0 : json.idExhibitorCountry;
        _specialVisitName = ( json.specialVisitName == null ) ? "" : json.specialVisitName;
        visitActivityList = ( json.visitActivityList == null ) ? new Collection<VisitActivityJSON>() : new Collection<VisitActivityJSON>(json.visitActivityList);
        idVotePeriod = ( json.idVotePeriod == null ) ? "" : json.idVotePeriod;
    }
    
    
	
	
	
	
    public function checkPeriodAvailability(newPeriod:Period = null):Bool
    {
        if (newPeriod == null)
        {
            newPeriod = period;
        }
        //trace( "Visit.checkPeriodAvailability:" + newPeriod );
        var v:Visit;
        var i:Int = -1;
        while (++i < Visit.list.length)
        {
            v = Visit.list.getItemAt(i);
            if (v.id != this.id)
            {
                if (v.period.startABSOLUTE >= newPeriod.startABSOLUTE && v.period.startABSOLUTE < newPeriod.endABSOLUTE)
                {
                    return false;
                }
                if (v.period.endABSOLUTE <= newPeriod.endABSOLUTE && v.period.endABSOLUTE > newPeriod.startABSOLUTE)
                {
                    return false;
                }
                if (newPeriod.startABSOLUTE >= v.period.startABSOLUTE && newPeriod.startABSOLUTE < v.period.endABSOLUTE)
                {
                    return false;
                }
                if (newPeriod.endABSOLUTE > v.period.startABSOLUTE && newPeriod.endABSOLUTE < v.period.endABSOLUTE)
                {
                    return false;
                }
            }
        }
        return true;
    }
    
    public function checkPeriodChanged(newPeriod:Period):Bool    
    {
        // TODO:distinction nécessaire ..?
        //if ( !this.isSpecialVisit ) {
        if ((this.dateEnd.getTime() != newPeriod.endABSOLUTE) || (this.dateStart.getTime() != newPeriod.startABSOLUTE))
        {
            return true;
        }
        //}
        return false;
    }
    
    
    //public function getJSONRepresentation():String
    public function getJSONRepresentation():VisitJSON
    {
        var json:VisitJSON = {
			id:id, 
			idPlanning:idPlanning, 
			idDemand:idDemand, 
			demandPriority:demandPriority, 
			idSpecialVisit:idSpecialVisit, 
			idExhibitor:idExhibitor, 
			exhibitorCode:exhibitorCode, 
			idDO:idDO, 
			dateStartString:dateStartString, 
			dateEndString:dateEndString, 
			contact:contact, 
			phone:phone, 
			isLocked:isLocked, 
			location:location, 
			motivation:motivation, 
			comment:comment, 
			isValdidateByProgrammer:isValdidateByProgrammer, 
			isValdidateByOZ:isValdidateByOZ, 
			name:name, 
			notes:notes, 
			notesProg:notesProg, 
			idStatus:idStatus, 
			exhibitorName:_exhibitorName, 
			exhibitorWelcomeCapacity:exhibitorWelcomeCapacity, 
			idExhibitorCountry:idExhibitorCountry, 
			specialVisitName:_specialVisitName, 
			visitActivityList:visitActivityList.innerArray, 
			idVotePeriod:idVotePeriod
		};
        //return Json.stringify( json );
        return json;
    }
    public function clone():Visit
    {
        /*var json:VisitJSON = Json.parse( getJSONRepresentation() );
        return new Visit(json);*/
		return new Visit( getJSONRepresentation() );
    }
    
    
    public static var list(get, null):Collection<Visit>;
    private static var _list:Collection<Visit>;
    public static function createList(list:Collection<Visit>):Void
    {
        if (list != null)
        {
            _list = list;			
			DataUpdater.instance.dispatchEvent(new DataUpdaterEvent(DataUpdaterEvent.VISIT_LIST_CHANGE));
        }
    }
    private static function get_list():Collection<Visit>
    {
        if (_list == null)
        {
            _list = new Collection<Visit>();
        }
        return _list;
    }
    
    
    public static function createNewSpecialVisit(startDate:Date, endDate:Date, idPlanning:Int, idDO:Int):Visit
    {
        var json:VisitJSON = {
			id:0, 
			idPlanning:idPlanning, 
			idDemand:0, 
			demandPriority:null, 
			idSpecialVisit:0, 
			idExhibitor:0, 
			exhibitorCode:0, 
			idDO:idDO, 
			dateStartString:null, 
			dateEndString:null, 
			contact:null, 
			phone:null, 
			isLocked:false, 
			location:null, 
			motivation:null, 
			comment:null, 
			isValdidateByProgrammer:false, 
			isValdidateByOZ:false, 
			name:null, 
			notes:null, 
			notesProg:null, 
			idStatus:VisitStatusID.LOCKED, 
			exhibitorName:null, 
			exhibitorWelcomeCapacity:0, 
			idExhibitorCountry:0, 
			specialVisitName:null, 
			visitActivityList:null, 
			idVotePeriod:null
		};
        var v:Visit = new Visit(json);
        v.dateStart = startDate;
        v.dateEnd = endDate;
        return v;
    }
    public static function createNewVisitFromSearchResult(startDate:Date, endDate:Date, idPlanning:Int, idDO:Int, searchResult:SearchResult, activityList:Array<VisitActivityJSON>):Visit
    {
		// TODO VERIF données et complément a faire ( contacts, etc )
        
        // WHAT ABOUT COMMENT & MOTIV ..?		
        var json:VisitJSON = {
			id:0, 
			idPlanning:idPlanning, 
			idDemand:searchResult.idDemand, 
			demandPriority:searchResult.demandPriority, 			
			idSpecialVisit:0, 			
			idExhibitor:searchResult.idExhibitor, 
			exhibitorCode:searchResult.exhibitorCode, 			
			idDO:idDO, 			
			dateStartString:null, 
			dateEndString:null, 			
			contact:searchResult.contactName, 
			phone:searchResult.contactPhone, 
			isLocked:false, 
			location:searchResult.exhibitorWelcomeStand, 
			motivation:searchResult.demandMotivation, 
			comment:searchResult.demandComment, 
			isValdidateByProgrammer:false, 
			isValdidateByOZ:false, 
			name:null, 
			notes:null, 
			notesProg:null, 
			idStatus:VisitStatusID.PENDING, 
			exhibitorName:searchResult.exhibitorCompanyName, 
			exhibitorWelcomeCapacity:searchResult.exhibitorWelcomeCapacity, 
			idExhibitorCountry:searchResult.idExhibitorCountry, 
			specialVisitName:null, 
			visitActivityList:activityList, 
			idVotePeriod:null
		};
		
        var v:Visit = new Visit(json);
        v.dateStart = startDate;
        v.dateEnd = endDate;
        return v;
    }
    
    
    public static function getVisitByDay(day:Date):Visit
    {
        if (_list == null)
        {
            return null;
        }
		for (v in _list )
		{
			if (v.dateStart.getDate() == day.getDate())  return v;
		}
		/*
        var o:Visit;
        var i:Int = -1;		
        while (++i < _list.length)
        {
            o = try cast(_list.getItemAt(i), Visit) catch(e:Dynamic) null;
            if (o.dateStart.getDate() == day.getDate())
            {
                return o;
            }
        }*/
        return null;
    }
    
}

