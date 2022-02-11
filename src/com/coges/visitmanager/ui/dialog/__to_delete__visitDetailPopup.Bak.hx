package com.coges.visitmanager.ui.dialog;

import com.coges.visitmanager.fonts.FontName;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.ui.components.VMButton;
import com.coges.visitmanager.vo.Icon;
import com.ibs.ui.popup.IPopup;
import com.ibs.ui.popup.PopupButtonData;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.DialogValue;
import com.coges.visitmanager.core.Locale;
import nbigot.ui.dialog.MessageDialog;
import nbigot.utils.ColorUtils;
import openfl.display.DisplayObject;
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
class VisitDetailPopup extends Sprite implements IPopup
{
    private var _title:String;
    private var _message:String;
    private var _icon:Class<Dynamic>;
    private var _buttons:Array<PopupButtonData>;
    
    public var btValid:VMButton;
    public var btCancel:VMButton;
    public var btSave:VMButton;
    public var btRemove:VMButton;
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
    }
    
    
    private function init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        
        
        var tf1:TextFormat = new TextFormat();
        tf1.size = 14;
        tf1.font = FontName.ARIAL_B_I_BI;
        txtMessage.defaultTextFormat = tf1;
        txtMessage.autoSize = TextFieldAutoSize.LEFT;
        txtMessage.embedFonts = true;
        txtMessage.antiAliasType = AntiAliasType.ADVANCED;
        txtMessage.wordWrap = true;
        txtMessage.text = _message;
        txtMessage.x = background.x + 4;
        txtMessage.width = background.width - 8;
        
        //background.height = txtMessage.height + 20 + btValid.height;
        
        
        background.y = (stage.stageHeight - background.height) / 2;
        txtMessage.y = background.y + 4;
        
        ColorUtils.colorizeGradientV(this, 0xFFFFFF, 0xCCCCCC, background.getRect(this));
        
        // remise au premier plan apres colorisation
        addChild(btValid);
        addChild(btCancel);
        addChild(txtMessage);
        addChild(btRemove);
        addChild(btSave);
        
        
        
        btValid.textFont = FontName.ARIAL_B_I_BI;
        btValid.label = Locale.get("BT_VALID_VISIT_LABEL");
        var iconValid:DisplayObject = Icons.getIconIconD.VALID);
        if (iconValid != null)
        {
            btValid.icon = iconValid;
        }
        btValid.addEventListener(MouseEvent.CLICK, clickValidHandler);
        
        btCancel.textFont = FontName.ARIAL_B_I_BI;
        btCancel.label = Locale.get("BT_CANCEL_VISIT_LABEL");
        var iconCancel:DisplayObject = Icons.getIconIconD.CANCEL);
        if (iconCancel != null)
        {
            btCancel.icon = iconCancel;
        }
        btCancel.addEventListener(MouseEvent.CLICK, clickCancelHandler);
        
        btSave.textFont = FontName.ARIAL_B_I_BI;
        btSave.textBold = true;
        btSave.label = Locale.get("BT_SAVE_VISIT_LABEL");
        btSave.addEventListener(MouseEvent.CLICK, clickValidHandler);
        
        btRemove.textFont = FontName.ARIAL_B_I_BI;
        btRemove.textBold = true;
        btRemove.label = Locale.get("BT_REMOVE_VISIT_LABEL");
        btRemove.addEventListener(MouseEvent.CLICK, clickCancelHandler);
    }
    
    private function clickValidHandler(e:MouseEvent):Void
    {
        //PopupManager.instance.closePopup(DialogValue.OK);
        DialogManager.instance.close(DialogValue.OK);
    }
    
    private function clickCancelHandler(e:MouseEvent):Void
    {
        //PopupManager.instance.openPopup(PopupType.MESSAGE, "", "dfsdfdsdgdfgdfgdf");
        DialogManager.instance.open( new MessageDialog( "", "dfsdfdsdgdfgdfgdf" ) );
    }
    
    
    
    public function update(args:Array<Dynamic> = null):Void
    {
    }
}

