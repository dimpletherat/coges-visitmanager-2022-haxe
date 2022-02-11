package com.coges.visitmanager.ui.dialog;

import com.coges.visitmanager.fonts.FontName;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.ui.components.VMButton;
import com.coges.visitmanager.ui.components.TextInputEmail;
import com.coges.visitmanager.ui.components.ScrollList;
import com.coges.visitmanager.ui.components.ScrollListItemEmail;
import com.coges.visitmanager.ui.components.ScrollItemResult;
import com.coges.visitmanager.vo.Icon;
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
import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ExportExcelPopup extends Sprite
{
    private var _txtEmail:TextInputEmail;
    private var _emailList:Collection;
    private var _emailScrollList:ScrollList;
    private var _btAddEmailVMButtonn;
    private var _title:String;
    private var _message:String;
    private var _icon:Class<Dynamic>;
    private var _isHTML:Bool;
    
    public var btValidVMButtonn;
    public var btCancelVMButtonn;
    public var txtMessage:TextField;
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
        _isHTML = (args[0] == "true");
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
		/*
		var r:Rectangle = background.getRect(this);
        var gradient:Shape = new Shape();
		gradient.graphics.beginFill(0xCCCCCC);
		gradient.graphics.drawRect( r.x, r.y, r.width, r.height );
		gradient.graphics.endFill();*/
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
        
        _txtEmail = new TextInputEmail();
        _txtEmail.x = 357;
        _txtEmail.y = 260;
        addChild(_txtEmail);
        
        
        _btAddEmail = new ButtonCancel();
        _btAddEmail.x = 624;
        _btAddEmail.y = 260;
        addChild(_btAddEmail);
        var icoAddEmail:DisplayObject = Icons.getIcon(Icon.PLUS);
        if (icoAddEmail != null)
        {
            _btAddEmail.icon = icoAddEmail;
            _btAddEmail.centerIcon();
        }
        _btAddEmail.addEventListener(MouseEvent.CLICK, clickAddEmailHandler);
        
        _emailList = new Collection();
    }
    private function _displayEmailList():Void
    {
        if (_emailScrollList != null)
        {
            removeChild(_emailScrollList);
        }
        
        _emailScrollList = new ScrollList(_emailList, 302, 122, "labelField", ScrollListItemEmail);
        _emailScrollList.x = 357;
        _emailScrollList.y = 290;
        _emailScrollList.addEventListener(Event.SELECT, _selectListItemHandler);
        addChild(_emailScrollList);
    }
    
    private function _selectListItemHandler(e:Event):Void
    {
        var selectedEmail:String = _emailScrollList.selectedData;
        _emailList.removeItem(selectedEmail);
        _displayEmailList();
    }
    
    private function clickAddEmailHandler(e:MouseEvent):Void
    {
        if (_txtEmail.text.length > 0)
        {
            _emailList.addItem(_txtEmail.text);
            _displayEmailList();
            _txtEmail.clear();
        }
    }
    
    private function clickValidHandler(e:MouseEvent):Void
    {
        //PopupManager.instance.closePopup(_emailList);
        DialogManager.instance.close( DialogValue.DATA(_emailList));
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

