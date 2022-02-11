package com.coges.visitmanager.ui.panel;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Config;
import com.coges.visitmanager.datas.DataUpdater;
import com.coges.visitmanager.datas.DataUpdaterEvent;
import com.coges.visitmanager.datas.ServiceEvent;
import com.coges.visitmanager.datas.ServiceManager;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.ui.vmcalendar.CalendarCornerItem;
import com.coges.visitmanager.ui.vmcalendar.CalendarDayItemHeader;
import com.coges.visitmanager.ui.vmcalendar.CalendarLegend;
import com.coges.visitmanager.ui.vmcalendar.CalendarSkin;
import com.coges.visitmanager.ui.vmcalendar.CalendarHourItem;
import com.coges.visitmanager.vo.DOAvailablePeriod;
import com.coges.visitmanager.vo.Visit;
import nbigot.utils.Collection;
import openfl.geom.Rectangle;
import com.coges.visitmanager.ui.vmcalendar.Calendar;
import com.coges.visitmanager.vo.DO;
import com.coges.visitmanager.vo.Planning;
import com.coges.visitmanager.vo.User;
import nbigot.utils.SpriteUtils;
import openfl.display.Sprite;
import openfl.events.Event;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class CalendarPanel extends Sprite
{
    public static var instance(default, null):CalendarPanel;
	
	
    public var isEditDOAvailablePeriodMode(default, null):Bool;

    private var _calendar:Calendar;    
    private var _background:Sprite;    
	private var _legend:CalendarLegend;
    
    
    
    public function new()
    {
        super();
        instance = this;
		
		_background = SpriteUtils.createSquare( 50, 50, Colors.WHITE );
		addChild( _background );
		
		_legend = new CalendarLegend();
		addChild( _legend );		
		
        var clSkin:CalendarSkin = new CalendarSkin();
        clSkin.gridHColor = Colors.GREY4;
        clSkin.gridHColorAlt = Colors.GREY1;
        clSkin.gridHThickness = 1;
        clSkin.gridVColor = Colors.GREY4;
        clSkin.gridVThickness = 1;
        clSkin.headerHeight = 50;
        clSkin.sideWidth = 50;
        clSkin.cornerBackgroundColor = Colors.WHITE;
        clSkin.headerBackgroundColor = Colors.WHITE;
        clSkin.mainBackgroundColor = Colors.WHITE;
        clSkin.sideBackgroundColor = Colors.WHITE;        
        
        var dayDuration:Int = Math.round(Math.abs((Config.INIT_SLOT_END.getTime() - Config.INIT_SLOT_START.getTime()) / 1000 / 60 / 60));
        var eventDuration:Int = Math.round(Math.abs((Config.INIT_END_DATE.getTime() - Config.INIT_START_DATE.getTime()) / 1000 / 60 / 60 / 24) + 1);
        
		//TODO TEST:
		/*var startHour:Date = Date.fromTime(Config.INIT_SLOT_START.getTime() - 1000 * 60 * 60 );
		dayDuration += 3;
		_calendar = new Calendar(_background.width, _background.height, Config.INIT_START_DATE, startHour, eventDuration, dayDuration, false, clSkin);*/
        _calendar = new Calendar(_background.width, _background.height, Config.INIT_START_DATE, Config.INIT_SLOT_START, eventDuration, dayDuration, false, clSkin);
        addChild(_calendar);
		
		
		
        DataUpdater.instance.addEventListener(DataUpdaterEvent.VISIT_LIST_CHANGE, _visitListChangeHandler);
        DataUpdater.instance.addEventListener(DataUpdaterEvent.DO_AVAILABLE_PERIOD_LIST_CHANGE, _doAvailablePeriodListChangeHandler);
        /*DataUpdater.instance.addEventListener(DataUpdaterEvent.DO_AVAILABLE_PERIOD_EDIT_START, _doAvailablePeriodEditStartHandler);
        DataUpdater.instance.addEventListener(DataUpdaterEvent.DO_AVAILABLE_PERIOD_EDIT_COMPLETE, _doAvailablePeriodEditCompleteHandler);*/
		/*
        Visit.addEventListener(DataUpdaterEvent.VISIT_LIST_CHANGE, _visitListChangeHandler);
        DOAvailablePeriod.addEventListener(DataUpdaterEvent.DO_AVAILABLE_PERIOD_LIST_CHANGE, _doAvailablePeriodListChangeHandler);
        DOAvailablePeriod.addEventListener(DataUpdaterEvent.DO_AVAILABLE_PERIOD_EDIT_START, _doAvailablePeriodEditStartHandler);
        DOAvailablePeriod.addEventListener(DataUpdaterEvent.DO_AVAILABLE_PERIOD_EDIT_COMPLETE, _doAvailablePeriodEditCompleteHandler);		
		*/
		
        ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _serviceCompleteHandler);
        addEventListener(Event.ADDED_TO_STAGE, _init);
    }
    
    private function _init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, _init);
        
    }
    
    
    private function _serviceCompleteHandler(e:ServiceEvent):Void
    {
		if ( e.currentCall == ServiceManager.instance.saveDOVisit )
		{
			//trace("CalendarPanel._serviceCompleteHandler > e:saveDOVisit");
			ServiceManager.instance.getDOVisitList(DO.selected, Planning.selected, User.instance);			
			return;
		}
		if ( e.currentCall == ServiceManager.instance.setDOVisitStandBy )
		{
			//trace("CalendarPanel._serviceCompleteHandler > e:saveDOVisit");
			ServiceManager.instance.getDOVisitList(DO.selected, Planning.selected, User.instance);			
			return;
		}
		if ( e.currentCall == ServiceManager.instance.removeDOVisit )
		{
			//trace("CalendarPanel._serviceCompleteHandler > e:removeDOVisit");
			ServiceManager.instance.getDOVisitList(DO.selected, Planning.selected, User.instance);		
			return;
		}
		if ( e.currentCall == ServiceManager.instance.removeDOVisitSerie )
		{
			//trace("CalendarPanel._serviceCompleteHandler > e:removeDOVisitSerie");
			ServiceManager.instance.getDOVisitList(DO.selected, Planning.selected, User.instance);	
			return;
		}
    }
    
    private function _visitListChangeHandler(e:DataUpdaterEvent):Void
    {
        _calendar.displayDOVisits(Visit.list);
    }
    
    private function _doAvailablePeriodListChangeHandler(e:DataUpdaterEvent):Void
    {
        _calendar.displayDOAvailablePeriods();
    }
	
	
	
    /********************* START refactoring*******************/
	//refactoring
	public function startEditDOAvailablePeriod():Void
    {
		//only used as a condition to open SearchPanel/PendingPanel in MOVABLE mode
        isEditDOAvailablePeriodMode = true;
		
		// will dispatch DataUpdaterEvent and call _visitListChangeHandler to remove all visit from the calendar
        Visit.createList(new Collection<Visit>());
        
        // not needed anymore
        // DOAvailablePeriod.startEditDOAvailablePeriod();
		
        _calendar.displayDOAvailablePeriodEditMode(DOAvailablePeriod.list);
    }	
	/*
    private function _doAvailablePeriodEditStartHandler(e:DataUpdaterEvent):Void
    {
        isEditDOAvailablePeriodMode = true;
        _calendar.displayDOAvailablePeriodEditMode(DOAvailablePeriod.list);
    }*/
	
	public function stopEditDOAvailablePeriod():Void
    {
		//only used as a condition to open SearchPanel/PendingPanel in MOVABLE mode
        isEditDOAvailablePeriodMode = false;		
		
        // not needed anymore
        // DOAvailablePeriod.stopEditDOAvailablePeriod();
		
		// will dispatch DataUpdaterEvent and call _visitListChangeHandler to re-display all visit
        ServiceManager.instance.getDOVisitList(DO.selected, Planning.selected, User.instance);
		
        _calendar.displayDOAvailablePeriodEditMode(null);
    }
	/*
    private function _doAvailablePeriodEditCompleteHandler(e:DataUpdaterEvent):Void
    {
        isEditDOAvailablePeriodMode = false;
        _calendar.displayDOAvailablePeriodEditMode(null);
    }
	*/
	/************************ END refactoring***********************/
	
	public function setRect( rect:Rectangle)
	{
		x = rect.x;
		y = rect.y;
		/*
		if ( rect.width < MIN_WIDTH ) rect.width = MIN_WIDTH;
		if ( rect.height < MIN_HEIGHT ) rect.height = MIN_HEIGHT;
		
		var spacerH = 10;
		var gapH:Int = Math.floor((rect.width - _btAddLocked.width - _btSave.width - _btDuplicate.width - _btPrint.width - spacerH) / 4);
		var marginV:Int = 10;
		*/
		var padding:Int = 8;
		
		_background.width = rect.width;
		_background.height = rect.height;
		
		_legend.x = rect.width - _legend.width - padding;
		_legend.y = rect.height - _legend.height;
		
		var calendarRect = new Rectangle( padding, padding, rect.width - padding * 2, rect.height - padding - _legend.height );
		_calendar.setRect( calendarRect );
	} 
	
	override public function get_width():Float
	{
		return _background.width;
	}
	override public function get_height():Float
	{
		return _background.height;
	}
}

