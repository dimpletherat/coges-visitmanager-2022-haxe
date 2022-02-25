package com.coges.visitmanager.core;

import format.SVG;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;

using com.coges.visitmanager.core.SVGExtender;

/**
	 * ...
	 * @author Nicolas Bigot
	 */

enum abstract Icon(String) from String to String{
	//Menu
	var BACK = "back.png";
	var INFO = "info.png";
	var ADD_DO_NOTES = "add-do-note.png";
	var DO_STATUS_FULLY_CONFIRMED = "do-status-fully-confirmed.png";
	var DO_STATUS_INTENDED = "do-status-confirmed.png";
	var DO_STATUS_CONFIRMED = "do-status-intended.png";
	var DO_STATUS_CANCELED = "do-status-canceled.png";
	var EDIT_AVAILABLE_PERIOD = "edit-do-available-period.png";
	var REFRESH_PLANNING = "refresh-planning.png";
	//Search
	var CLEAR_TEXTINPUT = "clear-textinput.png";
	var SORT_ASC_GREY2 = "sort-asc-grey2.png";
	var SORT_DESC_GREY2 = "sort-desc-grey2.png";
	var SEARCH_GREY1 = "search-grey1.png";
	//Action
	var PLANNING_DUPLICATE = "planning-duplicate.png";
	var PLANNING_CLEAR = "planning-clear.png";
	var PLANNING_ADD_BOOKED_VISIT = "planning-add-booked-visit.png";
	var PLANNING_EXPORT = "planning-export.png";
	var PLANNING_EXTRACT_AND_SAVE = "planning-extract-and-save.png";
	var PLANNING_SAVE = "planning-save.png";
	var PLANNING_PRINT = "planning-print.png";
	var PLANNING_VERSION = "planning-version.png";
	//Pager
    var PAGER_FIRST_GREY3 = "pager-first-grey3.png";
    var PAGER_FIRST_GREY3_alt = "pager-first-grey3.png";
    var PAGER_NEXT_GREY3 = "pager-next-grey3.png";
    var PAGER_LAST_GREY3 = "pager-last-grey3.png";
    var PAGER_PREVIOUS_GREY3 = "pager-previous-grey3.png";
    var PAGER_FIRST_GREY1 = "pager-first-grey1.png";
    var PAGER_NEXT_GREY1 = "pager-next-grey1.png";
    var PAGER_LAST_GREY1 = "pager-last-grey1.png";
    var PAGER_PREVIOUS_GREY1 = "pager-previous-grey1.png";
	//Pending
    var PENDING = "pending.png";
    var PENDING_CLEAR = "pending-clear.png";
    var PENDING_REFRESH = "pending-refresh.png";
	//Messages
    var MESSAGES = "messages.png";
    var MESSAGES_SEND = "messages-send.png";
    var MESSAGES_REFRESH = "messages-refresh.png";
	//Calendar
	var VISIT_STATUS_ACCEPTED = "visit-status-accepted.png";
	var VISIT_STATUS_CANCELED = "visit-status-canceled.png";	
	//General
	var CHECK_GREY2 = "check-grey2.png";
	var CHECK_GREY2_SELECTED = "check-grey2-selected.png";
	var CHECK_SOLID_GREY2 = "check-solid-grey2.png";
	var CHECK_SOLID_GREY2_SELECTED = "check-solid-grey2-selected.png";
	var CHECK_SOLID_GREY3 = "check-solid-grey3.png";
	var CHECK_SOLID_GREY3_SELECTED = "check-solid-grey3-selected.png";
	var WAIT_WHEEL = "waitWheel.png";
	var COMBOLIST_ARROW_GREY1 = "combo-arrow-grey1.png";
	var COMBOLIST_ARROW_GREY2 = "combo-arrow-grey2.png";
	var VISIT_DELETE = "visit-delete.png";
    var CANCEL = "cancel.png";
    var VALID = "valid.png";
	var LOCKED_GREY3 = "locked-grey3.png";
	var LOCKED_VISIT = "locked-visit.png";
	var UNLOCKED_GREY3 = "unlocked-grey3.png";
    var MINUS = "minus.png";
    var PLUS = "plus.png";
    var DIALOG_ATTENTION = "dialog-attention.png";
    var DIALOG_QUESTION = "dialog-question.png";
    var DIALOG_INFO = "dialog-info.png";
	var TMP_TRIANGLE_1 = "tmp-triangle-1.png";
	var TMP_TRIANGLE_2 = "tmp-triangle-2.png";
	var DELETE_WHITE = "delete-white.png";
	var SEE_VISIT_DEMAND = "see-visit-demand.png";
	//2022-evolution
	var ALERT_MULTI_USERS = "alert-multi-users.png";
	
	
	
	var LOCALIZATION_20 = "icoLocalization20.png";
	var LOCALIZATION_40 = "icoLocalization40.png";
    var NOTE_SMALL = "icoNoteSmall.png";
    var NOTE = "icoNote.png";
	var SEARCH = "icoSearch.png";
	
	var VISIT_STATUS_LOCKED = "icoVisitStatusLocked.png";
	var VISIT_STATUS_PENDING = "icoVisitStatusPending.png";
}

	 
class Icons
{
	
	public static function getIcon( icon:Icon, ?width:Int, ?height:Int ):DisplayObject
	{
		var fileName:String = icon;
		var iconObject:DisplayObject;
		if ( fileName.lastIndexOf(".svg") != -1 )
		{
			var svg = new SVG(Assets.getText("assets/icons/" + fileName ) );
			/*
			var iconVect = new Shape();
			var ratio:Float;
			if ( width == null && height == null )
			{
				//ratio from Inkscape to convert mm into pixel.
				//since Inkscape SVG saves size in mm
				ratio = 0.26458;
				width = Math.round(svg.data.width / ratio);
				height = Math.round(svg.data.height / ratio);
			}else if (width == null)
			{
				ratio = svg.data.width / svg.data.height;
				width = Math.round(height * ratio);
			}else if (height == null)
			{
				ratio = svg.data.height / svg.data.width;
				height = Math.round(width * ratio);
			}
			svg.render( iconVect.graphics, 0, 0, width, height );
			icon = iconVect;*/
			iconObject = svg.renderAsShape( width, height );
		}else{
			var bd:BitmapData = Assets.getBitmapData("assets/icons/" + fileName );
			var iconBmp = new Bitmap(bd, null, true);
			iconObject = iconBmp;
		}
		return iconObject;
		
	
	}
}

