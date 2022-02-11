package com.coges.visitmanager.view;


import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Config;
import com.coges.visitmanager.events.VMEvent;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.ui.DummyPanel;
import com.coges.visitmanager.ui.EditDOAvailablePeriodMask;
import com.coges.visitmanager.ui.WaitWheel;
import com.coges.visitmanager.ui.panel.ActionPanel;
import com.coges.visitmanager.ui.panel.CalendarPanel;
import com.coges.visitmanager.ui.panel.InfoPanel;
import com.coges.visitmanager.ui.panel.MenuPanel;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.ui.panel.MessagePanel;
import com.coges.visitmanager.ui.panel.PanelMode;
import com.coges.visitmanager.ui.panel.PendingPanel;
import com.coges.visitmanager.ui.panel.SearchPanel;
import com.coges.visitmanager.ui.panel.ResultPanel;
import feathers.controls.TextInput;
import motion.Actuate;
import nbigot.application.ResizeEvent;
import nbigot.application.ResizeManager;
import nbigot.ui.control.BaseButton;
import nbigot.ui.control.WaitPanel;
import nbigot.utils.SpriteUtils;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class HomeView extends Sprite
{
	private static final _MENU_MIN_HEIGHT:Int = 40;
	private static final _INFO_MIN_HEIGHT:Int = 80;
	private static final _MESSAGE_MIN_HEIGHT:Int = 110;
	private static final _ACTION_MIN_HEIGHT:Int = 110;
	private static final _SEARCH_MIN_HEIGHT:Int = 220;
	private static final _SEARCH_MIN_WIDTH:Int = 230;
	private static final _RESULT_MIN_WIDTH:Int = 230;
	private static final _PENDING_MIN_WIDTH:Int = 222;
	
	
	
    private var _waitPanel:WaitPanel;
    private var _editDOAvailablePeriodMask:EditDOAvailablePeriodMask;
    public var infoPanel:InfoPanel;
	public var menuPanel:MenuPanel;
	public var searchPanel:SearchPanel;
    public var resultPanel:ResultPanel;
    public var calendarPanel:CalendarPanel;
    public var messagePanel:MessagePanel;
    public var actionPanel:ActionPanel;
    public var pendingPanel:PendingPanel;
	
	
	//private var menu:DummyPanel;
	//private var search:DummyPanel;
	//private var result:DummyPanel;
	//private var calendar:DummyPanel;
	//private var message:DummyPanel;
	//private var action:DummyPanel;
	//private var pending:DummyPanel;
    
    public function new()
    {
        super();
        addEventListener(Event.ADDED_TO_STAGE, init);		
		
		/*
		menu = new DummyPanel( "Menu Panel", 0x006699 );
		addChild( menu );
		search = new DummyPanel( "Search Panel", 0x666666 );
		addChild( search );
		result = new DummyPanel( "Result Panel", 0xcccccc );
		addChild( result );*/
		/*calendar = new DummyPanel( "Calendar Panel", 0xaaaa66 );
		addChild( calendar );*/
		/*message = new DummyPanel( "Message Panel", 0xcc00cc );
		addChild( message );
		action = new DummyPanel( "Action Panel", 0x00cccc );
		addChild( action );
		pending = new DummyPanel( "Pending Panel", 0x009966 );
		addChild( pending );*/
		
		calendarPanel = new CalendarPanel();
		addChild( calendarPanel );
		searchPanel = new SearchPanel();
        searchPanel.addEventListener(VMEvent.OPEN_SEARCH, _searchOpenHandler);
        searchPanel.addEventListener(VMEvent.CLOSE_SEARCH, _searchCloseHandler);
		addChild( searchPanel);
		pendingPanel = new PendingPanel();
        pendingPanel.addEventListener(VMEvent.OPEN_PENDING, _pendingOpenHandler);
        pendingPanel.addEventListener(VMEvent.CLOSE_PENDING, _pendingCloseHandler);
		addChild( pendingPanel);
		resultPanel = new ResultPanel();
		addChild( resultPanel);
		infoPanel = new InfoPanel();
		addChild( infoPanel );
		menuPanel = new MenuPanel();
        menuPanel.addEventListener(VMEvent.OPEN_INFOS, _menuInfosOpenHandler);
        menuPanel.addEventListener(VMEvent.CLOSE_INFOS, _menuInfosCloseHandler);
        menuPanel.addEventListener(VMEvent.START_EDIT_DO_AVAILABLE_PERIOD, _editDOAvailablePeriodStartHandler);
		addChild( menuPanel);
		actionPanel = new ActionPanel();
        actionPanel.addEventListener(VMEvent.START_WAITING, _startWaitingHandler);
        actionPanel.addEventListener(VMEvent.STOP_WAITING, _stopWaitingHandler);
		addChild( actionPanel);
		messagePanel = new MessagePanel();
		addChild( messagePanel);		
		
		
        ResizeManager.instance.addEventListener(ResizeEvent.RESIZE, _resizeHandler);
    }
	
	function _resizeHandler(e:ResizeEvent):Void 
	{
		_draw();
	}
    
    private function init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);
		_draw();
    }
	
    
    private function _menuInfosOpenHandler(e:VMEvent):Void
    {
        e.stopImmediatePropagation();
        infoPanel.show();
    }
    
    private function _menuInfosCloseHandler(e:VMEvent):Void
    {
        e.stopImmediatePropagation();
        infoPanel.hide();
    }
	
	function _editDOAvailablePeriodStartHandler(e:VMEvent):Void 
	{
        _editDOAvailablePeriodMask = new EditDOAvailablePeriodMask( stage.stageWidth, stage.stageHeight, new Rectangle(calendarPanel.x, calendarPanel.y, calendarPanel.width, calendarPanel.height ) );
        _editDOAvailablePeriodMask.addEventListener(Event.CLOSE, _editDOAvailablePeriodMaskCloseHandler);
        stage.addChild(_editDOAvailablePeriodMask);
		
		calendarPanel.startEditDOAvailablePeriod();
	}	
	function _editDOAvailablePeriodMaskCloseHandler(e:Event):Void 
	{
		calendarPanel.stopEditDOAvailablePeriod();
		
		_editDOAvailablePeriodMask.removeEventListener(Event.CLOSE, _editDOAvailablePeriodMaskCloseHandler);
		stage.removeChild( _editDOAvailablePeriodMask );
		_editDOAvailablePeriodMask = null;
	}
   
    private function _searchOpenHandler(e:VMEvent):Void
    {
        e.stopImmediatePropagation();
        searchPanel.show();
		resultPanel.show();
		//TODO:
        /*
		Actuate.tween(calendarPanel, 0.5, {
                    x:resultPanel.width,
                    scaleX:(stage.stageWidth - resultPanel.width - 24) / 976
                });
        Actuate.tween(messagePanel, 0.5, {
                    x:resultPanel.width + 5,
                    width:actionPanel.x - resultPanel.width - 5 - 10
                });*/
    }
    
    private function _searchCloseHandler(e:VMEvent):Void
    {
        e.stopImmediatePropagation();
        searchPanel.hide();
		resultPanel.hide();
		//TODO:
        /*
        Actuate.tween(calendarPanel, 0.5, {
                    x:calendarPanel.initX,
                    scaleX:1
                });
        Actuate.tween(messagePanel, 0.5, {
                    x:messagePanel.initX,
                    width:actionPanel.x - messagePanel.initX - 10
                });*/
    }
    
    private function _pendingOpenHandler(e:VMEvent):Void
    {
        e.stopImmediatePropagation();
        pendingPanel.show();
    }
    
    private function _pendingCloseHandler(e:VMEvent):Void
    {
        e.stopImmediatePropagation();
        pendingPanel.hide();
    }
    private function _startWaitingHandler(e:VMEvent):Void
    {
        _showWaitPanel();
    }
    private function _stopWaitingHandler(e:VMEvent):Void
    {
        _hideWaitPanel();
    }
    
    private function _showWaitPanel():Void
    {
        if (_waitPanel == null)
        {		
			_waitPanel = new WaitPanel(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
			_waitPanel.displayMessage(Locale.get("LBL_WAIT_ITEM_WAIT"), new TextFormat( Fonts.OPEN_SANS, 14, 0xffffff ));
			_waitPanel.displayIcon(new WaitWheel());
			addChild(_waitPanel);
        }
    }
    
    private function _hideWaitPanel():Void
    {
        if (_waitPanel != null)
        {
            removeChild(_waitPanel);
            _waitPanel = null;
        }
    }
	
	private function _draw():Void
	{
		var w = stage.stageWidth;
		var h = stage.stageHeight;
		
		//1920/1600/1440/1366/1280/1024
		
		var menuRect = new Rectangle(0, 0, w, MenuPanel.MIN_HEIGHT);
		
		
		var searchRect = new Rectangle(0, menuRect.bottom, w  * 0.20, SearchPanel.MIN_HEIGHT);
		if ( searchRect.width < SearchPanel.MIN_WIDTH ) searchRect.width = SearchPanel.MIN_WIDTH;
		if ( searchRect.height < SearchPanel.MIN_HEIGHT ) searchRect.height = SearchPanel.MIN_HEIGHT;
		
		var resultRect = new Rectangle(0, searchRect.bottom, w * 0.20, h - menuRect.height - searchRect.height);
		if ( resultRect.width < ResultPanel.MIN_WIDTH ) resultRect.width = ResultPanel.MIN_WIDTH;
		
		var actionRect = new Rectangle(0, h - ActionPanel.MIN_HEIGHT, (w - resultRect.width) * 0.50, ActionPanel.MIN_HEIGHT);
		if ( actionRect.width < ActionPanel.MIN_WIDTH ) actionRect.width = ActionPanel.MIN_WIDTH;
		//var actionRect = new Rectangle(messageRect.right, h - ActionPanel.MIN_HEIGHT, w * 0.40, ActionPanel.MIN_HEIGHT);
		
		var messageRect = new Rectangle(resultRect.right, h - MessagePanel.MIN_HEIGHT, w - resultRect.width - actionRect.width, MessagePanel.MIN_HEIGHT);
		//var messageRect = new Rectangle(resultRect.right, h - MessagePanel.MIN_HEIGHT, w * 0.40, MessagePanel.MIN_HEIGHT);	
		actionRect.x = messageRect.right;
		
		var pendingRect = new Rectangle(w-PendingPanel.MAX_WIDTH, menuRect.bottom, PendingPanel.MAX_WIDTH, h - menuRect.height- messageRect.height);
		//var pendingRect = new Rectangle(calendarRect.right, menuRect.bottom, w*0.20, h - menuRect.height- messageRect.height);	
		
		var calendarRect = new Rectangle(searchRect.right, menuRect.bottom, w - searchRect.width - pendingRect.width, h - menuRect.height- messageRect.height);
		//var calendarRect = new Rectangle(searchRect.right, menuRect.bottom, w*0.60, h - menuRect.height- messageRect.height);
		
		var infoRect = new Rectangle(searchRect.right, MenuPanel.MIN_HEIGHT - InfoPanel.MIN_HEIGHT, w - searchRect.width - pendingRect.width, InfoPanel.MIN_HEIGHT);
		
		
		searchPanel.mode = PanelMode.FIXE;
		pendingPanel.mode = PanelMode.FIXE;
		
		
		
		if ( w <= Config.LAYOUT2_MAX_WIDTH )
		{
			pendingPanel.mode = PanelMode.MOVABLE;
			
			pendingRect.width = PendingPanel.MIN_WIDTH;
			pendingRect.x = w;
			calendarRect.width = w - searchRect.width;
			//calendarRect.width = w * 0.80;
			infoRect.width = w - searchRect.width;
		}
		
		
		if ( w <= Config.LAYOUT1_MAX_WIDTH )
		{
			searchPanel.mode = PanelMode.MOVABLE;
			
			searchRect.width = SearchPanel.MIN_WIDTH;
			searchRect.x = -searchRect.width;
			resultRect.width = ResultPanel.MIN_WIDTH;
			resultRect.height = h - menuRect.height - searchRect.height - messageRect.height;
			resultRect.x = -resultRect.width;
			calendarRect.x = 0;
			calendarRect.width = w;
			
			actionRect.x = 0;
			//actionRect.x = messageRect.right;
			actionRect.width = w * 0.50;
			if ( actionRect.width < ActionPanel.MIN_WIDTH ) actionRect.width = ActionPanel.MIN_WIDTH;
			
			messageRect.x = 0;
			messageRect.width = w - actionRect.width;
			
			actionRect.x = messageRect.right;
			
			
			infoRect.x = 0;
			infoRect.width = w;
		}
		
		
		//menu.setRect(menuRect);
		menuPanel.setRect(menuRect);
		
		//search.setRect( searchRect);
		searchPanel.setRect( searchRect);
		//result.setRect( resultRect);
		resultPanel.setRect( resultRect);
		
		//message.setRect( messageRect);
		messagePanel.setRect( messageRect);
		//action.setRect( actionRect);
		actionPanel.setRect( actionRect);
		
		//calendar.setRect( calendarRect);
		calendarPanel.setRect( calendarRect);
		
		//pending.setRect( pendingRect );
		pendingPanel.setRect( pendingRect );
		
		infoPanel.setRect( infoRect );
		
		if (_editDOAvailablePeriodMask != null )
		{
			_editDOAvailablePeriodMask.setRect( new Rectangle( 0, 0, w, h), calendarRect );
		}
	}
}

