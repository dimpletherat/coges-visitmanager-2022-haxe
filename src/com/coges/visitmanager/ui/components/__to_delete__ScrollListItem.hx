package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.fonts.Fonts;
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
class ScrollListItem extends Sprite implements IScrollListItem
{
    private var ITEM_HEIGHT:Int = 30;
    private var NORMAL_COLOR:Int = 0xCDCDCD;
    private var OVER_COLOR:Int = 0xEFEFEF;
    private var LABEL_COLOR:Int = 0x000000;
    private var BORDER_COLOR:Int = 0x666666;
    
    
    private var _data:Dynamic;
    public function getData():Dynamic
    {
        return _data;
    }
    
    private var _labelField:String;
    private var _txtLabel:TextField;
    private var _width:Float;
    private var _index:Int;
    public function getIndex():Int
    {
        return _index;
    }
    
    private var _selected:Bool;
    public function setSelected(value:Bool):Void
    {
        _selected = value;
        if (_selected)
        {
            drawBackground(OVER_COLOR);
        }
        else
        {
            drawBackground(NORMAL_COLOR);
        }
    }
    public function getSelected():Bool
    {
        return _selected;
    }
    
    public function new(data:Dynamic = null, index:Int = -1, width:Float = 120, labelField:String = "label")
    {
        super();
        _index = index;
        _width = width;
        _labelField = labelField;
        _data = data;
        mouseChildren = false;
        buttonMode = true;
        
        addEventListener(Event.ADDED_TO_STAGE, init);
        addEventListener(MouseEvent.ROLL_OVER, _rollOverHandler);
        addEventListener(MouseEvent.ROLL_OUT, _rollOutHandler);
    }
    private function init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        
        draw();
        
        drawBackground(NORMAL_COLOR);
    }
    
    private function draw():Void
    {
        _txtLabel = drawLabel();
        if (_data != null)
        {
            _txtLabel.text = Std.string(Reflect.field(_data, _labelField));
        }
        _txtLabel.width = _width;
        _txtLabel.y = (ITEM_HEIGHT - _txtLabel.height) / 2;
        _txtLabel.x = 4;
    }
    
    private function _rollOutHandler(e:MouseEvent):Void
    {
        if (!_selected)
        {
            drawBackground(NORMAL_COLOR);
        }
    }
    
    private function _rollOverHandler(e:MouseEvent):Void
    {
        if (!_selected)
        {
            drawBackground(OVER_COLOR);
        }
    }
    
    private function drawBackground(color:Int):Void
    {
        graphics.clear();
        graphics.lineStyle(1, BORDER_COLOR);
        graphics.beginFill(color, 1);
        graphics.drawRect(0, 0, _width, ITEM_HEIGHT);
        graphics.endFill();
    }
    
    private function drawLabel():TextField
    {
        var t:TextField = new TextField();
        var tf:TextFormat = new TextFormat();
        tf.font = Fonts.OPEN_SANS;
        //tf.bold = true;
        tf.color = LABEL_COLOR;
        tf.size = 12;
        t.selectable = false;
        t.embedFonts = true;
        t.antiAliasType = AntiAliasType.ADVANCED;
        t.autoSize = TextFieldAutoSize.LEFT;
        t.defaultTextFormat = tf;
        addChild(t);
        return t;
    }
}

