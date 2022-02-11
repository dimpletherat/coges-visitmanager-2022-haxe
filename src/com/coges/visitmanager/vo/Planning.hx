
package com.coges.visitmanager.vo;

import com.coges.visitmanager.datas.DataUpdater;
import com.coges.visitmanager.datas.DataUpdaterEvent;
import haxe.Json;
import nbigot.utils.Collection;
import nbigot.utils.DateUtils;

/**
	 * ...
	 * @author Nicolas Bigot
	 */

	 
	 
	 
typedef PlanningJSON = {	
	var id:Int;
	var version:Int;
	var idDO:Int;
	var label:String;
	var dateCreaString:String;
	var dateEditString:String;
}
	 
	 
	 
class Planning
{
    public var id(get, never):Int;
    public var idDO(get, never):Int;
    public var version(get, never):Int;
    public var label(get, never):String;
    public var labelAndDate(get, never):String;
    public var dateCrea(get, set):Date;
    public var dateCreaString(get, set):String;
    public var dateEdit(get, never):Date;
    public var dateEditString(get, set):String;
    public var isLocked(get, never):Bool;
    public static var list(get, never):Collection<Planning>;
    public static var selected(get, set):Planning;

    private var _id:Int;
    private function get_id():Int
    {
        return _id;
    }
    
    private var _idDO:Int;
    private function get_idDO():Int
    {
        return _idDO;
    }
    
    private var _version:Int;
    private function get_version():Int
    {
        return _version;
    }
    
    private var _label:String;
    private var _localizedLabel:String;
    private function get_label():String
    {
        return _localizedLabel;
    }
    private function get_labelAndDate():String
    {
        //return _localizedLabel + " - " + DateFormat.toCompleteString(_dateCrea, "/");
        return _localizedLabel + " - " + DateUtils.toString(_dateCrea, "DD/MM/YYYY hh:mm:ss");
    }
    
    private var _dateCrea:Date;
    private function get_dateCrea():Date
    {
        return _dateCrea;
    }
    private function set_dateCrea(value:Date):Date
    {
        _dateCrea = value;
        _dateCreaString = DateUtils.toDBString(_dateCrea);
        //_dateCreaString = Utils.getDBStringFromDate(_dateCrea);
        //trace("set dateCrea:" + _dateCreaString);
        return value;
    }
    private var _dateCreaString:String;
    private function get_dateCreaString():String
    {
        return _dateCreaString;
    }
    private function set_dateCreaString(value:String):String
    {
        //trace("set dateCreaString:" + value);
        _dateCreaString = value;
        _dateCrea = DateUtils.fromDBString(_dateCreaString);
        //_dateCrea = Utils.getDateFromDBString(_dateCreaString);
        return value;
    }
    
    private var _dateEdit:Date;
    private function get_dateEdit():Date
    {
        return _dateEdit;
    }
    private var _dateEditString:String;
    private function get_dateEditString():String
    {
        return _dateEditString;
    }
    
    
    private function set_dateEditString(value:String):String
    {
        _dateEditString = value;
        _dateEdit = DateUtils.fromDBString(_dateEditString);
        //_dateEdit = Utils.getDateFromDBString(_dateEditString);
        return value;
    }
    /*
		private var _lockedForEditDOAvailablePeriod:Boolean = false;
		public function set lockedForEditDOAvailablePeriod( value :Boolean )
		{
			_lockedForEditDOAvailablePeriod = value;
		}*/
    
    private function get_isLocked():Bool
    {
        return ((_version >= 0)  /* || _lockedForEditDOAvailablePeriod*/  );
    }
    
    public function getJSONRepresentation():String
    {
        var json:PlanningJSON = {
			id:_id,
			version:_version,
			idDO:_idDO,
			label:_label,
			dateCreaString:_dateCreaString,
			dateEditString:_dateEditString
		}
        return Json.stringify( json );
    }
    
    public function new(json:PlanningJSON)
    {
        _id = json.id;
        _idDO = json.idDO;
        _version = json.version;
        _label = json.label;
        _localizedLabel = StringTools.replace(_label, "Travail", _localizedWorkingLabel);
        _localizedLabel = StringTools.replace(_localizedLabel, "Version", _localizedSavedLabel);
        _dateCreaString = json.dateCreaString;
        _dateCrea = DateUtils.fromDBString(_dateCreaString);
        //_dateCrea = Utils.getDateFromDBString(_dateCreaString);
        _dateEditString = json.dateEditString;
        _dateEdit = DateUtils.fromDBString(_dateEditString);
        //_dateEdit = Utils.getDateFromDBString(_dateEditString);
    }
    
    private static var _localizedWorkingLabel:String;
    private static var _localizedSavedLabel:String;
    public static function initLocalizedLabels(localizedWorkingLabel:String, localizedSavedLabel:String):Void
    {
        _localizedSavedLabel = localizedSavedLabel;
        _localizedWorkingLabel = localizedWorkingLabel;
    }
    public static function createNewPlanning(id:Int = 0, idDO:Int = 0, version:Int = 0, label:String = "", dateCreaString:String = "", dateEditString:String = ""):Planning
    {
        var json:PlanningJSON = {id:id, idDO:idDO, version:version, label:label, dateCreaString:dateCreaString, dateEditString:dateEditString};
		
        var p:Planning = new Planning(json);
        list.addItem(p);
        return p;
    }
    
    private static var _list:Collection<Planning>;
    private static function get_list():Collection<Planning>
    {
        if (_list == null)
        {
            _list = new Collection<Planning>();
        }
        return _list;
    }
    private static var _selected:Planning;
    private static function set_selected(value:Planning):Planning
    {
        _selected = value;
        DataUpdater.instance.dispatchEvent(new DataUpdaterEvent(DataUpdaterEvent.PLANNING_SELECTED_CHANGE));
        return value;
    }
    private static function get_selected():Planning
    {
        return _selected;
    }
}

