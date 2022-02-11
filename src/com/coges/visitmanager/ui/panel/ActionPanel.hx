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
import com.coges.visitmanager.events.VisitDetailEvent;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.ui.VisitDetail;
import com.coges.visitmanager.ui.components.ComboListPlanning;
import com.coges.visitmanager.ui.components.VMButton;
import com.coges.visitmanager.ui.dialog.DuplicateDOPlanningDialog;
import com.coges.visitmanager.ui.dialog.ExportExcelDialog;
import com.coges.visitmanager.ui.dialog.VMConfirmDialog;
import com.coges.visitmanager.ui.dialog.VMMessageDialog;
import com.coges.visitmanager.vo.DO;
import com.coges.visitmanager.vo.PendingVisit;
import com.coges.visitmanager.vo.Planning;
import com.coges.visitmanager.vo.User;
import com.coges.visitmanager.vo.UserType;
import com.coges.visitmanager.vo.Visit;
import nbigot.ui.IconPosition;
import nbigot.ui.dialog.DialogEvent;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.DialogValue;
import nbigot.utils.Collection;
import nbigot.utils.DateUtils;
import nbigot.utils.SpriteUtils;
import nbigot.utils.StringUtils;
import openfl.Lib;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.net.URLRequestMethod;
import openfl.net.URLVariables;
import openfl.text.TextFormat;


