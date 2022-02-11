package com.coges.visitmanager.core;

import com.coges.visitmanager.core.Config;
import com.coges.visitmanager.core.Utils;
import com.coges.visitmanager.datas.ServiceManager;
import com.coges.visitmanager.datas.ServiceEvent;
import com.coges.visitmanager.events.VisitSaveEvent;
import com.coges.visitmanager.vo.DO;
import com.coges.visitmanager.vo.Message.MessageJSON;
import com.coges.visitmanager.vo.NotificationAction;
import com.coges.visitmanager.vo.Period;
import com.coges.visitmanager.vo.Planning;
import com.coges.visitmanager.vo.SearchResult;
import com.coges.visitmanager.vo.User;
import com.coges.visitmanager.vo.UserType;
import com.coges.visitmanager.vo.Visit;
import com.coges.visitmanager.vo.VisitStatusID;
import nbigot.utils.Collection;
import nbigot.utils.DateUtils;
import com.coges.visitmanager.core.Locale;
import openfl.events.EventDispatcher;

/**
	 * ...
	 * @author Nicolas Bigot
	 */

	 
enum VisitSerieProcess
{
	SINGLE;
	ALL;
}
	 
	 
	 
class VisitSaveHelper extends EventDispatcher
{
    public static var instance(get, never):VisitSaveHelper;
    public var currentSaveType(get, never):VisitSaveType;
    public var currentVisit(get, never):Visit;
/*
    public static final SERIE_PROCESS_SINGLE:String = "SINGLE";
    public static final SERIE_PROCESS_ALL:String = "ALL";
*/    
    
    private static var _instance:VisitSaveHelper;
    private static function get_instance():VisitSaveHelper
    {
        if (_instance == null)
        {
            _instance = new VisitSaveHelper();
        }
        return _instance;
    }
    
    
    private var _currentSaveType:VisitSaveType;
    private function get_currentSaveType():VisitSaveType
    {
        return _currentSaveType;
    }
    
    private var _currentVisit:Visit;
    private function get_currentVisit():Visit
    {
        return _currentVisit;
    }
    private var _currentNewPeriod:Period;
    private var _currentSource:SearchResult;
    private var _currentNewStatusID:String;
    private var _visitToRemove:Visit;
    private var _visitToRemoveIdList:Array<Int>;
    private var _visitToSaveIdList:Array<Int>;
    private var _currentExhibitorAvailabilityResult:ExhibitorAvailabilityResult;
    private var _saveVisitSerieResult:Array<Int>;
    //private var _currentIsStandBy:Boolean;
    
    public function new()
    {
        super();
    }
    
