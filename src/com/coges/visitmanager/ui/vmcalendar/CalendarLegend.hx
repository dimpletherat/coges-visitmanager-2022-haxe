package com.coges.visitmanager.ui.vmcalendar;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.vo.VisitStatus;
import com.coges.visitmanager.vo.VisitStatusID;
import nbigot.ui.control.Label;
import nbigot.utils.SpriteUtils;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextFormat;

/**
 * ...
 * @author Nicolas Bigot
 */
class CalendarLegend extends Sprite 
{

	public function new() 
	{
		super();
		
		var spacer:Int = 6;
		
		var lblTitle = new Label( Locale.get("LBL_LEGEND"), new TextFormat( Fonts.OPEN_SANS, 8, Colors.GREY3, true ) );
		addChild( lblTitle );
		
		var tfStatus = new TextFormat( Fonts.OPEN_SANS, 9, Colors.GREY3 );
		
		var iconStatus1 = SpriteUtils.createRoundSquare( 10, 12, 2, 2, VisitStatus.getVisitStatusByID(VisitStatusID.PENDING).colorLight, 1, Colors.GREY4 );
		iconStatus1.x = lblTitle.width + spacer;
		addChild( iconStatus1 );
		var lblStatus1 = new Label( Locale.get("LBL_LEGEND_STATUS_PENDING").toUpperCase(), tfStatus );
		lblStatus1.x = iconStatus1.x + iconStatus1.width + spacer;
		addChild( lblStatus1 );
		
		var iconStatus2 = SpriteUtils.createRoundSquare( 10, 12, 2, 2, VisitStatus.getVisitStatusByID(VisitStatusID.ACCEPTED).colorLight, 1, Colors.GREY4 );
		iconStatus2.x = lblStatus1.x + lblStatus1.width + spacer * 2;
		addChild( iconStatus2 );
		var lblStatus2 = new Label( Locale.get("LBL_LEGEND_STATUS_ACCEPTED").toUpperCase(), tfStatus );
		lblStatus2.x = iconStatus2.x + iconStatus2.width + spacer;
		addChild( lblStatus2 );
		
		var iconStatus3 = SpriteUtils.createRoundSquare( 10, 12, 2, 2, VisitStatus.getVisitStatusByID(VisitStatusID.CANCELED).colorLight, 1, Colors.GREY4 );
		iconStatus3.x = lblStatus2.x + lblStatus2.width + spacer * 2;
		addChild( iconStatus3 );
		var lblStatus3 = new Label( Locale.get("LBL_LEGEND_STATUS_CANCELED").toUpperCase(), tfStatus );
		lblStatus3.x = iconStatus3.x + iconStatus3.width + spacer;
		addChild( lblStatus3 );
		
		var iconStatus4 = SpriteUtils.createRoundSquare( 10, 12, 2, 2, VisitStatus.getVisitStatusByID(VisitStatusID.LOCKED_OFFICIAL).colorLight, 1, Colors.GREY4 );
		iconStatus4.x = lblStatus3.x + lblStatus3.width + spacer * 2;
		addChild( iconStatus4 );
		var lblStatus4 = new Label( Locale.get("LBL_LEGEND_STATUS_LOCKED_OFFICIAL").toUpperCase(), tfStatus );
		lblStatus4.x = iconStatus4.x + iconStatus4.width + spacer;
		addChild( lblStatus4 );
		
		var iconStatus5 = SpriteUtils.createRoundSquare( 10, 12, 2, 2, VisitStatus.getVisitStatusByID(VisitStatusID.LOCKED).colorLight, 1, Colors.GREY4 );
		iconStatus5.x = lblStatus4.x + lblStatus4.width + spacer * 2;
		addChild( iconStatus5 );
		var lblStatus5 = new Label( Locale.get("LBL_LEGEND_STATUS_LOCKED").toUpperCase(), tfStatus );
		lblStatus5.x = iconStatus5.x + iconStatus5.width + spacer;
		addChild( lblStatus5 );
		
		
		
		
		var iconStatus6 = SpriteUtils.createRoundSquare( 10, 12, 2, 2, Colors.VISIT_STATUS_BY_OA_DONE, 1, Colors.GREY4 );
		iconStatus6.x = lblStatus5.x + lblStatus5.width + spacer * 4;
		addChild( iconStatus6 );
		var lblStatus6 = new Label( Locale.get("LBL_LEGEND_STATUS_BY_OA_DONE").toUpperCase(), tfStatus );
		lblStatus6.x = iconStatus6.x + iconStatus6.width + spacer;
		addChild( lblStatus6 );
		
		var iconStatus7 = SpriteUtils.createRoundSquare( 10, 12, 2, 2, Colors.VISIT_STATUS_BY_OA_CANCEL, 1, Colors.GREY4 );
		iconStatus7.x = lblStatus6.x + lblStatus6.width + spacer * 2;
		addChild( iconStatus7 );
		var lblStatus7 = new Label( Locale.get("LBL_LEGEND_STATUS_BY_OA_CANCEL").toUpperCase(), tfStatus );
		lblStatus7.x = iconStatus7.x + iconStatus7.width + spacer;
		addChild( lblStatus7 );
	}
	
}