package com.coges.visitmanager.ui;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Config;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.core.VisitSaveHelper;
import com.coges.visitmanager.core.VisitSaveType;
import com.coges.visitmanager.datas.ServiceEvent;
import com.coges.visitmanager.datas.ServiceManager;
import com.coges.visitmanager.events.VisitDetailEvent;
import com.coges.visitmanager.events.VisitSaveEvent;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.ui.components.VMButton;
import com.coges.visitmanager.ui.components.VMComboList;
import com.coges.visitmanager.ui.components.VisitActivityCheckBox;
import com.coges.visitmanager.ui.dialog.ConfirmChangeVisitStatusDialog;
import com.coges.visitmanager.ui.dialog.ConfirmInteractiveDialog;
import com.coges.visitmanager.ui.dialog.ConfirmVisitSerieDialog;
import com.coges.visitmanager.ui.dialog.VMConfirmDialog;
import com.coges.visitmanager.ui.dialog.VMErrorDialog;
import com.coges.visitmanager.ui.dialog.VMMessageDialog;
import com.coges.visitmanager.vo.Activity;
import com.coges.visitmanager.vo.ActivityType;
import com.coges.visitmanager.vo.ComboListTimeData;
import com.coges.visitmanager.vo.Country;
import com.coges.visitmanager.vo.Period;
import com.coges.visitmanager.vo.Planning;
import com.coges.visitmanager.vo.SpecialVisit;
import com.coges.visitmanager.vo.User;
import com.coges.visitmanager.vo.UserType;
import com.coges.visitmanager.vo.Visit;
import com.coges.visitmanager.vo.VisitStatusID;
import motion.Actuate;
import nbigot.application.ResizeEvent;
import nbigot.application.ResizeManager;
import nbigot.ui.control.CheckBox;
import nbigot.ui.control.Label;
import nbigot.ui.control.RoundRectSprite;
import nbigot.ui.control.TextInput.TextInputBackground;
import nbigot.ui.control.ToggleTextInput;
import nbigot.ui.dialog.DialogEvent;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.DialogValue;
import nbigot.utils.Collection;
import nbigot.utils.DateUtils;
import nbigot.utils.SpriteUtils;
import openfl.Lib;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TextEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.net.URLRequest;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import nbigot.ui.control.Scrollbar;
import openfl.text.TextFormatAlign;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class VisitDetail extends Sprite
{    
    private var _data:Visit;
    private var _darkLayer:Shape;
	private var _width:Float;
	private var _height:Float;
	private var _duplicateOverlayPosY:Float;
    private var _contentRect:Rectangle;
    private var _isPlanningLocked:Bool;
    private var _isUserAuthorized:Bool;
    private var _notes:String;
    private var _notesProg:String;
    private var _activeNotesIsProg:Bool;
    private var _activityIntList:Collection<Activity>;
    private var _activityIntCheckBoxList:Collection<VisitActivityCheckBox>;
    private var _activityExtList:Collection<Activity>;
    private var _activityExtCheckBoxList:Collection<VisitActivityCheckBox>;
	private var _isVisitLocked:Bool;
	private var _countryFlag:DisplayObject;
	private var _localizationIcon:DisplayObject;
	
    private var _background:Sprite;
    private var _lblNameLabel:Label;
    private var _txtName:ToggleTextInput;
    private var _lblPriorityLabel:Label;
    private var _lblPriority:Label;
    private var _lblLocationLabel:Label;
    private var _txtLocation:ToggleTextInput;
    private var _lblContactLabel:Label;
    private var _txtContact:ToggleTextInput;
    private var _lblPhoneLabel:Label;
    private var _txtPhone:ToggleTextInput;
    private var _lblStartLabel:Label;
    private var _lblEndLabel:Label;
    private var _lblActivitiesLabel:Label;
	private var _backgroundNotes:RoundRectSprite;
    private var _txtNotes:TextField;
    private var _sbNotes:Scrollbar;
    private var _btStatusAccept:VMButton;
    private var _btStatusCancel:VMButton;
    private var _btSaveVisit:VMButton;
    private var _btDeleteVisit:VMButton;
    private var _btGetDemand:VMButton;
    private var _btDuplicateVisitForDO:VMButton;
	//2022-evolution
	private var _btDuplicateVisitOnWorkingPlanning:VMButton;	
	
    private var _btClose:VMButton;
    private var _btLockVisit:VMButton;
    private var _btNotes:VMButton;
    private var _btNotesProg:VMButton;
    private var _clStartDay:VMComboList<ComboListTimeData>;
    private var _clStartHour:VMComboList<ComboListTimeData>;
    private var _clStartMinute:VMComboList<ComboListTimeData>;
    private var _clEndDay:VMComboList<ComboListTimeData>;
    private var _clEndHour:VMComboList<ComboListTimeData>;
    private var _clEndMinute:VMComboList<ComboListTimeData>;
    private var _clSpecialVisit:VMComboList<SpecialVisit>;
    private var _cbSpecialVisit:CheckBox;
	private var _duplicateOverlay:VisitDetailDuplicateVisitOverlay;
    
    public function new(visit:Visit = null, isPlanningLocked:Bool = false, isUserAuthorized:Bool = true)
    {
        super();
        _isUserAuthorized = isUserAuthorized;
        _isPlanningLocked = isPlanningLocked;
        
        // si utilisateur est en "read only", on simule le planning verrouillé :
        if (!_isUserAuthorized)
        {
            _isPlanningLocked = true;
        }
        _data = visit;
		_height = 600;
		_duplicateOverlayPosY = 70;
		
		alpha = 0;
		
        _darkLayer = new Shape();
        addChild(_darkLayer);		
		
		_background = new Sprite();
		addChild( _background );
		
		
		var tfLabel = new TextFormat( Fonts.OPEN_SANS, 14, 0 );
		var tfData = new TextFormat( Fonts.OPEN_SANS, 14, 0, true );
		
		_lblNameLabel = new Label( Locale.get("VISIT_DETAIL_LABEL_NAME"), tfLabel );
		addChild( _lblNameLabel );		
		
		var tfName = tfData.clone();
		tfName.size = 18;
		_txtName = new ToggleTextInput(100, 32, tfName, "", TextInputBackground.CUSTOM( new RoundRectSprite( 20, 20, 6, 6, Colors.WHITE), 0 ) );
		addChild( _txtName );
		
		
		
		_lblPriorityLabel = new Label( Locale.get( "LBL_PRIORITY" ), tfLabel );
		addChild( _lblPriorityLabel );
		_lblPriority = new Label( "", tfData );
		addChild( _lblPriority );
		
		_lblStartLabel = new Label( Locale.get("VISIT_DETAIL_LABEL_START"), tfLabel );
		addChild( _lblStartLabel );		
		_lblEndLabel = new Label( Locale.get("VISIT_DETAIL_LABEL_END"), tfLabel );
		addChild( _lblEndLabel );
		
		_lblLocationLabel = new Label( Locale.get("VISIT_DETAIL_LABEL_LOCATION"), tfLabel );
		addChild( _lblLocationLabel );
		_txtLocation = new ToggleTextInput(100, 28, tfData, "", TextInputBackground.CUSTOM( new RoundRectSprite( 20, 20, 6, 6, Colors.WHITE), 0 ) );
		addChild( _txtLocation );
		
		_lblContactLabel = new Label( Locale.get("VISIT_DETAIL_LABEL_CONTACT"), tfLabel );
		addChild( _lblContactLabel );
		_txtContact = new ToggleTextInput(100, 28, tfData, "", TextInputBackground.CUSTOM( new RoundRectSprite( 20, 20, 6, 6, Colors.WHITE), 0 ) );
		addChild( _txtContact );
		
		_lblPhoneLabel = new Label( Locale.get("VISIT_DETAIL_LABEL_PHONE"), tfLabel );
		addChild( _lblPhoneLabel );
		_txtPhone = new ToggleTextInput(100, 28, tfData, "", TextInputBackground.CUSTOM( new RoundRectSprite( 20, 20, 6, 6, Colors.WHITE), 0 ) );
		addChild( _txtPhone );
		
		_lblActivitiesLabel = new Label( Locale.get("VISIT_DETAIL_LABEL_ACTIVITIES"), tfLabel );
		addChild( _lblActivitiesLabel );	
		
        _btNotes = new VMButton(Locale.get("VISIT_DETAIL_LABEL_NOTES"), tfLabel, SpriteUtils.createRoundSquare( 120, 30, 6, 6, Colors.WHITE ) );
		_btNotes.borderEnabled = false;
        _btNotes.addEventListener(MouseEvent.CLICK, _notesClickHandler);
		addChild( _btNotes );  
		
        _btNotesProg = new VMButton(Locale.get("VISIT_DETAIL_LABEL_NOTES_PROG"), tfLabel, SpriteUtils.createRoundSquare( 120, 30, 6, 6, Colors.WHITE ) );
		_btNotesProg.borderEnabled = false;
        _btNotesProg.addEventListener(MouseEvent.CLICK, _notesProgClickHandler);
		addChild( _btNotesProg );		
		
		_backgroundNotes = new RoundRectSprite( 100, 100, 6, 6);
		addChild( _backgroundNotes );
		
		
		_txtNotes = new TextField();
		_txtNotes.embedFonts = true;
        _txtNotes.antiAliasType = AntiAliasType.ADVANCED;
		_txtNotes.type = TextFieldType.INPUT;
		//_txtNotes.border = true;
		_txtNotes.multiline = true;
		_txtNotes.wordWrap = true;
		_txtNotes.defaultTextFormat = tfLabel;
		//BUG : Event.CHANGE is not fired with Dom renderer
		//FIX : while waiting for an update, we add TextEvent.TEXT_INPUT as a fallback
        _txtNotes.addEventListener(Event.CHANGE, _txtNotesChangeHandler);
        _txtNotes.addEventListener(TextEvent.TEXT_INPUT, _txtNotesChangeHandler);
		addChild( _txtNotes );
		
		_sbNotes = new Scrollbar();
		_sbNotes.options.gripStyle = GripStyle.LINE;
		_sbNotes.options.gripColor = Colors.GREY2;
		_sbNotes.options.background = false;
        _sbNotes.target = _txtNotes;
		addChild( _sbNotes );
		
		
		//var tf13Grey4 = new TextFormat(Fonts.OPEN_SANS, 13, Colors.GREY4, true);
		var tf13Black = new TextFormat(Fonts.OPEN_SANS, 13, Colors.BLACK, true);
        _btStatusAccept = new VMButton(Locale.get("BT_VALID_VISIT_LABEL"), tf13Black, SpriteUtils.createRoundSquare( 120, 30, 6, 6, Colors.WHITE, 2, Colors.GREEN2 ) );
		_btStatusAccept.borderEnabled = false;
		_btStatusAccept.toolTipContent = Locale.get("TOOLTIP_BT_ACCEPT_VISIT");
		_btStatusAccept.setIcon( Icons.getIcon( Icon.VISIT_STATUS_ACCEPTED), new Point(40,30) );
        _btStatusAccept.addEventListener(MouseEvent.CLICK, _statusAcceptClickHandler);
		addChild( _btStatusAccept );
		
        _btStatusCancel = new VMButton(Locale.get("BT_CANCEL_VISIT_LABEL"), tf13Black, SpriteUtils.createRoundSquare( 120, 30, 6, 6, Colors.WHITE, 2, Colors.RED2 ) );
		_btStatusCancel.borderEnabled = false;
		_btStatusCancel.toolTipContent = Locale.get("TOOLTIP_BT_CANCEL_VISIT");
		_btStatusCancel.setIcon( Icons.getIcon( Icon.VISIT_STATUS_CANCELED), new Point(40,30) );
        _btStatusCancel.addEventListener(MouseEvent.CLICK, _statusCancelClickHandler);
		addChild( _btStatusCancel );
		
		
        _btLockVisit = new VMButton("", tf13Black, SpriteUtils.createRoundSquare( 140, 30, 6, 6, Colors.WHITE, 2, Colors.GREY4 ) );
		_btLockVisit.borderEnabled = false;
        _btLockVisit.addEventListener(MouseEvent.CLICK, _lockVisitClickHandler);
		addChild( _btLockVisit );  
		
		
		var tf13Grey1Centered = new TextFormat(Fonts.OPEN_SANS, 13, Colors.GREY1);
		tf13Grey1Centered.align = TextFormatAlign.CENTER;
        _btClose = new VMButton(Locale.get( "BT_CLOSE_LABEL" ), tf13Grey1Centered, SpriteUtils.createRoundSquare( 120, 30, 6, 6, Colors.GREY3 ) );
		_btClose.borderEnabled = false;
		_btClose.toolTipContent = Locale.get("TOOLTIP_BT_CLOSE_POPUP");
        _btClose.addEventListener(MouseEvent.CLICK, _closeClickHandler);
		addChild( _btClose );
		
		var tf13Grey1 = tf13Grey1Centered.clone();
		tf13Grey1.align = TextFormatAlign.LEFT;
		_btSaveVisit = new VMButton(Locale.get("BT_SAVE_VISIT_LABEL"), tf13Grey1, SpriteUtils.createRoundSquare(120, 30, 6, 6, Colors.BLUE1) );
		_btSaveVisit.borderEnabled = false;
		_btSaveVisit.setIcon( Icons.getIcon( Icon.PLANNING_SAVE), new Point( 40, 30 ) );
		_btSaveVisit.toolTipContent = Locale.get("TOOLTIP_BT_SAVE_VISITE");
        _btSaveVisit.addEventListener(MouseEvent.CLICK, _saveVisitClickHandler);
		addChild(_btSaveVisit);	
		
		_btDuplicateVisitForDO = new VMButton(Locale.get("BT_DUPLICATE_VISIT_LABEL"), tf13Grey1, SpriteUtils.createRoundSquare(220, 30, 6, 6, Colors.BLUE1) );
		_btDuplicateVisitForDO.borderEnabled = false;
		_btDuplicateVisitForDO.setIcon( Icons.getIcon( Icon.PLANNING_DUPLICATE), new Point( 40, 30 ) );
		_btDuplicateVisitForDO.toolTipContent = Locale.get("TOOLTIP_BT_DUPLICATE_FOR_DO");
        _btDuplicateVisitForDO.addEventListener(MouseEvent.CLICK, _duplicateForDOClickHandler);
		addChild(_btDuplicateVisitForDO);
		
		//2022-evolution
		_btDuplicateVisitOnWorkingPlanning = new VMButton(Locale.get("BT_DUPLICATE_VISIT_ON_WORKING_PLANNING_LABEL"), tf13Grey1, SpriteUtils.createRoundSquare(250, 30, 6, 6, Colors.BLUE1) );
		_btDuplicateVisitOnWorkingPlanning.borderEnabled = false;
		_btDuplicateVisitOnWorkingPlanning.setIcon( Icons.getIcon( Icon.PLANNING_DUPLICATE), new Point( 40, 30 ) );
		_btDuplicateVisitOnWorkingPlanning.toolTipContent = Locale.get("TOOLTIP_BT_DUPLICATE_ON_WORKING_PLANNING");
        _btDuplicateVisitOnWorkingPlanning.addEventListener(MouseEvent.CLICK, _duplicateOnWorkingPlanningClickHandler);
		addChild(_btDuplicateVisitOnWorkingPlanning);
		
		_btGetDemand = new VMButton(Locale.get("BT_GET_DEMAND_VISIT_LABEL"), tf13Grey1, SpriteUtils.createRoundSquare(200, 30, 6, 6, Colors.PURPLE2) );
		_btGetDemand.borderEnabled = false;
		_btGetDemand.setIcon( Icons.getIcon( Icon.SEE_VISIT_DEMAND), new Point( 40, 30 ));
		_btGetDemand.toolTipContent = Locale.get("TOOLTIP_BT_GET_DEMAND");
        _btGetDemand.addEventListener(MouseEvent.CLICK, _getVisitDemandClickHandler);
		addChild(_btGetDemand);	
		
		_btDeleteVisit = new VMButton(Locale.get("BT_REMOVE_VISIT_LABEL"), tf13Grey1, SpriteUtils.createRoundSquare(120, 30, 6, 6, Colors.RED1) );
		_btDeleteVisit.borderEnabled = false;
		_btDeleteVisit.setIcon( Icons.getIcon( Icon.DELETE_WHITE), new Point( 40, 30 ) );
		_btDeleteVisit.toolTipContent = Locale.get("TOOLTIP_BT_REMOVE_VISIT");
        _btDeleteVisit.addEventListener(MouseEvent.CLICK, _deleteVisitClickHandler);
		addChild(_btDeleteVisit);	
        
		
		
		_clStartDay = new VMComboList<ComboListTimeData>( null );
        _clStartDay.addEventListener(Event.SELECT, _startDaySelectHandler);
		_clStartDay.width = 220;
		addChild( _clStartDay );
		_clStartHour = new VMComboList<ComboListTimeData>( null );
        _clStartHour.addEventListener(Event.SELECT, _startHourSelectHandler);
		_clStartHour.width = 80;
		addChild( _clStartHour );
		_clStartMinute = new VMComboList<ComboListTimeData>( null );
        _clStartMinute.addEventListener(Event.SELECT, _startMinuteSelectHandler);
		_clStartMinute.width = 80;
		addChild( _clStartMinute );
		
		_clEndDay = new VMComboList<ComboListTimeData>( null );
        _clEndDay.addEventListener(Event.SELECT, _endDaySelectHandler);
		_clEndDay.width = 220;
		addChild( _clEndDay );
		_clEndHour = new VMComboList<ComboListTimeData>( null );
        _clEndHour.addEventListener(Event.SELECT, _endHourSelectHandler);
		_clEndHour.width = 80;
		addChild( _clEndHour );
		_clEndMinute = new VMComboList<ComboListTimeData>( null );
        _clEndMinute.addEventListener(Event.SELECT, _endMinuteSelectHandler);
		_clEndMinute.width = 80;
		addChild( _clEndMinute );
		
        _initComboListTimeDatas();
		
		
		
		// TODO: optimize that !! 
		// maybe using Maps instead of Collections for visitActivities and checkboxes ? ( see _displayDatas line 556 )	
		var vacb:VisitActivityCheckBox;
        _activityIntList = Activity.getActivityListByType(ActivityType.INT);
        _activityIntCheckBoxList = new Collection<VisitActivityCheckBox>();	
		for ( a in _activityIntList )
		{
			vacb = new VisitActivityCheckBox();
			vacb.setText( a.labelInt, tfLabel );
			addChild( vacb );
			_activityIntCheckBoxList.addItem( vacb );
		}		
        _activityExtList = Activity.getActivityListByType(ActivityType.EXT);
        _activityExtCheckBoxList = new Collection<VisitActivityCheckBox>();
		for ( a in _activityExtList )
		{
			vacb = new VisitActivityCheckBox();
			vacb.setText( a.labelExt, tfLabel );
			addChild( vacb );
			_activityExtCheckBoxList.addItem( vacb );
		}		
		
		
		_clSpecialVisit = new VMComboList<SpecialVisit>( SpecialVisit.list.clone() );
		addChild( _clSpecialVisit );
		
		
        _cbSpecialVisit = new CheckBox();
		_cbSpecialVisit.setText(Locale.get("CB_SPECIAL_VISIT"), tfLabel );
		_cbSpecialVisit.icon = Icons.getIcon( Icon.CHECK_SOLID_GREY3 );
		_cbSpecialVisit.iconSelected = Icons.getIcon( Icon.CHECK_SOLID_GREY3_SELECTED );
        _cbSpecialVisit.addEventListener(Event.CHANGE, _cbSpecialVisitChangeHandler);
		addChild( _cbSpecialVisit );		
		
		ResizeManager.instance.addEventListener( ResizeEvent.RESIZE, _resizeHandler );		
		
        addEventListener(Event.ADDED_TO_STAGE, _init);
        addEventListener(Event.REMOVED_FROM_STAGE, _destroy); 
		
		//BUG : ON CANVAS, this makes TEXTINPUT INACTIVE    -___-	
		//what is it for anyways ?
        //addEventListener(FocusEvent.FOCUS_OUT, _focusOutHandler);
		
        addEventListener(KeyboardEvent.KEY_DOWN, _keyDownHandler);
    }
    private function _init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, _init);
		
        stage.focus = this;
		
		_displayDatas();
		_draw();
	}
	
    private function _destroy(e:Event):Void
    {
        removeEventListener(KeyboardEvent.KEY_DOWN, _keyDownHandler);
        //removeEventListener(FocusEvent.FOCUS_OUT, _focusOutHandler);
    }
	
	function _resizeHandler(e:ResizeEvent):Void 
	{
		if ( stage == null ) return;
		_draw();
	}
    
	//BUG : ON CANVAS, this makes TEXTINPUT INACTIVE    -___-	
    /*private function _focusOutHandler(e:FocusEvent):Void
    {	
		trace( "VisitDetail._focusOutHandler",e.target,e.currentTarget,e.relatedObject );
        stage.focus = this;
    }*/
    
    private function _keyDownHandler(e:KeyboardEvent):Void
    {
		if ( Std.isOfType(e.target, TextField ) ) return;
		// Enter
        if (e.keyCode == 13)
        {
            _saveVisitClickHandler(null);
        }
		// Esc
        if (e.keyCode == 27)
        {
            _closeClickHandler(null);
        }
    } 
	
	function _initComboListTimeDatas() 
	{
        var dayTimeValue:Float = 24 * 60 * 60 * 1000;
        var dDay:Collection<ComboListTimeData> = new Collection<ComboListTimeData>();
        var o:ComboListTimeData;
        var dateData:Date;
        for ( i in 0...5)
        {
            dateData = Date.fromTime(Config.INIT_START_DATE.getTime() + i * dayTimeValue);
            o = {
                        label:DateUtils.toText(dateData, Config.LANG),
                        data:dateData
                    };
            dDay.addItem(o);
        }
        _clEndDay.datas = dDay;
        _clStartDay.datas = dDay;	
		
		
        var hourTimeValue:Float = 60 * 60 * 1000;
        var dHour:Collection<ComboListTimeData> = new Collection<ComboListTimeData>();
        var o:ComboListTimeData;
		var max:Int = Config.INIT_SLOT_END.getHours() - Config.INIT_SLOT_START.getHours() + 1;
		for ( i in 0...max )
        {
            o = {
				label : (Config.INIT_SLOT_START.getHours() + i) + " h",
				data : Date.fromTime(Config.INIT_SLOT_START.getTime() + i * hourTimeValue)
			};
            dHour.addItem(o);
        }
        _clEndHour.datas = dHour;
        _clStartHour.datas = dHour;
		
        
        var minuteTimeValue:Float = 60 * 1000;
        var dMinute:Collection<ComboListTimeData> = new Collection<ComboListTimeData>();
		max = Std.int(60 * minuteTimeValue / Config.INIT_SLOT_LENGTH_TIME);
		for ( i in 0...max )
        {
            o = {
				label : (Config.INIT_SLOT_START.getMinutes() + i * Config.INIT_SLOT_LENGTH_TIME / 60 / 1000) + " min",
				data : Date.fromTime(Config.INIT_SLOT_START.getTime() + i * Config.INIT_SLOT_LENGTH_TIME)
			};
            
            dMinute.addItem(o);
        }
        _clEndMinute.datas = dMinute;
        _clStartMinute.datas = dMinute;		
	} 
    
    private function _displayDatas():Void
    {
        Actuate.tween(this, 0.5, {alpha:1});
		
		
        if (_data.idDemand > 0)
        {
            _lblPriority.setText( _data.demandPriority );
        }else{
			_lblPriority.alpha = 0.5;
            _lblPriority.setText( "-" );
			_lblPriorityLabel.alpha = 0.5;
            _btGetDemand.visible = false;
		}
        
        
        
        if (User.instance.type != UserType.PROGRAMMEUR)
        {
            _btNotesProg.visible = false;
			_btNotes.enabled = false;
        }
        
        _notes = _data.notes;
        _notesProg = _data.notesProg;        
        _activeNotesIsProg = false;
        _displayActiveNotes();
		
        	
			
			
        if (_data.isSpecialVisit)
        {
            _btGetDemand.visible = false;
            _btStatusCancel.visible = false;
            _btStatusAccept.visible = false;
            _btDeleteVisit.visible = false;
            
			if (_data.idSpecialVisit > 0)
			{
				_cbSpecialVisit.selected = true;
				_clSpecialVisit.selectedData = _clSpecialVisit.datas.getItemBy("id", _data.idSpecialVisit);
			}
			else
			{
				_cbSpecialVisit.selected = false;
				_clSpecialVisit.selectedIndex = 0;
			}
			_cbSpecialVisitChangeHandler();
        }
        else
        {
			_txtLocation.state = ToggleTextInputState.STATIC;
			_txtContact.state = ToggleTextInputState.STATIC;
			_txtPhone.state = ToggleTextInputState.STATIC;
			_txtName.state = ToggleTextInputState.STATIC;
			
			
            _clSpecialVisit.visible = false;
            _clSpecialVisit.mouseChildren = false;
            _clSpecialVisit.mouseEnabled = false;
            _cbSpecialVisit.visible = false;
            _cbSpecialVisit.mouseChildren = false;
            _cbSpecialVisit.mouseEnabled = false;
			
        
            var country:Country = _data.exhibitorCountry;
			if ( country != null )
			{
				_countryFlag = country.flag32;
				addChild( _countryFlag );
			}
			
			//FIX: not used in 2021
			/*
            _localizationIcon = Icons.getIcon(Icon.LOCALIZATION_40);
            _localizationIcon.addEventListener(MouseEvent.CLICK, _clickLocalizeHandler);
			addChild ( _localizationIcon );
			*/
        }
		
		
		// TODO: optimize that !! 
		// maybe using Maps instead of Collections for visitActivities and checkboxes ? ( see constructor line 355 )
        var vaJSON:VisitActivityJSON;
		for ( aInt in _activityIntList )
		{
			vaJSON = _data.visitActivityList.getItemBy("label", aInt.labelInt, false);
			if ( vaJSON != null )
			{
				for (cb in _activityIntCheckBoxList )
				{
						trace( "vaJSON.label : " + vaJSON.label );
						trace( "cb.text : " + cb.text );
					if ( cb.text == vaJSON.label ) 
					{
						cb.selected = vaJSON.isChecked;
						break;
					}
				}
			}
		}
		
		for ( aExt in _activityExtList )
		{
			vaJSON = _data.visitActivityList.getItemBy("label", aExt.labelExt, false);
			if ( vaJSON != null )
			{
				for (cb in _activityExtCheckBoxList )
				{
					
					if ( cb.text == vaJSON.label ) 
					{
						cb.selected = vaJSON.isChecked;
						break;
					}
				}
			}
		}
		
        
        _applyDatesToComboList(_data.period.startDate, _data.period.endDate);
        
        _txtContact.text = _data.contact;
        _txtLocation.text = _data.location;
        _txtPhone.text = _data.phone;        
        _txtName.text = _data.name;
		
        _isVisitLocked = _data.isLocked;
        _toggleLockVisitButton();
        _toggleLockedVisit();
        		
		//2022-evolution
        //_btDuplicateVisitForDO.enabled = (_data.id != 0);
        _btDuplicateVisitForDO.enabled = ((_data.id != 0) && _isUserAuthorized);		
        _btDuplicateVisitOnWorkingPlanning.enabled = ((_data.id != 0) && _isUserAuthorized && _isPlanningLocked);
        _btDuplicateVisitOnWorkingPlanning.visible = _btDuplicateVisitOnWorkingPlanning.enabled;
    }
    
		
	
    private function _toggleLockedVisit():Void
    {
        _clEndDay.enabled = !(_isPlanningLocked || _isVisitLocked);
        _clEndHour.enabled = !(_isPlanningLocked || _isVisitLocked);
        _clEndMinute.enabled = !(_isPlanningLocked || _isVisitLocked);
        _clStartDay.enabled = !(_isPlanningLocked || _isVisitLocked);
        _clStartHour.enabled = !(_isPlanningLocked || _isVisitLocked);
        _clStartMinute.enabled = !(_isPlanningLocked || _isVisitLocked);
        _clSpecialVisit.enabled = !(_isPlanningLocked || _isVisitLocked);
        
        _btStatusAccept.enabled = !(_isPlanningLocked || _isVisitLocked);
        _btStatusCancel.enabled = !(_isPlanningLocked || _isVisitLocked);
        _btGetDemand.enabled = !(_isPlanningLocked || _isVisitLocked);
        _btDeleteVisit.enabled = !(_isPlanningLocked || _isVisitLocked);
        _txtNotes.mouseEnabled = !(_isPlanningLocked || _isVisitLocked);
        _cbSpecialVisit.enabled = !(_isPlanningLocked || _isVisitLocked);
        if (_isPlanningLocked || _isVisitLocked)
        {
			_txtLocation.state = ToggleTextInputState.STATIC;
			_txtContact.state = ToggleTextInputState.STATIC;
			_txtPhone.state = ToggleTextInputState.STATIC;
            if (!_cbSpecialVisit.selected)
            {
				_txtName.state = ToggleTextInputState.STATIC;
            }
        }
        else if (_data.isSpecialVisit)
        {
			_txtLocation.state = ToggleTextInputState.DYNAMIC;
			_txtContact.state = ToggleTextInputState.DYNAMIC;
			_txtPhone.state = ToggleTextInputState.DYNAMIC;
            if (!_cbSpecialVisit.selected)
            {
				_txtName.state = ToggleTextInputState.DYNAMIC;
            }
			
        }
        _btSaveVisit.enabled = !(_isPlanningLocked);
        _btLockVisit.enabled = !(_isPlanningLocked);
        
		for ( cb in _activityIntCheckBoxList )
			cb.enabled = !(_isPlanningLocked || _isVisitLocked);
			
		for ( cb in _activityExtCheckBoxList )
			cb.enabled = !(_isPlanningLocked || _isVisitLocked);
    }
	
	
    
    private function _getVisitToSave():Visit
    {
		// original Visit is copied.
		// if an error occurs, the original Visit is not modified.        
        var visit:Visit = _data.clone();
        
        // APPLY DATAS
        if (visit.isSpecialVisit  )
        {
            if (_cbSpecialVisit.selected)
            {
                var specialVisit:SpecialVisit = _clSpecialVisit.selectedData;
                visit.idSpecialVisit = specialVisit.id;
                visit.name = "";
            }
            else
            {
                visit.idSpecialVisit = 0;
                visit.name = _txtName.text;
            }
        }
        visit.location = _txtLocation.text;
        visit.contact = _txtContact.text;
        visit.phone = _txtPhone.text;
        
        
        visit.notes = _notes;
        visit.notesProg = _notesProg;
        
        var vaJSON:VisitActivityJSON;
        var a:Activity;
        var i:Int = -1;
        var checked:Bool;
        while (++i < _activityIntCheckBoxList.length)
        {
            checked = _activityIntCheckBoxList.getItemAt(i).selected;
            a = _activityIntList.getItemAt(i);
            vaJSON = visit.visitActivityList.getItemBy("label", a.labelInt);
            if (vaJSON != null)
            {
                vaJSON.isChecked = checked;
            }
            else
            {
                vaJSON = { id:0, idVisit:visit.id, label:a.labelInt, isChecked:checked, comment:"", urlIcon:""};
                visit.visitActivityList.addItem(vaJSON);
            }
        }
        i = -1;
        while (++i < _activityExtCheckBoxList.length)
        {
            checked = _activityExtCheckBoxList.getItemAt(i).selected;
            a = _activityExtList.getItemAt(i);
            vaJSON = visit.visitActivityList.getItemBy("label", a.labelExt);
            if (vaJSON != null)
            {
                vaJSON.isChecked = checked;
            }
            else
            {
                vaJSON = { id:0, idVisit:visit.id, label:a.labelExt, isChecked:checked, comment:"", urlIcon:""};
                visit.visitActivityList.addItem(vaJSON);
            }
        }
        
        visit.isLocked = _isVisitLocked;
        
        return visit;
    }
    private function _getNewPeriod():Period
    {
        if (_clStartDay.selectedData == null || _clStartHour.selectedData == null || _clStartMinute.selectedData == null)
        {
            return null;
        }
        if (_clEndDay.selectedData == null || _clEndHour.selectedData == null || _clEndMinute.selectedData == null)
        {
            return null;
        }       
        
        
        var newStartDate:Date = new Date(
        _data.dateStart.getFullYear(), _data.dateStart.getMonth(), _clStartDay.selectedData.data.getDate(), 
        _clStartHour.selectedData.data.getHours(), _clStartMinute.selectedData.data.getMinutes(), 0);
        
        var newEndDate:Date = new Date(
        _data.dateEnd.getFullYear(), _data.dateEnd.getMonth(), _clEndDay.selectedData.data.getDate(), 
        _clEndHour.selectedData.data.getHours(), _clEndMinute.selectedData.data.getMinutes(), 0);
		
        return new Period(newStartDate, newEndDate);
    }
	
	
    
    private function _startDaySelectHandler(e:Event):Void
    {
        _clEndDay.selectedIndex = _clStartDay.selectedIndex;
    }
    private function _startHourSelectHandler(e:Event):Void
    {
        _checkDate(true);
    }
    private function _startMinuteSelectHandler(e:Event):Void
    {
        _checkDate(true);
    }
    private function _endDaySelectHandler(e:Event):Void
    {
        _clStartDay.selectedIndex = _clEndDay.selectedIndex;
    }
    private function _endHourSelectHandler(e:Event):Void
    {
        _checkDate(false);
    }
    private function _endMinuteSelectHandler(e:Event):Void
    {
        _checkDate(false);
    }
    private function _checkDate(isFromStart:Bool):Void
    {
        var day:Date = _clStartDay.selectedData.data;
        var newStartDate:Date = new Date(
									day.getFullYear(), day.getMonth(), day.getDate(), 
									_clStartHour.selectedData.data.getHours(), 
									_clStartMinute.selectedData.data.getMinutes(),
									0);
        var newEndDate:Date = new Date(
									day.getFullYear(), day.getMonth(), day.getDate(), 
									_clEndHour.selectedData.data.getHours(), 
									_clEndMinute.selectedData.data.getMinutes(),
									0);
        
        var dayStartDate:Date = new Date(
									day.getFullYear(), day.getMonth(), day.getDate(), 
									Config.INIT_SLOT_START.getHours(), 
									Config.INIT_SLOT_START.getMinutes(), 
									Config.INIT_SLOT_START.getSeconds());
        
        var dayEndDate:Date = new Date(
									day.getFullYear(), day.getMonth(), day.getDate(), 
									Config.INIT_SLOT_END.getHours(), 
									Config.INIT_SLOT_END.getMinutes(), 
									Config.INIT_SLOT_END.getSeconds());
        
        if (newEndDate.getTime() - newStartDate.getTime() < Config.INIT_SLOT_LENGTH_TIME)
        {
            if (isFromStart)
            {
                newEndDate = Date.fromTime(newStartDate.getTime() + Config.INIT_SLOT_LENGTH_TIME);
                if (newEndDate.getTime() > dayEndDate.getTime())
                {
                    _checkDate(false);
                    return;
                }
            }
            else
            {
                newStartDate = Date.fromTime(newEndDate.getTime() - Config.INIT_SLOT_LENGTH_TIME);
                if (newStartDate.getTime() < dayStartDate.getTime())
                {
                    _checkDate(true);
                    return;
                }
            }
        }
        if (newStartDate.getTime() < dayStartDate.getTime())
        {
            newStartDate = dayStartDate;
            _applyDatesToComboList(newStartDate, newEndDate);
            _checkDate(true);
            return;
        }
        if (newEndDate.getTime() > dayEndDate.getTime())
        {
            newEndDate = dayEndDate;
            _applyDatesToComboList(newStartDate, newEndDate);
            _checkDate(false);
            return;
        }
        
        _applyDatesToComboList(newStartDate, newEndDate);
    }
    
    private function _toggleLockVisitButton():Void
    {
        if (_isVisitLocked)
        {
			_btLockVisit.setLabel(Locale.get("BT_LOCK_VISIT_LABEL") );
			_btLockVisit.toolTipContent = Locale.get("TOOLTIP_BT_UNLOCK_VISIT");
			_btLockVisit.setIcon( Icons.getIcon( Icon.LOCKED_GREY3), new Point(40, 30) );
        }
        else
        {
			_btLockVisit.setLabel(Locale.get("BT_UNLOCK_VISIT_LABEL")  );
			_btLockVisit.toolTipContent = Locale.get("TOOLTIP_BT_LOCK_VISIT");
			_btLockVisit.setIcon( Icons.getIcon( Icon.UNLOCKED_GREY3), new Point(40, 30) );
        }
    }
	
    private function _displayActiveNotes():Void
    {
        if (_activeNotesIsProg)
        {
            _txtNotes.text = _notesProg;
            _btNotes.alpha = 0.4;
            _btNotesProg.alpha = 1;
        }
        else
        {
            _txtNotes.text = _notes;
            _btNotes.alpha = 1;
            _btNotesProg.alpha = 0.4;
        }
		
        _updateNotesScrollBar();
    }
    
    private function _txtNotesChangeHandler(e:Event):Void
    {
        if (_activeNotesIsProg)
        {
			#if dom
            _notesProg = _cleanText( _txtNotes.text );
			#else
            _notesProg = _txtNotes.text;
			#end
        }
        else
        {
			#if dom
            _notes = _cleanText( _txtNotes.text );
			#else
            _notes = _txtNotes.text;
			#end
        }
        _updateNotesScrollBar(true);
    }
	
	function _cleanText(text:String):String
	{
		//BUG: with DOM, a html text is return by the TextField.text property
		//FIX: clean the text
		text = StringTools.replace( text, "<div>", "" );
		text = StringTools.replace( text, "</div>", "" );
		text = StringTools.replace( text, "&nbsp;", " " );
		text = StringTools.replace( text, "&amp;", "&" );
		text = StringTools.replace( text, "&lt;", "<" );
		text = StringTools.replace( text, "&gt;", ">" );
		text = StringTools.replace( text, "<br>", "\n" );
		
		return text;
	}
    
    private function _updateNotesScrollBar(showAlwaysLastLine:Bool = false):Void
    {
        _sbNotes.visible = (_txtNotes.maxScrollV > 1);
        if (showAlwaysLastLine)
        {
            _txtNotes.scrollV = _txtNotes.maxScrollV;
        }
        else
        {
            _txtNotes.scrollV = 1;
        }
        _sbNotes.updatePosition(true);
    }
	
	
    private function _applyDatesToComboList(startDate:Date, endDate:Date):Void
    {
        
        // day
		for ( timeData in _clStartDay.datas )
		{
			if ( timeData.data.getDate() == startDate.getDate() )
			{
				_clStartDay.selectedData = timeData;
				_clEndDay.selectedData = timeData;	
				break;
			}
		}
		/*
        var i:Int = -1;
        var clDate:Date;
        while (++i < _clStartDay.datas.length)
        {
            clDate = _clStartDay.datas.getItemAt(i).data;
            if (clDate.date == startDate.date)
            {
                _clStartDay.selectedIndex = i;
                _clEndDay.selectedIndex = i;
                break;
            }
        }
		*/
        
        // hours
		for ( timeData in _clStartHour.datas )
		{
			if ( timeData.data.getHours() == startDate.getHours() )
			{
				_clStartHour.selectedData = timeData;
				break;
			}
		}
		for ( timeData in _clEndHour.datas )
		{
			if ( timeData.data.getHours() == endDate.getHours() )
			{
				_clEndHour.selectedData = timeData;
				break;
			}
		}
		/*
        i = -1;
        while (++i < _clStartHour.datas.length)
        {
            clDate = _clStartHour.datas.getItemAt(i).data;
            if (clDate.hours == startDate.hours)
            {
                _clStartHour.selectedIndex = i;
                break;
            }
        }
        i = -1;
        while (++i < _clEndHour.datas.length)
        {
            clDate = _clEndHour.datas.getItemAt(i).data;
            if (clDate.hours == endDate.hours)
            {
                _clEndHour.selectedIndex = i;
                break;
            }
        }*/
        
        // minutes
		for ( timeData in _clStartMinute.datas )
		{
			if ( timeData.data.getMinutes() == startDate.getMinutes() )
			{
				_clStartMinute.selectedData = timeData;
				break;
			}
		}
		for ( timeData in _clEndMinute.datas )
		{
			if ( timeData.data.getMinutes() == endDate.getMinutes() )
			{
				_clEndMinute.selectedData = timeData;
				break;
			}
		}
		/*
        i = -1;
        while (++i < _clStartMinute.datas.length)
        {
            clDate = _clStartMinute.datas.getItemAt(i).data;
            if (clDate.minutes == startDate.minutes)
            {
                _clStartMinute.selectedIndex = i;
                break;
            }
        }
        i = -1;
        while (++i < _clEndMinute.datas.length)
        {
            clDate = _clEndMinute.datas.getItemAt(i).data;
            if (clDate.minutes == endDate.minutes)
            {
                _clEndMinute.selectedIndex = i;
                break;
            }
        }*/
    }
	
	
    private function _cbSpecialVisitChangeHandler(e:Event = null):Void
    {
        if (_cbSpecialVisit.selected)
        {
			_txtName.state = ToggleTextInputState.STATIC;
			_txtName.visible = false;
			
            _clSpecialVisit.visible = true;
        }
        else
        {
			_txtName.state = ToggleTextInputState.DYNAMIC;
			_txtName.visible = true;
			
            _clSpecialVisit.visible = false;
        }
    }
    
    
    private function _notesClickHandler(e:MouseEvent):Void
    {
        _activeNotesIsProg = false;
        _displayActiveNotes();
    }
    private function _notesProgClickHandler(e:MouseEvent):Void
    {
        _activeNotesIsProg = true;
        _displayActiveNotes();
    }
    private function _lockVisitClickHandler(e:MouseEvent):Void
    {
        _isVisitLocked = !_isVisitLocked;
        _toggleLockVisitButton();
        _toggleLockedVisit();
    }
    private function _getVisitDemandClickHandler(e:MouseEvent):Void
    {
        if (_data.idDemand > 0)
        {
            var url:URLRequest = new URLRequest(Config.getDemandURL + "?pIdDmd=" + _data.idDemand);
            Lib.navigateToURL(url, "_blank");
        }
    }
    private function _duplicateForDOClickHandler(e:MouseEvent):Void
    {
        if (!_isUserAuthorized)
        {
            return;
        }
		
		if ( !_isVisitLocked )
		{		
			_cbSpecialVisit.enabled = false;
			if ( _cbSpecialVisit.selected )				
				_clSpecialVisit.enabled = false;
			else
				_txtName.state = ToggleTextInputState.STATIC;
		}
		
        _duplicateOverlay = new VisitDetailDuplicateVisitOverlay(_data, _width, _height - _duplicateOverlayPosY);
		_duplicateOverlay.x = _background.x;
		_duplicateOverlay.y = _background.y + _duplicateOverlayPosY;
        _duplicateOverlay.addEventListener(Event.CLOSE, _duplicateOverlayCloseHandler);
        addChild(_duplicateOverlay);
    }    
	
    private function _duplicateOverlayCloseHandler(e:Event):Void
    {
		_duplicateOverlay.removeEventListener( Event.CLOSE, _duplicateOverlayCloseHandler );
		removeChild( _duplicateOverlay );
		_duplicateOverlay = null;
		if ( !_isVisitLocked )
		{	
			_cbSpecialVisit.enabled = true;
			if ( _cbSpecialVisit.selected )				
				_clSpecialVisit.enabled = true;
			else
				_txtName.state = ToggleTextInputState.DYNAMIC;
		}
    }
	
	//2022-evolution
    private function _duplicateOnWorkingPlanningClickHandler(e:MouseEvent):Void
    {
		//useless ?
        if (!_isUserAuthorized)
        {
            return;
        }
		
		ServiceManager.instance.addEventListener( ServiceEvent.COMPLETE, _duplicateOnWorkingPlanningCompleteHandler );
		ServiceManager.instance.duplicateVisitOnWorkingPlanning( _data ); 
		
    } 	
	function _duplicateOnWorkingPlanningCompleteHandler(e:ServiceEvent):Void 
	{
		if ( e.currentCall == ServiceManager.instance.duplicateVisitOnWorkingPlanning )
		{
			ServiceManager.instance.removeEventListener( ServiceEvent.COMPLETE, _duplicateOnWorkingPlanningCompleteHandler );
			
			DialogManager.instance.open( new VMMessageDialog( "", Locale.get("ALERT_DUPLICATE_ON_WORKING_PLANNING" ) ) );
		}
	}
	//-----------
    
    private function _statusAcceptClickHandler(e:MouseEvent):Void
    {
        if (User.instance.showChangeStatusAlert)
        {
            DialogManager.instance.addEventListener(DialogEvent.CLOSE, _confirmChangeStatusAcceptHandler);
            DialogManager.instance.open( new ConfirmChangeVisitStatusDialog( "", Locale.get("CONFIRM_CHANGE_VISIT_STATUS") ) );
        }
        else
        {
            _changeStatus(VisitStatusID.ACCEPTED);
        }
    }
	
    private function _statusCancelClickHandler(e:MouseEvent):Void
    {
        if (User.instance.showChangeStatusAlert)
        {
            DialogManager.instance.addEventListener(DialogEvent.CLOSE, _confirmChangeStatusCancelHandler);
            DialogManager.instance.open( new ConfirmChangeVisitStatusDialog( "", Locale.get("CONFIRM_CHANGE_VISIT_STATUS") ) );
        }
        else
        {
            _changeStatus(VisitStatusID.CANCELED);
        }
    }
	
    private function _confirmChangeStatusAcceptHandler(e:DialogEvent):Void
    {
        DialogManager.instance.removeEventListener(DialogEvent.CLOSE, _confirmChangeStatusAcceptHandler);
        if (e.value == DialogValue.CONFIRM)
        {
            _changeStatus(VisitStatusID.ACCEPTED);
        }
    }
    private function _confirmChangeStatusCancelHandler(e:DialogEvent):Void
    {
        DialogManager.instance.removeEventListener(DialogEvent.CLOSE, _confirmChangeStatusCancelHandler);
        if (e.value == DialogValue.CONFIRM)
        {
            _changeStatus(VisitStatusID.CANCELED);
        }
    }
    private function _changeStatus(idStatus):Void
    {
        var visitToSave:Visit = _getVisitToSave();
        var newPeriod:Period = _getNewPeriod();
        if (newPeriod == null)
        {
            return;
        }
		
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ERROR, _saveVisitErrorHandler);
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.COMPLETE, _saveVisitCompleteHandler);
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _saveVisitAskForConfirmSerieHandler);
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_EXHIBITOR_AVAILABILITY, _visitSaveAskForConfirmExhibitorAvailabilityHandler);
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ALERT_EXHIBITOR_NON_ELIGIBLE, _visitSaveAlertExhibitorNonEligibleHandler);
        VisitSaveHelper.instance.saveVisit( VisitSaveType.FROM_VISIT_DETAIL, visitToSave, newPeriod, null, idStatus);
    }
	
    
    private function _saveVisitClickHandler(e:MouseEvent):Void
    {
        var visitToSave:Visit = _getVisitToSave();
		//trace( "visitToSave : " + visitToSave );
        var newPeriod:Period = _getNewPeriod();
		//trace( "newPeriod : " + newPeriod );
        if (newPeriod == null)
        {
            return;
        }
		
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ERROR, _saveVisitErrorHandler);
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.COMPLETE, _saveVisitCompleteHandler);
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _saveVisitAskForConfirmSerieHandler);
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_EXHIBITOR_AVAILABILITY, _visitSaveAskForConfirmExhibitorAvailabilityHandler);
        VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ALERT_EXHIBITOR_NON_ELIGIBLE, _visitSaveAlertExhibitorNonEligibleHandler);
        VisitSaveHelper.instance.saveVisit(VisitSaveType.FROM_VISIT_DETAIL, visitToSave, newPeriod);
    }
    
    private function _visitSaveAlertExhibitorNonEligibleHandler(e:VisitSaveEvent):Void
    {
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ERROR, _saveVisitErrorHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _saveVisitAskForConfirmSerieHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_EXHIBITOR_AVAILABILITY, _visitSaveAskForConfirmExhibitorAvailabilityHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ALERT_EXHIBITOR_NON_ELIGIBLE, _visitSaveAlertExhibitorNonEligibleHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.COMPLETE, _saveVisitCompleteHandler);
		
        DialogManager.instance.addEventListener(DialogEvent.CLOSE, _saveVisitConfirmExhibitorAvailabilityCloseHandler);
		DialogManager.instance.open( new VMConfirmDialog( "Message Dialog Title", e.message ) );
    }
    private function _visitSaveAskForConfirmExhibitorAvailabilityHandler(e:VisitSaveEvent):Void
    {
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ERROR, _saveVisitErrorHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _saveVisitAskForConfirmSerieHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_EXHIBITOR_AVAILABILITY, _visitSaveAskForConfirmExhibitorAvailabilityHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ALERT_EXHIBITOR_NON_ELIGIBLE, _visitSaveAlertExhibitorNonEligibleHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.COMPLETE, _saveVisitCompleteHandler);
		
        DialogManager.instance.addEventListener(DialogEvent.CLOSE, _saveVisitConfirmExhibitorAvailabilityCloseHandler);
		DialogManager.instance.open( new ConfirmInteractiveDialog( "Confirm Dialog Title", e.message ) );
    }
    
    private function _saveVisitConfirmExhibitorAvailabilityCloseHandler(e:DialogEvent):Void
    {
        //PopupManager.instance.removeEventListener(DialogEvent.CLOSE, _saveVisitConfirmExhibitorAvailabilityCloseHandler);
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
        //trace("CalendarDayItem._saveVisitAskForConfirmSerieHandler:" + e.message);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _saveVisitAskForConfirmSerieHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ERROR, _saveVisitErrorHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.COMPLETE, _saveVisitCompleteHandler);
		
        DialogManager.instance.addEventListener(DialogEvent.CLOSE, _saveVisitConfirmSerieCloseHandler);
        DialogManager.instance.open(new ConfirmVisitSerieDialog( "Confirm Dialog Title", e.message ) );
    }
    private function _saveVisitConfirmSerieCloseHandler(e:DialogEvent):Void
    {
        DialogManager.instance.removeEventListener(DialogEvent.CLOSE, _saveVisitConfirmSerieCloseHandler);		
		
		switch (e.value) 
		{
			case DATA(visitSerieProcess):        
				//trace("_saveVisitConfirmSerieCloseHandler:" + visitSerieProcess);
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
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _saveVisitAskForConfirmSerieHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_EXHIBITOR_AVAILABILITY, _visitSaveAskForConfirmExhibitorAvailabilityHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ALERT_EXHIBITOR_NON_ELIGIBLE, _visitSaveAlertExhibitorNonEligibleHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.COMPLETE, _saveVisitCompleteHandler);
		
        DialogManager.instance.open( new VMMessageDialog( "Message Dialog Title", e.message ) );
    }
	
    private function _saveVisitCompleteHandler(e:VisitSaveEvent):Void
    {
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ERROR, _saveVisitErrorHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _saveVisitAskForConfirmSerieHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_EXHIBITOR_AVAILABILITY, _visitSaveAskForConfirmExhibitorAvailabilityHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ALERT_EXHIBITOR_NON_ELIGIBLE, _visitSaveAlertExhibitorNonEligibleHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.COMPLETE, _saveVisitCompleteHandler);
        
        if ( e.message != null )
        {
			// check save Serie Result
            DialogManager.instance.addEventListener(DialogEvent.CLOSE, _saveVisitSerieResultCloseHandler);
            DialogManager.instance.open( new VMMessageDialog( "Message Dialog Title", e.message ) );
			
        } else {
			
            //trace("SAVE VISIT SERIE COMPLETE:" + e.message);
            _close(new VisitDetailEvent(VisitDetailEvent.CLOSE, _data));
        }
    }
    private function _saveVisitSerieResultCloseHandler(e:DialogEvent):Void
    {
        DialogManager.instance.removeEventListener(DialogEvent.CLOSE, _saveVisitSerieResultCloseHandler);
        _close(new VisitDetailEvent(VisitDetailEvent.CLOSE, _data));
    }
	
	
	
	
	
	
	
    
    private function _closeClickHandler(e:MouseEvent):Void
    {
        _close(new VisitDetailEvent(VisitDetailEvent.CLOSE, _data));
    }
	
	
	//FIX: not used in 2021
	/*
    private function _clickLocalizeHandler(e:MouseEvent):Void
    {
        if (ExternalInterface.available)
        {
            ExternalInterface.call("localizeExhibitor", _data.exhibitorCode, User.instance.id, Config.LANG);
        }
        else
        {
            DialogManager.instance.open( new VMMessageDialog( "", Locale.get("LOCALIZATION_ERROR_MESSAGE") ) );
        }
    }*/
	
	
    private function _deleteVisitClickHandler(e:MouseEvent):Void
    {
        if (_isPlanningLocked || _isVisitLocked || !_isUserAuthorized)
        {
            return;
        }
        
        var message:String;
        if (_data.isSpecialVisit)
        {
            message = Locale.get("CONFIRM_REMOVE_VISIT");
        }
        else if (_data.idStatus == VisitStatusID.CANCELED)
        {
            message = Locale.get("CONFIRM_REMOVE_VISIT_CANCELED");
        }
        else
        {
            message = Locale.get("CONFIRM_REMOVE_VISIT_PENDING");
        }
        DialogManager.instance.addEventListener(DialogEvent.CLOSE, _removeVisitConfirmCloseHandler);
        DialogManager.instance.open( new VMConfirmDialog( "Confirm Dialog title", message ) );
    }
    private function _removeVisitConfirmCloseHandler(e:DialogEvent):Void
    {
        DialogManager.instance.removeEventListener(DialogEvent.CLOSE, _removeVisitConfirmCloseHandler);
        if (e.value == DialogValue.CONFIRM)
        {
            VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ERROR, _removeVisitErrorHandler);
            VisitSaveHelper.instance.addEventListener(VisitSaveEvent.COMPLETE, _removeVisitCompleteHandler);
            VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _removeVisitAskForConfirmSerieHandler);
            VisitSaveHelper.instance.removeVisit(_data);
        }
    }
    private function _removeVisitAskForConfirmSerieHandler(e:VisitSaveEvent):Void
    {
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ERROR, _removeVisitErrorHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.COMPLETE, _removeVisitCompleteHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _removeVisitAskForConfirmSerieHandler);
        
        DialogManager.instance.addEventListener(DialogEvent.CLOSE, _removeVisitConfirmSerieCloseHandler);
        DialogManager.instance.open(new ConfirmVisitSerieDialog( "Confirm Dialog title", e.message) );
    }
    private function _removeVisitConfirmSerieCloseHandler(e:DialogEvent):Void
    {
        DialogManager.instance.removeEventListener(DialogEvent.CLOSE, _removeVisitConfirmSerieCloseHandler);
        
		
		switch (e.value) 
		{
			case DATA(visitSerieProcess):        
				//trace("_closeConfirmRemoveVisitHandler:" + visitSerieProcess);
				VisitSaveHelper.instance.addEventListener(VisitSaveEvent.ERROR, _removeVisitErrorHandler);
				VisitSaveHelper.instance.addEventListener(VisitSaveEvent.COMPLETE, _removeVisitCompleteHandler);
				VisitSaveHelper.instance.confirmRemoveVisitSerie(visitSerieProcess);
			case _:
				return;
		}
    }
    private function _removeVisitErrorHandler(e:VisitSaveEvent):Void
    {
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ERROR, _removeVisitErrorHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _removeVisitAskForConfirmSerieHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.COMPLETE, _removeVisitCompleteHandler);
		
        DialogManager.instance.open( new VMMessageDialog( "Message Dialog title", e.message ) );
    }
    private function _removeVisitCompleteHandler(e:VisitSaveEvent):Void
    {
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ERROR, _removeVisitErrorHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.ASK_FOR_CONFIRM_SERIE, _removeVisitAskForConfirmSerieHandler);
        VisitSaveHelper.instance.removeEventListener(VisitSaveEvent.COMPLETE, _removeVisitCompleteHandler);
        
        _close(new VisitDetailEvent(VisitDetailEvent.CLOSE, _data));
    }
    
    
    private function _close(closingEvent:VisitDetailEvent):Void
    {
        dispatchEvent(closingEvent);
        parent.removeChild(this);
    }
	
	
	
	
    private function _draw():Void
    {
		var w = stage.stageWidth;
		var h = stage.stageHeight;
		
		_darkLayer.graphics.clear();
        _darkLayer.graphics.beginFill(0x00, 0.7);
        _darkLayer.graphics.drawRect(-10, -10, w+20, h+20);
        _darkLayer.graphics.endFill();	
		
		var labelMaxWidth:Int = 100;
		var padding = 20;		
		_width = w * 0.50;		
		if ( w <= Config.LAYOUT2_MAX_WIDTH )
		{
			_width = w * 0.60;	
		}
		if ( w <= Config.LAYOUT1_MAX_WIDTH )
		{
			_width = w * 0.70;	
		}
		
				
		_contentRect = new Rectangle( (w - _width) * 0.5, (h - _height) * 0.5, _width, _height );
		var contentCenter:Float = _contentRect.left + _contentRect.width * 0.5;
		
		SpriteUtils.drawRoundSquare( _background, Std.int(_contentRect.width), Std.int(_contentRect.height), 8, 8, Colors.GREY1 );		
		//2022-evolution
		if ( _btDuplicateVisitOnWorkingPlanning.visible )
			SpriteUtils.drawRoundSquare( _background, Std.int(_contentRect.width), Std.int(_contentRect.height) + padding + 30, 8, 8, Colors.GREY1 );		
			
		
		_background.x = _contentRect.x;
		_background.y = _contentRect.y;
		
		if ( _duplicateOverlay != null )
		{
			var overlayRect = _contentRect.clone();
			overlayRect.y += _duplicateOverlayPosY;
			overlayRect.height -= _duplicateOverlayPosY;
			_duplicateOverlay.setRect( overlayRect );
		}
		
		_contentRect.inflate( -padding, -padding );
		
		_lblNameLabel.x = _contentRect.x;
		_lblNameLabel.y = _contentRect.y;
		_lblNameLabel.width = labelMaxWidth;
		_txtName.x = _contentRect.x + labelMaxWidth;
		_txtName.y = _contentRect.y - 4;
		_txtName.width = _contentRect.width - labelMaxWidth;
		if ( _countryFlag != null )
		{
			_countryFlag.x = _contentRect.right - _countryFlag.width;
			_countryFlag.y = _contentRect.top;
			_txtName.width -= ( _countryFlag.width + padding );
		}
		
		if ( _localizationIcon != null )
		{
			_localizationIcon.x = ( _countryFlag == null ) ? _contentRect.right - _localizationIcon.width : _countryFlag.x - padding - _localizationIcon.width;
			_localizationIcon.y = _contentRect.top;
			_txtName.width -= ( _localizationIcon.width + padding );
		}
		
		if ( _cbSpecialVisit.visible == true )
		{
			_cbSpecialVisit.x = _contentRect.right - _cbSpecialVisit.width;
			_cbSpecialVisit.y = _lblNameLabel.y;
			_txtName.width -= ( _cbSpecialVisit.width + padding );
		}
		
		_clSpecialVisit.x = _txtName.x;
		_clSpecialVisit.y = _lblNameLabel.y;
		_clSpecialVisit.width = _txtName.width;
		
		
		_lblPriorityLabel.x = _contentRect.x;
		_lblPriorityLabel.y = _lblNameLabel.y + _lblNameLabel.height + padding;
		_lblPriority.x = _contentRect.x + labelMaxWidth;
		_lblPriority.y = _lblPriorityLabel.y;
		_btLockVisit.x = _contentRect.right - _btLockVisit.width;
		_btLockVisit.y = _lblPriorityLabel.y;
		
		//var restLocContactPhone:Float = (_contentRect.width - labelMaxWidth - _txtLocation.width - _lblContactLabel.width - _txtContact.width - _lblPhoneLabel.width - _txtPhone.width) * 0.4;
		var restLocContactPhone:Float = (_contentRect.width - labelMaxWidth - _lblContactLabel.width - _lblPhoneLabel.width - padding * 2) / 3;
		_lblLocationLabel.x = _contentRect.x;
		_lblLocationLabel.y = _lblPriority.y + _lblPriority.height + padding;
		_txtLocation.x = _contentRect.x + labelMaxWidth;
		_txtLocation.y = _lblPriority.y + _lblPriority.height + padding - 2;
		_txtLocation.width = restLocContactPhone;
		_lblContactLabel.x = _txtLocation.x + _txtLocation.width + padding;
		_lblContactLabel.y = _lblPriority.y + _lblPriority.height + padding;
		_txtContact.x = _lblContactLabel.x + _lblContactLabel.width;
		_txtContact.y = _lblPriority.y + _lblPriority.height + padding - 2;
		_txtContact.width = restLocContactPhone;
		_lblPhoneLabel.x = _txtContact.x + _txtContact.width + padding;
		_lblPhoneLabel.y = _lblPriority.y + _lblPriority.height + padding;
		_txtPhone.x = _lblPhoneLabel.x + _lblPhoneLabel.width;
		_txtPhone.y = _lblPriority.y + _lblPriority.height + padding - 2;
		_txtPhone.width = restLocContactPhone;
		
		
		_lblStartLabel.x = _contentRect.x;
		_lblStartLabel.y = _lblLocationLabel.y + _lblLocationLabel.height + padding;
		_clStartDay.x = _contentRect.x + labelMaxWidth;
		_clStartDay.y = _lblStartLabel.y;
		_clStartHour.x = _clStartDay.x + _clStartDay.width + padding;
		_clStartHour.y = _lblStartLabel.y;
		_clStartMinute.x = _clStartHour.x + _clStartHour.width + padding;
		_clStartMinute.y = _lblStartLabel.y;
		_lblEndLabel.x = _contentRect.x;
		_lblEndLabel.y = _lblStartLabel.y + _lblStartLabel.height + padding;
		_clEndDay.x = _contentRect.x + labelMaxWidth;
		_clEndDay.y = _lblEndLabel.y;
		_clEndHour.x = _clEndDay.x + _clEndDay.width + padding;
		_clEndHour.y = _lblEndLabel.y;
		_clEndMinute.x = _clEndHour.x + _clEndHour.width + padding;
		_clEndMinute.y = _lblEndLabel.y;
		
		_lblActivitiesLabel.x = _contentRect.x;
		_lblActivitiesLabel.y = _lblEndLabel.y + _lblEndLabel.height + padding;
		
		var cbOffsetX:Float = _contentRect.width - labelMaxWidth;
		if ( _activityIntCheckBoxList.length > _activityExtCheckBoxList.length )
		{
			cbOffsetX /= _activityIntCheckBoxList.length;
		}else{
			cbOffsetX /= _activityExtCheckBoxList.length;
		}
		var cbOffsetY:Float = 30.0;
		var cbPosX:Float = _contentRect.x + labelMaxWidth;
		var cbPosY:Float = _lblActivitiesLabel.y;
		for ( vacb in _activityIntCheckBoxList ) 
		{
			vacb.x = cbPosX;
			vacb.y = cbPosY;
			vacb.width = cbOffsetX;
			cbPosX += cbOffsetX;
			if ( vacb.height > cbOffsetY ) cbOffsetY = vacb.height + 10;
		}
		
		cbPosX = _contentRect.x + labelMaxWidth;
		cbPosY += cbOffsetY;
		for ( vacb in _activityExtCheckBoxList ) 
		{
			vacb.x = cbPosX;
			vacb.y = cbPosY;
			vacb.width = cbOffsetX;
			cbPosX += cbOffsetX;
			if ( vacb.height > cbOffsetY ) cbOffsetY = vacb.height + 10;
		}
		
		var buttonHeight = _btStatusAccept.height;
		var buttonLine1PosY = _contentRect.bottom - buttonHeight * 2 - padding;
		var buttonLine2PosY = _contentRect.bottom - buttonHeight;
		var notesPosY = cbPosY + padding * 2;
		var noteHeight = buttonLine1PosY - (notesPosY + padding);
		
		
		_backgroundNotes.x = _contentRect.left + _btNotes.width - 10;
		_backgroundNotes.y = notesPosY;
		_backgroundNotes.width = _contentRect.width - _btNotes.width + 10;
		_backgroundNotes.height = noteHeight;
		
		_btNotes.x = _contentRect.x;
		_btNotes.y = notesPosY;
		_btNotesProg.x = _contentRect.x;
		_btNotesProg.y = _btNotes.y + _btNotes.height + 10;
		
		_txtNotes.x = _backgroundNotes.x + 10;
		_txtNotes.y = _backgroundNotes.y + 10;
		_txtNotes.width = _backgroundNotes.width - 20;
		_txtNotes.height = noteHeight - 20;
		
		_sbNotes.x = _txtNotes.x + _txtNotes.width;
		_sbNotes.y = _txtNotes.y;
		_sbNotes.update();	
		
		
		
		
		
		
		
		_btGetDemand.x = _contentRect.left;
		_btGetDemand.y = buttonLine1PosY;
		_btStatusCancel.x = contentCenter + padding;
		_btStatusCancel.y = buttonLine1PosY;
		_btStatusAccept.x = contentCenter - padding - _btStatusAccept.width;
		_btStatusAccept.y = buttonLine1PosY;
		_btSaveVisit.x = _contentRect.right - _btSaveVisit.width;
		_btSaveVisit.y = buttonLine1PosY;
		
		_btDeleteVisit.x = _contentRect.left;
		_btDeleteVisit.y = buttonLine2PosY;
		_btClose.x = contentCenter - _btClose.width * 0.5;
		_btClose.y = buttonLine2PosY;
		_btDuplicateVisitForDO.x = _contentRect.right - _btDuplicateVisitForDO.width;
		_btDuplicateVisitForDO.y = buttonLine2PosY;
		
		//2022-evolution
		_btDuplicateVisitOnWorkingPlanning.x = _contentRect.right - _btDuplicateVisitOnWorkingPlanning.width;
		_btDuplicateVisitOnWorkingPlanning.y = buttonLine2PosY + buttonHeight + padding;
    }	
}

