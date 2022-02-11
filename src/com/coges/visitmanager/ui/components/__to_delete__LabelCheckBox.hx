package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.fonts.FontName;
import com.coges.visitmanager.fonts.Fonts;
import nbigot.ui.control.SimpleToggleButton;
import openfl.events.Event;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class LabelCheckBox extends SimpleToggleButton
{
    public var label(get, never):String;

    private var _textSize:Int;
    private var _textBold:Bool;
    private var _textColor:Int;
    private var _label:String;
    
    private function get_label():String
    {
        return _label;
    }
    private var _forceWidth:Int;
    
    
    public function new(label:String = "", textSize:Int = 12, textBold:Bool = false, textColor:Int = 0x000000, forceWidth:Int = 0)
    {
        super();
        _forceWidth = forceWidth;
        _textColor = textColor;
        _textBold = textBold;
        _textSize = textSize;
        _label = label;
        addEventListener(Event.ADDED_TO_STAGE, _init);
    }
    
    private function _init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, _init);
        
        if (_label.length > 0)
        {
            var tf:TextFormat = new TextFormat();
            tf.size = _textSize;
            tf.font = Fonts.OPEN_SANS;
            tf.bold = _textBold;
            tf.color = _textColor;
            
            var txtLabel:TextField = new TextField();
            txtLabel.defaultTextFormat = tf;
            txtLabel.embedFonts = true;
            txtLabel.antiAliasType = AntiAliasType.ADVANCED;
            if (_forceWidth > 0)
            {
                txtLabel.wordWrap = true;
                txtLabel.multiline = true;
            }
            else
            {
                txtLabel.wordWrap = false;
                txtLabel.multiline = false;
            }
            txtLabel.selectable = false;
            txtLabel.autoSize = TextFieldAutoSize.LEFT;
            
            txtLabel.text = _label;
            txtLabel.x = width + 2;
            txtLabel.y = (height - txtLabel.height) / 2;
            addChild(txtLabel);
        }
    }
}

