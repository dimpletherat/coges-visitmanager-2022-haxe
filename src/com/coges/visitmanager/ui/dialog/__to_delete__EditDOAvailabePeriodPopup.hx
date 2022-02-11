package com.coges.visitmanager.ui.dialog;

import com.coges.visitmanager.core.Config;
import com.coges.visitmanager.fonts.FontName;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.ui.components.VMButton;
import com.coges.visitmanager.ui.components.ComboListVM;
import com.coges.visitmanager.vo.DOAvailablePeriod;
import com.coges.visitmanager.vo.Icon;
import com.coges.visitmanager.vo.Period;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.DialogValue;
import nbigot.utils.Collection;
import com.coges.visitmanager.core.Locale;
import nbigot.utils.ColorUtils;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class EditDOAvailabePeriodPopup extends Sprite
{
    private var _data:DOAvailablePeriod;
    private var _title:String;
    private var _message:String;
    private var _icon:Class<Dynamic>;
    private var _isHTML:Bool;
    
    public var btValid:VMButton;
    public var btCancel:VMButton;
    public var txtMessage:TextField;
    public var txtLabelStart:TextField;
    public var txtLabelEnd:TextField;
    public var clStartHour:ComboListVM;
    public var clStartMinute:ComboListVM;
    public var clEndHour:ComboListVM;
    public var clEndMinute:ComboListVM;
    public var background:Sprite;
    public var emailListBackground:Sprite;
    
    
    public function new()
    {
        super();
        addEventListener(Event.ADDED_TO_STAGE, init);
    }
    
    public function initialize(title:String = "", message:String = "", icon:Class<Dynamic> = null, args:Array<Dynamic> = null):Void
    {
        _icon = icon;
        _message = message;
        _title = title;
        _isHTML = (args[0][1] == "true");
        _data = args[0][0];
    }
    
    
    private function init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        
        
        var tf1:TextFormat = new TextFormat();
        tf1.size = 14;
        tf1.font = FontName.ARIAL_B_I_BI;
        txtMessage.autoSize = TextFieldAutoSize.LEFT;
        txtMessage.embedFonts = true;
        txtMessage.antiAliasType = AntiAliasType.ADVANCED;
        txtMessage.wordWrap = true;
        txtMessage.multiline = true;
        
        if (_isHTML)
        {
            txtMessage.htmlText = _message;
            txtMessage.setTextFormat(tf1);
        }
        else
        {
            txtMessage.defaultTextFormat = tf1;
            txtMessage.text = _message;
        }
        
        txtMessage.x = background.x + 4;
        txtMessage.width = background.width - 8;
        
        background.height = txtMessage.height + 20 + btValid.height + 160;
        
        txtMessage.y = background.y + 4;
        
        // colorisation, remise au dernier plan et suppression du Background de reference
        //var gradient:Shape = Colorizer.colorizeGradient(this, 0xFFFFFF, 0xCCCCCC, background.getRect(this));
        var gradient:Shape = new Shape();
		ColorUtils.colorizeGradientV(gradient, 0xFFFFFF, 0xCCCCCC, background.getRect(this));
        addChildAt(gradient, 0);
        background.visible = false;
        
        
        btValid.textFont = FontName.ARIAL_B_I_BI;
        btValid.textBold = true;
        btValid.label = Locale.get("BT_VALID_LABEL");
        var iconValid:DisplayObject = Icons.getIcon(Icon.VALID);
        if (iconValid != null)
        {
            btValid.icon = iconValid;
        }
        btValid.x = background.x + background.width - btValid.width - 8;
        btValid.y = background.y + background.height - btValid.height - 4;
        btValid.addEventListener(MouseEvent.CLICK, clickValidHandler);
        
        btCancel.textFont = FontName.ARIAL_B_I_BI;
        btCancel.textBold = true;
        btCancel.label = Locale.get("BT_CANCEL_LABEL");
        var iconCancel:DisplayObject = Icons.getIcon(Icon.CANCEL);
        if (iconCancel != null)
        {
            btCancel.icon = iconCancel;
        }
        btCancel.x = background.x + 8;
        btCancel.y = background.y + background.height - btCancel.height - 4;
        btCancel.addEventListener(MouseEvent.CLICK, clickCancelHandler);
        
        txtLabelStart.text = Locale.get("VISIT_DETAIL_LABEL_START");
        txtLabelEnd.text = Locale.get("VISIT_DETAIL_LABEL_END");
        
        clStartHour.addEventListener(Event.SELECT, _selectStartHourHandler);
        clEndHour.addEventListener(Event.SELECT, _selectEndHourHandler);
        clStartMinute.addEventListener(Event.SELECT, _selectStartMinuteHandler);
        clEndMinute.addEventListener(Event.SELECT, _selectEndMinuteHandler);
        
        _displayCLdatas();
    }
    
    private function _displayCLdatas():Void
    {
        var hourTimeValue:Float = 60 * 60 * 1000;
        var dHour:Collection = new Collection();
        var i:Int = -1;
        var o:ComboListTimeData;
        while (++i < Config.INIT_SLOT_END.getHours() - Config.INIT_SLOT_START.getHours() + 1)
        {
            o = {
				label : (Config.INIT_SLOT_START.getHours() + i) + " h",
				data : Date.fromTime(Config.INIT_SLOT_START.getTime() + i * hourTimeValue)
			};
            dHour.addItem(o);
        }
        clEndHour.datas = dHour;
        clStartHour.datas = dHour;
        
        var minuteTimeValue:Float = 60 * 1000;
        var dMinute:Collection = new Collection();
        i = -1;
        while (++i < 60 * minuteTimeValue / Config.INIT_SLOT_LENGTH_TIME)
        {
            o = {
				label : (Config.INIT_SLOT_START.getMinutes() + i * Config.INIT_SLOT_LENGTH_TIME / 60 / 1000) + " min",
				data : Date.fromTime(Config.INIT_SLOT_START.getTime() + i * Config.INIT_SLOT_LENGTH_TIME)
			};
            
            dMinute.addItem(o);
        }
        clEndMinute.datas = dMinute;
        clStartMinute.datas = dMinute;
        
        _applyDatesToComboList(_data.period.startDate, _data.period.endDate);
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
							(clStartHour.selectedData:ComboListTimeData).data.getHours(), 
							(clStartMinute.selectedData:ComboListTimeData).data.getMinutes(),
							0
							);
        var newEndDate:Date = new Date(
							day.getFullYear(), 
							day.getMonth(), 
							day.getDate(), 
							(clEndHour.selectedData:ComboListTimeData).data.getHours(), 
							(clEndMinute.selectedData:ComboListTimeData).data.getMinutes(),
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
        while (++i < clStartHour.datas.length)
        {
            clDate = (clStartHour.datas.getItemAt(i):ComboListTimeData).data;
            if (clDate.getHours() == startDate.getHours())
            {
                clStartHour.selectedIndex = i;
                break;
            }
        }
        i = -1;
        while (++i < clEndHour.datas.length)
        {
            clDate = (clEndHour.datas.getItemAt(i):ComboListTimeData).data;
            if (clDate.getHours() == endDate.getHours())
            {
                clEndHour.selectedIndex = i;
                break;
            }
        }
        
        // minutes
        i = -1;
        while (++i < clStartMinute.datas.length)
        {
            clDate = (clStartMinute.datas.getItemAt(i):ComboListTimeData).data;
            if (clDate.getMinutes() == startDate.getMinutes())
            {
                clStartMinute.selectedIndex = i;
                break;
            }
        }
        i = -1;
        while (++i < clEndMinute.datas.length)
        {
            clDate = (clEndMinute.datas.getItemAt(i):ComboListTimeData).data;
            if (clDate.getMinutes() == endDate.getMinutes())
            {
                clEndMinute.selectedIndex = i;
                break;
            }
        }
    }
    
    
    private function clickValidHandler(e:MouseEvent):Void
    {
        var newStartDate:Date = new Date(
						_data.startDate.getFullYear(), 
						_data.startDate.getMonth(), 
						_data.startDate.getDate(), 
						clStartHour.selectedData.data.hours, 
						clStartMinute.selectedData.data.minutes,
						0
						);
        
        var newEndDate:Date = new Date(
						_data.startDate.getFullYear(), 						
						_data.startDate.getMonth(), 
						_data.startDate.getDate(), 
						clEndHour.selectedData.data.hours, 
						clEndMinute.selectedData.data.minutes,
						0
						);
        
        
        //PopupManager.instance.closePopup({                start:newStartDate,                    end:newEndDate                });
		
		DialogManager.instance.close( DialogValue.DATA( new Period(newStartDate, newEndDate)));
    }
    
    private function clickCancelHandler(e:MouseEvent):Void
    {
        //PopupManager.instance.closePopup(DialogValue.CANCEL);
        DialogManager.instance.close(DialogValue.CANCEL);
    }
    
    
    
    public function update(args:Array<Dynamic> = null):Void
    {
    }
}

typedef ComboListTimeData = { label:String, data:Date }