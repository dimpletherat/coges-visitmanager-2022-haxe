package com.coges.visitmanager.ui.vmcalendar;

import com.coges.visitmanager.vo.DOAvailablePeriod;
import com.coges.visitmanager.vo.Visit;
import nbigot.utils.Collection;
import openfl.display.CapsStyle;
import openfl.display.LineScaleMode;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Rectangle;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class Calendar extends Sprite
{
    private var _width:Int;
    private var _height:Int;
    private var _startingDay:Date;
    private var _startingHour:Date;
    private var _dayCount:Int;
    private var _hourCount:Int;
    private var _displayChangeDayInterface:Bool;
    private var _skin:CalendarSkin;
    private var _dayList:Array<Date>;
	private var _dayItemList:Array<CalendarDayItem>;
	private var _dayItemHeaderList:Array<CalendarDayItemHeader>;
    private var _hourList:Array<Date>;
    private var _hourItemList:Array<CalendarHourItem>;
	private var _cornerItem:CalendarCornerItem;
	//private var _layoutContainer:Shape;
    
    public function new(width:Float, height:Float, startingDay:Date, startingHour:Date = null, dayCount:Int = 7, hourCount:Int = 24, displayChangeDayInterface:Bool = false, skin:CalendarSkin = null)
    {
        super();
        _skin = ((skin != null)) ? skin:new CalendarSkin();
        _displayChangeDayInterface = displayChangeDayInterface;
        _dayCount = dayCount;
        _hourCount = hourCount;
        _startingDay = startingDay;
        if (startingHour == null)
        {
            _startingHour = new Date(0, 0, 0, 0, 0, 0);
        } else {
			// un nouvel objet date, ne gardant que les heures/minutes/secondes de celui passé au constructeur.            
            _startingHour = new Date(0, 0, 0, startingHour.getHours(), startingHour.getMinutes(), startingHour.getSeconds());
        }
        _height = Std.int(height);
        _width = Std.int(width);
        
		_cornerItem = new CalendarCornerItem(_startingDay);
		addChild( _cornerItem );
		
        // init hours		
		_hourList = new Array<Date>();
		_hourItemList = new Array<CalendarHourItem>();
		var hour:Date;
		var hourItem:CalendarHourItem;
		//_hourCount+1 to have the final hour displayed
        for ( i in 0..._hourCount + 1)
        {
			if ( i == 0 )
			{
				hour = startingHour;
			}else{
				hour = new Date(0, 0, 0, startingHour.getHours() + i, startingHour.getMinutes(), startingHour.getSeconds() );
			}
			
            _hourList.push( hour );
			hourItem = new CalendarHourItem( hour );
			addChild( hourItem );
			_hourItemList.push( hourItem );
        }
			
		
		// init days
		_dayList = new Array<Date>();
        _dayItemList = new Array<CalendarDayItem>();
        _dayItemHeaderList = new Array<CalendarDayItemHeader>();
        var dayDate:Date;
		var dayItem:CalendarDayItem;
		var dayItemHeader:CalendarDayItemHeader;
        for ( i in 0..._dayCount)
        {
			if ( i == 0 )
			{
				dayDate = _startingDay;
			}else{
				dayDate = new Date(_startingDay.getFullYear(), _startingDay.getMonth(), _startingDay.getDate() + i, 0, 0, 0);
			}
			
			_dayList.push( dayDate );
			
			dayItemHeader = new CalendarDayItemHeader(dayDate);
            addChild(dayItemHeader);
			
            dayItem = new CalendarDayItem(i + 1, dayDate, _hourList, 0, 0);
            dayItem.addEventListener(Event.CHANGE, _dayItemChangeHandler, false, 0, true);    
            addChild(dayItem);   
			
            _dayItemList.push(dayItem);
            _dayItemHeaderList.push(dayItemHeader);
        }
		
		
        
        _draw();
		
        addEventListener(Event.ADDED_TO_STAGE, _init);
    }
    
    private function _init(e:Event = null):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, _init);
    }
    
    private function _draw():Void
    {
        graphics.clear();
        
		var offsetH:Int = 16;
		var offsetV:Int = 10;
		var activeArea:Rectangle = new Rectangle( _skin.sideWidth + offsetH, _skin.headerHeight + offsetV, _width - _skin.sideWidth - offsetH * 2, _height - _skin.headerHeight - offsetV * 2 );
		
		_cornerItem.setRect( new Rectangle(0, 0, _skin.sideWidth, _skin.headerHeight) );
        
        // Grid H & Header Labels & DayItems
        graphics.lineStyle(_skin.gridVThickness, _skin.gridVColor, _skin.gridVAlpha, true, LineScaleMode.NONE, CapsStyle.NONE);

        var position:Float;
        var dayItem:CalendarDayItem;
        var dayItemHeader:CalendarDayItemHeader;
        var dayItemWidth:Float = activeArea.width / _dayCount;
        for ( i in 0..._dayCount)
        {
            position = activeArea.x + i * dayItemWidth;
            graphics.moveTo(position, activeArea.y - offsetV);
            graphics.lineTo(position, activeArea.bottom + offsetV );
			
			dayItem = _dayItemList[i];
			dayItem.setRect( new Rectangle( position, activeArea.y, dayItemWidth, activeArea.height ) );
			
            dayItemHeader = _dayItemHeaderList[i];
			dayItemHeader.setRect( new Rectangle( position, 0, dayItemWidth, _skin.headerHeight ) );
        }
		
		
        // Grid V & Side Labels
        var hourSpacing:Float = activeArea.height / _hourCount;
        var hourItem:CalendarHourItem;
        for ( i in 0..._hourCount + 1)
        {
            position = _skin.headerHeight + i * hourSpacing + offsetV;
            graphics.lineStyle(_skin.gridHThickness, _skin.gridHColor, _skin.gridHAlpha, true, LineScaleMode.NONE, CapsStyle.NONE);
            graphics.moveTo(0, position);
            graphics.lineTo(_width, position);
            graphics.lineStyle(_skin.gridHThickness, _skin.gridHColorAlt, _skin.gridHAlpha, true, LineScaleMode.NONE, CapsStyle.NONE);
            graphics.moveTo(0, position + hourSpacing / 2);
            graphics.lineTo(_width, position + hourSpacing / 2);
			
			hourItem = _hourItemList[i];
			hourItem.setRect( new Rectangle( 0, position - 10, _skin.sideWidth, 20 ) );
        }
    }
    
    
    private function _dayItemChangeHandler(e:Event):Void
    {
        displayDOVisits(Visit.list);
    }
    
    public function displayDOVisits(visitList:Collection<Visit>):Void
    {
		for ( di in _dayItemList )
		{
			di.displayDOVisits(visitList);
		}
    }
    
    public function displayDOAvailablePeriods():Void
    {
		for ( di in _dayItemList )
		{
			di.displayDOAvailablePeriods();
		}
    }
    public function displayDOAvailablePeriodEditMode(availablePeridoList:Collection<DOAvailablePeriod>):Void
    {
		//trace( "Calendar.displayDOAvailablePeriodEditMode > availablePeridoList : " + availablePeridoList );
        var visible:Bool = (availablePeridoList != null);
        
		for ( di in _dayItemList )
		{
			di.displayDOAvailablePeriodEditMode(visible);
		}
		
		//TODO: remove below if the new way (above) works
		/*
        var i:Int = -1;
        var dayItem:CalendarDayItem;
        while (++i < _dayCount)
        {
            _dayItemList[i].displayDOAvailablePeriodEditMode(visible);
        }*/
		
    }
	
	
	public function setRect( rect:Rectangle)
	{
		x = rect.x;
		y = rect.y;
		
		_width = Std.int(rect.width);
		_height = Std.int(rect.height);
		
		_draw();
	} 
}

