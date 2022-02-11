package com.coges.visitmanager.vo.remote;

import com.coges.visitmanager.datas.DataUpdaterEvent;
import com.coges.visitmanager.core.Utils;
import com.coges.visitmanager.vo.Period;
import nbigot.utils.Collection;
import openfl.events.Event;
import openfl.events.EventDispatcher;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class VisitVO
{
    public var id:Int;
    public var idPlanning:Int;
    public var idDemand:Int;
    public var demandPriority:String;
    public var idSpecialVisit:Int;
    public var idExhibitor:Int;
    public var exhibitorCode:Int;
    public var idDO:Int;
    public var dateStartString:String;
    public var dateEndString:String;
    public var contact:String;
    public var phone:String;
    public var isLocked:Bool;
    public var location:String;
    public var motivation:String;
    public var comment:String;
    public var isValdidateByProgrammer:Bool;
    public var isValdidateByOZ:Bool;
    public var name:String;
    public var notes:String;
    public var notesProg:String;
    public var idStatus:String;
    //public var isStandBy:Boolean;
    public var exhibitorName:String;
    public var exhibitorWelcomeCapacity:Int;
    public var idExhibitorCountry:Int;
    public var specialVisitName:String;
    public var visitActivityList:Array<VisitActivityVO>;
    public var idVotePeriod:String;
    
    public function new(id:Int = 0, idPlanning:Int = 0, idDemand:Int = 0, demandPriority:String = "", idSpecialVisit:Int = 0, idExhibitor:Int = 0, exhibitorCode:Int = 0, idDO:Int = 0,
            dateStartString:String = "", dateEndString:String = "", contact:String = "", phone:String = "",
            isLocked:Bool = false, location:String = "", motivation:String = "", comment:String = "",
            isValdidateByProgrammer:Bool = false, isValdidateByOZ:Bool = false, name:String = "", notes:String = "", notesProg:String = "",
            idStatus:String = "",  /*isStandBy:Boolean = false, */   exhibitorName:String = "", exhibitorWelcomeCapacity:Int = 0, idExhibitorCountry:Int = 0, specialVisitName:String = "", visitActivityList:Array<VisitActivityVO> = null, idVotePeriod:String = "")
    {
        this.id = id;
        this.idPlanning = idPlanning;
        this.idDemand = idDemand;
        this.demandPriority = demandPriority;
        this.idSpecialVisit = idSpecialVisit;
        this.idExhibitor = idExhibitor;
        this.exhibitorCode = exhibitorCode;
        this.idDO = idDO;
        this.dateStartString = dateStartString;
        this.dateEndString = dateEndString;
        this.contact = contact;
        this.phone = phone;
        this.isLocked = isLocked;
        this.location = location;
        this.motivation = motivation;
        this.comment = comment;
        this.isValdidateByProgrammer = isValdidateByProgrammer;
        this.isValdidateByOZ = isValdidateByOZ;
        this.name = name;
        this.notes = notes;
        this.notesProg = notesProg;
        this.idStatus = idStatus;
        //this.isStandBy = isStandBy;
        this.exhibitorName = exhibitorName;
        this.exhibitorWelcomeCapacity = exhibitorWelcomeCapacity;
        this.idExhibitorCountry = idExhibitorCountry;
        this.specialVisitName = specialVisitName;
        this.visitActivityList = visitActivityList;
        this.idVotePeriod = idVotePeriod;
    }
    
}

