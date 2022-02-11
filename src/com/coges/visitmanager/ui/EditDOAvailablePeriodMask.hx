package com.coges.visitmanager.ui;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.ui.components.VMButton;
import motion.Actuate;
import nbigot.utils.SpriteUtils;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.text.*;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class EditDOAvailablePeriodMask extends Sprite
{
    private var _darkLayer:Shape;
    private var _calendarRect:Rectangle;
	private var _width:Float;
	private var _height:Float;
    
    
    private var _btClose:VMButton;
    
    
    public function new( width:Float, height:Float, calendarRect:Rectangle)
    {
        super();
		_width = width;
		_height = height;
        _calendarRect = calendarRect;		
        alpha = 0;
		
        _darkLayer = new Shape();
        addChild(_darkLayer);
		
		_btClose = new VMButton( Locale.get("BT_CLOSE_LABEL"), new TextFormat( Fonts.OPEN_SANS, 14, Colors.BLACK, true, null, null, null, null, TextFormatAlign.CENTER ), SpriteUtils.createRoundSquare( 200, 30, 4, 4, Colors.WHITE ) );
        _btClose.addEventListener(MouseEvent.CLICK, _clickCloseHandler);
		addChild( _btClose );
		
        _draw();
		
        addEventListener(Event.ADDED_TO_STAGE, _init);
    }
	
    private function _init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, _init);	
		
		
        Actuate.tween(this, 0.5, {
                    alpha:1
                });
    }
    
    private function _draw():Void
    {
		_darkLayer.graphics.clear();
        _darkLayer.graphics.beginFill(Colors.BLACK, 0.7);
        _darkLayer.graphics.drawRect(0, 0, _calendarRect.x, _height);
        _darkLayer.graphics.drawRect(_calendarRect.right, 0, _width - _calendarRect.right, _height);
        _darkLayer.graphics.drawRect(_calendarRect.x, 0, _calendarRect.width, _calendarRect.y);
        _darkLayer.graphics.drawRect(_calendarRect.x, _calendarRect.bottom, _calendarRect.width, _height - _calendarRect.bottom);
        _darkLayer.graphics.endFill();
		
        _btClose.x = (_width - _btClose.width) * 0.5;
        _btClose.y = _calendarRect.bottom + (_height - _calendarRect.bottom) * 0.5 - _btClose.height;
    }
    
    
    
    private function _clickCloseHandler(e:MouseEvent):Void
    {
		dispatchEvent( new Event( Event.CLOSE ) );
        //parent.removeChild(this);
    }
	
	
	
	public function setRect(rect:Rectangle, calendarRect:Rectangle )
	{
		x = rect.x;
		y = rect.y;
		
		_width = rect.width;
		_height = rect.height;
		
		_calendarRect = calendarRect;
		
		_draw();
	} 
}

