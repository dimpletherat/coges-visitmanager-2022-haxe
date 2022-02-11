package com.coges.visitmanager.ui.dialog;

import com.coges.visitmanager.core.VisitSaveHelper;
import com.coges.visitmanager.fonts.FontName;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.ui.components.VMButton;
import com.coges.visitmanager.vo.Icon;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.DialogValue;
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
class ConfirmVisitSeriePopup extends Sprite
{
    private var _title:String;
    private var _message:String;
    private var _icon:Class<Dynamic>;
    private var _isHTML:Bool;
    
    public var btValidSingle:VMButton;
    public var btValidAll:VMButton;
    public var btCance:VMButton;
    public var txtMessage:TextField;
    public var background:Sprite;
    
    
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
        
        background.height = txtMessage.height + 20 + btValidAll.height;
        
        
        background.y = (stage.stageHeight - background.height) / 2;
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
        
        
        
        btValidAll.textFont = FontName.ARIAL_B_I_BI;
        btValidAll.textBold = true;
        btValidAll.label = Locale.get("BT_VALID_SERIE_ALL_LABEL");
        var iconValidAll:DisplayObject = Icons.getIcon(Icon.VALID);
        if (iconValidAll != null)
        {
            btValidAll.icon = iconValidAll;
        }
        btValidAll.x = background.x + background.width - btValidAll.width - 8;
        btValidAll.y = background.y + background.height - btValidAll.height - 4;
        btValidAll.addEventListener(MouseEvent.CLICK, clickValidAllHandler);
        
        btValidSingle.textFont = FontName.ARIAL_B_I_BI;
        btValidSingle.textBold = true;
        btValidSingle.label = Locale.get("BT_VALID_SERIE_SINGLE_LABEL");
        var iconValidSingle:DisplayObject = Icons.getIcon(Icon.VALID);
        if (iconValidSingle != null)
        {
            btValidSingle.icon = iconValidSingle;
        }
        btValidSingle.x = btValidAll.x - btValidSingle.width - 8;
        btValidSingle.y = background.y + background.height - btValidSingle.height - 4;
        btValidSingle.addEventListener(MouseEvent.CLICK, clickValidSingleHandler);
        
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
    }
    
    private function clickValidSingleHandler(e:MouseEvent):Void
    {
        //PopupManager.instance.closePopup(VisitSaveHelper.SERIE_PROCESS_SINGLE);
        DialogManager.instance.close(DialogValue.DATA(VisitSaveHelper.SERIE_PROCESS_SINGLE));
    }
    
    private function clickValidAllHandler(e:MouseEvent):Void
    {
        //PopupManager.instance.closePopup(VisitSaveHelper.SERIE_PROCESS_ALL);
        DialogManager.instance.close(DialogValue.DATA(VisitSaveHelper.SERIE_PROCESS_ALL));
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

