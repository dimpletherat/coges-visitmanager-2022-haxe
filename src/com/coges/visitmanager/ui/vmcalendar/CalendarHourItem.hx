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
class CalendarHourItem extends Sprite
{
    private var _background:Sprite; 	
	private var _lblTime:Label;

	public function new( hour:Date ) 
	{
		super();
		
		
		_background = SpriteUtils.createSquare( 50, 50, Colors.WHITE );
		addChild( _background );
		
		
		_lblTime = new Label( DateUtils.toString( hour, "hh:mm" ), new TextFormat( Fonts.OPEN_SANS, 11, Colors.GREY4 ) );
		addChild( _lblTime );
		
	}
	
	public function setRect( rect:Rectangle)
	{
		x = rect.x;
		y = rect.y;
		
		_background.width = rect.width;
		_background.height = rect.height;	
		
		_lblTime.x = (rect.width - _lblTime.width) * 0.5;
		_lblTime.y = ( rect.height - _lblTime.height ) * 0.5;
	} 
}