/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ActionPanel extends Sprite
{
	public static final MIN_WIDTH:Int = 610;
	public static final MIN_HEIGHT:Int = 100;
	
	
	
    private var _background:Sprite;
    private var _clPlanning:ComboListPlanning;
    private var _btSave:VMButton;
    private var _btAddLocked:VMButton;
    private var _btPrint:VMButton;
    private var _btExport:VMButton;
    private var _btDuplicate:VMButton;
    private var _btClear:VMButton;
    private var _iconSave:DisplayObject;
    private var _iconExtractAndSave:DisplayObject;
    private var _targetDOForPlanningDuplication:DO;
    
    public function new()
    {
        super();
		
		
		_background = SpriteUtils.createSquare( 40, 40, Colors.GREY1 );
		addChild(_background);
		
		
		_clPlanning = new ComboListPlanning(null);
        _clPlanning.enabled = User.instance.isAuthorized;
        _clPlanning.addEventListener(Event.SELECT, _selectPlanningVersionHandler);
        addChild(_clPlanning);
		
		_btAddLocked = new VMButton(Locale.get("BT_ADD_LOCKED_LABEL"), new TextFormat( Fonts.OPEN_SANS, 13, Colors.GREY1 ), SpriteUtils.createRoundSquare(230, 30, 6, 6, Colors.GREY3) );
		_btAddLocked.borderEnabled = false;
		_btAddLocked.setIcon( Icons.getIcon( Icon.PLANNING_ADD_BOOKED_VISIT), new Point( 40, 30 ) );
		_btAddLocked.toolTipContent = Locale.get("TOOLTIP_BT_ADD_LOCKED_VISIT");
        _btAddLocked.enabled = User.instance.isAuthorized;
        _btAddLocked.addEventListener(MouseEvent.CLICK, _clickAddLockedHandler);
		addChild(_btAddLocked);		
		
		
		_btDuplicate = new VMButton("", null, SpriteUtils.createRoundSquare(70, 30, 6, 6, Colors.BLUE1) );
		_btDuplicate.borderEnabled = false;
		_btDuplicate.setIcon( Icons.getIcon( Icon.PLANNING_DUPLICATE), new Point( 40, 30 ),IconPosition.CENTER );
		_btDuplicate.toolTipContent = Locale.get("TOOLTIP_BT_DUPLICATE_PLANNING");
        _btDuplicate.addEventListener(MouseEvent.CLICK, _clickDuplicateHandler);
		addChild(_btDuplicate);			
		
        _iconSave = Icons.getIcon(Icon.PLANNING_SAVE);
        _iconExtractAndSave = Icons.getIcon(Icon.PLANNING_EXTRACT_AND_SAVE);
		
		_btSave = new VMButton("", null, SpriteUtils.createRoundSquare(70, 30, 6, 6, Colors.BLUE1) );
		_btSave.borderEnabled = false;
		_btSave.setIcon( _iconSave, new Point( 40, 30 ),IconPosition.CENTER );
		_btSave.toolTipContent = Locale.get("TOOLTIP_BT_CREATE_NEW_VERSION");
		addChild(_btSave);	
		
		
		_btClear = new VMButton("", null, SpriteUtils.createRoundSquare(70, 30, 6, 6, Colors.RED1) );
		_btClear.borderEnabled = false;
		_btClear.setIcon( Icons.getIcon( Icon.PLANNING_CLEAR), new Point( 40, 30 ),IconPosition.CENTER );
		_btClear.toolTipContent = Locale.get("TOOLTIP_BT_CLEAR_PLANNING");
        _btClear.addEventListener(MouseEvent.CLICK, _clickClearHandler);
		addChild(_btClear);	
        
		
		_btPrint = new VMButton(Locale.get("BT_PRINT_LABEL"), new TextFormat( Fonts.OPEN_SANS, 13, Colors.GREY1 ), SpriteUtils.createRoundSquare(190, 30, 6, 6, Colors.PURPLE2) );
		_btPrint.borderEnabled = false;
		_btPrint.setIcon( Icons.getIcon( Icon.PLANNING_PRINT), new Point( 40, 30 ) );
		_btPrint.toolTipContent = Locale.get("TOOLTIP_BT_PRINT_PLANNING");
        _btPrint.addEventListener(MouseEvent.CLICK, _clickPrintHandler);
		addChild(_btPrint);
        
		
		_btExport = new VMButton(Locale.get("BT_EXPORT_EXCEL_LABEL"), new TextFormat( Fonts.OPEN_SANS, 13, Colors.GREY1 ), SpriteUtils.createRoundSquare(190, 30, 6, 6, Colors.PURPLE2) );
		_btExport.borderEnabled = false;
		_btExport.setIcon( Icons.getIcon( Icon.PLANNING_EXPORT), new Point( 40, 30 ) );
		_btExport.toolTipContent = Locale.get("TOOLTIP_BT_EXPORT_PLANNING");
        _btExport.addEventListener(MouseEvent.CLICK, _clickExportHandler);
		addChild(_btExport);
		
		
		
        if (User.instance.type != UserType.PROGRAMMEUR)
        {
            _btSave.enabled = false;
            _btDuplicate.enabled = false;
            _btClear.enabled = false;
        }
        else
        {
            _btSave.addEventListener(MouseEvent.CLICK, _clickSaveHandler);
        }
		
		
		DataUpdater.instance.addEventListener(DataUpdaterEvent.DO_SELECTED_CHANGE, _changeDOHandler );
        //DO.addEventListener(DataUpdaterEvent.DO_SELECTED_CHANGE, _changeDOHandler);
		DataUpdater.instance.addEventListener(DataUpdaterEvent.PLANNING_SELECTED_CHANGE, _changePlanningHandler );
        //Planning.addEventListener(DataUpdaterEvent.PLANNING_SELECTED_CHANGE, _changePlanningHandler);    
		
        addEventListener(Event.ADDED_TO_STAGE, init);
    }
    
    private function init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        
    }
    
    private function _changeDOHandler(e:DataUpdaterEvent):Void
    {
        _loadPlanningList();
    }
    private function _changePlanningHandler(e:DataUpdaterEvent):Void
    {
        _loadDOVisitList();
    }
    
    private function _loadPlanningList():Void
    {
        if (DO.selected != null )
        {
            ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _loadPlanningListCompleteHandler);
            ServiceManager.instance.getDOPlanningList(DO.selected);
        }
    }
    
    private function _loadPlanningListCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.getDOPlanningList)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _loadPlanningListCompleteHandler);
            
            if (Planning.list.length == 0)
            {
				// Premiere utilisation:la DO n'a pas de planning.                
                // création d'un planning de travail obligatoire.
                var nowStr:String = DateUtils.toDBString(Date.now());
				
                ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _savePlanningCompleteHandler);
                ServiceManager.instance.saveDOPlanning(Planning.createNewPlanning(0, DO.selected.id, -1, Locale.get("LBL_WORKING_PLANNING"), nowStr, nowStr));
            }
            else
            {
                Planning.selected = Planning.list.getItemAt(0);
                _fillComboListPlanning();
                if (_iconSave != null)
                {
                    _btSave.setIcon( _iconSave, new Point( 40, 30 ),IconPosition.CENTER );
                }
                _btSave.toolTipContent = Locale.get("TOOLTIP_BT_CREATE_NEW_VERSION");
                _btClear.enabled = (User.instance.type == UserType.PROGRAMMEUR);
            }
        }
    }
    
    private function _savePlanningCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.saveDOPlanning)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _savePlanningCompleteHandler);
            _loadPlanningList();
        }
    }
    private function _fillComboListPlanning():Void
    {
        _clPlanning.datas = Planning.list;
        _clPlanning.selectedData = Planning.selected;
    }
    private function _loadDOVisitList():Void
    {
        ServiceManager.instance.getDOVisitList(DO.selected, Planning.selected, User.instance);
    }
    
    
    private function _extractOldPlanning():Void
    {
        var message:String = Locale.get("ALERT_EXTRACT_OLD_PLANNING");
        message = StringTools.replace(message, "{planningLabel}", Planning.selected.label);
        DialogManager.instance.addEventListener(DialogEvent.CLOSE, _confirmExtractOldPlanningClosePopupHandler);
        DialogManager.instance.open( new VMConfirmDialog( "Confirm Dialog title", message ) );
    }
    private function _confirmExtractOldPlanningClosePopupHandler(e:DialogEvent):Void
    {
        DialogManager.instance.removeEventListener(DialogEvent.CLOSE, _confirmExtractOldPlanningClosePopupHandler);
        if (e.value == DialogValue.CONFIRM)
        {
            ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _extractOldPlanningCompleteHandler);
            Planning.selected.dateCrea = Date.now();
            ServiceManager.instance.extractOldPlanning(Planning.selected);
        }
        else if (!_btSave.enabled)
        {
            _btSave.enabled = true;
        }
    }
    private function _extractOldPlanningCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.extractOldPlanning)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _extractOldPlanningCompleteHandler);
			
			var message:String = Locale.get("MESSAGE_EXTRACT_OLD_PLANNING_COMPLETE");
			message = StringTools.replace(message, "{DOLabel}", DO.selected.label);
			DialogManager.instance.open( new VMMessageDialog("Title", message) );
            
            _loadPlanningList();
            if (!_btSave.enabled)
            {
                _btSave.enabled = true;
            }
        }
    }
    
    private function _createNewPlanningVersion():Void
    {
        dispatchEvent(new VMEvent(VMEvent.START_WAITING));
        Planning.selected.dateCrea = Date.now();
        ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _createNewPlanningVersionCompleteHandler);
        ServiceManager.instance.createNewDOPlanningVersion(Planning.selected, Visit.list);
    }
    private function _createNewPlanningVersionCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.createNewDOPlanningVersion)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _createNewPlanningVersionCompleteHandler);
            dispatchEvent(new VMEvent(VMEvent.STOP_WAITING));
            
            if (e.result)
            {
                var message:String = Locale.get("MESSAGE_NEW_PLANNING_VERSION_COMPLETE");
                message = StringTools.replace(message, "{version}", e.result);
                message = StringTools.replace(message, "{DOLabel}", DO.selected.label);
				
                DialogManager.instance.open( new VMMessageDialog("Title", message) );
            }
            
            _loadPlanningList();
            if (!_btSave.enabled)
            {
                _btSave.enabled = true;
            }
        }
    }
    
    private function _selectPlanningVersionHandler(e:Event):Void
    {
        Planning.selected = _clPlanning.selectedData;
        
        if (!Planning.selected.isLocked)
        {
            if (User.instance.type != UserType.PROGRAMMEUR)
            {
                _btSave.enabled = false;
            }
            if (_iconSave != null)
            {
                _btSave.setIcon( _iconSave, new Point( 40, 30 ),IconPosition.CENTER );
                _btSave.toolTipContent = Locale.get("TOOLTIP_BT_CREATE_NEW_VERSION");
            }
            _btClear.enabled = true;
        }
        else
        {
            _btSave.enabled = true;
            if (_iconExtractAndSave != null)
            {
                _btSave.setIcon( _iconExtractAndSave, new Point( 40, 30 ),IconPosition.CENTER );
                _btSave.toolTipContent = Locale.get("TOOLTIP_BT_EXTRACT_OLD_PLANNING");
            }
            _btClear.enabled = false;
        }
    }
    
    private function _clickAddLockedHandler(e:MouseEvent):Void
    {
        if (Planning.selected.isLocked)
        {
            DialogManager.instance.open( new VMMessageDialog("Title", Locale.get("WARNING_PLANNING_LOCKED")) );
        }
        else
        {
            var startDate:Date = new Date(
				Config.INIT_START_DATE.getFullYear(), 
				Config.INIT_START_DATE.getMonth(), 
				Config.INIT_START_DATE.getDate(), 
				Config.INIT_SLOT_START.getHours(), 
				Config.INIT_SLOT_START.getMinutes(), 
				Config.INIT_SLOT_START.getSeconds()
				);
				
			
            var endDate = Date.fromTime(startDate.getTime() + Config.INIT_SLOT_LENGTH_TIME);
            
            var v:Visit = Visit.createNewSpecialVisit(startDate, endDate, Planning.selected.id, DO.selected.id);            
            var vd:VisitDetail = new VisitDetail(v);
			
            vd.addEventListener(VisitDetailEvent.SAVE, _closeVisitDetailSaveHandler);
			stage.addChild( vd );
        }
    }
    private function _closeVisitDetailSaveHandler(e:VisitDetailEvent):Void
    {
        var v:Visit = e.targetVisit;
        var periodAvailable:Bool = v.checkPeriodAvailability();
        if (!periodAvailable)
        {
            DialogManager.instance.open( new VMMessageDialog("Title", Locale.get("MESSAGE_PERIOD_NOT_AVAILABLE")) );
            return;
        }
        ServiceManager.instance.saveDOVisit(v);
    }
    
    private function _clickPrintHandler(e:MouseEvent):Void
    {	
        var url:URLRequest = new URLRequest(Config.printURL + "?id_do=" + DO.selected.id + "&log=" + User.instance.type + "&vers=" + Planning.selected.version);
        Lib.getURL(url, "_blank");
    }
    
    private function _clickSaveHandler(e:MouseEvent):Void
    {
        _btSave.enabled = false;
        if (Planning.selected.isLocked)
        {
            _extractOldPlanning();
        }
        else
        {
            _createNewPlanningVersion();
        }
    }
    
    private function _clickClearHandler(e:MouseEvent):Void
    {
        DialogManager.instance.addEventListener(DialogEvent.CLOSE, _confirmClearPlanningHandler);
        DialogManager.instance.open( new VMConfirmDialog( "Confirm Dialog title", Locale.get("CLEAR_PLANNING") ) );
    }
    
    private function _confirmClearPlanningHandler(e:DialogEvent):Void
    {
        DialogManager.instance.removeEventListener(DialogEvent.CLOSE, _confirmClearPlanningHandler);
        
        if (e.value == DialogValue.CANCEL)
        {
            return;
        }
        // TODO - Q:vider PendingList aussi ???
        ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _clearPlanningCompleteHandler);
        ServiceManager.instance.clearDOPlanning(Planning.selected);
    }
    private function _clearPlanningCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.clearDOPlanning)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _clearPlanningCompleteHandler);
			
            // reload DOVisitList & DOPendingVisitList   
			Planning.selected = Planning.selected;
        }
    }
    
    private function _clickDuplicateHandler(e:MouseEvent):Void
    {
        //PopupManager.instance.addEventListener(DialogEvent.CLOSE, _closeDuplicateDOPlanningPopupHandler);
        DialogManager.instance.addEventListener(DialogEvent.CLOSE, _closeDuplicateDOPlanningPopupHandler);
        //PopupManager.instance.openPopup(DuplicateDOPlanningPopup, "", Locale.get("DUPLICATE_PLANNING"), null, null, isHTML);
        DialogManager.instance.open( new DuplicateDOPlanningDialog( Locale.get("TOOLTIP_BT_DUPLICATE_PLANNING"), Locale.get("DUPLICATE_PLANNING") ) );
		
    }
    
    private function _closeDuplicateDOPlanningPopupHandler(e:DialogEvent):Void
    {
        //PopupManager.instance.removeEventListener(DialogEvent.CLOSE, _closeDuplicateDOPlanningPopupHandler);
        DialogManager.instance.removeEventListener(DialogEvent.CLOSE, _closeDuplicateDOPlanningPopupHandler);
        		
		switch ( e.value ) 
		{
			case DialogValue.CANCEL:
				return;
			case DialogValue.DATA(content):					
				_targetDOForPlanningDuplication = cast content;			
				ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _duplicateDOPlanningCompleteHandler);
				ServiceManager.instance.duplicateDOPlanning(Visit.list, PendingVisit.list, _targetDOForPlanningDuplication);
			case _:
				return;
				
		}
    }
    
    private function _duplicateDOPlanningCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.duplicateDOPlanning)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _duplicateDOPlanningCompleteHandler);
            
            //PopupManager.instance.openPopup(PopupType.MESSAGE, "", Utils.concatString(Locale.get("ALERT_DUPLICATE_DO"), _targetDOForPlanningDuplication.label), null, null, isHTML);
			var message:String = StringUtils.concatString( Locale.get("ALERT_DUPLICATE_DO"), [_targetDOForPlanningDuplication.label] );
            DialogManager.instance.open( new VMMessageDialog( "Title", message ) );
        }
    }
    
    
    private function _clickExportHandler(e:MouseEvent):Void
    {
        //PopupManager.instance.addEventListener(DialogEvent.CLOSE, _closeExportExcelHandler);
        //PopupManager.instance.openPopup(ExportExcelPopup, "", Locale.get("EXPORT_EXCEL"));
        DialogManager.instance.addEventListener(DialogEvent.CLOSE, _closeExportExcelHandler);
        DialogManager.instance.open( new ExportExcelDialog(Locale.get("BT_EXPORT_EXCEL_LABEL"), Locale.get("EXPORT_EXCEL")));
    }
    
    private function _closeExportExcelHandler(e:DialogEvent):Void
    {
        //PopupManager.instance.removeEventListener(DialogEvent.CLOSE, _closeExportExcelHandler);
        DialogManager.instance.removeEventListener(DialogEvent.CLOSE, _closeExportExcelHandler);
        
		
		switch ( e.value ) 
		{
			case DialogValue.CANCEL:
				return;
			case DialogValue.DATA(content):	
				
				
				
				var uv:URLVariables = new URLVariables();
				uv.log = User.instance.type;
				uv.id_do = DO.selected.id;
				uv.vers = Planning.selected.version;
				
				var ur:URLRequest = new URLRequest();
				ur.url = Config.exportURL;
				ur.method = URLRequestMethod.GET;
				ur.data = uv;
				openfl.Lib.getURL(ur, "_blank");
				
				
				if ( (content:Collection<String>).length > 0 )
				{
					uv.pDoId = DO.selected.id;
					uv.pVers = Planning.selected.version;
					uv.pEmail = (content:Collection<String>).innerArray.join(";");
					ur.url = Config.exportWithEmailURL;
					ur.data = uv;
					
					var ul:URLLoader = new URLLoader();
					ul.load(ur);
				}				
			case _:
				return;
				
		}
    }
	
	
	public function setRect( rect:Rectangle)
	{
		x = rect.x;
		y = rect.y;
		
		//already handled in HomeView._draw()
		/*
		if ( rect.width < MIN_WIDTH ) rect.width = MIN_WIDTH;
		if ( rect.height < MIN_HEIGHT ) rect.height = MIN_HEIGHT;
		*/
		
		var spacerH = 10;
		var gapH:Int = Math.floor((rect.width - _btAddLocked.width - _btSave.width - _btDuplicate.width - _btPrint.width - spacerH) / 4);
		var marginV:Int = 10;
		
		_background.width = rect.width;
		_background.height = rect.height;
		
		_clPlanning.x = gapH;
		_clPlanning.y = marginV;
		_btAddLocked.x = gapH;
		_btAddLocked.y = rect.height - _btAddLocked.height - marginV;
		
		_btSave.x = _btAddLocked.x + _btAddLocked.width + gapH;
		_btSave.y = marginV;
		_btClear.x = _btAddLocked.x + _btAddLocked.width + gapH;
		_btClear.y = rect.height - _btClear.height - marginV;
		_btDuplicate.x = _btSave.x+ _btSave.width + spacerH;
		_btDuplicate.y = marginV;
		
		_btPrint.x = rect.width - _btPrint.width - gapH;
		_btPrint.y = marginV;
		_btExport.x = rect.width - _btExport.width - gapH;
		_btExport.y = rect.height - _btExport.height - marginV;
	} 
}

