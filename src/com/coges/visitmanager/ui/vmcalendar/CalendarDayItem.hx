package com.coges.visitmanager.ui.vmcalendar;


import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Config;
import com.coges.visitmanager.core.DraggerEvent;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.core.SearchResultDragger;
import com.coges.visitmanager.core.VisitDragger;
import com.coges.visitmanager.core.VisitDraggerOrigin;
import com.coges.visitmanager.core.VisitSaveHelper;
import com.coges.visitmanager.core.VisitSaveType;
import com.coges.visitmanager.datas.ServiceEvent;
import com.coges.visitmanager.datas.ServiceManager;
import com.coges.visitmanager.events.VisitSaveEvent;
import com.coges.visitmanager.ui.components.VMButton;
import com.coges.visitmanager.ui.dialog.ConfirmInteractiveDialog;
import com.coges.visitmanager.ui.dialog.ConfirmVisitSerieDialog;
import com.coges.visitmanager.ui.dialog.EditDOAvailabePeriodDialog;
import com.coges.visitmanager.ui.dialog.VMConfirmDialog;
import com.coges.visitmanager.ui.dialog.VMMessageDialog;
import com.coges.visitmanager.ui.panel.PendingPanel;
import com.coges.visitmanager.ui.panel.ResultPanel;
import com.coges.visitmanager.vo.DO;
import com.coges.visitmanager.vo.DOAvailablePeriod;
import com.coges.visitmanager.vo.Period;
import com.coges.visitmanager.vo.Planning;
import com.coges.visitmanager.vo.SearchResult;
import com.coges.visitmanager.vo.User;
import com.coges.visitmanager.vo.Visit;
import com.coges.visitmanager.vo.VisitStatusID;
import feathers.controls.BasicToggleButton;
import motion.Actuate;
import nbigot.ui.control.SimpleToggleButton;
import nbigot.ui.control.ToolTip;
import nbigot.ui.dialog.DialogEvent;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.DialogValue;
import nbigot.utils.Collection;
import nbigot.utils.DateUtils;
import nbigot.utils.SpriteUtils;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class CalendarDayItem extends Sprite
{
    public var dayDate(default, null):Date;

    private var SECONDE_TIME(default, never):Int = 1000;
    private var MINUTE_TIME(default, never):Int = 1000 * 60;
    private var HOUR_TIME(default, never):Int = 1000* 60 * 60;
    
    private var _hourList:Array<Date>;
    private var _width:Float;
    private var _height:Float;
    private var _hourHeight:Float;
    private var _startTime:Float;
    private var _startTimeABSOLUTE:Float;
    private var _endTime:Float;
    private var _endTimeABSOLUTE:Float;
    private var _totalDayPeriod:Period;
    private var _visitList:Array<Visit>;
    private var _visitItemList:Array<VisitItem>;
    private var _ratioHeightTime:Float;
    private var _dayUnavailablePeriodList:Array<Period>;
    private var _visitStatusMenu:VisitStatusMenu;
    private var _currentVisitItem:VisitItem;
    private var _mouseDropY:Float;
    private var _background:Sprite;
    
    private var _draggerVisitItemSource:VisitItem;
    private var _cbEditDOAvailablePeriod:SimpleToggleButton;
    private var _dayAvailablePeriod:DOAvailablePeriod;
    private var _dayNum:Int;
    private var _isDOAvailablePeriodEditMode:Bool;
    private var _reloadVisitListForSaveCompleteParams:Array<Dynamic>;
    private var _magnetBorder:Shape;
	private var _btLocalization:VMButton;
    
    public function new(dayNum:Int, dayDate:Date, hourList:Array<Date>, width:Float, height:Float)
    {
        super();
		
        this.dayDate = dayDate;
        _dayNum = dayNum;
        _height = height;
        _width = width;		
		//hourList is duplicated in order to break the reference, for safety
        _hourList = hourList.slice(0);
		
		
		_background = SpriteUtils.createSquare( 100, 100, Colors.WHITE );
		_background.alpha = 0.4;
        _background.doubleClickEnabled = true;
        _background.addEventListener(MouseEvent.DOUBLE_CLICK, _doubleClickHandler);
		addChild( _background );
		
		
		/*
		_cbEditDOAvailablePeriod = new BasicToggleButton();
		_cbEditDOAvailablePeriod.buttonMode = true;
		_cbEditDOAvailablePeriod.backgroundSkin = Icons.getIcon( Icon.CHECK_GREY2 );
		_cbEditDOAvailablePeriod.selectedBackgroundSkin = Icons.getIcon( Icon.CHECK_GREY2_SELECTED );
		_cbEditDOAvailablePeriod.visible = false;*/
		_cbEditDOAvailablePeriod = new SimpleToggleButton();
		_cbEditDOAvailablePeriod.icon = Icons.getIcon( Icon.CHECK_GREY2 );
		_cbEditDOAvailablePeriod.iconSelected = Icons.getIcon( Icon.CHECK_GREY2_SELECTED );
		_cbEditDOAvailablePeriod.visible = false;
        _cbEditDOAvailablePeriod.addEventListener(Event.CHANGE, _changeCBEditDOAvailablePeriodHandler);
		addChild( _cbEditDOAvailablePeriod );
       
        
        //localization is not available
		/*
        _btLocalization = new VMButton( "", null, SpriteUtils.createSquare( 20, 20, Colors.WHITE ) );
		_btLocalization.borderColor = Colors.GREY2;
		_btLocalization.borderSize = 1;
		_btLocalization.setIcon( Icons.getIcon(Icon.LOCALIZATION_20), new Point( 20, 20) );
		_btLocalization.toolTipContent = Locale.get("TOOLTIP_LOCALIZATION_DAY_PATH");
        _btLocalization.addEventListener(MouseEvent.CLICK, _localizationClickHandler);
		addChild( _btLocalization );	
		*/	
		
		
        // réaffectation de la date du jour à toutes celles de hourList
		for ( i in 0..._hourList.length )
        {
            _hourList[i] = new Date(dayDate.getFullYear(), dayDate.getMonth(), dayDate.getDate(), _hourList[i].getHours(), _hourList[i].getMinutes(), _hourList[i].getSeconds());
        }
        
        var firstHour:Date = _hourList[0];
        var lastHour:Date = _hourList[_hourList.length - 1];
		
        _totalDayPeriod = new Period(firstHour, lastHour);        
		
        _visitList = new Array<Visit>();
        _visitItemList = new Array<VisitItem>();
        _dayUnavailablePeriodList = new Array<Period>();
        
        SearchResultDragger.instance.addEventListener(DraggerEvent.DROP, _draggerSearchResultDropHandler);
        VisitDragger.instance.addEventListener(DraggerEvent.DROP, _draggerVisitItemDropHandler);
        VisitDragger.instance.addEventListener(DraggerEvent.MOVE, _draggerVisitItemMoveHandler);
		
		_draw();
    }
	
    private function _draw():Void
    {
        _hourHeight = _height / _hourList.length;
        _ratioHeightTime = _height / _totalDayPeriod.length;
		
		
		_background.width = _width;
		_background.height = _height;
		
        _cbEditDOAvailablePeriod.x = _width - 40;
        _cbEditDOAvailablePeriod.y = -50; // TODO: access calendar skin for headerHeight
		
        //localization is not available
		/*
		_btLocalization.x = 20;
		_btLocalization.y = -50;
		*/
		_drawDOAvailablePeriods();
		
		for (vi in _visitItemList)
			vi.setRect( new Rectangle( 0, (vi.data.period.start - _totalDayPeriod.start) * _ratioHeightTime, _width, vi.data.period.length * _ratioHeightTime ) );
			
	}
	
	function _drawDOAvailablePeriods() 
	{		
		
        graphics.clear();
        graphics.beginFill(Colors.YELLOW, 0.4);
		for ( dup in _dayUnavailablePeriodList )
		{
			graphics.drawRect(0, (dup.start - _totalDayPeriod.start) * _ratioHeightTime, _width, dup.length * _ratioHeightTime);
		}
        
        //Event Opening		
        var openingStart:Date = Config.EXHIBITION_OPENING_PERIOD.startDate;
        var openingDayStart:Date = new Date(dayDate.getFullYear(), dayDate.getMonth(), dayDate.getDate(), openingStart.getHours(), openingStart.getMinutes(), openingStart.getSeconds());
        var openingEnd:Date = Config.EXHIBITION_OPENING_PERIOD.endDate;
        var openingDayEnd:Date = new Date(dayDate.getFullYear(), dayDate.getMonth(), dayDate.getDate(), openingEnd.getHours(), openingEnd.getMinutes(), openingEnd.getSeconds());
        var openingDayPeriod:Period = new Period(openingDayStart, openingDayEnd);
        graphics.beginFill(Colors.BLACK, 0.4);
        graphics.drawRect(0, 0, _width, (openingDayPeriod.start - _totalDayPeriod.start) * _ratioHeightTime);
        graphics.drawRect(0, (openingDayPeriod.end - _totalDayPeriod.start) * _ratioHeightTime, _width, (_totalDayPeriod.end - openingDayPeriod.end) * _ratioHeightTime);
        
        
        graphics.endFill();
	}
    
	//localization is not available
	/*
    private function _localizationClickHandler(e:MouseEvent):Void
    {
        if (ExternalInterface.available)
        {
            var idList:Array<Int> = new Array<Int>();
			
			for ( v in _visitList )
			{
				if ( v.exhibitorCode > 0 ) idList.push( v.exhibitorCode );
			}
            if (idList.length > 0)
            {
                ExternalInterface.call("localizeDayPath", idList, User.instance.id, Config.LANG);
            }
        }
        else
        {
            //PopupManager.instance.openPopup(PopupType.MESSAGE, "", Locale.get("LOCALIZATION_ERROR_MESSAGE"));
            DialogManager.instance.open(new VMMessageDialog( Locale.get("LOCALIZATION_ERROR_MESSAGE")));
        }
    }
	*/
    
    public function displayDOVisits(list:Collection<Visit>):Void
    {
        for ( vi in _visitItemList )
		{
			removeChild( vi );
		}
        
        _visitList = new Array<Visit>();
        _visitItemList = new Array<VisitItem>();
        var vi:VisitItem;		
		
		for ( v in list )
        {
            if (v.dateStart.getDate() == dayDate.getDate())
            {
                vi = new VisitItem(v, _width, v.period.length * _ratioHeightTime);
                vi.y = (v.period.start - _totalDayPeriod.start) * _ratioHeightTime;
                
                vi.addEventListener(MouseEvent.ROLL_OVER, _visitItemRolloverHandler);
                vi.addEventListener(MouseEvent.ROLL_OUT, _visitItemRolloutHandler);
                vi.addEventListener(MouseEvent.MOUSE_DOWN, _visitItemMouseDownHandler);
                vi.addEventListener(Event.SELECT, _visitItemSelectHandler);
                vi.addEventListener(VisitSaveEvent.REMOVE, _visitItemRemoveHandler);               
                
					//if ( v.idStatus != VisitStatusID.CANCELED )
					//{
					//	addChildAt( vi, 0 );
					//}else {
                addChild(vi);
                //}
                _visitItemList.push(vi);
                _visitList.push(v);
            }
        }
		
		
		//why is that ?
		//maybe to highlight visits canceled by other users, in order to proper remove them ??
		for ( vi in _visitItemList )
		{
            if (vi.data.idStatus == VisitStatusID.CANCELED)
            {
                addChild(vi);
            }			
		}
    }
    
    public function displayDOAvailablePeriods():Void
    {
        _dayUnavailablePeriodList = new Array<Period>();
        _dayAvailablePeriod = DOAvailablePeriod.getDOAvailablePeriodByDay(dayDate, _dayNum);
        
        
        var start:Date = _totalDayPeriod.startDate;
        var end:Date;
		
        if (_dayAvailablePeriod.period.length > 0)
        {
			// DO available today			
			if ( _dayAvailablePeriod.startDate.getTime() > _totalDayPeriod.startDate.getTime() )
			{
				start = _totalDayPeriod.startDate;
				end = _dayAvailablePeriod.startDate;
				if ( end.getTime() > _totalDayPeriod.endDate.getTime() ) end = _totalDayPeriod.endDate;
				_dayUnavailablePeriodList.push(new Period(start, end));
			}
			if ( _dayAvailablePeriod.endDate.getTime() < _totalDayPeriod.endDate.getTime() )
			{
				start = _dayAvailablePeriod.endDate;
				if ( start.getTime() < _totalDayPeriod.startDate.getTime() ) start = _totalDayPeriod.startDate;
				end = _totalDayPeriod.endDate;
				_dayUnavailablePeriodList.push(new Period(start, end));
			}
				
				//KEEP: in case the fact that we removed one minute was important, and not just for visual purpose
				//end = Date.fromTime(_dayAvailablePeriod.startDate.getTime() - (1 * 60 * 1000) );
				
				
        }else{
			// DO not available for the day
			_dayUnavailablePeriodList.push(new Period(_totalDayPeriod.startDate, _totalDayPeriod.endDate));
		}
		
		_drawDOAvailablePeriods();
    }
    
	
    public function displayDOAvailablePeriodEditMode(isEditMode:Bool):Void
    {
        _isDOAvailablePeriodEditMode = isEditMode;
        _cbEditDOAvailablePeriod.visible = _isDOAvailablePeriodEditMode;
        _cbEditDOAvailablePeriod.selected = (_dayAvailablePeriod.period.length > 0);
    }
	
    private function _draggerSearchResultDropHandler(e:DraggerEvent):Void
    {
        if (_background.hitTestPoint(stage.mouseX, stage.mouseY))
        {
            if (Planning.selected.isLocked)
            {
                //PopupManager.instance.openPopup(PopupType.MESSAGE, "", Locale.get("WARNING_PLANNING_LOCKED"), null, null, true);
                DialogManager.instance.open(new VMMessageDialog( "Title", Locale.get("WARNING_PLANNING_LOCKED") ) );
            }
            else
            {
                _mouseDropY = cast(e.draggerItem, Sprite).getRect(this).y;
                SearchResult.selected = e.draggerItem.data;
                
                var exhibitorInPlanning:Bool = _checkExhibitorInPlanning(SearchResult.selected.idExhibitor);
                if (exhibitorInPlanning)
                {
                    //PopupManager.instance.addEventListener(DialogEvent.CLOSE, _alertExhibitorIsInPlanningCloseHandler);
                    //PopupManager.instance.openPopup(PopupType.MESSAGE, "", Locale.get("ALERT_EXHIBITOR_IN_PLANNING"), null, null, true);
                    DialogManager.instance.addEventListener(DialogEvent.CLOSE, _alertExhibitorIsInPlanningCloseHandler);
                    DialogManager.instance.open(new VMMessageDialog( "Title", Locale.get("ALERT_EXHIBITOR_IN_PLANNING") ) );
                    return;
                }
                
                _saveVisitFromSearchResult();
            }
        }
    }
    private function _checkExhibitorInPlanning(idExhibitor:Int):Bool
    {
        var i:Int = -1;
        var v:Visit;
		for ( v in Visit.list )
		{
			if ( v.idExhibitor == idExhibitor ) return true;
		}
		return false;
    }
    private function _alertExhibitorIsInPlanningCloseHandler(e:DialogEvent = null):Void
    {
        //PopupManager.instance.removeEventListener(DialogEvent.CLOSE, _alertExhibitorIsInPlanningCloseHandler);
        DialogManager.instance.removeEventListener(DialogEvent.CLOSE, _alertExhibitorIsInPlanningCloseHandler);
        
        _saveVisitFromSearchResult();
    }
    
    
    private function _draggerVisitItemMoveHandler(e:DraggerEvent):Void
    {
        if (_background.hitTestPoint(stage.mouseX, stage.mouseY))
        {
            var vdi:VisitDraggerItem = cast(e.draggerItem, VisitDraggerItem);
            _mouseDropY = globalToLocal(new Point(0, vdi.y)).y;  //mouseY;  ;
            var d:Date = _getStartDateForNewVisit();
            var p:Period = new Period(d, d);
            
            _createMagnetBorder(vdi, p);
            
            _magnetBorder.y = (p.start - _totalDayPeriod.start) * _ratioHeightTime;
        }
        else if (_magnetBorder != null)
        {
            removeChild(_magnetBorder);
            _magnetBorder = null;
        }
    }
	
    private function _createMagnetBorder(vdi:VisitDraggerItem, p:Period):Void
    {
        if (_magnetBorder != null)
        {
            return;
        }
        
        _magnetBorder = new Shape();
        _magnetBorder.graphics.lineStyle(2, Colors.GREEN1);
        _magnetBorder.graphics.drawRoundRect(0, 0, _background.width, vdi.height, 4,4);
        _magnetBorder.y = (p.start - _totalDayPeriod.start) * _ratioHeightTime;
        addChild(_magnetBorder);
    }
	
    private function _removeMagnetBorder():Void
    {
        if (_magnetBorder == null)
        {
            return;
        }
        
        removeChild(_magnetBorder);
        _magnetBorder = null;
    }
    
    
    
    private function _draggerVisitItemDropHandler(e:DraggerEvent):Void
    {
        _removeMagnetBorder();
        
        if (_background.hitTestPoint(stage.mouseX, stage.mouseY))
        {
            _mouseDropY = cast(e.draggerItem, Sprite).getRect(this).y;
            var v:Visit = e.draggerItem.data;
            
            _saveVisitFromVisitItem(v);
        }
    }
    
    
    
    
    
    private function _getStartDateForNewVisit():Date
    {
        var time:Float = _mouseDropY / _ratioHeightTime;
        var startDate:Date = Date.fromTime(_totalDayPeriod.startDate.getTime() + time);
        
        var initSlotLengthMinutes:Float = Config.INIT_SLOT_LENGTH_TIME / 60 / 1000;
        var mod:Float = startDate.getMinutes() % initSlotLengthMinutes;
		var minutes:Int = startDate.getMinutes();
        if (mod != 0)
        {
            var rest:Float = initSlotLengthMinutes - mod;
            if (rest < mod)
            {
                minutes += Std.int(rest);
            }
            else
            {
                minutes -= Std.int(mod);
            }
        }
		// initalize seconds and milliseconds to 0
		startDate = new Date( startDate.getFullYear(), startDate.getMonth(), startDate.getDate(), startDate.getHours(), minutes, 0);
		
        return startDate;
		
    }
    
    
    
    private function _visitItemMouseDownHandler(e:MouseEvent):Void
    {
		_currentVisitItem = cast(e.currentTarget, VisitItem);  // e.target;  
        _currentVisitItem.alpha = 0.3;
        addEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveVisitItemTestHandler);
        stage.addEventListener(MouseEvent.MOUSE_UP, _stageMouseUpHandler);
    }
    
	
    private function _stageMouseUpHandler(e:MouseEvent):Void
    {
        stage.removeEventListener(MouseEvent.MOUSE_UP, _stageMouseUpHandler);
        if (_currentVisitItem != null)
        {
            _currentVisitItem.alpha = 1;
        }
        removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveVisitItemTestHandler);
    }
    
    private function _mouseMoveVisitItemTestHandler(e:MouseEvent):Void
    {
        removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveVisitItemTestHandler);
        if (Planning.selected.isLocked || _currentVisitItem.data.isLocked || !User.instance.isAuthorized)
        {
            return;
        }
        
        VisitDragger.instance.startDrag(_currentVisitItem);
    }
    
    private function _visitItemRolloverHandler(e:MouseEvent):Void
    {
        _currentVisitItem = cast(e.target, VisitItem);
        
        parent.addChild(this);
        _currentVisitItem.parent.addChild(_currentVisitItem);
        
        var toolTypeText:String = "";
        if (_currentVisitItem.data.idDemand > 0)
        {
            toolTypeText += Locale.get("FLAG_WITH_DEMAND") + " | " + _currentVisitItem.data.demandPriority + "\n";
        }
        toolTypeText += Locale.get("TOOLTIP_VISIT_DETAIL_FROM") + DateUtils.toString(_currentVisitItem.data.dateStart, "hh:mm") + " " + Locale.get("TOOLTIP_VISIT_DETAIL_TO") + DateUtils.toString(_currentVisitItem.data.dateEnd, "hh:mm") + "\n";
        if (_currentVisitItem.data.location != null && _currentVisitItem.data.location.length > 0)
        {
            toolTypeText += Locale.get("TOOLTIP_VISIT_DETAIL_LOCATION") + _currentVisitItem.data.location + "\n";
        }
		
        var activityList:Collection<VisitActivityJSON> = _currentVisitItem.data.visitActivityList.filter("isChecked", true);
        if (activityList != null && activityList.length > 0)
        {
            toolTypeText += Locale.get("TOOLTIP_VISIT_DETAIL_ACTIVITIES") + "\n";
            for ( va in activityList)
            {
                toolTypeText += "- " + va.label + "\n";
            }
        }
        
        if (toolTypeText.length > 0)
        {
            ToolTip.show(toolTypeText);
        }
        
        if (_currentVisitItem.data.idStatus == VisitStatusID.ACCEPTED || Planning.selected.isLocked ||
            _currentVisitItem.data.isSpecialVisit || _currentVisitItem.data.isLocked || !User.instance.isAuthorized)
        {
            return;
        }
        
        if (_visitStatusMenu == null)
        {
            _visitStatusMenu = new VisitStatusMenu(/*e.target.width, _currentVisitItem.data.idStatus*/);
            _visitStatusMenu.addEventListener(Event.CHANGE, _changeVisitStatusMenuHandler, false, 0, true);
            _visitStatusMenu.alpha = 0;
            addChild(_visitStatusMenu);
        }
        
        
		
			//_visitStatusMenu.x = _currentVisitItem.x;			
			//_visitStatusMenu.y = ( VisitStatusMenu.HEIGHT > _currentVisitItem.height - 16 ) ? 
											//_currentVisitItem.y + _currentVisitItem.height - 1:
											//_currentVisitItem.y + e.target.height - VisitStatusMenu.HEIGHT;	
											
        _visitStatusMenu.x = ((this.x + this.width + _visitStatusMenu.width > parent.width)) ? _currentVisitItem.x - _visitStatusMenu.width + 1:_currentVisitItem.x + _currentVisitItem.width - 1;
        _visitStatusMenu.y = _currentVisitItem.y - 1;
        _visitStatusMenu.addEventListener(MouseEvent.ROLL_OUT, _rolloutVisitStatusMenuHandler);
        Actuate.tween(_visitStatusMenu, 0.4, {
                    alpha:1
                });
    }
    private function _visitItemRolloutHandler(e:MouseEvent):Void
    {
        if (ToolTip.exists)
        {
            ToolTip.hide();
        }
        
        if (_currentVisitItem.data.idStatus == VisitStatusID.ACCEPTED || Planning.selected.isLocked ||
            _currentVisitItem.data.isSpecialVisit || _currentVisitItem.data.isLocked || !User.instance.isAuthorized)
        {
            return;
        }
        
        if (_visitStatusMenu != null && !_visitStatusMenu.hitTestPoint(stage.mouseX, stage.mouseY))
        {
            _removeVisitStatusMenu();
        }
    }
	
    
    private function _removeVisitStatusMenu():Void
    {
        if (_visitStatusMenu != null)
        {
            _visitStatusMenu.removeEventListener(Event.CHANGE, _changeVisitStatusMenuHandler, false);
            removeChild(_visitStatusMenu);
        }
        _visitStatusMenu = null;
    }
    private function _rolloutVisitStatusMenuHandler(e:MouseEvent):Void
    {
        if (!_currentVisitItem.hitTestPoint(stage.mouseX, stage.mouseY))
        {
            _removeVisitStatusMenu();
        }
    }
    private function _changeVisitStatusMenuHandler(e:Event):Void
    {
        var newStatusID:VisitStatusID = _visitStatusMenu.value;
        _currentVisitItem.data.idStatus = newStatusID;
		
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ERROR, _saveVisitErrorHandler);
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.COMPLETE, _saveVisitCompleteHandler);
        VisitSaveHelper.instance.saveVisit(VisitSaveType.CHANGE_STATUS, _currentVisitItem.data, null, null, newStatusID);
    }
    
    
    
    
    
    private function _visitItemRemoveHandler(e:VisitSaveEvent):Void
    {
		// authorization for removing already handled in VisitItem.askForRemoveVisit()   	
		
        var vi:VisitItem = try cast(e.target, VisitItem) catch(e:Dynamic) null;
        _removeVisit(vi.data);
    }
    
    private function _doubleClickHandler(e:MouseEvent):Void
    {
        if (Planning.selected.isLocked || !User.instance.isAuthorized)
        {
            return;
        }
        
        if (_isDOAvailablePeriodEditMode)
        {
            if (_cbEditDOAvailablePeriod.selected)
            {
                _displayEditDOAvailablePeriodDialog();
            }
        }
        else
        {
            _mouseDropY = mouseY;
            var startDate:Date = _getStartDateForNewVisit();
            var endDate:Date = Date.fromTime(startDate.getTime() + Config.INIT_SLOT_LENGTH_TIME);
            var v:Visit = Visit.createNewSpecialVisit(startDate, endDate, Planning.selected.id, DO.selected.id);
			
            var vDetail:VisitDetail = new VisitDetail(v);
			stage.addChild( vDetail );
        }
    }
    private function _visitItemSelectHandler(e:Event):Void
    {
        var v:VisitItem = cast(e.target, VisitItem);
		
        var vDetail:VisitDetail = new VisitDetail(v.data, Planning.selected.isLocked, User.instance.isAuthorized);
		stage.addChild(vDetail);
    }
	
		//private function _closeVisitDetailRemoveHandler(e:VisitDetailEvent):void 
		//{
		//	var v:Visit = e.targetVisit;
		//	_removeVisit( v );
		//}		
		//private function _closeVisitDetailSaveHandler(e:VisitDetailEvent):void 
		//{
		//	var v:Visit = e.targetVisit;
		//	_saveVisit( v, true );
		//}		
		//private function _closeVisitDetailChangeStatusHandler( e:VisitDetailEvent ):void 
		//{
		//	var v:Visit = e.targetVisit;
		//	
		//	var saveOK:Boolean = _saveVisit( v, true );
		//	if ( saveOK ) ServiceManager.instance.throwNotification( User.instance, DO.selected, NotificationAction.INCREASE  )
		//}	
		
    private function _changeCBEditDOAvailablePeriodHandler(e:Event):Void
    {
        if (_dayAvailablePeriod.period.length == 0)
        {
            _displayEditDOAvailablePeriodDialog();
        }
        else
        {
            _dayAvailablePeriod.startDate = dayDate;
            _dayAvailablePeriod.endDate = dayDate;
			
            ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _editDOAvailablePeriodCompleteHandler);
            ServiceManager.instance.updateDOAvailablePeriod(_dayAvailablePeriod);
        }
    }
	
    private function _displayEditDOAvailablePeriodDialog():Void
    {
        DialogManager.instance.addEventListener(DialogEvent.CLOSE, _closeEditDOAvailablePeriodPopupHandler);
        DialogManager.instance.open( new EditDOAvailabePeriodDialog( Locale.get("TOOLTIP_BT_EDIT_DO_AVAILABLE_PERIOD"), Locale.get("EDIT_DO_AVAILABLE_PERIOD"), _dayAvailablePeriod ) );
    }
    
    private function _closeEditDOAvailablePeriodPopupHandler(e:DialogEvent):Void
    {
        DialogManager.instance.removeEventListener(DialogEvent.CLOSE, _closeEditDOAvailablePeriodPopupHandler);
		switch (e.value) 
		{
			case DialogValue.CANCEL:
				_cbEditDOAvailablePeriod.selected = (_dayAvailablePeriod.period.length > 0);
				
			case DialogValue.DATA(content):
				_dayAvailablePeriod.startDate = (content:Period).startDate;
				_dayAvailablePeriod.endDate = (content:Period).endDate;
				ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _editDOAvailablePeriodCompleteHandler);
				ServiceManager.instance.updateDOAvailablePeriod(_dayAvailablePeriod);
			case _:
				return;
		}
    }
	
    private function _editDOAvailablePeriodCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.updateDOAvailablePeriod)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _editDOAvailablePeriodCompleteHandler);
            displayDOAvailablePeriods();
        }
    }
    
    
    /************************************************************************/
    /********************* SAVE VISIT *******************************************/
    /************************************************************************/
		
    private function _saveVisitFromSearchResult():Void
    {
        var startDate:Date = _getStartDateForNewVisit();
        var endDate:Date = Date.fromTime(startDate.getTime() + Config.INIT_SLOT_LENGTH_TIME);
        var newPeriod:Period = new Period(startDate, endDate);
		
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ERROR, _saveVisitErrorHandler);
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_EXHIBITOR_AVAILABILITY, _saveVisitAskForConfirmExhibitorAvailabilityHandler);
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ALERT_EXHIBITOR_NON_ELIGIBLE, _saveVisitAlertExhibitorNonEligibleHandler);
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.COMPLETE, _saveVisitCompleteHandler);
        VisitSaveHelper.instance.saveVisit(VisitSaveType.FROM_RESULT_SEARCH, null, newPeriod, SearchResult.selected);
    }
	
    private function _saveVisitFromVisitItem(visit:Visit):Void
    {
        var startDate:Date = _getStartDateForNewVisit();
        var endDate:Date = Date.fromTime(startDate.getTime() + visit.period.length);
        if (endDate.getTime() > _totalDayPeriod.endABSOLUTE)
        {
            return;
        }
        if (startDate.getTime() < _totalDayPeriod.startABSOLUTE)
        {
            return;
        }
        var newPeriod:Period = new Period(startDate, endDate);
        
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ERROR, _saveVisitErrorHandler);
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_EXHIBITOR_AVAILABILITY, _saveVisitAskForConfirmExhibitorAvailabilityHandler);
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ALERT_EXHIBITOR_NON_ELIGIBLE, _saveVisitAlertExhibitorNonEligibleHandler);
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _saveVisitAskForConfirmSerieHandler);
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.COMPLETE, _saveVisitCompleteHandler);
        if (VisitDragger.instance.origin == VisitDraggerOrigin.PENDING )
        {
            VisitSaveHelper.instance.saveVisit(VisitSaveType.FROM_PENDING_VISIT, visit, newPeriod);
        }
        else
        {
            VisitSaveHelper.instance.saveVisit(VisitSaveType.FROM_VISIT_ITEM, visit, newPeriod);
        }
    }
	
    
    private function _saveVisitAlertExhibitorNonEligibleHandler(e:VisitSaveEvent):Void
    {
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ERROR, _saveVisitErrorHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_EXHIBITOR_AVAILABILITY, _saveVisitAskForConfirmExhibitorAvailabilityHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ALERT_EXHIBITOR_NON_ELIGIBLE, _saveVisitAlertExhibitorNonEligibleHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _saveVisitAskForConfirmSerieHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.COMPLETE, _saveVisitCompleteHandler);
		
        DialogManager.instance.addEventListener(DialogEvent.CLOSE, _saveVisitConfirmExhibitorAvailabilityCloseHandler);		
		DialogManager.instance.open( new VMConfirmDialog( "Message Dialog Title", e.message ) );
    }
    private function _saveVisitAskForConfirmExhibitorAvailabilityHandler(e:VisitSaveEvent):Void
    {
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ERROR, _saveVisitErrorHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_EXHIBITOR_AVAILABILITY, _saveVisitAskForConfirmExhibitorAvailabilityHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ALERT_EXHIBITOR_NON_ELIGIBLE, _saveVisitAlertExhibitorNonEligibleHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _saveVisitAskForConfirmSerieHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.COMPLETE, _saveVisitCompleteHandler);
		
        DialogManager.instance.addEventListener(DialogEvent.CLOSE, _saveVisitConfirmExhibitorAvailabilityCloseHandler);
		DialogManager.instance.open( new ConfirmInteractiveDialog( "Confirm Dialog Title", e.message ) );
    }
	
    private function _saveVisitConfirmExhibitorAvailabilityCloseHandler(e:DialogEvent):Void
    {
        DialogManager.instance.removeEventListener(DialogEvent.CLOSE, _saveVisitConfirmExhibitorAvailabilityCloseHandler);		
		
		switch ( e.value ) 
		{
			case DialogValue.CONFIRM:
				// confirm Visit as it is..            
				VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ERROR, _saveVisitErrorHandler);
				VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _saveVisitAskForConfirmSerieHandler);
				VisitSaveHelper.instance.addEventListener(VisitSaveEvent.COMPLETE, _saveVisitCompleteHandler);
				VisitSaveHelper.instance.confirmSaveVisit();
				
			case DialogValue.DATA( newDateString ):
				// confirm Visit with a new period        
				VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ERROR, _saveVisitErrorHandler);
				VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _saveVisitAskForConfirmSerieHandler);
				VisitSaveHelper.instance.addEventListener(VisitSaveEvent.COMPLETE, _saveVisitCompleteHandler);
				VisitSaveHelper.instance.confirmSaveVisit(DateUtils.fromDBString(newDateString));
				
			case _:
				return;
		}
    }
    
    private function _saveVisitAskForConfirmSerieHandler(e:VisitSaveEvent):Void
    {
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ERROR, _saveVisitErrorHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _saveVisitAskForConfirmSerieHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.COMPLETE, _saveVisitCompleteHandler);
        
        DialogManager.instance.addEventListener(DialogEvent.CLOSE, _saveVisitConfirmSerieCloseHandler);
        DialogManager.instance.open(new ConfirmVisitSerieDialog( "Confirm Visit Serie Dialog Title", e.message ) );
    }
    private function _saveVisitConfirmSerieCloseHandler(e:DialogEvent):Void
    {
        DialogManager.instance.removeEventListener(DialogEvent.CLOSE, _saveVisitConfirmSerieCloseHandler);
        
        switch (e.value )
        {
			case DialogValue.CANCEL:
				return;
				
			case DialogValue.DATA(visitSerieProcess):				
				VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ERROR, _saveVisitErrorHandler);
				VisitSaveHelper.instance.addEventListener(VisitSaveEvent.COMPLETE, _saveVisitCompleteHandler);
				VisitSaveHelper.instance.confirmSaveVisitSerie(visitSerieProcess);
			case _:
				return;
        }
    }
    
    
    
    private function _saveVisitErrorHandler(e:VisitSaveEvent):Void
    {
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ERROR, _saveVisitErrorHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_EXHIBITOR_AVAILABILITY, _saveVisitAskForConfirmExhibitorAvailabilityHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ALERT_EXHIBITOR_NON_ELIGIBLE, _saveVisitAlertExhibitorNonEligibleHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _saveVisitAskForConfirmSerieHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.COMPLETE, _saveVisitCompleteHandler);
		
        DialogManager.instance.open( new VMMessageDialog("Message Dialog title", e.message ) );
    }
    private function _saveVisitCompleteHandler(e:VisitSaveEvent):Void
    {
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ERROR, _saveVisitErrorHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_EXHIBITOR_AVAILABILITY, _saveVisitAskForConfirmExhibitorAvailabilityHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ALERT_EXHIBITOR_NON_ELIGIBLE, _saveVisitAlertExhibitorNonEligibleHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _saveVisitAskForConfirmSerieHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.COMPLETE, _saveVisitCompleteHandler);
              

        switch (VisitSaveHelper.instance.currentSaveType)
        {
            case VisitSaveType.FROM_RESULT_SEARCH:
                if (VisitSaveHelper.instance.currentVisit.idDemand > 0)
                {
                    SearchResult.list.removeItem(SearchResult.selected);					
                    ResultPanel.instance.updateSearchResultList(SearchResult.list);
                }
				
            case VisitSaveType.CHANGE_STATUS:
                _removeVisitStatusMenu();
				
            case VisitSaveType.FROM_VISIT_ITEM:
                PendingPanel.instance.updatePendingList();
                
                // check save Serie Result
				// TODO : check if e.message is null when no serie, or just an empty string
                if (e.message != null )
                {
                    DialogManager.instance.open(new VMMessageDialog( "Message Dialog title", e.message ) );
                }
				
            case VisitSaveType.FROM_PENDING_VISIT:
                PendingPanel.instance.updatePendingList();
				
            default:
				return;
        }
    }
    /*************************************************************/
    
    
    
    
    /*************************************************************/
    /************* REMOVE VISIT *************************************/
    /*************************************************************/
    private function _removeVisit(visit:Visit):Void
    {
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _removeVisitAskForConfirmSerieHandler);
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.COMPLETE, _removeVisitCompleteHandler);
        VisitSaveHelper.instance.removeVisit(visit);
    }
    private function _removeVisitAskForConfirmSerieHandler(e:VisitSaveEvent):Void
    {
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _removeVisitAskForConfirmSerieHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.COMPLETE, _removeVisitCompleteHandler);
		
        DialogManager.instance.addEventListener(DialogEvent.CLOSE, _removeVisitAskForConfirmSerieCloseHandler);
        DialogManager.instance.open(new ConfirmVisitSerieDialog("Confirm Visit Serie Dialog Title", e.message ) );
    }
    private function _removeVisitAskForConfirmSerieCloseHandler(e:DialogEvent):Void
    {
        DialogManager.instance.removeEventListener(DialogEvent.CLOSE, _removeVisitAskForConfirmSerieCloseHandler);
        
        switch (e.value) 
		{
			case DialogValue.CANCEL:
				return;
				
			case DialogValue.DATA(content):
				VisitSaveHelper.instance.addEventListener(VisitSaveEvent.COMPLETE, _removeVisitCompleteHandler);
				VisitSaveHelper.instance.confirmRemoveVisitSerie(content);
			case _:
				return;
		}        
    }
    private function _removeVisitCompleteHandler(e:VisitSaveEvent):Void
    {
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _removeVisitAskForConfirmSerieHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.COMPLETE, _removeVisitCompleteHandler);
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

