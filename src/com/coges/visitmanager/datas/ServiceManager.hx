package com.coges.visitmanager.datas;

import com.coges.visitmanager.core.Config;
import com.coges.visitmanager.datas.ServiceEvent;
import com.coges.visitmanager.ui.dialog.VMErrorDialog;
import com.coges.visitmanager.vo.Activity;
import com.coges.visitmanager.vo.Country;
import com.coges.visitmanager.vo.DO;
import com.coges.visitmanager.vo.DOAvailablePeriod;
import com.coges.visitmanager.vo.ExhibitorGroup;
import com.coges.visitmanager.vo.FlagProg;
import com.coges.visitmanager.vo.Message;
import com.coges.visitmanager.vo.NotificationAction;
import com.coges.visitmanager.vo.OppositeOwner;
import com.coges.visitmanager.vo.PendingVisit;
import com.coges.visitmanager.vo.Period;
import com.coges.visitmanager.vo.Planning;
import com.coges.visitmanager.vo.SearchParameter;
import com.coges.visitmanager.vo.SearchResult;
import com.coges.visitmanager.vo.SpecialVisit;
import com.coges.visitmanager.vo.User;
import com.coges.visitmanager.vo.UserType;
import com.coges.visitmanager.vo.Visit;
import haxe.Http;
import haxe.Json;
import nbigot.ui.dialog.DialogManager;
import nbigot.utils.Collection;
import nbigot.utils.DateUtils;
import openfl.events.EventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.net.URLRequestMethod;
import openfl.net.URLVariables;
//import openfl.net.Responder;

/**
	 * ...
	 * @author Nicolas Bigot
	 */

	 
@:allow(com.coges.visitmanager.ui.panel.MenuPanel)
typedef MultiUsersDataJSON = {
	type : String,
	userList:Array<String>	
}
	 
	 
	 
class ServiceManager extends EventDispatcher
{
    public static var instance(get, never):ServiceManager;

    private static var _instance:ServiceManager;
    private static function get_instance():ServiceManager
    {
        if (_instance == null)
        {
            _instance = new ServiceManager();
        }
        return _instance;
    }
    
    ///private var _service:NetConnection;
    private var _service:Http;
    
    private function new()
    {
		
        super();
		/*
        _service. = new NetConnection();
        _service.objectEncoding = ObjectEncoding.AMF3;
        _service.connect(Config.servicesURL);
		
		_service = new Http( Config.servicesURL );
		_service.onStatus = _serviceStatusHandler;
		_service.onError = _serviceErrorHandler;*/
		
    }
	
	function _serviceStatusHandler( status:Int ) 
	{
	}
    
    /*
    private function _netStatusHandler(event:NetStatusEvent):void {
			trace ( event.info.code)
    switch (event.info.code) {
    case "NetConnection.Connect.Success":
       
    break;
    }
    }
		private function _securityErrorHandler(event:SecurityErrorEvent):void {
    trace("securityErrorHandler: " + event);
    }
		
	*/
    
	
	//TODO: implement proper result handling with the model {"success":true,"data":null, "message:"" }
    //TODO: ADD resultJSON.message to Error description everywhere
	//TODO: Decide what to do with arrays passed as ws parameter ( see line 1300-ish in getUserMessageList )
	
    // STATIC SERVICES
    public function getInitDBConfig():Void
    {
		var http = new Http( Config.servicesURL ); //"./assets/tmp-datas/get-ini-db-config.json");
		http.addParameter("action", "get-ini-db-config");
		http.onData = _getInitDBConfigCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.request(true);
    }
    private function _getInitDBConfigCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
        
