package com.coges.visitmanager.ui.panel;


import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Config;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.datas.DataUpdater;
import com.coges.visitmanager.datas.DataUpdaterEvent;
import com.coges.visitmanager.datas.ServiceEvent;
import com.coges.visitmanager.datas.ServiceManager;
import com.coges.visitmanager.events.VMEvent;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.ui.components.ComboListDO;
import com.coges.visitmanager.ui.components.ComboListDOStatus;
import com.coges.visitmanager.ui.components.VMButton;
import com.coges.visitmanager.ui.dialog.AddDONotesDialog;
import com.coges.visitmanager.ui.dialog.VMMessageDialog;
import com.coges.visitmanager.vo.DO;
import com.coges.visitmanager.vo.DOStatus;
import com.coges.visitmanager.vo.NotificationAction;
import com.coges.visitmanager.vo.OppositeOwner;
import com.coges.visitmanager.vo.Planning;
import com.coges.visitmanager.vo.User;
import com.coges.visitmanager.vo.UserType;
import nbigot.ui.IconPosition;
import nbigot.ui.control.Label;
import nbigot.ui.control.WaitPanel;
import nbigot.ui.dialog.DialogEvent;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.DialogSkin;
import nbigot.ui.dialog.DialogValue;
import nbigot.utils.SpriteUtils;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.net.URLRequest;
import openfl.net.URLRequestMethod;
import openfl.net.URLVariables;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class MenuPanel extends Sprite
{
	public static final MIN_HEIGHT:Int = 40;
	/*
	public static var INFO_LIMIT_LEFT:Int = 40;
	public static var INFO_LIMIT_RIGHT:Int = 40;*/
	
	private var _background:Sprite;	
	private var _btBack:VMButton;
	private var _btInfos:VMButton;
	private var _btRefreshAll:VMButton;
	private var _btAddDONote:VMButton;
    private var _btEditDOAvailablePeriod:VMButton;
	private var _clDOStatus:ComboListDOStatus;
	private var _clDO:ComboListDO;	
	
	//2022-evolution
	private var _checkMultiUsersResultList:Array<MultiUsersDataJSON>;
	private var _DONotAvailableDialogIsOpen:Bool = false;
	private var _lblMultiUserNum:Label;
	
    public function new()
    {
        super();
        
		_background = SpriteUtils.createSquare( 40, MIN_HEIGHT, Colors.DARK_BLUE2 );
		addChild(_background);
		
		
		_btBack = new VMButton( Locale.get("BT_BACK_LABEL"), new TextFormat(Fonts.OPEN_SANS, 14, Colors.GREY1), SpriteUtils.createSquare( 120, 40, Colors.DARK_BLUE2 ) );
		_btBack.setIcon( Icons.getIcon(Icon.BACK, 6, 10 ), new Point(30, MIN_HEIGHT), IconPosition.LEFT );
		_btBack.borderEnabled = false;
        _btBack.addEventListener(MouseEvent.CLICK, _btBackClickHandler);
		addChild(_btBack);
		
		_btInfos = new VMButton( "", null, SpriteUtils.createSquare( 80, MIN_HEIGHT, Colors.DARK_BLUE2  ) );
		_btInfos.setIcon( Icons.getIcon(Icon.INFO, 26,26 ), null, IconPosition.CENTER );
		_btInfos.borderEnabled = false;
        _btInfos.addEventListener(MouseEvent.ROLL_OVER, _btInfosRolloverHandler);
        _btInfos.addEventListener(MouseEvent.ROLL_OUT, _btInfosRolloutHandler);
		addChild(_btInfos);
		
		_btRefreshAll = new VMButton( "", null, SpriteUtils.createSquare( 70, MIN_HEIGHT, Colors.DARK_BLUE2  ) );
		_btRefreshAll.setIcon( Icons.getIcon(Icon.REFRESH_PLANNING, 26,26 ), null, IconPosition.CENTER );
		_btRefreshAll.borderEnabled = false;
        _btRefreshAll.addEventListener(MouseEvent.CLICK, _btRefreshAllClickHandler);
        _btRefreshAll.toolTipContent = Locale.get("TOOLTIP_BT_REFRESH_PLANNING");
		addChild(_btRefreshAll);
		
		_btAddDONote = new VMButton( "", null, SpriteUtils.createSquare( 70, MIN_HEIGHT, Colors.DARK_BLUE2  ) );
		_btAddDONote.setIcon( Icons.getIcon(Icon.ADD_DO_NOTES, 29, 26 ), null, IconPosition.CENTER );
		_btAddDONote.borderEnabled = false;
        _btAddDONote.addEventListener(MouseEvent.CLICK, _btAddDONoteClickHandler);
        _btAddDONote.toolTipContent = Locale.get("TOOLTIP_BT_ADD_DO_NOTE");
		_btAddDONote.enabled = User.instance.isAuthorized;
		addChild(_btAddDONote);
		
		_btEditDOAvailablePeriod = new VMButton( "", null, SpriteUtils.createSquare( 70, MIN_HEIGHT, Colors.DARK_BLUE2  ) );
		_btEditDOAvailablePeriod.setIcon( Icons.getIcon(Icon.EDIT_AVAILABLE_PERIOD, null, 26 ), null, IconPosition.CENTER );
		_btEditDOAvailablePeriod.borderEnabled = false;
        _btEditDOAvailablePeriod.addEventListener(MouseEvent.CLICK, _editDOAvailablePeriodClickHandler);
        _btEditDOAvailablePeriod.toolTipContent = Locale.get("TOOLTIP_BT_EDIT_DO_AVAILABLE_PERIOD");
		_btEditDOAvailablePeriod.enabled = User.instance.isAuthorized;
		addChild(_btEditDOAvailablePeriod);
		
		
		
		_clDOStatus = new ComboListDOStatus(DOStatus.list);
        _clDOStatus.addEventListener(Event.SELECT, _selectDOStatusHandler);
		_clDOStatus.enabled = User.instance.isAuthorized;
        addChild(_clDOStatus);
		
		// TODO TMP
		_clDOStatus.selectedIndex = 0;
		
		
		_clDO = new ComboListDO(null);
        _clDO.addEventListener(Event.SELECT, _DOSelectHandler);
		_clDO.enabled = User.instance.isAuthorized;
        addChild(_clDO);
		
        if (DO.list.length == 0)
        {
            _loadDOList();
        }
        else
        {
            _fillComboListDO();
        }		
        
		DataUpdater.instance.addEventListener(DataUpdaterEvent.DO_SELECTED_CHANGE, _changeDOHandler );
		
		
		
		//2022-evolution
		_lblMultiUserNum = new  Label( "99", new TextFormat(Fonts.OPEN_SANS, 15, Colors.RED2, true) );
		_lblMultiUserNum.mouseEnabled = false;
		_lblMultiUserNum.mouseChildren = false;
		addChild( _lblMultiUserNum );
        
        addEventListener(Event.ADDED_TO_STAGE, _init);
    }
    
    private function _init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, _init);
    }
	
	
    private function _btInfosRolloverHandler(e:MouseEvent):Void
    {
        dispatchEvent(new VMEvent(VMEvent.OPEN_INFOS));
    }
    
    private function _btInfosRolloutHandler(e:MouseEvent):Void
    {
        dispatchEvent(new VMEvent(VMEvent.CLOSE_INFOS));
    }
	
    private function _btBackClickHandler(e:MouseEvent):Void
    {
        var page:String = Config.INIT_PREVIOUS_PAGE_NAME + ".php";
        var url:URLRequest = new URLRequest(Config.goBackURL + page);
        
        var paramsString:String = Config.INIT_PREVIOUS_SEARCH_PARAMS.join("&");
        if (paramsString.length > 0)
        {
            var params:URLVariables = new URLVariables();
            params.decode(paramsString);
            url.data = params;
            url.method = URLRequestMethod.GET;
        }
        
        Lib.navigateToURL(url, "_self");		
    }
    
    private function _btRefreshAllClickHandler(e:MouseEvent):Void
    {
        if (!Planning.selected.isLocked)
        {
            DO.selected = _clDO.selectedData;
        }
    }
    private function _btAddDONoteClickHandler(e:MouseEvent):Void
    {
        DialogManager.instance.addEventListener(DialogEvent.CLOSE, _addDONoteCloseHandler);
		
		DialogManager.instance.open( new AddDONotesDialog( Locale.get("TOOLTIP_BT_ADD_DO_NOTE"), Locale.get("ADD_DO_NOTES") ) );
    }
    
    private function _addDONoteCloseHandler(e:DialogEvent):Void
    {
        DialogManager.instance.removeEventListener(DialogEvent.CLOSE, _addDONoteCloseHandler);
		switch ( e.value) 
		{
			case DialogValue.CANCEL:
				return;
			case DialogValue.DATA(content):
				DO.selected.notes = content;
				ServiceManager.instance.updateDONotes(DO.selected);
			case _:
				return;
		}
    }
    
    
    private function _loadDOList():Void
    {
        ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _loadDOListCompleteHandler);
        ServiceManager.instance.getDOList(User.instance);
    }
    
    private function _loadDOListCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.getDOList)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _loadDOListCompleteHandler);
			
			if ( DO.list.length == 0 )
			{
				//Error no DO found
				var w = new WaitPanel( new Rectangle( 0, 0, stage.stageWidth, stage.stageHeight ) );
				w.displayMessage( "ERROR: NO DO FOUND", new TextFormat( Fonts.OPEN_SANS, 12, Colors.WHITE ) );
				stage.addChild( w);
				return;
			}
			
			
			
			
			
            
            DO.selected = DO.getDOByID(Config.INIT_ID_DO);
			
            if (DO.selected == null)
            {
				//2022-evolution
				//if this flag is not managed, this dialog cannot be seen because the 'check multi users' dialog would replace it immediately after.
				_DONotAvailableDialogIsOpen = true;
				DialogManager.instance.addEventListener( DialogEvent.CLOSE, _DONotAvailableDialogCloseHandler );
				//--
                DialogManager.instance.open( new VMMessageDialog( "Title", Locale.get("MESSAGE_DO_NOT_AVAILABLE"), Icons.getIcon( Icon.DIALOG_INFO ) ) );
				
                DO.selected = DO.list.getItemAt(0);
            }
            _fillComboListDO();
        }
    }
	
	//2022-evolution
	function _DONotAvailableDialogCloseHandler(e:DialogEvent):Void 
	{
		DialogManager.instance.removeEventListener( DialogEvent.CLOSE, _DONotAvailableDialogCloseHandler );
		_DONotAvailableDialogIsOpen = false;
		_displayCheckMultiUsersResult();
	}
	//--
    
    private function _fillComboListDO():Void
    {
        _clDO.datas = DO.list;
        if (DO.selected != null )
        {
            _clDO.selectedData = DO.selected;
            var doStatus:DOStatus = DOStatus.getDOStatusByID(DO.selected.idStatus);
            if (doStatus != null)
            {
                _clDOStatus.selectedData = doStatus;
            }
            else
            {
                _clDOStatus.selectedIndex = 0;
            }
        }
        else
        {
			_clDO.selectedIndex = 0;  
			
			//TODO?????: this was previously commented, so i guess no		
            //clDOStatus.selectedIndex = 0;
            
        }
    }
    
    private function _changeDOHandler(e:DataUpdaterEvent):Void
    {		
		ServiceManager.instance.getDOAvailablePeriodList(DO.selected);
        if (User.instance.type == UserType.PROGRAMMEUR)
        {
            ServiceManager.instance.registerProgUser(DO.selected, User.instance);
        }
        if (User.instance.isAuthorized)
        {
            ServiceManager.instance.throwNotification(User.instance, DO.selected, NotificationAction.CLEAR);
            ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _getDOOppositeOwnerCompleteHandler);
            ServiceManager.instance.getDOOppositeOwner(DO.selected, User.instance);
        }		
		
		//2022-evolution
		ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _checkMultiUsersCompleteHandler);
		ServiceManager.instance.checkMultiUsers(DO.selected, User.instance);
    }

    
    private function _getDOOppositeOwnerCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.getDOOppositeOwner)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _getDOOppositeOwnerCompleteHandler);
            OppositeOwner.selected = OppositeOwner.list.getItemAt(0);
        }
    }
    
	//2022-evolution
    private function _checkMultiUsersCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.checkMultiUsers)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _checkMultiUsersCompleteHandler);
			
			_checkMultiUsersResultList = e.result;			
			
			if ( !_DONotAvailableDialogIsOpen )
				_displayCheckMultiUsersResult();
        }
    }
	private function _displayCheckMultiUsersResult():Void
	{
		_lblMultiUserNum.setText("1");
		
		if ( _checkMultiUsersResultList == null ) return;
		if ( _checkMultiUsersResultList.length == 0 ) return;		
		
		_lblMultiUserNum.setText( Std.string(_checkMultiUsersResultList.length+1) );
		
		var ds:DialogSkin = DialogManager.instance.skin.clone();
		ds.titleBackgroundColor = Colors.YELLOW;
		ds.contentBackgroundColor = Colors.YELLOW;
		ds.contentFormat = new TextFormat( Fonts.OPEN_SANS, 16, Colors.GREY5, null, null, null, null, null, TextFormatAlign.CENTER );
		ds.titleFormat = new TextFormat( Fonts.OPEN_SANS, 16, Colors.GREY5, true );
		
		
		var message:String = "";
		for ( m in _checkMultiUsersResultList)
		{
			message += "<font size='20'>" + Locale.get( "LBL_USER_TYPE_" + m.type.toUpperCase() ).toUpperCase() + " :</font><br>";
			for ( u in m.userList )
			{
				message += "- " + u + "<br>";
			}
			message += "<br>";
		}
		
		DialogManager.instance.open( new VMMessageDialog( Locale.get( "MESSAGE_MULTI_USERS" ), message, Icons.getIcon( Icon.ALERT_MULTI_USERS ) ), ds );
	}
	//----
    
    private function _DOSelectHandler(e:Event):Void
    {
        DO.selected = _clDO.selectedData;
        
        var doStatus:DOStatus = DOStatus.getDOStatusByID(DO.selected.idStatus);
        if (doStatus != null)
        {
            _clDOStatus.selectedData = doStatus;
        }
        else
        {
            _clDOStatus.selectedIndex = 0;
        }
    }
    
   
    private function _selectDOStatusHandler(e:Event):Void
    {
        if (DO.selected != null)
        {
            DO.selected.idStatus = _clDOStatus.selectedData.id;
			
			ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _updateDOStatusCompelteHandler);
            ServiceManager.instance.updateDOStatus(DO.selected);
        }
    }
    
    private function _updateDOStatusCompelteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.updateDOStatus)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _updateDOStatusCompelteHandler);
            if (e.result)
            {
                var message:String = Locale.get("MESSAGE_CHANGE_DO_STATUS");
                message = StringTools.replace(message, "{DOLabel}", DO.selected.label);
                message = StringTools.replace(message, "{DOStatus}", _clDOStatus.selectedData.label);
                DialogManager.instance.open( new VMMessageDialog( "Title", message ) );
            }
        }
    }
    
    
    private function _editDOAvailablePeriodClickHandler(e:MouseEvent):Void
    {
		/********************* START refactoring*******************/
		// test refactoring :
		// HomeView will display EditDOAvailablePeriodMask, handle resizing
		// and call directly CalendarPanel to display Edit Mode 
		// cleaning and loading Visit list will be handled in CalendarPanel or maybe Calendar		
        dispatchEvent( new VMEvent( VMEvent.START_EDIT_DO_AVAILABLE_PERIOD ) );
		/*
		// création d'une liste vide > déclenche évenement pour re-display les visite dans CalendarPanel
        Visit.createList(new Collection<Visit>());
        
        //Planning.selected.lockedForEditDOAvailablePeriod = true;
        
        // déclenche évenement dans CalendarPanel pour display le mode Edit
        DOAvailablePeriod.startEditDOAvailablePeriod();
        
        var editDOAP:EditDOAvailablePeriodMask = new EditDOAvailablePeriodMask(CalendarPanel.instance.getBounds(stage));
        editDOAP.addEventListener(Event.CLOSE, _editDOAvailablePeriodCloseHandler);
        stage.addChild(editDOAP);
		*/
    }
	
    /*
    private function _editDOAvailablePeriodCloseHandler(e:Event):Void
    {
		// déclenche évenement dans CalendarPanel pour stop le mode Edit
        DOAvailablePeriod.stopEditDOAvailablePeriod();
        //Planning.selected.lockedForEditDOAvailablePeriod = false;
        ServiceManager.instance.getDOVisitList(DO.selected, Planning.selected, User.instance);
    }
	*/
		/************************ END refactoring***********************/
	
	public function setRect( rect:Rectangle)
	{
		x = rect.x;
		y = rect.y;
		
		_background.width = rect.width;
		_background.height = rect.height;
		
		
		_clDO.x = rect.width * 0.20;
		if ( _clDO.x < SearchPanel.MIN_WIDTH )
			_clDO.x =  SearchPanel.MIN_WIDTH;
		_btAddDONote.width = 70;
		_btInfos.width = 80;
		_btEditDOAvailablePeriod.width = 70;
		_btRefreshAll.width = 70;
		if ( rect.width <= Config.LAYOUT1_MAX_WIDTH )
		{
			_clDO.x = _btBack.x + _btBack.width;
			_btAddDONote.width = 50;
			_btInfos.width = 50;
			_btEditDOAvailablePeriod.width = 50;
			_btRefreshAll.width = 50;
		}
		_clDOStatus.width = 280;
		_clDO.width = rect.width - _clDO.x - _btAddDONote.width - _btInfos.width - _btEditDOAvailablePeriod.width - _btRefreshAll.width - _clDOStatus.width;
		_btEditDOAvailablePeriod.x = rect.right -_btEditDOAvailablePeriod.width;
		_btAddDONote.x =_btEditDOAvailablePeriod.x - _btAddDONote.width;
		_btRefreshAll.x = _btAddDONote.x - _btRefreshAll.width;
		_clDOStatus.x = _btRefreshAll.x - _clDOStatus.width;
		_btInfos.x = _clDOStatus.x - _btInfos.width;
		/*
		INFO_LIMIT_LEFT = Std.int(_clDO.x);
		INFO_LIMIT_RIGHT = Std.int(_btRefreshAll.x);*/
		
		//2022-evolution
		_lblMultiUserNum.x = _btAddDONote.x - _lblMultiUserNum.width * 0.5 - 5;
		_lblMultiUserNum.y = (_btAddDONote.height - _lblMultiUserNum.height) * 0.5;
		
	} 
}

