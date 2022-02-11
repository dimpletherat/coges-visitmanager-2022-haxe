package com.coges.visitmanager.ui.dialog;

import com.coges.visitmanager.core.Debug;
import com.coges.visitmanager.fonts.FontName;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.ui.components.VMButton;
import com.coges.visitmanager.vo.Icon;
import nbigot.ui.control.ScrollBar;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.DialogValue;
import com.coges.visitmanager.core.Locale;
import nbigot.utils.ColorUtils;
import nbigot.utils.TextFieldUtils;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.TextEvent;
import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ConfirmWithScrollPopup extends Sprite
{
    private var _title:String;
    private var _message:String;
    private var _icon:Class<Dynamic>;
    private var _isHTML:Bool;
    
    public var btValid:VMButton;
    public var btCancel:VMButton;
    public var txtMessage1:TextField;
    public var txtMessageScroll:TextField;
    public var txtMessage2:TextField;
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
        /*
			txtMessage1.embedFonts = txtMessage2.embedFonts = txtMessageScroll.embedFonts = true;
			txtMessage1.antiAliasType = txtMessage2.antiAliasType = txtMessageScroll.antiAliasType = AntiAliasType.ADVANCED;
			txtMessage1.autoSize = txtMessage2.autoSize = txtMessageScroll.autoSize = TextFieldAutoSize.LEFT;
			txtMessage1.wordWrap = txtMessage2.wordWrap = txtMessageScroll.wordWrap = true;
			txtMessage1.multiline = txtMessage2.multiline = txtMessageScroll.multiline = true;
			*/
        /*
			txtMessage1.embedFonts = txtMessageScroll.embedFonts = true;
			txtMessage1.antiAliasType = txtMessageScroll.antiAliasType = AntiAliasType.ADVANCED;
			txtMessage1.autoSize = txtMessageScroll.autoSize = TextFieldAutoSize.LEFT;*/
        txtMessage1.wordWrap = txtMessage2.wordWrap = txtMessageScroll.wordWrap = true;
        txtMessage1.multiline = txtMessage2.multiline = txtMessageScroll.multiline = true;
        
        
        //txtMessage1.border = txtMessage2.border = txtMessageScroll.border = true;
        
        var messageArr:Array<Dynamic> = _message.split("{SCROLLLIST}");
        var message1:String = "";
        var messageScroll:String = "";
        var message2:String = "";
        
        message1 = messageArr[0];
        if (messageArr.length > 1)
        {
            messageScroll = messageArr[1];
        }
        if (messageArr.length > 2)
        {
            message2 = messageArr[2];
        }
        /*trace( "message1:" + message1 );
			trace( "messageScroll:" + messageScroll );
			trace( "message2:" + message2 );*/
        
        if (_isHTML)
        {
            //Utils.initTextField(txtMessage1, TextFieldAutoSize.LEFT, tf1, "html", true, true);
			TextFieldUtils.init(txtMessage1, TextFieldAutoSize.LEFT, tf1, "html", true, true );
            txtMessage1.htmlText = "<html>" + message1 + "</html>";
            //Utils.initTextField(txtMessageScroll, TextFieldAutoSize.LEFT, tf1, "html", true, true);
			TextFieldUtils.init(txtMessageScroll, TextFieldAutoSize.LEFT, tf1, "html", true, true );
            txtMessageScroll.htmlText = "<html>" + messageScroll + "</html>";
            //Utils.initTextField(txtMessage2, TextFieldAutoSize.LEFT, tf1, "html", true, true);
			TextFieldUtils.init(txtMessage2, TextFieldAutoSize.LEFT, tf1, "html", true, true );
            
            // set style for links
			//TODO: find a way in haxe
            /*txtMessage2.styleSheet.setStyle("a", {
                        textDecoration:"underline",
                        color:"#000099"
                    });*/
					
					
            //txtMessage2.styleSheet.setStyle("a:hover", {textDecoration:"none", color:"#000000"});
            
            txtMessage2.htmlText = "<html>" + message2 + "</html>";
            txtMessage2.addEventListener(TextEvent.LINK, _textEventLinkHandler);
        }
        else
        {
            //Utils.initTextField(txtMessage1, TextFieldAutoSize.LEFT, tf1, "", true, true);
			TextFieldUtils.init(txtMessage1, TextFieldAutoSize.LEFT, tf1, "html", true, true );
            txtMessage1.text = message1;
            //Utils.initTextField(txtMessageScroll, TextFieldAutoSize.LEFT, tf1, "", true, true);
			TextFieldUtils.init(txtMessageScroll, TextFieldAutoSize.LEFT, tf1, "html", true, true );
            txtMessageScroll.text = messageScroll;
            //Utils.initTextField(txtMessage2, TextFieldAutoSize.LEFT, tf1, "", true, true);
			TextFieldUtils.init(txtMessage2, TextFieldAutoSize.LEFT, tf1, "html", true, true );
            txtMessage2.text = message2;
        }
        
        txtMessage1.x = txtMessage2.x = txtMessageScroll.x = background.x + 4;
        txtMessage1.width = txtMessage2.width = txtMessageScroll.width = background.width - 8;
        
        // test if ScrollBar is needed
        var sb:ScrollBar;
        if (txtMessageScroll.height > 140)
        {
            txtMessageScroll.width -= 20;
            txtMessageScroll.autoSize = TextFieldAutoSize.NONE;
            //txtMessageScroll.wordWrap = false;
            txtMessageScroll.height = 140;
            txtMessageScroll.borderColor = 0xAAAAAA;
            txtMessageScroll.border = true;
            sb = new ScrollBar(txtMessageScroll);
            addChild(sb);
            sb.x = txtMessageScroll.x + txtMessageScroll.width + 20 - sb.width;
        }
        else
        {
            txtMessage1.autoSize = TextFieldAutoSize.NONE;
            txtMessage1.height += 20;
            txtMessageScroll.autoSize = TextFieldAutoSize.NONE;
            txtMessageScroll.height += 20;
        }
        
        background.height = txtMessage1.height + txtMessage2.height + txtMessageScroll.height + 40 + btValid.height;
        
        
        background.y = (stage.stageHeight - background.height) / 2;
        txtMessage1.y = background.y + 4;
        txtMessageScroll.y = txtMessage1.y + txtMessage1.height;
        if (sb != null)
        {
            sb.y = txtMessageScroll.y;
        }
        txtMessage2.y = txtMessageScroll.y + txtMessageScroll.height + 20;
        
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
    }
    
    private function _textEventLinkHandler(e:TextEvent):Void
    {
        //PopupManager.instance.closePopup(e.text);
        DialogManager.instance.close(DialogValue.DATA(e.text));
    }
    
    private function clickValidHandler(e:MouseEvent):Void
    {
        //PopupManager.instance.closePopup(DialogValue.OK);
        DialogManager.instance.close(DialogValue.CONFIRM);
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

