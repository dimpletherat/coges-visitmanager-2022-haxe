package com.coges.visitmanager.ui.dialog;

import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.fonts.FontName;
import com.coges.visitmanager.vo.DO;
import com.coges.visitmanager.vo.Icon;
import nbigot.ui.control.ScrollBar;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.DialogValue;
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
class AddDONotesPopup extends Sprite
{
    private var _title:String;
    private var _message:String;
    private var _icon:Class<Dynamic>;
    private var _isHTML:Bool;
    
    public var btValid:VMButton;
    public var btCancel:VMButton;
    public var txtMessage:TextField;
    public var background:Sprite;
    public var txtNotes:TextField;
    public var sbNotes:Scrollbar;
    
    
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
        txtMessage.y = background.y + 4;
        txtMessage.width = background.width - 8;
        
        
        // colorisation, remise au dernier plan et suppression du Background de reference
        //var gradient:Shape = Colorizer.colorizeGradient(this, 0xFFFFFF, 0xCCCCCC, background.getRect(this));
        var gradient:Shape = new Shape();
		ColorUtils.colorizeGradientV(gradient, 0xFFFFFF, 0xCCCCCC, background.getRect(this));
		/*var r:Rectangle = background.getRect(this);
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
        
        
        
        txtNotes.addEventListener(Event.CHANGE, _txtNotesChangeHandler);
        sbNotes.target = txtNotes;
        
        txtNotes.text = DO.selected.notes;
        _updateNotesScrollBar();
    }
    private function _txtNotesChangeHandler(e:Event):Void
    {
        _updateNotesScrollBar(true);
    }
    
    private function _updateNotesScrollBar(showAlwaysLastLine:Bool = false):Void
    {
        sbNotes.visible = (txtNotes.maxScrollV > 1);
        if (showAlwaysLastLine)
        {
            txtNotes.scrollV = txtNotes.maxScrollV;
        }
        else
        {
            txtNotes.scrollV = 1;
        }
        sbNotes.updatePosition(true);
    }
    
    
    private function clickValidHandler(e:MouseEvent):Void
    {
        //PopupManager.instance.closePopup(txtNotes.text);
        DialogManager.instance.close(DialogValue.DATA(txtNotes.text));
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

