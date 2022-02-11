package com.coges.visitmanager.ui.dialog;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Config;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.ui.components.VMComboList;
import com.coges.visitmanager.vo.ComboListTimeData;
import com.coges.visitmanager.vo.DOAvailablePeriod;
import com.coges.visitmanager.vo.Period;
import nbigot.ui.control.BaseButton;
import nbigot.ui.control.Label;
import nbigot.ui.dialog.BaseDialog;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.DialogSkin;
import nbigot.ui.dialog.DialogValue;
import nbigot.utils.Collection;
import nbigot.utils.SpriteUtils;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
/**
	 * ...
	 * @author Nicolas Bigot
	 */




class EditDOAvailabePeriodDialog extends BaseDialog
{
    private var _title:String;
    private var _data:DOAvailablePeriod;
    private var _message:String;
	private var _background:Sprite;
	private var _titleLine:Sprite;
    private var _btConfirm:BaseButton;
    private var _btCancel:BaseButton;
    
    private var _txtMessage:TextField;
    private var _txtTitle:TextField;
    private var _lblStart:Label;
    private var _lblEnd:Label;
    private var _clStartHour:VMComboList<ComboListTimeData>;
    private var _clStartMinute:VMComboList<ComboListTimeData>;
    private var _clEndHour:VMComboList<ComboListTimeData>;
    private var _clEndMinute:VMComboList<ComboListTimeData>;
    private var _icon:DisplayObject;
    
    
    public function new( title:String, message:String, period:DOAvailablePeriod, ?icon:DisplayObject )
    {
        super();
		
		_data = period;
		_message = message;
		_title = title;
		_icon = icon;
    }
	
    override public function init( skin:DialogSkin):Void
    {
		_skin = skin;
		
		_background = new Sprite();
		addChild( _background );
		
		
		_txtMessage = new TextField();
		_txtMessage.embedFonts = true;
        _txtMessage.antiAliasType = AntiAliasType.ADVANCED;
        _txtMessage.autoSize = TextFieldAutoSize.LEFT;
		_txtMessage.multiline = true;
		_txtMessage.wordWrap = true;
		_txtMessage.defaultTextFormat = _skin.contentFormat;
		_txtMessage.htmlText = _message;		
		addChild( _txtMessage );
		
		
		
		_txtTitle = new TextField();
		_txtTitle.embedFonts = true;
        _txtTitle.antiAliasType = AntiAliasType.ADVANCED;
        _txtTitle.autoSize = TextFieldAutoSize.LEFT;
		_txtTitle.multiline = true;
		//_txtTitle.wordWrap = true;
		//_txtTitle.border = true;
		_txtTitle.defaultTextFormat = _skin.titleFormat;
		_txtTitle.htmlText = _title;		
		addChild( _txtTitle );
		
		_titleLine = new Sprite();
		addChild( _titleLine );
		
		if ( _icon != null )
			addChild( _icon );
		
        
        _btCancel = new BaseButton( _skin.cancelButtonLabel, _skin.cancelButtonFormat, SpriteUtils.createRoundSquare( 140, 30, 6, 6, Colors.RED2 ));
		_btCancel.borderEnabled = false;
		_btCancel.setIcon( Icons.getIcon(Icon.CANCEL), new Point( 50, 30) );
        _btCancel.addEventListener(MouseEvent.CLICK, _clickCancelHandler);
		addChild( _btCancel );
		
        
        _btConfirm = new BaseButton( _skin.confirmButtonLabel, _skin.confirmButtonFormat, SpriteUtils.createRoundSquare( 140, 30, 6, 6, Colors.GREEN2 ));
		_btConfirm.setIcon( Icons.getIcon(Icon.VALID), new Point( 50, 30) );
		_btConfirm.borderEnabled = false;
        _btConfirm.addEventListener(MouseEvent.CLICK, _clickConfirmHandler);
		addChild( _btConfirm );
		
		var tf:TextFormat = new TextFormat( Fonts.OPEN_SANS, 14, Colors.GREY4, true );
		_lblStart = new Label( Locale.get("VISIT_DETAIL_LABEL_START"), tf );
		addChild( _lblStart );
		_lblEnd = new Label( Locale.get("VISIT_DETAIL_LABEL_END"), tf );
		addChild( _lblEnd );
		
		_clStartHour = new VMComboList<ComboListTimeData>( null );
        _clStartHour.addEventListener(Event.SELECT, _selectStartHourHandler);
		_clStartHour.width = 80;
		addChild( _clStartHour );
		_clEndHour = new VMComboList<ComboListTimeData>( null );
        _clEndHour.addEventListener(Event.SELECT, _selectEndHourHandler);
		_clEndHour.width = 80;
		addChild( _clEndHour );
		_clStartMinute = new VMComboList<ComboListTimeData>( null );
        _clStartMinute.addEventListener(Event.SELECT, _selectStartMinuteHandler);
		_clStartMinute.width = 80;
		addChild( _clStartMinute );
		_clEndMinute = new VMComboList<ComboListTimeData>( null );
        _clEndMinute.addEventListener(Event.SELECT, _selectEndMinuteHandler);
		_clEndMinute.width = 80;
		addChild( _clEndMinute );
		
		
		_initComboListDatas();
		
        _applyDatesToComboList(_data.period.startDate, _data.period.endDate);
    }
	
