package com.coges.visitmanager.vo;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Config;
import com.coges.visitmanager.core.Icons;
import nbigot.utils.Collection;
import com.coges.visitmanager.core.Locale;
import openfl.display.DisplayObject;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class VisitStatus
{
    public var id(default, null):VisitStatusID;
    public var label(default, null):String;
    public var colorLight(default, null):Int;
    public var colorDark(default, null):Int;
    public var icon(get, null):DisplayObject;
    
    
    private var _idIcon:Icon;
    private function get_icon():DisplayObject
    {
        return Icons.getIcon(_idIcon);
    }
    
    public function new(id:VisitStatusID, label:String, colorLight:Int, colorDark:Int, idIcon:Icon)
    {
        this.id = id;
        this.label = label;
        this.colorLight = colorLight;
        this.colorDark = colorDark;
        _idIcon = idIcon;
    }
    
    public static var list(get, null):Collection<VisitStatus>;
    private static function get_list():Collection<VisitStatus>
    {
		//TODO:
		// check status with client, change colors  
        if (list == null)
        {
            list = new Collection<VisitStatus>();
            /*list.addItem(new VisitStatus(VisitStatusID.ACCEPTED_FRANCE, Locale.get("VISIT_STATUS_ACCEPTED_FRANCE"), Config.COLOR_GREEN_LIGHT, Config.COLOR_GREEN_DARK, Icon.VISIT_STATUS_ACCEPTED));
            list.addItem(new VisitStatus(VisitStatusID.ACCEPTED, Locale.get("VISIT_STATUS_ACCEPTED"), Config.COLOR_DARKGREEN_LIGHT, Config.COLOR_DARKGREEN_DARK, Icon.VISIT_STATUS_ACCEPTED));
            list.addItem(new VisitStatus(VisitStatusID.PENDING, Locale.get("VISIT_STATUS_PENDING"), Config.COLOR_ORANGE_LIGHT, Config.COLOR_ORANGE_DARK, Icon.VISIT_STATUS_PENDING));
            list.addItem(new VisitStatus(VisitStatusID.CANCELED, Locale.get("VISIT_STATUS_CANCELED"), Config.COLOR_RED_LIGHT, Config.COLOR_RED_DARK, Icon.VISIT_STATUS_CANCELED));
            list.addItem(new VisitStatus(VisitStatusID.LOCKED, Locale.get("VISIT_STATUS_LOCKED"), Config.COLOR_WHITE_LIGHT, Config.COLOR_WHITE_DARK, Icon.VISIT_STATUS_LOCKED));
            list.addItem(new VisitStatus(VisitStatusID.LOCKED_OFFICIAL, Locale.get("VISIT_STATUS_LOCKED"), Config.COLOR_GREY_LIGHT, Config.COLOR_GREY_DARK, Icon.VISIT_STATUS_LOCKED));*/
            list.addItem(new VisitStatus(VisitStatusID.ACCEPTED_FRANCE, Locale.get("VISIT_STATUS_ACCEPTED_FRANCE"), Colors.GREEN2, Colors.GREEN2_DARK, Icon.VISIT_STATUS_ACCEPTED));
            list.addItem(new VisitStatus(VisitStatusID.ACCEPTED, Locale.get("VISIT_STATUS_ACCEPTED"), Colors.GREEN1, Colors.GREEN1_DARK, Icon.VISIT_STATUS_ACCEPTED));
            list.addItem(new VisitStatus(VisitStatusID.PENDING, Locale.get("VISIT_STATUS_PENDING"), Colors.ORANGE, Colors.ORANGE_DARK, Icon.VISIT_STATUS_PENDING));
            list.addItem(new VisitStatus(VisitStatusID.CANCELED, Locale.get("VISIT_STATUS_CANCELED"), Colors.RED1, Colors.RED2, Icon.VISIT_STATUS_CANCELED));
            list.addItem(new VisitStatus(VisitStatusID.LOCKED, Locale.get("VISIT_STATUS_LOCKED"), Colors.GREY1, Colors.GREY3, Icon.VISIT_STATUS_LOCKED));
            list.addItem(new VisitStatus(VisitStatusID.LOCKED_OFFICIAL, Locale.get("VISIT_STATUS_LOCKED"), Colors.GREY2, Colors.GREY4, Icon.VISIT_STATUS_LOCKED));
        }
        return list;
    }
    public static function getVisitStatusByID(idStatus:VisitStatusID):VisitStatus
    {
        return list.getItemBy("id", idStatus);
    }
}