    public function saveVisit(saveType:VisitSaveType, visit:Visit, newPeriod:Period = null, source:SearchResult = null, newStatusID:String = null  /*, isStandBy:Boolean = false*/  )
    {
        _currentNewStatusID = newStatusID;
        _currentSaveType = saveType;
        _currentVisit = visit;
        _currentNewPeriod = newPeriod;
        _currentSource = source;
        _visitToSaveIdList = new Array<Int>();
        //_currentIsStandBy = isStandBy;
        _saveVisitSerieResult = null;
        
        
        switch (_currentSaveType)
        {
            case VisitSaveType.FROM_RESULT_SEARCH:
                _saveVisitFromSearchResult();
            case VisitSaveType.FROM_VISIT_ITEM:
                _saveVisitFromVisitItem();
            case VisitSaveType.FROM_VISIT_DETAIL:
                _saveVisitFromVisitDetail();
            case VisitSaveType.CHANGE_STATUS:
                _saveVisitChangeStatus();
            case VisitSaveType.FROM_PENDING_VISIT:
                _saveVisitFromPendingVisit();
            default:
        }
    }
    public function confirmSaveVisit(newPeriodStartDate:Date = null)
    {
        if (newPeriodStartDate != null)
        {
            var newPeriodEndDate:Date = Date.fromTime(newPeriodStartDate.getTime() + _currentVisit.period.length);
            _currentNewPeriod = new Period(newPeriodStartDate, newPeriodEndDate);
        }
        
        switch (_currentSaveType)
        {
            case VisitSaveType.FROM_RESULT_SEARCH:
                _checkPeriodAvailability();
            case VisitSaveType.FROM_VISIT_ITEM:
                _checkPeriodAvailability();
            case VisitSaveType.FROM_VISIT_DETAIL:
                _checkPeriodAvailability();
            case VisitSaveType.FROM_PENDING_VISIT:
                _checkPeriodAvailability();
            default:
        }
    }
    public function confirmSaveVisitSerie(serieProcess:VisitSerieProcess)
    {
        //trace("VisitSaveHelper.confirmSaveVisitSerie > serieProcess:" + serieProcess);
        switch (serieProcess)
        {
            case VisitSerieProcess.ALL:
                _saveVisitSerie();
            case VisitSerieProcess.SINGLE:
                _proceedSaveVisit();
        }
    }
    
    
    
    
    public function removeVisit(visit:Visit)
    {
       // trace("VisitSaveHelper.removeVisit > visit:" + visit);
        _visitToRemove = visit;
        _visitToRemoveIdList = new Array<Int>();
        
        // check For SERIE ( same Name or idSpecialVisit, same day, same time )
        if (_visitToRemove.isSpecialVisit)
        {
            
            ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _checkVisitSerieForRemoveCompleteHandler);
            ServiceManager.instance.checkVisitSerie(0, _visitToRemove.id, _visitToRemove.dateStart, _visitToRemove.dateEnd, _visitToRemove.idSpecialVisit, _visitToRemove.name);
        }
        else
        {
            _removeVisitSingle();
        }
    }
    public function confirmRemoveVisitSerie(serieProcess:VisitSerieProcess)
    {
        switch (serieProcess)
        {
            case VisitSerieProcess.ALL:
                _removeVisitSerie();
            case VisitSerieProcess.SINGLE:
                _removeVisitSingle();
        }
    }
    
    
    private function _checkVisitSerieForRemoveCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.checkVisitSerie)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _checkVisitSerieForRemoveCompleteHandler);
            
            if (e.result.length == 0)
            {                
				// Visit is Alone
                _removeVisitSingle();
				
            } else {
				// Visit is part of a SERIE
                _visitToRemoveIdList = e.result;
				// Add current Visit to list for removing
                _visitToRemoveIdList.push(_visitToRemove.id);
                //trace("VisitSaveHelper._checkVisitSerieForRemoveCompleteHandler > SERIE:" + _visitToRemoveIdList);
                
                
                var message:String = Locale.get("ALERT_VISIT_IS_SERIE");
                message = StringTools.replace(message, "{visitCount}", Std.string(_visitToRemoveIdList.length) );
                dispatchEvent(new VisitSaveEvent(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, message));
                return;
            }
        }
    }
    private function _removeVisitSingle():Void
    {
        if (_visitToRemove == null)
        {
            return;
        }
        
        if (_visitToRemove.idStatus == VisitStatusID.ACCEPTED)
        {
            ServiceManager.instance.throwNotification(User.instance, DO.selected, NotificationAction.INCREASE);
        }
        
        ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _removeVisitCompleteHandler);
        ServiceManager.instance.removeDOVisit(_visitToRemove);
    }
    private function _removeVisitSerie():Void
    {
        //trace("VisitSaveHelper._removeVisitSerie");
        
        ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _removeVisitCompleteHandler);
        ServiceManager.instance.removeDOVisitSerie(_visitToRemoveIdList);
    }
    
    private function _removeVisitCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.removeDOVisit || e.currentCall == ServiceManager.instance.removeDOVisitSerie)
        {
            //trace("removeDOVisit complete:::" + e.result);
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _removeVisitCompleteHandler);
            if (User.instance.type == UserType.OZ)
            {
				var m:MessageJSON = {			
					id:0,
					idAuthor:User.instance.id,
					authorFirstName:User.instance.firstName,
					authorLastName:User.instance.lastName,
					idDO:DO.selected.id,
					content:Locale.get("MESSAGE_REMOVAL") + _visitToRemove.name,
					dateString:DateUtils.toDBString(Date.now())
				}
				
                ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _saveUserMessageCompleteHandler);
                ServiceManager.instance.saveUserMessage(m, User.instance);
            }
            else
            {
                dispatchEvent(new VisitSaveEvent(VisitSaveEvent.COMPLETE));
            }
            _visitToRemove = null;
            return;
        }
    }
    
    
    
    
    private function _saveVisitFromSearchResult(demandActivityList:Array<VisitActivityJSON> = null):Void
    {
        if (demandActivityList == null && _currentSource.idDemand > 0)
        {
            _getDemandActivityList();
            return;
        }
        
        _currentVisit = Visit.createNewVisitFromSearchResult(_currentNewPeriod.startDate, _currentNewPeriod.endDate, Planning.selected.id, DO.selected.id, _currentSource, demandActivityList);
        
        
        _checkExhibitorAvailability();
    }
    
    private function _saveVisitFromVisitItem():Void
    {
        if (!_currentVisit.isSpecialVisit)
        {
            _checkExhibitorAvailability();
        }
        else
        {
            _checkPeriodAvailability();
        }
    }
    private function _saveVisitFromVisitDetail():Void
    {
        if (_currentVisit.name.length == 0 && _currentVisit.idSpecialVisit == 0)
        {
            var message:String = Locale.get("ALERT_NAME_MISSING");
            dispatchEvent(new VisitSaveEvent(VisitSaveEvent.ERROR, message));
            return;
        }
        if (!_currentVisit.isSpecialVisit)
        {
            _checkExhibitorAvailability();
        }
        else
        {
            _checkPeriodAvailability();
        }
    }
    private function _saveVisitChangeStatus():Void
    {
        _currentVisit.idStatus = _currentNewStatusID;
        
        _saveVisit();
    }
    private function _saveVisitFromPendingVisit():Void
    {
        if (!_currentVisit.isSpecialVisit)
        {
            _checkExhibitorAvailability();
        }
        else
        {
            _checkPeriodAvailability();
        }
    }
    
    
    
    private function _saveVisitStandByChange(callServiceIsComplete:Bool = false, result:Dynamic = null):Void
    {
        //trace("VisitSaveHelper._saveVisitStandByChange callServiceIsComplete: " + callServiceIsComplete);
        if (!callServiceIsComplete)
        {
            ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _serviceCompleteHandler);
            ServiceManager.instance.setDOVisitStandBy(_currentVisit, false);
        }
        else
        {
            dispatchEvent(new VisitSaveEvent(VisitSaveEvent.COMPLETE));
        }
    }
    
    private function _getDemandActivityList(callServiceIsComplete:Bool = false, result:Dynamic = null):Void
    {
        if (!callServiceIsComplete)
        {
            //trace("VisitSaveHelper._getDemandActivityList - ID Demand:" + _currentSource.idDemand);
            ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _serviceCompleteHandler);
            ServiceManager.instance.getDemandActivityList(_currentSource.idDemand);
        }
        else
        {
			//could happen if _currentSource.idDemand is 0 or less
            if (result == null)
            {
				//prevent infinite call of getDemandActivityList
                result = new Collection();
            }
            //trace("VisitSaveHelper._getDemandActivityList OK - result:" + result);
            _saveVisitFromSearchResult(result);
        }
    }
    private function _checkExhibitorAvailability(callServiceIsComplete:Bool = false, result:Dynamic = null):Void
    {
        if (!callServiceIsComplete)
        {
            var idExhibitor:Int = (_currentSource != null) ? _currentSource.idExhibitor:_currentVisit.idExhibitor;
            //trace("VisitSaveHelper._checkExhibitorAvailability:" + idExhibitor + "::" + _currentVisit.id + "::" + _currentNewPeriod.startDate + "::" + _currentNewPeriod.endDate);
            ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _serviceCompleteHandler);
            ServiceManager.instance.checkExhibitorAvailability(idExhibitor, _currentVisit.id, _currentNewPeriod.startDate, _currentNewPeriod.endDate);
			
        } else{
			     
            //trace("VisitSaveHelper._checkExhibitorAvailability OK - Result:" + result);
			
            var message:String = "";
            
            if (_currentSource != null && !_currentSource.exhibitorIsEligible)
            {
				// ERROR
                
                message += Locale.get("ALERT_EXHIBITOR_NON_ELIGIBLE");
                message = StringTools.replace(message, "{name}", _currentSource.exhibitorCompanyName);
                message = StringTools.replace(message, "{welcomeCapacity}", Std.string(_currentSource.exhibitorWelcomeCapacity) );
                message = StringTools.replace(message, "{welcomeStand}", _currentSource.exhibitorWelcomeStand);
                message = StringTools.replace(message, "{contact}", _currentSource.contactName);
                
                dispatchEvent(new VisitSaveEvent(VisitSaveEvent.ALERT_EXHIBITOR_NON_ELIGIBLE, message));
                return;
            }
            
            
            /************************
			 * result object anatomy :
			 * result.isAvailable = true|false
			 * result.DOList:Array = [DOName etc|2016-06-15 16:00:00|2016-06-15 16:30:00, etc...]
			 * result.availabilityList:Array = [2016-06-14 09:40:00,2016-06-15 10:00:00,2016-06-16 10:20:00,2016-06-16 10:40:00, etc...]
			 * **********************/
            
            _currentExhibitorAvailabilityResult = new ExhibitorAvailabilityResult(result);
            
            if (!_currentExhibitorAvailabilityResult.isAvailable)
            {
				// ERROR
                
                // We need to udpate the DOList First
                ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _getDOListForExhibitorAvailabilityCompleteHandler);
                ServiceManager.instance.getDOVisitList(DO.selected, Planning.selected, User.instance);
                
                return;
            }
            
            // OK
            switch (_currentSaveType)
            {
                case VisitSaveType.FROM_RESULT_SEARCH:
                    _checkPeriodAvailability();
                case VisitSaveType.FROM_VISIT_ITEM:
                    _checkPeriodAvailability();
                case VisitSaveType.FROM_VISIT_DETAIL:
                    _checkPeriodAvailability();
                case VisitSaveType.FROM_PENDING_VISIT:
                    _checkPeriodAvailability();
                default:
            }
        }
    }
    private function _getDOListForExhibitorAvailabilityCompleteHandler(e:ServiceEvent):Void
    {
        ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _getDOListForExhibitorAvailabilityCompleteHandler);
        
        var message:String = "";
        message += Locale.get("ALERT_EXHIBITOR_NOT_AVAILABLE");
        var listCount:Int;
        var i:Int;
        
            /************************
			 * result object anatomy :
			 * result.isAvailable = true|false
			 * result.DOList:Array = [DOName etc|2016-06-15 16:00:00|2016-06-15 16:30:00, etc...]
			 * result.availabilityList:Array = [2016-06-14 09:40:00,2016-06-15 10:00:00,2016-06-16 10:20:00,2016-06-16 10:40:00, etc...]
			 * **********************/
			
        // build DOList
        listCount = _currentExhibitorAvailabilityResult.DOList.length;
        var DOListMessage:String = "\n";  // "<br>";  
        //DOListMessage += "{SCROLLLIST}";
        if (listCount > 0)
        {
            var a:Array<Dynamic>;
            var startTime:Date;
            var endTime:Date;
            for (i in 0...listCount)
            {
                a = _currentExhibitorAvailabilityResult.DOList[i].split("|");
                startTime = Utils.getDateFromDBString(a[1]);
                endTime = Utils.getDateFromDBString(a[2]);
                //DOListMessage += "- " + a[0] + ":" + DateFormat.toShortTimeString(startTime, ":") + " > " + DateFormat.toShortTimeString(endTime, ":");
                DOListMessage += "- " + a[0] + ":" + DateUtils.toString(startTime, "hh:mm") + " > " + DateUtils.toString(endTime, "hh:mm");
                if (i < listCount - 1)
                {
                    //DOListMessage += "<br>";
                    DOListMessage += "\n";
                }
            }
        }
        //DOListMessage += "{SCROLLLIST}";
        message = StringTools.replace(message, "{DOList}", DOListMessage);
        
        
        //build AvailabilityList
        var availabilityListMessage:String = "";
        var dateString:String;
        var date:Date;
        var prevDate:Date = null;
        var tmpEndDate:Date;
        var sep:String = "";
        var isCurrentVisitDay:Bool = false;
        var period:Period;
        
        listCount = _currentExhibitorAvailabilityResult.availabilityList.length;
        
        //trace( "ExhibitorAvailabilityList raw:" + _currentExhibitorAvailabilityResult.availabilityList );
        
        // filter with Visit already there in this planning
        var availabilityListFiltered:Array<Dynamic> = new Array<Dynamic>();
        for (i in 0...listCount)
        {
            dateString = _currentExhibitorAvailabilityResult.availabilityList[i];
            date = DateUtils.fromDBString(dateString);
            period = new Period(date, Date.fromTime(date.getTime() + _currentNewPeriod.length));
            if (_currentVisit.checkPeriodAvailability(period))
            {
                availabilityListFiltered.push(dateString);
            }
        }
        
        listCount = availabilityListFiltered.length;
        //trace( "ExhibitorAvailabilityList filtered:" + availabilityListFiltered);
        
        if (listCount > 0)
        {
            availabilityListMessage += "<li>";
            for (i in 0...listCount)
            {
                dateString = availabilityListFiltered[i];
                date = DateUtils.fromDBString(dateString);
                sep = "  |  ";
                if (!DateUtils.isEqual(date, prevDate))
                {
                    if (i > 0)
                    {
                        if (isCurrentVisitDay)
                        {
                            availabilityListMessage += "</b>";
                        }
                        availabilityListMessage += "</li>";
                        availabilityListMessage += "<li>";
                    }
                    isCurrentVisitDay = DateUtils.isEqual(date, _currentNewPeriod.startDate);
                    if (isCurrentVisitDay)
                    {
                        availabilityListMessage += "<b>";
                    }
                    availabilityListMessage += DateUtils.toText(date, Config.LANG, true).toUpperCase() + " : ";
                    prevDate = date;
                    sep = "";
                }
				
                availabilityListMessage += sep + "<font color=\"#"+StringTools.hex( Colors.DARK_BLUE1 )+"\"><b><u><a href='event:" + dateString + "'>" + DateUtils.toString( date, "hh:mm" ) + "</a></u></b></font>";
            }
            if (isCurrentVisitDay)
            {
                availabilityListMessage += "</b>";
            }
            availabilityListMessage += "</li>";
        }
        else
        {
            availabilityListMessage += Locale.get("NO_RESULT");
        }
        
        //trace( "availabilityListMessage:" + availabilityListMessage );
        
        message = StringTools.replace(message, "{AvailabilityList}", availabilityListMessage);
        
        _currentExhibitorAvailabilityResult = null;
        
        dispatchEvent(new VisitSaveEvent(VisitSaveEvent.ASK_FOR_CONFIRM_EXHIBITOR_AVAILABILITY, message));
    }
    
    
    
    private function _checkPeriodAvailability(callServiceIsComplete:Bool = false, result:Dynamic = null):Void
    {
        if (!callServiceIsComplete)
        {
            //trace("VisitSaveHelper._checkPeriodAvailability > callServiceIsComplete:" + callServiceIsComplete + ", result:" + result);
            ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _serviceCompleteHandler);
            ServiceManager.instance.getDOVisitList(DO.selected, Planning.selected, User.instance);
        }
        else
        {
            var isPeriodAvailable:Bool = _currentVisit.checkPeriodAvailability(_currentNewPeriod);
            if (!isPeriodAvailable)
            {
				// ERROR                
                var message:String = Locale.get("ALERT_PERIOD_NOT_AVAILABLE");
                dispatchEvent(new VisitSaveEvent(VisitSaveEvent.ERROR, message));
            }            
            else
            {                
                // OK
                var periodHasChanged:Bool = false;
                switch (_currentSaveType)
                {
                    case VisitSaveType.FROM_RESULT_SEARCH:
                        _proceedSaveVisit();
                    
                    case VisitSaveType.FROM_VISIT_ITEM:
                        
                        periodHasChanged = _currentVisit.checkPeriodChanged(_currentNewPeriod);
                        if (periodHasChanged && _currentVisit.isSpecialVisit)
                        {
                            _checkVisitSerieForSave();
                        }
                        else
                        {
                            _proceedSaveVisit();
                        }
                    
                    case VisitSaveType.FROM_VISIT_DETAIL:
                        
                        periodHasChanged = _currentVisit.checkPeriodChanged(_currentNewPeriod);
                        if (periodHasChanged && _currentVisit.isSpecialVisit)
                        {
                            _checkVisitSerieForSave();
                        }
                        else
                        {
                            _proceedSaveVisit();
                        }
                    
                    case VisitSaveType.FROM_PENDING_VISIT:
                        
                        periodHasChanged = _currentVisit.checkPeriodChanged(_currentNewPeriod);
                        _proceedSaveVisit();
                    default:
                }
            }
        }
    }
    
    private function _checkVisitSerieForSave():Void
    // check For SERIE ( same Exhibitor, same day, same time )
    {
        
        ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _checkVisitSerieForSaveCompleteHandler);
        ServiceManager.instance.checkVisitSerie(_currentVisit.idExhibitor, _currentVisit.id, _currentVisit.dateStart, _currentVisit.dateEnd, _currentVisit.idSpecialVisit, _currentVisit.name);
    }
    private function _checkVisitSerieForSaveCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.checkVisitSerie)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _checkVisitSerieForSaveCompleteHandler);
            
            if (e.result.length == 0)
            {
				// Visit is Alone                
                _proceedSaveVisit();
            }            
            else
            {
                // Visit is part of a SERIE
                // We do not add the current visit to save to the list. It will be saved at the end via _proceedSaveVisit
                _visitToSaveIdList = e.result;
                
                //_visitToSaveIdList.push( _currentVisit.id );
                //trace("VisitSaveHelper._checkVisitSerieForSaveCompleteHandler > SERIE:" + _visitToSaveIdList);
                
                
                var message:String = "";
                message += Locale.get("ALERT_VISIT_IS_SERIE");
                message = StringTools.replace(message, "{visitCount}", Std.string(_visitToSaveIdList.length + 1) );  // +1 to count the current Visit  
                dispatchEvent(new VisitSaveEvent(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, message));
                return;
            }
        }
    }
    
    private function _saveVisitSerie():Void
    {
        //trace("VisitSaveHelper._saveVisitSerie");
        
        ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _saveVisitSerieCompleteHandler);
        ServiceManager.instance.saveDOVisitSerie(_visitToSaveIdList, _currentNewPeriod);
    }
    
    private function _saveVisitSerieCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.saveDOVisitSerie)
        {
            //trace("saveDOVisitSerie complete:::" + e.result);
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _saveVisitSerieCompleteHandler);
            
            if (e.result.length > 0)
            {
                _saveVisitSerieResult = e.result;
            }
            
            _proceedSaveVisit();
        }
    }
    
    
    
    private function _proceedSaveVisit():Void
    {
        var periodHasChanged:Bool = false;
        switch (_currentSaveType)
        {
            case VisitSaveType.FROM_RESULT_SEARCH:
                
                _saveVisit();
            
            case VisitSaveType.FROM_VISIT_ITEM:
                
                periodHasChanged = _currentVisit.checkPeriodChanged(_currentNewPeriod);
                if (periodHasChanged)
                {
                    _currentVisit.idStatus = VisitStatusID.PENDING;
                    ServiceManager.instance.throwNotification(User.instance, DO.selected, NotificationAction.INCREASE);
                }
                
                _currentVisit.dateStart = _currentNewPeriod.startDate;
                _currentVisit.dateEnd = _currentNewPeriod.endDate;
                
                _saveVisit();
            
            case VisitSaveType.FROM_VISIT_DETAIL:
                
                periodHasChanged = _currentVisit.checkPeriodChanged(_currentNewPeriod);
                if (periodHasChanged)
                {
                    _currentVisit.idStatus = VisitStatusID.PENDING;
                    ServiceManager.instance.throwNotification(User.instance, DO.selected, NotificationAction.INCREASE);
                }
                
                _currentVisit.dateStart = _currentNewPeriod.startDate;
                _currentVisit.dateEnd = _currentNewPeriod.endDate;
                
                if (_currentNewStatusID != null)
                {
                    _currentVisit.idStatus = _currentNewStatusID;
                }
                
                _saveVisit();
            
            case VisitSaveType.FROM_PENDING_VISIT:
                
                _currentVisit.dateStart = _currentNewPeriod.startDate;
                _currentVisit.dateEnd = _currentNewPeriod.endDate;
                
                _saveVisit();
            default:
        }
    }
    
    
    
    private function _saveVisit(callServiceIsComplete:Bool = false, result:Dynamic = null):Void
    {
        if (!callServiceIsComplete)
        {
			// A SPECIAL VISIT HAS ALWAYS A 'LOCKED' STATUS            
            if (_currentVisit.isSpecialVisit)
            {
                _currentVisit.idStatus = VisitStatusID.LOCKED;
            }
            
            //trace("VisitSaveHelper._saveVisit");
            ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _serviceCompleteHandler);
            ServiceManager.instance.saveDOVisit(_currentVisit);
        }
        else
        {
            //trace("VisitSaveHelper._saveVisit OK");
            switch (_currentSaveType)
            {
                case VisitSaveType.FROM_RESULT_SEARCH:
                    ServiceManager.instance.throwNotification(User.instance, DO.selected, NotificationAction.INCREASE);
                    dispatchEvent(new VisitSaveEvent(VisitSaveEvent.COMPLETE));
                
                case VisitSaveType.CHANGE_STATUS:
                    if (_currentNewStatusID == VisitStatusID.CANCELED)
                    {
                        ServiceManager.instance.throwNotification(User.instance, DO.selected, NotificationAction.INCREASE);
                        if (User.instance.type == UserType.OZ)
                        {							
							var m:MessageJSON = {			
								id:0,
								idAuthor:User.instance.id,
								authorFirstName:User.instance.firstName,
								authorLastName:User.instance.lastName,
								idDO:DO.selected.id,
								content:Locale.get("MESSAGE_ADJOURNMENT") + _currentVisit.name,
								dateString:DateUtils.toDBString(Date.now())
							}							
							
                            ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _saveUserMessageCompleteHandler);
                            ServiceManager.instance.saveUserMessage(m, User.instance);
                            return;
                        }
                    }
                    dispatchEvent(new VisitSaveEvent(VisitSaveEvent.COMPLETE));
                
                case VisitSaveType.FROM_PENDING_VISIT:
                    _saveVisitStandByChange();
                default:
                    
                    var message:String = null;
                    if (_saveVisitSerieResult != null)
                    {
                        message = Locale.get("SAVE_VISIT_SERIE_ERROR_MESSAGE");
                        message += "<br>";
                        var i:Int = 0;
                        var del:DO = null;
                        i = 0;
                        while (i < _saveVisitSerieResult.length)
                        {
                            del = DO.getDOByID(_saveVisitSerieResult[i]);
                            //trace("_saveVisitSerieResult[i]:" + _saveVisitSerieResult[i]);
                            //trace("del:" + del);
                            if (del != null)
                            {
                                message += "<br>- " + del.label;
                            }
                            i++;
                        }
                    }
                    dispatchEvent(new VisitSaveEvent(VisitSaveEvent.COMPLETE, message));
            }
        }
    }
    
    private function _saveUserMessageCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.saveUserMessage)
        {
            //trace("saveUserMessage complete");
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _saveUserMessageCompleteHandler);
            dispatchEvent(new VisitSaveEvent(VisitSaveEvent.COMPLETE));
        }
    }
    
    
    
    
    
    
    
    
    private function _serviceCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.getDOVisitList)
		{
			ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _serviceCompleteHandler);
			_checkPeriodAvailability(true, e.result);
			
			return;
		}
        if (e.currentCall == ServiceManager.instance.checkExhibitorAvailability)
		{
			ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _serviceCompleteHandler);
			_checkExhibitorAvailability(true, e.result);
			
			return;
		}
        if (e.currentCall == ServiceManager.instance.getDemandActivityList)
		{
			ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _serviceCompleteHandler);
			_getDemandActivityList(true, e.result);
			
			return;
		}
        if (e.currentCall == ServiceManager.instance.saveDOVisit)
		{
			ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _serviceCompleteHandler);
			_saveVisit(true, e.result);
			
			return;
		}
        if (e.currentCall == ServiceManager.instance.setDOVisitStandBy)
		{
			ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _serviceCompleteHandler);
			_saveVisitStandByChange(true, e.result);
			//_currentSaveType = VisitSaveType.FROM_VISIT_ITEM;
			//_saveVisitFromVisitItem();
			
			return;
		}
    }
}



class ExhibitorAvailabilityResult
{
    private var _isAvailable:Bool;
    public var isAvailable(get, never):Bool;
    private function get_isAvailable():Bool
    {
        return _isAvailable;
    }
	
    private var _DOList:Array<String>;
    public var DOList(get, never):Array<String>;
    private function get_DOList():Array<String>
    {
        return _DOList;
    }
	
    private var _availabilityList:Array<String>;
    public var availabilityList(get, never):Array<String>;
    private function get_availabilityList():Array<String>
    {
        return _availabilityList;
    }
    
    
    
    @:allow(com.coges.visitmanager)
    private function new(wsSource:Dynamic)
    {
        _isAvailable = wsSource.isAvailable;
        _DOList = wsSource.DOList;
        _availabilityList = wsSource.availabilityList;
    }
}