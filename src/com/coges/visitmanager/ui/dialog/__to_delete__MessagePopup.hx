package com.coges.visitmanager.ui.dialog;

import com.coges.visitmanager.fonts.FontName;
import com.coges.visitmanager.ui.components.VMButton;
import nbigot.ui.control.ScrollBar;
import com.ibs.ui.popup.IPopup;
import com.ibs.ui.popup.PopupButtonData;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.DialogValue;
import com.ibs.Utils;
import com.coges.visitmanager.core.Locale;
import nbigot.utils.ColorUtils;
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
class MessagePopup extends Sprite implements IPopup
{
    private var _title:String;
    private var _message:String;
    private var _icon:Class<Dynamic>;
    private var _buttons:Array<PopupButtonData>;
    private var _isHTML:Bool;
    
    public var btClose:VMButton;
    public var txtMessage:TextField;
    public var background:Sprite;
    
    public function new()
    {
        super();
        addEventListener(Event.ADDED_TO_STAGE, init);
    }
    public function initialize(title:String = "", message:String = "", icon:Class<Dynamic> = null, buttons:Array<PopupButtonData> = null, args:Array<Dynamic> = null):Void
    {
        _buttons = buttons;
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
        //txtMessage.embedFonts = true;
        //txtMessage.antiAliasType = AntiAliasType.ADVANCED;
        //txtMessage.autoSize = TextFieldAutoSize.LEFT;
        txtMessage.wordWrap = true;
        txtMessage.multiline = true;
        
        
        var messageArr:Array<Dynamic> = _message.split("{SCROLLLIST}");
        
        
        if (_isHTML)
        {
            Utils.initTextField(txtMessage, TextFieldAutoSize.LEFT, tf1, "html", true, true);
            txtMessage.htmlText = "<html>" + _message + "</html>";
        }
        else
        {
            Utils.initTextField(txtMessage, TextFieldAutoSize.LEFT, tf1, "", true, true);
            txtMessage.text = _message;
        }
        txtMessage.x = background.x + 4;
        txtMessage.width = background.width - 8;
        
        
        // test if ScrollBar is needed
        var sb:ScrollBar;
        if (txtMessage.height > 240)
        {
            txtMessage.width -= 20;
            txtMessage.autoSize = TextFieldAutoSize.NONE;
            //txtMessageScroll.wordWrap = false;
            txtMessage.height = 240;
            txtMessage.borderColor = 0xAAAAAA;
            txtMessage.border = true;
            sb = new ScrollBar(txtMessage);
            addChild(sb);
            sb.x = txtMessage.x + txtMessage.width + 20 - sb.width;
        }
        else
        {
            txtMessage.autoSize = TextFieldAutoSize.NONE;
            txtMessage.height += 20;
        }
        
        
        background.height = txtMessage.height + 20 + btClose.height;
        
        
        background.y = (stage.stageHeight - background.height) / 2;
        txtMessage.y = background.y + 4;
        if (sb != null)
        {
            sb.y = txtMessage.y;
        }
        
        // colorisation, remise au dernier plan et suppression du Background de reference
        //var gradient:Shape = Colorizer.colorizeGradient(this, 0xFFFFFF, 0xCCCCCC, background.getRect(this));
        var gradient:Shape = new Shape();
		ColorUtils.colorizeGradientV(gradient, 0xFFFFFF, 0xCCCCCC, background.getRect(this));
        addChildAt(gradient, 0);
        background.visible = false;
        
        btClose.textFont = FontName.ARIAL_B_I_BI;
        btClose.textBold = true;
        btClose.label = Locale.get("BT_CLOSE_LABEL");
        btClose.x = background.x + (background.width - btClose.width) / 2;
        btClose.y = background.y + background.height - btClose.height - 4;
        btClose.addEventListener(MouseEvent.CLICK, clickCloseHandler);
    }
    
    private function clickCloseHandler(e:MouseEvent):Void
    {
        //PopupManager.instance.closePopup(DialogValue.OK);
        DialogManager.instance.closePopup(DialogValue.OK);
    }
    
    
    public function update(args:Array<Dynamic> = null):Void
    {
    }
}

