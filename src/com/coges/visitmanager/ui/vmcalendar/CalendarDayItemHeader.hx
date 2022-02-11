package com.coges.visitmanager.ui.vmcalendar;


import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Config;
import com.coges.visitmanager.fonts.Fonts;
import nbigot.ui.control.Label;
import nbigot.utils.DateUtils;
import nbigot.utils.SpriteUtils;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.text.TextFormat;

/**
 * ...
 * @author Nicolas Bigot
 */
class CalendarDayItemHeader extends Sprite
{
    private var _background:Sprite; 	
	private var _lblDayName:Label;
	private var _lblDayNum:Label;

	public function new( day:Date ) 
	{
		super();
		
		
		_background = SpriteUtils.createSquare( 50, 50, Colors.WHITE );
		addChild( _background );
		
		
		_lblDayName = new Label( DateUtils.getDayName( day.getDay(), Config.LANG, true ).toUpperCase() + ".", new TextFormat( Fonts.OPEN_SANS, 12, Colors.GREY4 ) );
		addChild( _lblDayName );
		_lblDayNum = new Label( Std.string(day.getDate()), new TextFormat( Fonts.OPEN_SANS, 24, Colors.GREY4, true ) );
		addChild( _lblDayNum );
		
	}
	
	public function setRect( rect:Rectangle)
	{
		x = rect.x;
		y = rect.y;
		
		_background.width = rect.width;
		_background.height = rect.height;	
		
		var lblSpacer:Int = -10;
		
		_lblDayName.x = (rect.width - _lblDayName.width) * 0.5;
		_lblDayName.y = ( rect.height - _lblDayName.height - _lblDayNum.height - lblSpacer ) * 0.5;
		_lblDayNum.x = (rect.width - _lblDayNum.width) * 0.5;
		_lblDayNum.y = _lblDayName.y + _lblDayName.height + lblSpacer;
	} 
}