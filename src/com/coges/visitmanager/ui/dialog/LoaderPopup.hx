package com.coges.visitmanager.ui.dialog;

import com.coges.visitmanager.fonts.FontName;
import com.ibs.ui.popup.IPopup;
import com.ibs.ui.popup.PopupButtonData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class LoaderPopup extends Sprite implements IPopup
{
    private var _title:String;
    private var _message:String;
    private var _icon:Class<Dynamic>;
    private var _buttons:Array<PopupButtonData>;
    
    
    public var txtMessage:TextField;
    public var txtPercent:TextField;
    public var loaderBar:Sprite;
    public var loaderLine:Sprite;
    
    public function new()
    {
        super();
        addEventListener(Event.ADDED_TO_STAGE, init);
    }
    
    private function init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        
        var tf1:TextFormat = new TextFormat();
        tf1.color = 0xffffff;
        txtMessage.defaultTextFormat = tf1;
        txtMessage.autoSize = TextFieldAutoSize.LEFT;
        
        var tf2:TextFormat = new TextFormat();
        tf2.bold = true;
        tf2.color = 0xffffff;
        txtPercent.defaultTextFormat = tf2;
        
        txtMessage.text = _message;
        txtMessage.x = loaderBar.x;
        txtMessage.y = loaderBar.y - txtMessage.height - 4;
        
        txtPercent.y = loaderBar.y + loaderBar.height + 4;
        
        update(0, 100);
    }
    public function initialize(title:String = "", message:String = "", icon:Class<Dynamic> = null, buttons:Array<PopupButtonData> = null, args:Array<Dynamic> = null):Void
    {
        _buttons = buttons;
        _icon = icon;
        _message = message;
        _title = title;
    }
    public function update(args:Array<Dynamic> = null):Void
    {
        var percent:Float = Math.ceil(args[0] / args[1] * 100);
        loaderBar.scaleX = percent / 100;
        txtPercent.text = percent + " %";
        txtPercent.x = loaderBar.x + loaderBar.width - txtPercent.width;
        loaderLine.x = loaderBar.x + loaderBar.width;
    }
}