	function _initComboListDatas() 
	{		
        var hourTimeValue:Float = 60 * 60 * 1000;
        var dHour:Collection<ComboListTimeData> = new Collection<ComboListTimeData>();
        var o:ComboListTimeData;
		var max:Int = Config.INIT_SLOT_END.getHours() - Config.INIT_SLOT_START.getHours() + 1;
		for ( i in 0...max )
        //while (++i < Config.INIT_SLOT_END.getHours() - Config.INIT_SLOT_START.getHours() + 1)
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
        //while (++i < 60 * minuteTimeValue / Config.INIT_SLOT_LENGTH_TIME)
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
	
	
    override public function draw( parentSize:Point ) : Void
    {
		_parentSize = parentSize;		
		
		var marg = _skin.contentMargin;
		var dialogWidth:Float = _parentSize.x * 0.30;
		var dialogHeight:Float = 100;	
		var contentRect:Rectangle = new Rectangle( (parentSize.x - dialogWidth) * 0.5 + marg, (parentSize.y - dialogHeight) * 0.5 + marg, dialogWidth - marg * 2, dialogHeight - marg * 2 );
		
		_txtMessage.width = contentRect.width;
		var titleMaxWidth:Float = ( _icon != null ) ? contentRect.width - _icon.width - marg * 0.5  : contentRect.width;
        _txtTitle.autoSize = TextFieldAutoSize.LEFT;
		_txtTitle.wordWrap = false;
		if ( _txtTitle.width > titleMaxWidth )
		{
			_txtTitle.wordWrap = true;	
			_txtTitle.width = titleMaxWidth;
		}
		
		SpriteUtils.drawSquare( _titleLine, Std.int(contentRect.width), 1, _skin.titleBackgroundColor );		
		
		// Set the height resulting of all resized elements
		var dialogHeight:Float = _txtTitle.height + _titleLine.height + _txtMessage.height + _clStartHour.height + _clEndHour.height + _btCancel.height + _skin.contentMargin * 7.5;
		// Change contentRect accordingly
		contentRect.height = dialogHeight - marg * 2;
		contentRect.y = (parentSize.y - dialogHeight) * 0.5 + marg;
		
		SpriteUtils.drawRoundSquare( _background, Std.int(dialogWidth), Std.int(dialogHeight), 8, 8, _skin.contentBackgroundColor );
		_background.x = (parentSize.x - dialogWidth) * 0.5;
		_background.y = (parentSize.y - dialogHeight) * 0.5;
		
		_txtTitle.y = contentRect.top;
		if ( _icon != null )
		{
			_icon.x = contentRect.left + ( contentRect.width - _icon.width - marg * 0.5 - _txtTitle.width ) * 0.5;
			_icon.y = _txtTitle.y + 4;
			_txtTitle.x = _icon.x + _icon.width + marg * 0.5;
		}else{			
			_txtTitle.x = contentRect.left + ( contentRect.width - _txtTitle.width ) * 0.5;
		}
		
		_titleLine.x  = contentRect.left;
		_titleLine.y  = _txtTitle.y + _txtTitle.height + marg * 0.5;
		
		_txtMessage.x = contentRect.left;
		_txtMessage.y = _titleLine.y + _titleLine.height + marg;	
		
		
		var w = ( _lblStart.width >= _lblEnd.width ) ? _lblStart.width : _lblEnd.width;
		w += _clStartHour.width + _clStartMinute.width + marg * 2;
		var middle  = contentRect.left  + contentRect.width * 0.5;
		
		_lblStart.x = middle - w * 0.5;
		_clStartMinute.x = middle + w * 0.5 - _clStartMinute.width;
		_clStartHour.x = _clStartMinute.x - marg - _clStartHour.width;
		_lblStart.y = _clStartHour.y = _clStartMinute.y = _txtMessage.y + _txtMessage.height + marg;
		
		_lblEnd.x = middle - w * 0.5;
		_clEndMinute.x = middle + w * 0.5 - _clEndMinute.width;
		_clEndHour.x = _clEndMinute.x - marg - _clEndHour.width;
		_lblEnd.y = _clEndHour.y = _clEndMinute.y = _clStartHour.y + _clStartHour.height + marg;	
		
		_btCancel.x = contentRect.left;
		_btCancel.y = contentRect.bottom - _btCancel.height;
		_btConfirm.x = contentRect.right - _btConfirm.width;
		_btConfirm.y = contentRect.bottom - _btConfirm.height;
		
	}
	
	
	
    
    private function _selectStartHourHandler(e:Event):Void
    {
        _checkDate(true);
    }
    private function _selectEndHourHandler(e:Event):Void
    {
        _checkDate(false);
    }
    private function _selectStartMinuteHandler(e:Event):Void
    {
        _checkDate(true);
    }
    private function _selectEndMinuteHandler(e:Event):Void
    {
        _checkDate(false);
    }
    
    private function _checkDate(isFromStart:Bool):Void
    {
        var day:Date = Date.now();
        var newStartDate:Date = new Date(
							day.getFullYear(), 
							day.getMonth(), 
							day.getDate(), 
							(_clStartHour.selectedData:ComboListTimeData).data.getHours(), 
							(_clStartMinute.selectedData:ComboListTimeData).data.getMinutes(),
							0
							);
        var newEndDate:Date = new Date(
							day.getFullYear(), 
							day.getMonth(), 
							day.getDate(), 
							(_clEndHour.selectedData:ComboListTimeData).data.getHours(), 
							(_clEndMinute.selectedData:ComboListTimeData).data.getMinutes(),
							0
							);
        
        var dayStartDate:Date = new Date(
							day.getFullYear(), 
							day.getMonth(), 
							day.getDate(), 
							Config.INIT_SLOT_START.getHours(), 
							Config.INIT_SLOT_START.getMinutes(), 
							Config.INIT_SLOT_START.getSeconds()
							);
        
        var dayEndDate:Date = new Date(
							day.getFullYear(), 
							day.getMonth(), 
							day.getDate(), 
							Config.INIT_SLOT_END.getHours(), 
							Config.INIT_SLOT_END.getMinutes(), 
							Config.INIT_SLOT_END.getSeconds()
							);
        
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
    private function _applyDatesToComboList(startDate:Date, endDate:Date):Void
    {
        if (startDate.getTime() == endDate.getTime())
        {
			// création d'une plage de présence du début de journée et our une longueur de 4h.            
            startDate = Date.fromTime(Config.INIT_SLOT_START.getTime());
            endDate = Date.fromTime(Config.INIT_SLOT_END.getTime());
        }
        
        var i:Int = -1;
        var clDate:Date;
        
        // hours
        i = -1;
        while (++i < _clStartHour.datas.length)
        {
            clDate = (_clStartHour.datas.getItemAt(i):ComboListTimeData).data;
            if (clDate.getHours() == startDate.getHours())
            {
                _clStartHour.selectedIndex = i;
                break;
            }
        }
        i = -1;
        while (++i < _clEndHour.datas.length)
        {
            clDate = (_clEndHour.datas.getItemAt(i):ComboListTimeData).data;
            if (clDate.getHours() == endDate.getHours())
            {
                _clEndHour.selectedIndex = i;
                break;
            }
        }
        
        // minutes
        i = -1;
        while (++i < _clStartMinute.datas.length)
        {
            clDate = (_clStartMinute.datas.getItemAt(i):ComboListTimeData).data;
            if (clDate.getMinutes() == startDate.getMinutes())
            {
                _clStartMinute.selectedIndex = i;
                break;
            }
        }
        i = -1;
        while (++i < _clEndMinute.datas.length)
        {
            clDate = (_clEndMinute.datas.getItemAt(i):ComboListTimeData).data;
            if (clDate.getMinutes() == endDate.getMinutes())
            {
                _clEndMinute.selectedIndex = i;
                break;
            }
        }
    }
    
    
    private function _clickConfirmHandler(e:MouseEvent):Void
    {
        var newStartDate:Date = new Date(
						_data.startDate.getFullYear(), 
						_data.startDate.getMonth(), 
						_data.startDate.getDate(), 
						_clStartHour.selectedData.data.getHours(), 
						_clStartMinute.selectedData.data.getMinutes(),
						0
						);
        
        var newEndDate:Date = new Date(
						_data.startDate.getFullYear(), 						
						_data.startDate.getMonth(), 
						_data.startDate.getDate(), 
						_clEndHour.selectedData.data.getHours(), 
						_clEndMinute.selectedData.data.getMinutes(),
						0
						);
        
        		
		DialogManager.instance.close( DialogValue.DATA( new Period(newStartDate, newEndDate)));
    }
    
    private function _clickCancelHandler(e:MouseEvent):Void
    {
        DialogManager.instance.close(DialogValue.CANCEL);
    }
    
    
    
    public function update(args:Array<Dynamic> = null):Void
    {
    }
}