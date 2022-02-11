package com.coges.visitmanager.ui.panel;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.VisitDragger;
import com.coges.visitmanager.core.VisitDraggerOrigin;
import com.coges.visitmanager.core.VisitSaveHelper;
import com.coges.visitmanager.ui.components.ScrollItemPending;
import com.coges.visitmanager.vo.PendingVisit;
import nbigot.ui.control.Scrollbar.GripStyle;
import nbigot.ui.list.ScrollList;
//import com.coges.visitmanager.core.VisitDragger;
import com.coges.visitmanager.datas.DataUpdater;
import com.coges.visitmanager.datas.ServiceManager;
import com.coges.visitmanager.datas.DataUpdaterEvent;
import com.coges.visitmanager.core.DraggerEvent;
import com.coges.visitmanager.datas.ServiceEvent;
import com.coges.visitmanager.events.VisitSaveEvent;
import com.coges.visitmanager.events.VMEvent;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.ui.VisitStatusMenu;
import com.coges.visitmanager.ui.components.VMButton;
import com.coges.visitmanager.ui.dialog.VMConfirmDialog;
import nbigot.ui.IconPosition;
//import com.coges.visitmanager.core.VisitSaveHelper;
import com.coges.visitmanager.core.VisitSaveType;
import com.coges.visitmanager.vo.DO;
import com.coges.visitmanager.vo.Planning;
import com.coges.visitmanager.vo.User;
import com.coges.visitmanager.vo.Visit;
import com.coges.visitmanager.vo.VisitStatusID;
import motion.Actuate;
import nbigot.ui.control.Label;
import nbigot.ui.control.WaitPanel;
import nbigot.ui.dialog.DialogEvent;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.DialogValue;
import nbigot.ui.control.ToolTip;
import nbigot.ui.list.ScrollItemSelectType;
import nbigot.utils.Collection;
import com.coges.visitmanager.core.Locale;
import nbigot.utils.ImageUtils;
import nbigot.utils.SpriteUtils;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.filters.DropShadowFilter;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class PendingPanel extends Sprite
{    
	public static final MIN_WIDTH:Int = 280;
	public static final MAX_WIDTH:Int = 280;	
	
    public static var instance(default, null):PendingPanel;
    
    
    private var _openTab:Sprite;
    private var _lblTitle:Label;
    private var _btClear:VMButton;
    private var _btRefresh:VMButton;
	private var _background:Sprite;
	private var _listBackground:Sprite;
	
	
	public var mode(default, set):PanelMode;
	public function set_mode(value:PanelMode):PanelMode
	{
		mode = value;
		if ( hasEventListener( Event.ENTER_FRAME ) )
			removeEventListener(Event.ENTER_FRAME, _enterFrameHandler);
		return value;
	}
	
	private var _scrollListPending:ScrollList<PendingVisit>;
	private var _selectedScrollItemPending:ScrollItemPending;
    private var _waitPanel:WaitPanel;
    private var _openedPosition:Point;
    private var _closedPosition:Point;
    private var _magnetBorder:Shape;
	private var _listRect:Rectangle;
    private var _visitToAdd:Visit;
    
    public function new()
    {
        super();
        instance = this;
		
		mode = PanelMode.FIXE;
		
		_openTab = SpriteUtils.createRoundSquare(40, 70, 4, 4, Colors.GREY1, 1, Colors.GREY2);
		var i = Icons.getIcon( Icon.PENDING );
		ImageUtils.center( i, new Rectangle( 0, 0, _openTab.width - 10, _openTab.height ) );
		_openTab.addChild(i);
		addChild( _openTab );
		
		_background = SpriteUtils.createSquare( 40, 40, Colors.DARK_BLUE1 );
		addChild(_background);	
		
		_listBackground = SpriteUtils.createSquare( 40, 40, Colors.DARK_BLUE2 );
		addChild(_listBackground);		
		
		_lblTitle = new Label( Locale.get("LBL_PENDING").toUpperCase(), new TextFormat( Fonts.OPEN_SANS, 16, Colors.GREY3 ) );
		addChild( _lblTitle );
		
		
		
		
		
		_btClear = new VMButton("", null, SpriteUtils.createRoundSquare(48, 22, 4, 4, Colors.RED1) );
		_btClear.borderEnabled = false;
		_btClear.setIcon( Icons.getIcon( Icon.PENDING_CLEAR), null,IconPosition.CENTER );
		_btClear.toolTipContent = Locale.get("TOOLTIP_BT_CLEAR_PENDING");
        _btClear.addEventListener(MouseEvent.CLICK, _clearClickHandler);
		addChild(_btClear);	
		
		
		_btRefresh = new VMButton("", null, SpriteUtils.createRoundSquare(48, 22, 4, 4, Colors.BLUE1) );
		_btRefresh.borderEnabled = false;
		_btRefresh.setIcon( Icons.getIcon( Icon.PENDING_REFRESH), null,IconPosition.CENTER );
		_btRefresh.toolTipContent = Locale.get("TOOLTIP_BT_REFRESH_PENDING");
        _btRefresh.addEventListener(MouseEvent.CLICK, _refreshClickHandler);
		addChild(_btRefresh);	
		
		
		
		
		
		
        VisitDragger.instance.addEventListener(DraggerEvent.MOVE, _draggerVisitItemMoveHandler);
        VisitDragger.instance.addEventListener(DraggerEvent.DROP, _draggerVisitItemDropHandler, false, 5);  // listener priority > 0 --> CalendarDayItem will not catch this event  
		
		DataUpdater.instance.addEventListener(DataUpdaterEvent.PLANNING_SELECTED_CHANGE, _changePlanningHandler );
        //Planning.addEventListener(DataUpdaterEvent.PLANNING_SELECTED_CHANGE, _changePlanningHandler);
		
        addEventListener(MouseEvent.MOUSE_OVER, _rolloverHandler);
        addEventListener(Event.ADDED_TO_STAGE, init);
    }
    
    private function init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        
        //filters = [new DropShadowFilter(2, 180, 0, 0.6, 2, 2, 1, 2)];
    }
    private function _rolloverHandler(e:MouseEvent):Void
    {
        if (!CalendarPanel.instance.isEditDOAvailablePeriodMode)
        {
			if (mode == PanelMode.MOVABLE)
			{
				dispatchEvent(new VMEvent(VMEvent.OPEN_PENDING));
				addEventListener(Event.ENTER_FRAME, _enterFrameHandler);
			}
		}
    }
    
    private function _enterFrameHandler(e:Event):Void
    {		
        if (stage.mouseX < stage.stageWidth-MIN_WIDTH )
        {
            removeEventListener(Event.ENTER_FRAME, _enterFrameHandler);
            dispatchEvent(new VMEvent(VMEvent.CLOSE_PENDING));
        }
    }
    private function _refreshClickHandler(e:MouseEvent):Void
    {
        _loadPendingList();
    }
    
    private function _clearClickHandler(e:MouseEvent):Void
    {
        //PopupManager.instance.addEventListener(DialogEvent.CLOSE, _confirmClearPendingListHandler);
        //var isHTML:Bool = true;
        //PopupManager.instance.openPopup(PopupType.CONFIRM, "", Locale.get("CLEAR_PENDING_LIST"), null, null, isHTML);
        DialogManager.instance.addEventListener(DialogEvent.CLOSE, _clearPendingListConfirmHandler);
        DialogManager.instance.open( new VMConfirmDialog( Locale.get("TOOLTIP_BT_CLEAR_PENDING"), Locale.get("CLEAR_PENDING_LIST"), Icons.getIcon(Icon.DIALOG_ATTENTION) ) );
    }
    
    private function _clearPendingListConfirmHandler(e:DialogEvent):Void
    {
        //PopupManager.instance.removeEventListener(DialogEvent.CLOSE, _confirmClearPendingListHandler);
        DialogManager.instance.removeEventListener(DialogEvent.CLOSE, _clearPendingListConfirmHandler);
        
        if (e.value == DialogValue.CANCEL) return;
		
		
        ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _clearDOPendingVisitListCompleteHandler);
        ServiceManager.instance.clearDOPendingVisitList(PendingVisit.list);
    }
    
    private function _clearDOPendingVisitListCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.clearDOPendingVisitList)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _clearDOPendingVisitListCompleteHandler);
            
            _loadPendingList();
            ServiceManager.instance.getDOVisitList(DO.selected, Planning.selected, User.instance);
        }
    }
    
    private function _changePlanningHandler(e:Event):Void
    {
        _loadPendingList();
    }
    
    
    private function _loadPendingList():Void
    {
        ServiceManager.instance.addEventListener(ServiceEvent.START, _pendingListLoadStartHandler);
        ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _pendingListLoadCompleteHandler);
        ServiceManager.instance.getDOPendingVisitList(DO.selected, Planning.selected, User.instance);
    }
    
    private function _pendingListLoadStartHandler(e:ServiceEvent):Void
    {
		if (_waitPanel == null)
		{
			_waitPanel = new WaitPanel(new Rectangle(0, 0, _background.width, _background.height) );
			_waitPanel.displayMessage( Locale.get("LBL_WAIT_ITEM_WAIT"), new TextFormat(Fonts.OPEN_SANS, 11, Colors.WHITE) );
			_waitPanel.displayIcon( new WaitWheel() );
			
			addChild(_waitPanel);
		}
    }
    
    
    private function _pendingListLoadCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.getDOPendingVisitList)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _pendingListLoadCompleteHandler);
            ServiceManager.instance.removeEventListener(ServiceEvent.START, _pendingListLoadStartHandler);
            
            _displayPendingList();
            
            if (_waitPanel != null)
            {
                removeChild(_waitPanel);
                _waitPanel = null;
            }
        }
    }
    
    private function _displayPendingList():Void
    {
        if (_scrollListPending != null)
        {
            removeChild(_scrollListPending);
            _scrollListPending = null;
        }
        
        var datas:Collection<PendingVisit> = PendingVisit.list.clone();
        
        if ( datas.length == 0)
        {
			// creation objet fictif pour affichage "no result"
			var pvJSON:VisitJSON = {
				id:0, 
				idPlanning:0, 
				idDemand:0, 
				demandPriority:"", 
				idSpecialVisit:0, 
				idExhibitor:0, 
				exhibitorCode:0, 
				idDO:0, 
				dateStartString:null, 
				dateEndString:null, 
				contact:"", 
				phone:"", 
				isLocked:false, 
				location:"", 
				motivation:"", 
				comment:"", 
				isValdidateByProgrammer:false, 
				isValdidateByOZ:false, 
				name:Locale.get("NO_RESULT"), 
				notes:"", 
				notesProg:"", 
				idStatus:null, 
				exhibitorName:"", 
				exhibitorWelcomeCapacity:0, 
				idExhibitorCountry:0, 
				specialVisitName:"", 
				visitActivityList:null, 
				idVotePeriod:""
			};
            datas.addItem(new PendingVisit( pvJSON ));
        }
        
        _scrollListPending = new ScrollList(datas, Std.int(_listRect.width), Std.int(_listRect.height), "name", ScrollItemPending);
		_scrollListPending.scrollbarOptions.gripStyle = GripStyle.LINE;
		_scrollListPending.scrollbarOptions.gripColor = Colors.GREY2;
		_scrollListPending.scrollbarOptions.background = false;
        _scrollListPending.y = _listRect.y;
        _scrollListPending.x = _listRect.x;
        _scrollListPending.addEventListener(Event.SELECT, _selectListItemHandler);
        addChild(_scrollListPending);
    }
    
    private function _selectListItemHandler(e:Event):Void
    {        
        _selectedScrollItemPending = cast(_scrollListPending.selectedItem, ScrollItemPending);
        
        if (!User.instance.isAuthorized) return;

        switch (_selectedScrollItemPending.selectType)
        {
            
            case ScrollItemSelectType.DELETE:
				//trace("DELETE PENDING VISIT");
				//FIX : all delete logic has been moved to PendingPanel
				
				//to ensure this Visit has not been removed by another user
				_loadPendingList();
				
				//var v:Visit = PendingVisit( _selectedScrollItemPending.getData() ).relatedVisit;
				//ServiceManager.instance.addEventListener( ServiceEvent.COMPLETE, _setDOVisitStandByCompleteHandler );
				//ServiceManager.instance.setDOVisitStandBy( v, false );
				
				if ( _selectedScrollItemPending.relatedVisitItem.hasEventListener(VisitSaveEvent.REMOVE) )
				{
					_selectedScrollItemPending.relatedVisitItem.removeEventListener(VisitSaveEvent.REMOVE, _removeVisitItemHandler);
				}
				_selectedScrollItemPending.relatedVisitItem.addEventListener(VisitSaveEvent.REMOVE, _removeVisitItemHandler);
				_selectedScrollItemPending.relatedVisitItem.askForRemoveVisit();
				
				
			case ScrollItemSelectType.SELECT:
				//trace("SELECT PENDING VISIT");
                if (ToolTip.exists)
                {
                    ToolTip.hide();
                }
                VisitDragger.instance.startDrag(_selectedScrollItemPending.relatedVisitItem, VisitDraggerOrigin.PENDING);
                _selectedScrollItemPending.alpha = 0.5;
			case _:
				return;
        }
    }
	
	//FIX : all delete logic has been moved to PendingPanel
	function _removeVisitItemHandler(e:VisitSaveEvent):Void 
	{
		// authorization for removing already handled in VisitItem.askForRemoveVisit()   		
		
		VisitSaveHelper.instance.removeVisit(_selectedScrollItemPending.relatedVisitItem.data);
		_loadPendingList();
	}
    
	
	
	
    /**************************************************************************/
    /**************** MOVE & DROP VISIT  *********************************************/
    /**************************************************************************/    
    private function _draggerVisitItemMoveHandler(e:DraggerEvent):Void
    {
		
		if (mode == PanelMode.MOVABLE)
		{
			if (this.hitTestPoint(stage.mouseX, stage.mouseY))
			{
				dispatchEvent(new VMEvent(VMEvent.OPEN_PENDING));
				addEventListener(Event.ENTER_FRAME, _enterFrameHandler);
			}
		}
        if (_listBackground.hitTestPoint(stage.mouseX, stage.mouseY))
        {
            _createMagnetBorder();
        }
        else
        {
            _removeMagnetBorder();
        }
    }
    private function _createMagnetBorder():Void
    {
        if (_magnetBorder != null) return;
        
        _magnetBorder = new Shape();
        _magnetBorder.graphics.lineStyle(2, Colors.GREEN1 );
        _magnetBorder.graphics.drawRect(0, 0, _listBackground.width, _listBackground.height);
        _magnetBorder.x = _listBackground.x;
        _magnetBorder.y = _listBackground.y;
        addChild(_magnetBorder);
    }
    private function _removeMagnetBorder():Void
    {
        if (_magnetBorder == null) return;
        
        removeChild(_magnetBorder);
        _magnetBorder = null;
    }
    
    private function _draggerVisitItemDropHandler(e:DraggerEvent):Void
    {
        //trace("_draggerVisitItemDropHandler:", "INSIDE:" + _listBackground.hitTestPoint(stage.mouseX, stage.mouseY), "origin:" + VisitDragger.instance.origin);
        _removeMagnetBorder();
        
        if (_selectedScrollItemPending != null)
        {
            _selectedScrollItemPending.alpha = 1;
        }
        
        // Drop inside PendingPanel
        if (_listBackground.hitTestPoint(stage.mouseX, stage.mouseY))
        {
            e.stopImmediatePropagation();
            _visitToAdd = null;
            if (VisitDragger.instance.origin != VisitDraggerOrigin.PENDING)
            {
                _visitToAdd = e.draggerItem.data;
                
                VisitSaveHelper.instance.addEventListener(VisitSaveEvent.COMPLETE, _changeVisitStatusHandler);
                VisitSaveHelper.instance.saveVisit(VisitSaveType.CHANGE_STATUS, _visitToAdd, null, null, VisitStatusID.PENDING);
            }
        }
    }
    
    private function _changeVisitStatusHandler(e:VisitSaveEvent):Void
    {
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.COMPLETE, _changeVisitStatusHandler);
        
        ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _setDOVisitStandByCompleteHandler);
        ServiceManager.instance.setDOVisitStandBy(_visitToAdd, true);
    }
    
    private function _setDOVisitStandByCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.setDOVisitStandBy)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _setDOVisitStandByCompleteHandler);
            
            _loadPendingList();
			
			//this call is now made in CalendarPanel as a response to ServiceManager.instance.setDOVisitStandBy Complete Event
            //ServiceManager.instance.getDOVisitList(DO.selected, Planning.selected, User.instance);
        }
    }
    /**************************************************************************/
	
	
	
    
    public function updatePendingList():Void
    {
        _loadPendingList();
    }
    
    public function show():Void
    {
        Actuate.tween(this, 0.5, {
                    x:stage.stageWidth-MIN_WIDTH
                });
        Actuate.tween(_openTab, 0.5, {
                    x:0
                });
    }
    public function hide():Void
    {
        Actuate.tween(this, 0.5, {
                    x:stage.stageWidth
                });
        Actuate.tween(_openTab, 0.5, {
                    x:-_openTab.width + 10
                });
    }
	
	public function setRect( rect:Rectangle)
	{
		x = rect.x;
		y = rect.y;
		
		//already handled in HomeView._draw()
		/*
		if ( rect.width < MIN_WIDTH ) rect.width = MIN_WIDTH;
		if ( rect.width > MIN_WIDTH ) rect.width = MAX_WIDTH;
		*/
		var marginH:Int = 26;
		var marginV:Int = 18;
		var spacer:Int = 6;
		
		_background.width = rect.width;
		_background.height = rect.height;
		
        if (_waitPanel != null)
		{
			_waitPanel.setRect( new Rectangle( 0, 0, rect.width, rect.height ) );
		}
		
		_openTab.x = ( mode == PanelMode.FIXE ) ? 0 : - _openTab.width + 10 ;
		_openTab.y = (stage.stageHeight - ActionPanel.MIN_HEIGHT - _openTab.height ) * 0.5;
		
		_lblTitle.y = marginV;
		_lblTitle.x = (rect.width - _lblTitle.width ) * 0.5;
		
		_btClear.x = marginH * 2;
		_btClear.y = rect.height - _btClear.height - marginV;
		
		_btRefresh.x = rect.width - _btRefresh.width - marginH * 2;
		_btRefresh.y = rect.height - _btRefresh.height - marginV;
		
		//magic number 12 to add the scrollbar width
		_listRect = new Rectangle( marginH, _lblTitle.y + _lblTitle.height + marginV, rect.width - marginH * 2 + 12, _btRefresh.y - _lblTitle.y - _lblTitle.height - marginV - marginV );
		
		_listBackground.x = _listRect.x;
		_listBackground.y = _listRect.y;
		_listBackground.width = _listRect.width;
		_listBackground.height = _listRect.height;		
		
		
		if ( _scrollListPending != null )
		{
			_scrollListPending.setRect( _listRect );
		}
	} 
}

