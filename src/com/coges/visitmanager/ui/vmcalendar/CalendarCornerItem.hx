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
class CalendarCornerItem extends Sprite
{
    private var _background:Sprite; 	
	private var _lblMonth:Label;
	private var _lblYear:Label;

	public function new( day:Date ) 
	{
		super();
		
		
		_background = SpriteUtils.createSquare( 50, 50, Colors.WHITE );
		addChild( _background );
		
		
		_lblMonth = new Label( DateUtils.getMonthName( day.getMonth(), Config.LANG, true ) + ".", new TextFormat( Fonts.OPEN_SANS, 16, Colors.GREY2, true ) );
		addChild( _lblMonth );
		_lblYear = new Label( Std.string(day.getFullYear()), new TextFormat( Fonts.OPEN_SANS, 16, Colors.GREY2 ) );
		addChild( _lblYear );
		
	}
	
	public function setRect( rect:Rectangle)
	{
		x = rect.x;
		y = rect.y;
		
		_background.width = rect.width;
		_background.height = rect.height;	
		
		var lblSpacer:Int = -6;
		
		_lblMonth.x = (rect.width - _lblMonth.width) * 0.5;
		_lblMonth.y = ( rect.height - _lblMonth.height - _lblYear.height - lblSpacer ) * 0.5;
		_lblYear.x = (rect.width - _lblYear.width) * 0.5;
		_lblYear.y = _lblMonth.y + _lblMonth.height + lblSpacer;
	} 
}