        if (resultJSON.success == true )
        {
            Config.setInitDBConfig(resultJSON.data);
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, getInitDBConfig));
            return;
        }
        var error = "* ERROR - getInitDBConfig *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	
    public function getUserDatas(userId:Int, userType:UserType):Void
    {
		//var http = new Http("./assets/tmp-datas/get-user-datas.json");
		var http = new Http( Config.servicesURL );
		http.onData = _getUserDatasCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "get-user-datas");
		http.addParameter("user-id", Std.string(userId));
		http.addParameter("user-type", Std.string(userType));
		http.request(true);
		/*
        var responder:Responder = new Responder(_getUserDatasCompleteHandler, _serviceErrorHandler);
        _service.call("StaticServices.getUserDatas", responder, idUser, typeUser);*/
    }
    private function _getUserDatasCompleteHandler(result:String)
    {
		var resultJSON = Json.parse( result);
        
        if (resultJSON.success == true )
        {
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, resultJSON.data, getUserDatas));
            return;
        }
        var error = "* ERROR - getUserDatas *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
    public function updateUserDatas(user:User):Void
    {		
		//var http = new Http("./assets/tmp-datas/update-user-datas.json");
		var http = new Http( Config.servicesURL );
		http.onData = _updateUserDatasCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "update-user-datas");
		http.addParameter("user", user.getJSONRepresentation());
		http.addParameter("user-type", Std.string(user.type));
		http.request(true);
		/*
        var responder:Responder = new Responder(_updateUserDatasCompleteHandler, _serviceErrorHandler);
        var showChangeStatusAlert:String = Std.string(user.showChangeStatusAlert);
        _service.call("StaticServices.updateUserDatas", responder, user.getRemoteRepresentation(), user.type);*/
    }
    private function _updateUserDatasCompleteHandler(result:String)
    {
		var resultJSON = Json.parse( result);
        
        if (resultJSON.success == true )
        {
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, updateUserDatas));
            return;
        }
        var error = "* ERROR - updateUserDatas *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
    
	
    public function getCountryList():Void
    {	
		//var http = new Http("./assets/tmp-datas/get-country-list_fr.json");
		var http = new Http( Config.servicesURL );
		http.onData = _getCountryListCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "get-country-list");
		http.addParameter("lang", Config.LANG);
		http.request(true);
		/*
        var responder:Responder = new Responder(_getCountryListCompleteHandler, _serviceErrorHandler);
        _service.call("StaticServices.getCountryList", responder, Config.getLangForPHPServices());*/
    }
    private function _getCountryListCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
        
        Country.list.clear();
        if (resultJSON.success == true )
        {
			var list:Array<CountryJSON> = resultJSON.data;
			for ( c in list)
			{
				Country.list.addItem( new Country( c ) );
			}
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, getCountryList));
            return;
        }
        var error = "* ERROR - getCountryList *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
		
		
		/*
		
        if (result != null)
        {
			var list:Array<CountryJSON> = Json.parse( result);
			for ( c in list )
			{
				Country.list.addItem( new Country( c ) );
			}
        }
        dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, result, getCountryList));*/
    }
	
    public function getExhibitorGroupList():Void
    {	
		//var http = new Http("./assets/tmp-datas/get-exhibitor-group-list_fr.json");
		var http = new Http( Config.servicesURL );
		http.onData = _getExhibitorGroupListCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "get-exhibitor-group-list");
		http.addParameter("lang", Config.LANG);
		http.request(true);
		/*
        var responder:Responder = new Responder(_getExhibitorGroupListCompleteHandler, _serviceErrorHandler);
        _service.call("StaticServices.getExhibitorGroupList", responder, Config.getLangForPHPServices());*/
    }
    private function _getExhibitorGroupListCompleteHandler(result:Dynamic)
    {		
		var resultJSON = Json.parse( result);
        
        ExhibitorGroup.list.clear();
        if (resultJSON.success == true )
        {
			var list:Array<ExhibitorGroupJSON> = resultJSON.data;
			for ( e in list)
			{
				ExhibitorGroup.list.addItem( new ExhibitorGroup( e ) );
			}
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, getExhibitorGroupList));
            return;
        }
        var error = "* ERROR - getExhibitorGroupList *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	
    public function getActivityList():Void
    {
		//var http = new Http("./assets/tmp-datas/get-activity-list_fr.json");
		var http = new Http( Config.servicesURL );
		http.onData = _getActivityListCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "get-activity-list");
		http.addParameter("lang", Config.LANG);
		http.request(true);
		/*
        var responder:Responder = new Responder(_getActivityListCompleteHandler, _serviceErrorHandler);
        _service.call("StaticServices.getActivityList", responder, Config.getLangForPHPServices());*/
    }
    private function _getActivityListCompleteHandler(result:Dynamic)
    {	
		var resultJSON = Json.parse( result);
        
        Activity.list.clear();
        if (resultJSON.success == true )
        {
			var list:Array<ActivityJSON> = resultJSON.data;
			for ( e in list)
			{
				Activity.list.addItem( new Activity( e ) );
			}
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, getActivityList));
            return;
        }
        var error = "* ERROR - getActivityList *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
    public function getSpecialVisitList():Void
    {
		//var http = new Http("./assets/tmp-datas/get-specialvisit-list_fr.json");
		var http = new Http( Config.servicesURL );
		http.onData = _getSpecialVisitListCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "get-specialvisit-list");
		http.addParameter("lang", Config.LANG);
		http.request(true);
		/*
        var responder:Responder = new Responder(_getSpecialVisitListCompleteHandler, _serviceErrorHandler);
        _service.call("StaticServices.getSpecialVisitList", responder, Config.getLangForPHPServices());*/
    }
    private function _getSpecialVisitListCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
        
        SpecialVisit.list.clear();
        if (resultJSON.success == true )
        {
			var list:Array<SpecialVisitJSON> = resultJSON.data;
			for ( e in list)
			{
				SpecialVisit.list.addItem( new SpecialVisit( e ) );
			}
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, getSpecialVisitList));
            return;
        }
        var error = "* ERROR - getSpecialVisitList *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
		
		
		/*
		
        SpecialVisit.list.clear();
        if (result != null)
        {
			var list:Array<SpecialVisitJSON> = Json.parse( result);
			for ( sv in list )
			{
				SpecialVisit.list.addItem(new SpecialVisit( sv ));
			}
        }
        dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, result, getSpecialVisitList));*/
    }
    
	
    // SEARCH SERVICES
    public function getSearchResultCount(p:SearchParameter, delegation:DO):Void
    {
		//var http = new Http("./assets/tmp-datas/get-search-result-count.json");
		var http = new Http( Config.servicesURL );
		http.onData = _getSearchResultCountCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "get-search-result-count");
		http.addParameter("name", p.name);
		http.addParameter("country-id", Std.string( ( p.country != null ) ? p.country.id:0 ) );
		http.addParameter("group-id", Std.string( ( p.exhibitorGroup != null ) ? p.exhibitorGroup.id:0 ) );
		http.addParameter("has-demand", Std.string( p.hasInvitationDemand ) );
		http.addParameter("demand-day-num", Std.string( (p.day != null && p.hasInvitationDemand) ? p.day.id:0 ) );
		http.addParameter("do-id", Std.string( delegation.id ) );
		http.request(true);
		
		/*
        var responder:Responder = new Responder(_getSearchResultCountCompleteHandler, _serviceErrorHandler);
        
        var idCountry:Int = ((p.country)) ? p.country.id:0;
        var idGroup:Int = ((p.exhibitorGroup)) ? p.exhibitorGroup.id:0;
        var dayNum:Int = ((p.day && p.hasInvitationDemand)) ? p.day.id:0;
        var hasDemand:String = Std.string(p.hasInvitationDemand);
        
        _service.call("SearchServices.getSearchResultCount", responder, p.name, idCountry, idGroup, hasDemand, dayNum, delegation.id);*/
        
        dispatchEvent(new ServiceEvent(ServiceEvent.START, null, getSearchResultCount));
    }
    private function _getSearchResultCountCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
        
        if (resultJSON.success == true )
        {
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, resultJSON.data, getSearchResultCount));
            return;
        }
        var error = "* ERROR - getSearchResultCount *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
    
    public function getSearchResultList(p:SearchParameter, delegation:DO):Void
    {
		//var http = new Http("./assets/tmp-datas/get-search-result.json?45478");
		var http = new Http( Config.servicesURL );
		http.onData = _getSearchResultListCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "get-search-result");
		http.addParameter("name", p.name);
		http.addParameter("country-id", Std.string( ( p.country != null ) ? p.country.id:0 ) );
		http.addParameter("group-id", Std.string( ( p.exhibitorGroup != null ) ? p.exhibitorGroup.id:0 ) );
		http.addParameter("has-demand", Std.string( p.hasInvitationDemand ) );
		http.addParameter("demand-day-num", Std.string( (p.day != null && p.hasInvitationDemand) ? p.day.id:0 ) );
		http.addParameter("do-id", Std.string( delegation.id ) );
		http.addParameter("order", p.order );
		http.addParameter("from", Std.string( p.startIndex ) );
		http.addParameter("count", Std.string( p.pageSize ) );
		http.request(true);
		
		/*
        var responder:Responder = new Responder(_getSearchResultListCompleteHandler, _serviceErrorHandler);
        
        var idCountry:Int = ((p.country)) ? p.country.id:0;
        var idGroup:Int = ((p.exhibitorGroup)) ? p.exhibitorGroup.id:0;
        var dayNum:Int = ((p.day && p.hasInvitationDemand)) ? p.day.id:0;
        var hasDemand:String = Std.string(p.hasInvitationDemand);
        
        _service.call("SearchServices.getSearchResultList", responder, p.name, idCountry, idGroup, hasDemand, dayNum, delegation.id, p.order, p.startIndex, p.pageSize);*/
        
        dispatchEvent(new ServiceEvent(ServiceEvent.START, null, getSearchResultList));
    }
    private function _getSearchResultListCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
        
        SearchResult.list.clear();
        if (resultJSON.success == true )
        {
			var list:Array<SearchResultJSON> = resultJSON.data;
			for ( sr in list )
			{
				SearchResult.list.addItem( new SearchResult( sr ) );
			}
			
			/* WITH SATIC JSON DATAS */
			/*
			var end = Config.resultPageSize ;
			for ( i in 0...end )
			{
				SearchResult.list.addItem( new SearchResult( list[i] ) );
			}
			*/
			/************************/
			dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, getSearchResultList));
            return;
        }
        var error = "* ERROR - getSearchResultList *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
    
    
    public function insertDemandIntoPlanning(data:SearchResult):Void
    {
		//var http = new Http("./assets/tmp-datas/insert-demand-into-planning.json");
		var http = new Http( Config.servicesURL );
		http.onData = _insertDemandIntoPlanningCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "insert-demand-into-planning");
		http.addParameter("demand-id", Std.string(data.idDemand));
		http.request(true);
		/*
        var responder:Responder = new Responder(_insertDemandIntoPlanningCompleteHandler, _serviceErrorHandler);
        _service.call("SearchServices.insertDemandIntoPlanning", responder, data.idDemand);*/
    }
    private function _insertDemandIntoPlanningCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
        
        if (resultJSON.success == true )
        {
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, resultJSON.data, insertDemandIntoPlanning));
            return;
        }
        var error = "* ERROR - insertDemandIntoPlanning *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
    

    // DO SERVICES
    public function getDOList(user:User):Void
    {
		//var http = new Http("./assets/tmp-datas/get-do-list.json");
		var http = new Http( Config.servicesURL );
		http.onData = _getDOListCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "get-do-list");
		http.addParameter("user-id", Std.string(user.id));
		http.addParameter("user-type", Std.string(user.type));
		http.addParameter("owned-only", (Config.INIT_FLAG_PROG == FlagProg.OWNED) ? "true":"flase");
		http.request(true);
		/*
        var responder:Responder = new Responder(_getDOListCompleteHandler, _serviceErrorHandler);
        _service.call("DOServices.getDOList", responder, user.id, user.type, Std.string(Config.INIT_FLAG_PROG == FlagProg.OWNED));
		*/	
    }
    private function _getDOListCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
        
        DO.list.clear();
        if (resultJSON.success == true )
        {
			var list:Array<DOJSON> = resultJSON.data;
			for ( e in list)
			{
				DO.list.addItem( new DO( e ) );
			}
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, getDOList));
            return;
        }
        var error = "* ERROR - getDOList *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	
	
    public function getDOAvailablePeriodList(delegation:DO):Void
    {
		//var http = new Http("./assets/tmp-datas/get-do-available-period-list.json");
		var http = new Http(Config.servicesURL);
		http.onData = _getDOAvailablePeriodListCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "get-do-available-period-list" );
		http.addParameter("do-id", Std.string(delegation.id ) );
		http.request(true);
		/*
        trace("ServiceManager.getDOAvailablePeriodList > delegation:" + delegation.id);
        var responder:Responder = new Responder(_getDOAvailablePeriodListCompleteHandler, _serviceErrorHandler);
        _service.call("DOServices.getDOAvailablePeriodList", responder, delegation.id);*/
		
    }
    private function _getDOAvailablePeriodListCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
        
        if (resultJSON.success == true )
        {
            var newList:Collection<DOAvailablePeriod> = new Collection<DOAvailablePeriod>();
			var list:Array<DOAvailablePeriodJSON> = resultJSON.data;
			for ( o in list)
			{
				newList.addItem( new DOAvailablePeriod( o ) );
			}
			// needed in order to dispatch DataUpdaterEvent.DO_AVAILABLE_PERIOD_LIST_CHANGE event.
            DOAvailablePeriod.createList(newList);
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, getDOAvailablePeriodList));
            return;
        }
        var error = "* ERROR - getDOAvailablePeriodList *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	
	
    public function getDOOppositeOwner(delegation:DO, user:User):Void
    {		
		//var http = new Http("./assets/tmp-datas/get-do-opposite-owner.json");
		var http = new Http(Config.servicesURL);
		http.onData = _getDOOppositeOwnerCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "get-do-opposite-owner" );
		http.addParameter("do-id", Std.string(delegation.id ) );
		http.addParameter("user-type", Std.string(user.type) );
		http.request(true);
		/*
        trace("ServiceManager.getDOOppositeOwner > delegation:" + delegation + ", user:" + user);
        var responder:Responder = new Responder(_getDOOppositeOwnerCompleteHandler, _serviceErrorHandler);
        _service.call("DOServices.getDOOppositeOwner", responder, delegation.id, user.type);*/
    }
    private function _getDOOppositeOwnerCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
        
        OppositeOwner.list.clear();
        if (resultJSON.success == true )
        {
			var list:Array<OppositeOwnerJSON> = resultJSON.data;
			for ( e in list)
			{
				OppositeOwner.list.addItem( new OppositeOwner( e ) );
			}
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, getDOOppositeOwner));
            return;
        }
        var error = "* ERROR - getDOOppositeOwner *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	
	
	
    public function updateDOStatus(delegation:DO):Void
    {
		//var http = new Http("./assets/tmp-datas/update-do-status.json");
		var http = new Http(Config.servicesURL);
		http.onData = _updateDOStatusCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "update-do-status" );
		http.addParameter("do-id", Std.string(delegation.id) );
		http.addParameter("status-id", Std.string(delegation.idStatus) );
		http.request(true);
		/*
        var responder:Responder = new Responder(_updateDOStatusCompleteHandler, _serviceErrorHandler);
        _service.call("DOServices.updateDOStatus", responder, delegation.id, delegation.idStatus);*/
    }
    private function _updateDOStatusCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
        
        if (resultJSON.success == true )
        {
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, updateDOStatus));
            return;
        }
        var error = "* ERROR - updateDOStatus *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
    public function updateDONotes(delegation:DO):Void
    {
		//var http = new Http("./assets/tmp-datas/update-do-notes.json");
		var http = new Http(Config.servicesURL);
		http.onData = _updateDONotesCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "update-do-notes" );
		http.addParameter("do-id", Std.string(delegation.id) );
		http.addParameter("notes", Std.string(delegation.notes) );
		http.request(true);
		/*
        var responder:Responder = new Responder(_updateDONotesCompleteHandler, _serviceErrorHandler);
        _service.call("DOServices.updateDONotes", responder, delegation.id, delegation.notes);*/
    }
    private function _updateDONotesCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
        
        if (resultJSON.success == true )
        {
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, updateDONotes));
            return;
        }
        var error = "* ERROR - updateDONotes *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
    public function updateDOAvailablePeriod(doAP:DOAvailablePeriod):Void
    {
		//var http = new Http("./assets/tmp-datas/update-do-available-period.json");
		var http = new Http(Config.servicesURL);
		http.onData = _updateDOAvailablePeriodCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "update-do-available-period" );
		http.addParameter("av-period", doAP.getJSONRepresentation() );
		http.request(true);
        /*var responder:Responder = new Responder(_updateDOAvailablePeriodCompleteHandler, _serviceErrorHandler);
        _service.call("DOServices.updateDOAvailablePeriod", responder, doAP.getRemoteRepresentation());*/
    }
    private function _updateDOAvailablePeriodCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
        
        if (resultJSON.success == true )
        {
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, updateDOAvailablePeriod));
            return;
        }
        var error = "* ERROR - updateDOAvailablePeriod *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	
	
    public function registerProgUser(delegation:DO, user:User):Void
    {
		//var http = new Http("./assets/tmp-datas/register-prog-user.json");
		var http = new Http(Config.servicesURL);
		http.onData = _registerProgUserCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "register-prog-user" );
		http.addParameter("do-id", Std.string(delegation.id) );
		http.addParameter("user-id", Std.string(user.id) );
		http.request(true);
		/*
        var responder:Responder = new Responder(_registerProgUserCompleteHandler, _serviceErrorHandler);
        _service.call("DOServices.registerProgUser", responder, delegation.id, user.id);*/
    }
    private function _registerProgUserCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
        
        if (resultJSON.success == true )
        {
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, registerProgUser));
            return;
        }
        var error = "* ERROR - registerProgUser *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	
	//2022-evolution
    public function checkMultiUsers(delegation:DO, user:User):Void
    {
		// TODO !
		var http = new Http("./assets/tmp-datas/check-multi-users.json");
		//var http = new Http(Config.servicesURL);
		http.onData = _checkMultiUsersCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "check-multi-users" );
		http.addParameter("do-id", Std.string(delegation.id) );
		http.addParameter("user-id", Std.string(user.id) );
		http.request(true);
    }
    private function _checkMultiUsersCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
        
        if (resultJSON.success == true )
        {		
			var list:Array<MultiUsersDataJSON> = resultJSON.data;
			
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, list, checkMultiUsers));
            return;
        }
        var error = "* ERROR - checkMultiUsers *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	//----
    
    
    // PLANNING SERVICES
    
    // getPlanningList($idDO)
    public function getDOPlanningList(delegation:DO):Void
    {
		//var http = new Http("./assets/tmp-datas/get-do-planning-list.json");
		var http = new Http(Config.servicesURL);
		http.onData = _getDOPlanningListCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "get-do-planning-list" );
		http.addParameter("do-id", Std.string(delegation.id) );
		http.request(true);
		/*
        var responder:Responder = new Responder(_getDOPlanningListCompleteHandler, _serviceErrorHandler);
        _service.call("PlanningServices.getDOPlanningList", responder, delegation.id);*/
    }
    private function _getDOPlanningListCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
        
        Planning.list.clear();
        if (resultJSON.success == true )
        {
			var list:Array<PlanningJSON> = resultJSON.data;
			for ( p in list )
			{
				Planning.list.addItem( new Planning( p ) );
			}
            // Extraction du planning de travail et réaffectation à la premiere place dans la liste
            var workingPlanning:Planning = Planning.list.getItemBy("version", -1);
            if (workingPlanning != null)
            {
                Planning.list.removeItem(workingPlanning);
                Planning.list.addItemAt(workingPlanning, 0);
            }
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, getDOPlanningList));
            return;
        }
        var error = "* ERROR - getDOPlanningList *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	
	
	
	
	
	
    //saveDOPlanning( PlanningVO $p, $conDB = null )
    public function saveDOPlanning(planning:Planning):Void
    {
		//var http = new Http("./assets/tmp-datas/save-do-planning.json");
		var http = new Http( Config.servicesURL );
		http.onData = _saveDOPlanningCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "save-do-planning" );
		http.addParameter("planning", planning.getJSONRepresentation() );
		http.request(true);
		
		/*
        var responder:Responder = new Responder(_saveDOPlanningCompleteHandler, _serviceErrorHandler);
        _service.call("PlanningServices.saveDOPlanning", responder, planning.getRemoteRepresentation());
		*/
    }
    private function _saveDOPlanningCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
        
        if (resultJSON.success == true )
        {
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, saveDOPlanning));
            return;
        }
        var error = "* ERROR - saveDOPlanning *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
    
    //clearDOPlanning( PlanningVO $p )
    public function clearDOPlanning(planning:Planning):Void
    {
		//var http = new Http("./assets/tmp-datas/clear-do-planning.json");
		var http = new Http( Config.servicesURL );
		http.onData = _clearDOPlanningCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "clear-do-planning" );
		http.addParameter("planning", planning.getJSONRepresentation() );
		http.request(true);
		/*
        var responder:Responder = new Responder(_clearDOPlanningCompleteHandler, _serviceErrorHandler);
        _service.call("PlanningServices.clearDOPlanning", responder, planning.getRemoteRepresentation());*/
    }
    private function _clearDOPlanningCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
        
        if (resultJSON.success == true )
        {
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, clearDOPlanning));
            return;
        }
        var error = "* ERROR - clearDOPlanning *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
    
    
    // getDemandActivityList( $idDemand )
	public function getDemandActivityList(idDemand:Int = 0):Void
	{
		//var http = new Http("./assets/tmp-datas/get-demand-activity-list.json");
		var http = new Http(Config.servicesURL);
		http.onData = _getDemandActivityListCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "get-demand-activity-list" );
		http.addParameter("demand-id", Std.string( idDemand ) );
		http.request(true);
		
		/*
        var responder:Responder = new Responder(_getDemandActivityListCompleteHandler, _serviceErrorHandler);
        _service.call("PlanningServices.getDemandActivityList", responder, idDemand);
		*/
    }
    private function _getDemandActivityListCompleteHandler(result:Dynamic):Void
    {
		var resultJSON = Json.parse( result);
        
        if (resultJSON.success == true )
        {
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, resultJSON.data, getDemandActivityList ));
            return;
        }
        var error = "* ERROR - getDemandActivityList *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	
	
	
    
    // getDOVisitList($idDO, $idPlanning, $userType)
    public function getDOVisitList(delegation:DO, planning:Planning, user:User):Void
    {
		//var http = new Http("./assets/tmp-datas/get-do-visit-list.json");
		var http = new Http(Config.servicesURL);
		http.onData = _getDOVisitListCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "get-do-visit-list" );
		http.addParameter("do-id", Std.string(delegation.id) );
		http.addParameter("planning-id", Std.string(planning.id) );
		http.addParameter("user-type", Std.string(user.type) );
		http.addParameter("lang", Config.LANG );
		http.request(true);
		/*
        var responder:Responder = new Responder(_getDOVisitListCompleteHandler, _serviceErrorHandler);
        _service.call("PlanningServices.getDOVisitList", responder, delegation.id, planning.id, user.type, Config.getLangForPHPServices());
		*/
    }
	
    private function _getDOVisitListCompleteHandler(result:Dynamic):Void
    {
		var resultJSON = Json.parse( result);
        
        Visit.list.clear();
        if (resultJSON.success == true )
        {
            var newList:Collection<Visit> = new Collection<Visit>();
			var list:Array<VisitJSON> = resultJSON.data;
            for ( o in list )
            {
                newList.addItem(new Visit(o));
            }
			// needed in order to dispatch DataUpdaterEvent.DO_VISIT_LIST_CHANGE event.
            Visit.createList(newList);
			
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, getDOVisitList));
            return;
        }
        var error = "* ERROR - getDOVisitList *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	
	
    // getDOPendingVisitList($idDO, $idPlanning, $userType)
    public function getDOPendingVisitList(delegation:DO, planning:Planning, user:User):Void
    {	
		//var http = new Http("./assets/tmp-datas/get-do-pendingvisit-list.json?7454");
		var http = new Http(Config.servicesURL);
		http.onData = _getDOPendingVisitListCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "get-do-pendingvisit-list" );
		http.addParameter("do-id", Std.string(delegation.id) );
		http.addParameter("planning-id", Std.string(planning.id) );
		http.addParameter("user-type", Std.string(user.type) );
		http.addParameter("lang", Config.LANG );
		http.request(true);
		
		/*
        var responder:Responder = new Responder(_getDOPendingVisitListCompleteHandler, _serviceErrorHandler);
        _service.call("PlanningServices.getDOPendingVisitList", responder, delegation.id, planning.id, user.type, Config.getLangForPHPServices());
        //_service.call("PlanningServices.getDOPendingVisitList", responder, delegation.id, planning.id, user.type );
        dispatchEvent(new ServiceEvent(ServiceEvent.START, null, getDOPendingVisitList));
		*/
    }
    private function _getDOPendingVisitListCompleteHandler(result:Dynamic):Void
    {
		var resultJSON = Json.parse( result);
        
        PendingVisit.list.clear();
        if (resultJSON.success == true )
        {
			var list:Array<VisitJSON> = resultJSON.data;
            for ( o in list )
            {
                PendingVisit.list.addItem(new PendingVisit(o));
            }	
			
			//TO KEEP : in case PendingVisit.createList was really needed...
            /*
			var newList:Collection<PendingVisit> = new Collection<PendingVisit>();
			var list:Array<VisitJSON> = Json.parse( result);
            for ( o in list )
            {
                newList.addItem(new PendingVisit(o));
            }
            PendingVisit.createList(newList);
			*/		
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, getDOPendingVisitList));
            return;
        }
        var error = "* ERROR - getDOPendingVisitList *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	
    // removeDOVisitList( array $visitList )
    public function clearDOPendingVisitList(pendingVisitList:Collection<PendingVisit>):Void
    {
		//var http = new Http("./assets/tmp-datas/remove-do-visit-list.json");
		var http = new Http( Config.servicesURL );
		http.onData = _clearDOPendingVisitListCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "remove-do-visit-list" );
		var vList:Array<VisitJSON> = new Array<VisitJSON>();
		for ( pv in pendingVisitList )
		{
			vList.push( pv.relatedVisit.getJSONRepresentation() );
		}
		http.addParameter("visit-list", Json.stringify(vList) );
		http.request(true);
		/*
        var responder:Responder = new Responder(_clearDOPendingVisitListCompleteHandler, _serviceErrorHandler);
        var visitList:Array<Dynamic> = new Array<Dynamic>();
        var i:Int = -1;
        while (++i < pendingVisitList.length)
        {
            visitList.push(cast((pendingVisitList.getItemAt(i)), PendingVisit).relatedVisit.getRemoteRepresentation());
        }
        _service.call("PlanningServices.removeDOVisitList", responder, visitList);*/
    }
    private function _clearDOPendingVisitListCompleteHandler(result:Dynamic):Void
    {
		var resultJSON = Json.parse( result);
        
        if (resultJSON.success == true )
        {
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, clearDOPendingVisitList ));
            return;
        }
        var error = "* ERROR - clearDOPendingVisitList *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
    
    // Gestion Notifications
    public function throwNotification(user:User, delegation:DO, action:NotificationAction):Void
    {
        var actor:String = user.type;
        var target:String = "do";
        var id:Int = delegation.id;
        var action:String = action;
        
        var uv:URLVariables = new URLVariables();
        uv.actor = actor;
        uv.cible = target;
        uv.id = id;
        uv.action = action;
        
        var ur:URLRequest = new URLRequest();
        ur.url = Config.notificationsURL;
        ur.method = URLRequestMethod.GET;
        ur.data = uv;
        
        var ul:URLLoader = new URLLoader();
        ul.addEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler);
        ul.load(ur);
    }
    
    private function _ioErrorHandler(e:IOErrorEvent):Void
    {
		trace( "throwNotification ServiceManager._ioErrorHandler : " + e.text );
    }
	
	
	//checkExhibitorAvailability( $idExhibitor, $idCurrentVisit, $startDateString, $endDateString )
    public function checkExhibitorAvailability(idExhibitor:Int, idCurrentVisit:Int, startDate:Date, endDate:Date):Void
	{
		//var http = new Http("./assets/tmp-datas/check-exhibitor-availability.json");
		var http = new Http( Config.servicesURL );
		http.onData = _checkExhibitorAvailabilityCompleteHandler;
		http.onError = _serviceErrorHandler2;
		
		http.addParameter("action", "check-exhibitor-availability" );
		http.addParameter("exhibitor-id", Std.string( idExhibitor ) );
		http.addParameter("visit-id", Std.string( idCurrentVisit ) );
		http.addParameter("start-date", DateUtils.toDBString(startDate) );
		http.addParameter("end-date", DateUtils.toDBString( endDate ) );
		http.request(true);
		
		
		/*
		var responder:Responder = new Responder(_checkExhibitorAvailabilityCompleteHandler, _serviceErrorHandler);
        var startDateString:String = Utils.getDBStringFromDate(startDate);
        var endDateString:String = Utils.getDBStringFromDate(endDate);
        _service.call("PlanningServices.checkExhibitorAvailability", responder, idExhibitor, idCurrentVisit, startDateString, endDateString);
		*/
    }
    private function _checkExhibitorAvailabilityCompleteHandler(result:Dynamic):Void
    {
		var resultJSON = Json.parse( result);
		
		//resultJSON.data has the form :
		//{
		//	"isAvailable":false,
		//	"DOList":[],
		//	"availabilityList":[]
		//}
		
        if (resultJSON.success == true )
        {			
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, resultJSON.data, checkExhibitorAvailability));
            return;
        }
        var error = "* ERROR - checkExhibitorAvailability *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
    
    
    //saveDOVisit($visit)
    public function saveDOVisit(visit:Visit):Void
    {
		//trace( "ServiceManager.saveDOVisit > visit : " + visit );
		//var http = new Http("./assets/tmp-datas/save-do-visit.json");
		var http = new Http(Config.servicesURL);
		http.onData = _saveDOVisitCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "save-do-visit" );
		http.addParameter("visit", Json.stringify(visit.getJSONRepresentation()) );
		http.addParameter("lang", Config.LANG );
		http.request(true);
		//TODO:
		/*
        var responder:Responder = new Responder(_saveDOVisitCompleteHandler, _serviceErrorHandler);
        _service.call("PlanningServices.saveDOVisit", responder, visit.getRemoteRepresentation(), Config.getLangForPHPServices());
		*/
    }
    private function _saveDOVisitCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
		
        if (resultJSON.success == true )
        {			
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, saveDOVisit));
            return;
        }
        var error = "* ERROR - saveDOVisit *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
    
    //saveDOVisitSerie( array $visitIdList, $newStartDate, $newEndDate )
    public function saveDOVisitSerie(visitIdList:Array<Int>, newPeriod:Period):Void
    {
		//var http = new Http("./assets/tmp-datas/save-do-visit-serie.json");
		var http = new Http(Config.servicesURL);
		http.onData = _saveDOVisitSerieCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "save-do-visit-serie" );
		http.addParameter("visit-id-list", Json.stringify(visitIdList) );
		http.addParameter("new-start-date", DateUtils.toDBString(newPeriod.startDate) );
		http.addParameter("new-end-date", DateUtils.toDBString(newPeriod.endDate) );
		http.request(true);
		/*
        var responder:Responder = new Responder(_saveDOVisitSerieCompleteHandler, _serviceErrorHandler);
        _service.call("PlanningServices.saveDOVisitSerie", responder, visitIdList, DateUtils.toDBString(newPeriod.startDate), DateUtils.toDBString(newPeriod.endDate));*/
    }
    private function _saveDOVisitSerieCompleteHandler(result:Dynamic):Void
    {
		var resultJSON = Json.parse( result);
		
        if (resultJSON.success == true )
        {			
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, resultJSON.data, saveDOVisitSerie));
            return;
        }
        var error = "* ERROR - saveDOVisitSerie *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
    
    //setDOVisitStandBy( VisitVO $v, $isStandBy )
    public function setDOVisitStandBy(visit:Visit, isStandBy:Bool):Void
    {
		//var http = new Http("./assets/tmp-datas/set-do-visit-standby.json");
		var http = new Http( Config.servicesURL );
		http.onData = _setDOVisitStandByCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "set-do-visit-standby" );
		http.addParameter("visit", Json.stringify(visit.getJSONRepresentation()) );
		http.addParameter("is-stand-by", Std.string(isStandBy) );
		http.request(true);
		/*
        var responder:Responder = new Responder(_setDOVisitStandByCompleteHandler, _serviceErrorHandler);
        _service.call("PlanningServices.setDOVisitStandBy", responder, visit.getRemoteRepresentation(), isStandBy);*/
    }
    private function _setDOVisitStandByCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
		
        if (resultJSON.success == true )
        {			
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, setDOVisitStandBy));
            return;
        }
        var error = "* ERROR - setDOVisitStandBy *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	
	
    //checkVisitSerie( $idExhibitor, $idCurrentVisit, $startDateString, $endDateString, $idSpecialVisit, $visitName )
    public function checkVisitSerie(idExhibitor:Int, idCurrentVisit:Int, startDate:Date, endDate:Date, idSpecialVisit:Int, visitName:String):Void
    {
		//var http = new Http("./assets/tmp-datas/check-visit-serie.json");
		var http = new Http( Config.servicesURL );
		http.onData = _checkVisitSerieCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "check-visit-serie" );
		http.addParameter("exhibitor-id", Std.string( idExhibitor ) );
		http.addParameter("visit-id", Std.string( idCurrentVisit ) );
		http.addParameter("start-date", DateUtils.toDBString( startDate ) );
		http.addParameter("end-date", DateUtils.toDBString( endDate ) );
		http.addParameter("special-visit-id", Std.string( idSpecialVisit ) );
		http.addParameter("visit-name", visitName );
		http.request(true);
		
		
		/*
        var responder:Responder = new Responder(_checkVisitSerieCompleteHandler, _serviceErrorHandler);
        var startDateString:String = Utils.getDBStringFromDate(startDate);
        var endDateString:String = Utils.getDBStringFromDate(endDate);
        _service.call("PlanningServices.checkVisitSerie", responder, idExhibitor, idCurrentVisit, startDateString, endDateString, idSpecialVisit, visitName);*/
    }
    private function _checkVisitSerieCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
		
        if (resultJSON.success == true )
        {			
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, resultJSON.data, checkVisitSerie));
            return;
        }
        var error = "* ERROR - checkVisitSerie *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	
    //removeDOVisit($visit)
    public function removeDOVisit(visit:Visit):Void
    {
		//var http = new Http("./assets/tmp-datas/remove-do-visit.json");
		var http = new Http( Config.servicesURL );
		http.onData = _removeDOVisitCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "remove-do-visit" );
		http.addParameter("visit", Json.stringify(visit.getJSONRepresentation()) );
		http.request(true);
		/*
        var responder:Responder = new Responder(_removeDOVisitCompleteHandler, _serviceErrorHandler);
        _service.call("PlanningServices.removeDOVisit", responder, visit.getRemoteRepresentation());
		*/
    }
    private function _removeDOVisitCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
		
        if (resultJSON.success == true )
        {			
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, removeDOVisit));
            return;
        }
        var error = "* ERROR - removeDOVisit *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	
    //removeDOVisitSerie($visitIdList)
    public function removeDOVisitSerie(visitIdList:Array<Int>):Void
    {
		//var http = new Http("./assets/tmp-datas/remove-do-visit-serie.json");
		var http = new Http( Config.servicesURL );
		http.onData = _removeDOVisitSerieCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "remove-do-visit-serie" );
		http.addParameter("visit-id-list", Json.stringify( visitIdList ) );
		http.request(true);
		/*
        var responder:Responder = new Responder(_removeDOVisitSerieCompleteHandler, _serviceErrorHandler);
        _service.call("PlanningServices.removeDOVisitSerie", responder, visitIdList);
		*/
    }
    private function _removeDOVisitSerieCompleteHandler(result:Dynamic)
    {
		var resultJSON = Json.parse( result);
		
        if (resultJSON.success == true )
        {			
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, removeDOVisitSerie));
            return;
        }
        var error = "* ERROR - removeDOVisitSerie *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	
	
    //duplicateDOVisit( VisitVO visit, array $doIdList )
    public function duplicateDOVisit(visit:Visit, doList:Collection<DO>):Void
    {        
		//var http = new Http("./assets/tmp-datas/duplicate-do-visit.json");
		var http = new Http( Config.servicesURL );
		http.onData = _duplicateDOVisitCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "duplicate-do-visit" );
		http.addParameter("visit", Json.stringify(visit.getJSONRepresentation()) );
		
		var list:Array<String> = new Array<String>();
		for ( d in doList )
		{
			list.push( Std.string(d.id) );
		}
		http.addParameter("do-id-list", Json.stringify( list ) );
		http.request(true);
        
		/*
        var responder:Responder = new Responder(_duplicateDOVisitCompleteHandler, _serviceErrorHandler);
        var list:Array<Dynamic> = new Array<Dynamic>();
        var i:Int = -1;
        while (++i < doList.length)
        {
            list.push(doList.getItemAt(i).id);
        }
        
        _service.call("PlanningServices.duplicateDOVisit", responder, visit.getRemoteRepresentation(), list);*/
    }
    private function _duplicateDOVisitCompleteHandler(result:Dynamic):Void
    {	
		var resultJSON = Json.parse( result);
		
        if (resultJSON.success == true )
        {			
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, resultJSON.data, duplicateDOVisit));
            return;
        }
        var error = "* ERROR - duplicateDOVisit *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	
	//2022-evolution
	//duplicateVisitOnWorkingPlanning( VisitVO visit )
    public function duplicateVisitOnWorkingPlanning(visit:Visit):Void
    {
		//TODO
		var http = new Http("./assets/tmp-datas/duplicate-visit-on-working-planning.json");
		//var http = new Http( Config.servicesURL );
		http.onData = _duplicateVisitOnWorkingPlanningCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "duplicate-visit-on-working-planning" );
		http.addParameter("visit", Json.stringify(visit.getJSONRepresentation()) );
		/*
		var list:Array<String> = new Array<String>();
		for ( d in doList )
		{
			list.push( Std.string(d.id) );
		}
		http.addParameter("do-id-list", Json.stringify( list ) );*/
		http.request(true);
    }
    private function _duplicateVisitOnWorkingPlanningCompleteHandler(result:Dynamic):Void
    {	
		var resultJSON = Json.parse( result);
		
        if (resultJSON.success == true )
        {			
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, resultJSON.data, duplicateVisitOnWorkingPlanning));
            return;
        }
        var error = "* ERROR - duplicateVisitOnWorkingPlanning *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	//---------
	
	
    
    //createNewDOPlanningVersion(PlanningVO $p, array $visitList, $lang, $conDB = null )
    public function createNewDOPlanningVersion(planning:Planning, visitList:Collection<Visit>):Void
    {
		//var http = new Http("./assets/tmp-datas/create-new-do-planning-version.json");
		var http = new Http( Config.servicesURL );
		http.onData = _createNewDOPlanningVersionCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "create-new-do-planning-version" );
		http.addParameter("planning", planning.getJSONRepresentation() );
		//var vList:Array<String> = new Array<String>();
		var vList:Array<VisitJSON> = new Array<VisitJSON>();
		for ( v in visitList )
		{
			vList.push( v.getJSONRepresentation() );
		}
		http.addParameter("visit-list", Json.stringify(vList) );
		http.addParameter("lang", Config.LANG );
		http.request(true);
		/*
        var responder:Responder = new Responder(_createDOPlanningCompleteHandler, _serviceErrorHandler);
        var pVO:PlanningVO = planning.getRemoteRepresentation();
        var vList:Array<Dynamic> = new Array<Dynamic>();
        var i:Int = -1;
        while (++i < Visit.list.length)
        {
            vList.push(cast((Visit.list.getItemAt(i)), Visit).getRemoteRepresentation());
        }
        
        _service.call("PlanningServices.createNewDOPlanningVersion", responder, pVO, vList, Config.getLangForPHPServices());*/
    }
    private function _createNewDOPlanningVersionCompleteHandler(result:Dynamic):Void
    {
		var resultJSON = Json.parse( result);
		
        if (resultJSON.success == true )
        {			
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, resultJSON.data, createNewDOPlanningVersion));
            return;
        }
        var error = "* ERROR - createNewDOPlanningVersion *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	
    //extractOldDOPlanning( PlanningVO $p )
    public function extractOldPlanning(planning:Planning):Void
    {
		//var http = new Http("./assets/tmp-datas/extract-old-do-planning.json");
		var http = new Http( Config.servicesURL );
		http.onData = _extractOldPlanningCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "extract-old-do-planning" );
		http.addParameter("planning", planning.getJSONRepresentation() );
		http.request(true);
		/*
        var responder:Responder = new Responder(_extractOldPlanningCompleteHandler, _serviceErrorHandler);
        var pVO:PlanningVO = planning.getRemoteRepresentation();
        _service.call("PlanningServices.extractOldDOPlanning", responder, pVO);*/
    }
    private function _extractOldPlanningCompleteHandler(result:Dynamic):Void
    {
		var resultJSON = Json.parse( result);
		
        if (resultJSON.success == true )
        {			
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, extractOldPlanning));
            return;
        }
        var error = "* ERROR - extractOldPlanning *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	
	
	
		
	
	
    //duplicateDOPlanning( $idTargetDO, array $visitList, $lang )
    public function duplicateDOPlanning(visitList:Collection<Visit>, pendingVisitList:Collection<PendingVisit>, targetDO:DO):Void
    {	
		//var http = new Http("./assets/tmp-datas/duplicate-do-planning.json");
		var http = new Http( Config.servicesURL );
		http.onData = _duplicateDOPlanningCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "duplicate-do-planning" );
		http.addParameter("target-do-id", Std.string(targetDO.id) );
		//var vList:Array<String> = new Array<String>();
		var vList:Array<VisitJSON> = new Array<VisitJSON>();
		for ( v in visitList )
		{
			vList.push( v.getJSONRepresentation() );
		}
		for ( pv in pendingVisitList )
		{
			vList.push( pv.relatedVisit.getJSONRepresentation() );
		}
		http.addParameter("visit-list", Json.stringify(vList) );
		http.addParameter("lang", Config.LANG );
		http.request(true);
	
	
	/*
        var responder:Responder = new Responder(_duplicateDOPlanningCompleteHandler, _serviceErrorHandler);
        var vList:Array<Dynamic> = new Array<Dynamic>();
        var i:Int = -1;
        while (++i < visitList.length)
        {
            vList.push(visitList.getItemAt(i).getRemoteRepresentation());
        }
        
        i = -1;
        while (++i < pendingVisitList.length)
        {
            vList.push(pendingVisitList.getItemAt(i).relatedVisit.getRemoteRepresentation());
        }
        
        _service.call("PlanningServices.duplicateDOPlanning", responder, targetDO.id, vList, Config.getLangForPHPServices());
    */
    }
    private function _duplicateDOPlanningCompleteHandler(result:Dynamic):Void
    {
		var resultJSON = Json.parse( result);
		
        if (resultJSON.success == true )
        {			
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, duplicateDOPlanning));
            return;
        }
        var error = "* ERROR - duplicateDOPlanning *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
    
    
    // MESSAGES SERVICES
    public function getUserMessageList(user:User, oppositeOwnerList:Collection<OppositeOwner>, delegation:DO):Void
    {    
		//var http = new Http("./assets/tmp-datas/get-user-message-list.json");
		var http = new Http( Config.servicesURL );
		http.onData = _getUserMessageListCompleteHandler;
		http.onError = _serviceErrorHandler2;
		
		//var oList:Array<String> = new Array<String>();
		var oList:Array<OppositeOwnerJSON> = new Array<OppositeOwnerJSON>();
        for ( o in oppositeOwnerList)
        {
            oList.push( o.getJSONRepresentation() );
        }
		
		http.addParameter("action", "get-user-message-list");
		http.addParameter("user-id", Std.string(user.id ));
		http.addParameter("oo-list", Json.stringify(oList) );
		http.addParameter("do-id", Std.string(delegation.id ) );
		http.request(true);
	
		/*
        var responder:Responder = new Responder(_getUserMessageListCompleteHandler, _serviceErrorHandler);
        
        var oList:Array<Dynamic> = new Array<Dynamic>();
        var i:Int = -1;
        while (++i < oppositeOwnerList.length)
        {
            oList.push(cast((oppositeOwnerList.getItemAt(i)), OppositeOwner).getRemoteRepresentation());
        }
        
        _service.call("MessageServices.getUserMessageList", responder, user.id, oList, delegation.id);*/
    }
    private function _getUserMessageListCompleteHandler(result:Dynamic):Void
    {
		var resultJSON = Json.parse( result);
        
        Message.list.clear();
        if (resultJSON.success == true )
        {
			var list:Array<MessageJSON> = resultJSON.data;
			for ( m in list )
			{
				Message.list.addItem( new Message( m ) );
			}
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, getUserMessageList));
            return;
        }
        var error = "* ERROR - getUserMessageList *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
	
    // saveUserMessage(Message $m, $userType)
    public function saveUserMessage(message:MessageJSON, user:User):Void
    {
		//var http = new Http("./assets/tmp-datas/save-user-message.json");
		var http = new Http( Config.servicesURL );
		http.onData = _saveUserMessageCompleteHandler;
		http.onError = _serviceErrorHandler2;
		http.addParameter("action", "save-user-message" );
		http.addParameter("message", Json.stringify( message) );
		http.addParameter("user-type", Std.string(user.type) );
		http.request(true);
		/*
        var responder:Responder = new Responder(_saveUserMessageCompleteHandler, _serviceErrorHandler);
        _service.call("MessageServices.saveUserMessage", responder, message, user.type);*/
    }
    private function _saveUserMessageCompleteHandler(result:Dynamic):Void
    {
		var resultJSON = Json.parse( result);
        
        if (resultJSON.success == true )
        {
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, null, saveUserMessage));
            return;
        }
        var error = "* ERROR - saveUserMessage *\n\n" + resultJSON.message;
        _serviceErrorHandler2(error);
    }
    
    
    
    
    
    
    
    
    
    /*
    private function _serviceCompleteHandler(result:Dynamic)
    {
        dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, result));
    }
    
    
    private function _serviceErrorHandler(o:Dynamic)
    {
        for (i in Reflect.fields(o))
        {
            trace("key:" + i + ", value:" + Reflect.field(o, i));
        }
        
        if (!o.description)
        {
            var description:String = "";
            for (j in Reflect.fields(o))
            {
                description += j.toUpperCase() + ":" + Reflect.field(o, j) + "\n";
            }
            o.description = description;
        }
        
        DialogManager.instance.open( new MessageDialog( "", o.description ) );
        
    }*/
    private function _serviceErrorHandler2(message:String)
    {        
        DialogManager.instance.open( new VMErrorDialog("Error Dialog title", message ) );        
    }
}




/****************************
 * ** TEMPLATE*******
 * **********************/
/*
	public function ______MainMethod______ (  arg:Type):Void
	{
		var http = new Http("./assets/tmp-datas/_________________.json");
		http.onData = ________ResultHandler_________;
		http.onError = _serviceErrorHandler2;
		http.addParameter("________", _________ );
		
		var list:Array<String> = new Array<String>();
		for ( o in argList )
		{
			list.push( o.getJSONRepresentation() );
		}
		http.addParameter("_________", list.toString() );
		http.addParameter("lang", Config.LANG );
		http.request(true);
		
		
		//
		//OLD STUFF
		//
    }
    private function ________ResultHandler_________(result:Dynamic):Void
    {
		var resultJSON = Json.parse( result);
        
        if (resultJSON.success == true )
        {
            dispatchEvent(new ServiceEvent(ServiceEvent.COMPLETE, resultJSON.data, ______MainMethod______ ));
            return;
        }
        var error = "* ERROR - ______MainMethod______ *";
        _serviceErrorHandler2(error);
    }
*/