package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.fonts.Fonts;
import motion.Actuate;
import nbigot.ui.control.ToolTip;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.GradientType;
import openfl.display.MovieClip;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ButtonOLD extends Sprite
{
    public var backgroundColor(get, set):Int;
    public var backgroundColorOver(get, set):Int;
    public var textFont(get, set):String;
    public var textSize(get, set):Int;
    public var textBold(get, set):Bool;
    public var textAlign(get, set):String;
    public var textColor(get, set):Int;
    public var textColorOver(get, set):Int;
    public var borderColor(get, set):Int;
    public var borderColorOver(get, set):Int;
    public var label(get, set):String;
    public var icon(get, set):Dynamic;
    public var toolTipContent(get, set):Dynamic;
    public var enabled(get, set):Bool;

    public static final ICON_PADDING:Int = 4;
    public static final PADDING_LEFT:Int = 6;
    public static final PADDING_RIGHT:Int = 6;
    public static final ROUND_CORNER_SIZE:Int = 4;
    
    private var _width:Float = 120;
    private var _height:Float = 26;
    
    private var _backgroundColor:Int = 0xDEDEDE;
    private function get_backgroundColor():Int
    {
        return _backgroundColor;
    }
    
    private var _backgroundColorOver:Int = 0xA0B9C2;
    private function get_backgroundColorOver():Int
    {
        return _backgroundColorOver;
    }
    
    private var _textFont:String = Fonts.OPEN_SANS;
    private function get_textFont():String
    {
        return _textFont;
    }
    
    private var _textSize:Int = 14;
    private function get_textSize():Int
    {
        return _textSize;
    }
    
    private var _textBold:Bool = true;
    private function get_textBold():Bool
    {
        return _textBold;
    }
    
    private var _textAlign:String = TextFormatAlign.LEFT;
    private function get_textAlign():String
    {
        return _textAlign;
    }
    
    private var _textColor:Int = 0x000000;
    private function get_textColor():Int
    {
        return _textColor;
    }
    
    private var _textColorOver:Int = 0xFFFFFFF;
    private function get_textColorOver():Int
    {
        return _textColorOver;
    }
    
    private var _borderColor:Int = 0x000000;
    private function get_borderColor():Int
    {
        return _borderColor;
    }
    
    private var _borderColorOver:Int = 0x000000;
    private function get_borderColorOver():Int
    {
        return _borderColorOver;
    }
    
    private var _label:String;
    private function get_label():String
    {
        return _label;
    }
    
    private var _icon:Dynamic = null;
    private function get_icon():Dynamic
    {
        return _icon;
    }
    
    private var _isFromLibrary:Bool;
    
    
    private var _txtLabel:TextField;
    private var _txtLabelOver:TextField;
    private var _background:Sprite;
    private var _backgroundOver:Sprite;
    private var _border:Sprite;
    private var _borderOver:Sprite;
    private var _gradient:Sprite;
    private var _iconObject:DisplayObject;
    
    private var _toolTipContent:Dynamic;
    private function get_toolTipContent():Dynamic
    {
        return _toolTipContent;
    }
    private function set_toolTipContent(value:Dynamic):Dynamic
    {
        _toolTipContent = value;
        return value;
    }
    
    
    public function new(label:String = "", icon:Dynamic = null, background:Bool = true, gradient:Bool = true, border:Bool = false)
    {
        super();
        //trace( "getQualifiedClassName(this):" + getQualifiedClassName(this) );
        _isFromLibrary = (Type.resolveClass(Type.getClassName(Type.getClass(this))) != VMButton);
        //trace( "_isFromLibrary:" + _isFromLibrary );
        
        if (!_isFromLibrary)
        {
            _icon = icon;
            if (background)
            {
                _background = try cast(addChild(new Sprite()), Sprite) catch(e:Dynamic) null;
                _backgroundOver = try cast(addChild(new Sprite()), Sprite) catch(e:Dynamic) null;
            }
            if (border)
            {
                _border = try cast(addChild(new Sprite()), Sprite) catch(e:Dynamic) null;
                _borderOver = try cast(addChild(new Sprite()), Sprite) catch(e:Dynamic) null;
            }
            if (gradient)
            {
                _gradient = try cast(addChild(new Sprite()), Sprite) catch(e:Dynamic) null;
            }
            if (label.length > 0)
            {
                _label = label;
                _txtLabel = createTextField(_textColor, _textSize, _textBold);
                _txtLabel.text = _label;
                _txtLabelOver = createTextField(_textColorOver, _textSize, _textBold);
                _txtLabelOver.text = _label;
            }
        }
        else
        {
            _background = try cast(getChildByName("background"), Sprite) catch(e:Dynamic) null;
            _backgroundOver = try cast(getChildByName("backgroundOver"), Sprite) catch(e:Dynamic) null;
            _border = try cast(getChildByName("border"), Sprite) catch(e:Dynamic) null;
            _borderOver = try cast(getChildByName("borderOver"), Sprite) catch(e:Dynamic) null;
            _gradient = try cast(getChildByName("gradient"), Sprite) catch(e:Dynamic) null;
            _txtLabel = try cast(getChildByName("txtLabel"), TextField) catch(e:Dynamic) null;
            _txtLabelOver = try cast(getChildByName("txtLabelOver"), TextField) catch(e:Dynamic) null;
            if (_txtLabel != null)
            {
                _txtLabel.embedFonts = true;
                _txtLabel.autoSize = TextFieldAutoSize.LEFT;
                _label = _txtLabel.text;
            }
            if (_txtLabelOver != null)
            {
                _txtLabelOver.embedFonts = true;
                _txtLabelOver.autoSize = TextFieldAutoSize.LEFT;
            }
            _iconObject = getChildByName("icon");
            _height = height;
            _width = width;
        }
        
        buttonMode = true;
        mouseChildren = false;
        _toolTipContent = null;
        
        addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
        addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
        
        if (_txtLabelOver != null)
        {
            _txtLabelOver.alpha = 0;
        }
        if (_backgroundOver != null)
        {
            _backgroundOver.alpha = 0;
        }
        if (_borderOver != null)
        {
            _borderOver.alpha = 0;
        }
        
        draw();
    }
    
    private function draw():Void
    {
        var xLabel:Float;
        var widthLabel:Float = ((_txtLabel != null)) ? _txtLabel.width:0;
        
        if (_iconObject != null)
        {
            _width = PADDING_LEFT + _iconObject.width + ICON_PADDING + widthLabel + PADDING_RIGHT;
            xLabel = _iconObject.x + _iconObject.width + ICON_PADDING;
        }
        else
        {
            _width = PADDING_LEFT + widthLabel + PADDING_RIGHT;
            xLabel = PADDING_LEFT;
        }
        if (_txtLabel != null)
        {
            _txtLabel.x = Math.round(xLabel);
            _txtLabel.y = Math.round((_height - _txtLabel.height) / 2);
        }
        if (_txtLabelOver != null)
        {
            _txtLabelOver.x = Math.round(xLabel);
            _txtLabelOver.y = Math.round((_height - _txtLabelOver.height) / 2);
        }
        
        if (_background != null && !_isFromLibrary)
        {
            drawBackground(_background, _backgroundColor);
        }
        if (_backgroundOver != null && !_isFromLibrary)
        {
            drawBackground(_backgroundOver, _backgroundColorOver);
        }
        if (_gradient != null && !_isFromLibrary)
        {
            drawGradient();
        }
        if (_border != null && !_isFromLibrary)
        {
            drawBorder(_border, _borderColor);
        }
        if (_borderOver != null && !_isFromLibrary)
        {
            drawBorder(_borderOver, _borderColorOver);
        }
    }
    
    private function createTextField(color:Int, size:Int, bold:Bool):TextField
    {
        var t:TextField = new TextField();
        t.selectable = false;
        t.mouseEnabled = false;
        t.embedFonts = true;
        //t.multiline = true;
        t.autoSize = TextFieldAutoSize.LEFT;
        t.antiAliasType = AntiAliasType.ADVANCED;
        var tf:TextFormat = new TextFormat(Fonts.OPEN_SANS, size, color, bold);
        t.defaultTextFormat = tf;
        addChild(t);
        return t;
    }
    
    private function drawBackground(source:Sprite, color:Int):Void
    {
        source.graphics.clear();
        source.graphics.beginFill(color);
        source.graphics.drawRoundRect(0, 0, _width, _height, ROUND_CORNER_SIZE, ROUND_CORNER_SIZE);
        source.graphics.endFill();
    }
    
    private function drawBorder(source:Sprite, color:Int):Void
    {
        source.graphics.clear();
        source.graphics.lineStyle(1, color, 1, true);
        source.graphics.drawRoundRect(0, 0, _width, /*background.width*/_height, /*background.height*/ROUND_CORNER_SIZE, ROUND_CORNER_SIZE);
    }
    
    private function drawGradient():Void
    {
        if (_gradient == null)
        {
            return;
        }
        var m:Matrix = new Matrix();
        m.createGradientBox(_width, _height, Math.PI / 2);
        _gradient.graphics.clear();
        _gradient.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF, 0x000000, 0x000000], [0.2, 0.3, 0.1, 0.3], [0x00, 0x74, 0x90, 0xff], m);
        _gradient.graphics.drawRoundRect(0, 0, _width, _height, ROUND_CORNER_SIZE, ROUND_CORNER_SIZE);
        _gradient.graphics.endFill();
    }
    
    private function displayIcon():Void
    {
        removeIcon();
        if (Std.is(_icon, BitmapData))
        {
            _iconObject = new Bitmap(_icon);
        }
        else if (Std.is(_icon, Class))
        {
			
            _iconObject = Type.createInstance( _icon, [] );
            if (!(Std.is(_iconObject, DisplayObject)))
            {
                _iconObject = null;
                return;
            }
        }
        else if (Std.is(_icon, DisplayObject))
        {
            _iconObject = _icon;
        }
        else
        {
            _iconObject = null;
            return;
        }
        addChild(_iconObject);
        _iconObject.x = PADDING_LEFT;
        _iconObject.y = (_height - _iconObject.height) / 2;
        draw();
    }
    private function removeIcon():Void
    {
        if (_iconObject != null)
        {
            removeChild(_iconObject);
            _iconObject = null;
            draw();
        }
    }
    
    private var _enabled:Bool;
    private function get_enabled():Bool
    {
        return _enabled;
    }
    private function set_enabled(value:Bool):Bool
    {
        _enabled = value;
        mouseEnabled = _enabled;
        alpha = ((_enabled)) ? 1:0.5;
        return value;
    }
    
    public function centerIcon():Void
    {
        if (_iconObject != null)
        {
            _iconObject.x = (width - _iconObject.width) / 2;
        }
    }
    
    private function set_icon(value:Dynamic):Dynamic
    {
        _icon = value;
        if (_icon == null)
        {
            removeIcon();
        }
        else
        {
            displayIcon();
        }
        return value;
    }
    
    private function set_label(value:String):String
    {
        _label = value;
        if (_txtLabel != null)
        {
            _txtLabel.text = _label;
        }
        if (_txtLabelOver != null)
        {
            _txtLabelOver.text = label;
        }
        
        draw();
        return value;
    }
    private function set_borderColor(value:Int):Int
    {
        if (_border == null)
        {
            return value;
        }
        _borderColor = value;
        drawBorder(_border, _borderColor);
        return value;
    }
    private function set_borderColorOver(value:Int):Int
    {
        if (_borderOver == null)
        {
            return value;
        }
        _borderColorOver = value;
        drawBorder(_borderOver, _borderColorOver);
        return value;
    }
    private function set_textColor(value:Int):Int
    {
        if (_txtLabel == null)
        {
            return value;
        }
        _textColor = value;
        _txtLabel.textColor = _textColor;
        return value;
    }
    private function set_textColorOver(value:Int):Int
    {
        if (_txtLabelOver == null)
        {
            return value;
        }
        _textColorOver = value;
        _txtLabelOver.textColor = _textColorOver;
        return value;
    }
    private function set_textFont(value:String):String
    {
        if (_txtLabel == null)
        {
            return value;
        }
        
        _textFont = value;
        
        var tf:TextFormat = _txtLabel.getTextFormat();
        tf.font = _textFont;
        _txtLabel.defaultTextFormat = tf;
        _txtLabel.text = _label;
        
        if (_txtLabelOver != null)
        {
            var tfOver:TextFormat = _txtLabelOver.getTextFormat();
            tfOver.font = _textFont;
            _txtLabelOver.defaultTextFormat = tfOver;
            _txtLabelOver.text = _label;
        }
        draw();
        return value;
    }
    private function set_textSize(value:Int):Int
    {
        if (_txtLabel == null)
        {
            return value;
        }
        
        _textSize = value;
        var tf:TextFormat = _txtLabel.getTextFormat();
        tf.size = _textSize;
        _txtLabel.defaultTextFormat = tf;
        _txtLabel.text = _label;
        
        if (_txtLabelOver != null)
        {
            var tfOver:TextFormat = _txtLabelOver.getTextFormat();
            tfOver.size = _textSize;
            _txtLabelOver.defaultTextFormat = tfOver;
            _txtLabelOver.text = _label;
        }
        draw();
        return value;
    }
    private function set_textBold(value:Bool):Bool
    {
        if (_txtLabel == null)
        {
            return value;
        }
        
        _textBold = value;
        var tf:TextFormat = _txtLabel.getTextFormat();
        tf.bold = _textBold;
        _txtLabel.defaultTextFormat = tf;
        _txtLabel.text = _label;
        
        if (_txtLabelOver != null)
        {
            var tfOver:TextFormat = _txtLabelOver.getTextFormat();
            tfOver.bold = _textBold;
            _txtLabelOver.defaultTextFormat = tfOver;
            _txtLabelOver.text = _label;
        }
        draw();
        return value;
    }
    private function set_textAlign(value:String):String
    {
        if (_txtLabel == null)
        {
            return value;
        }
        
        _textAlign = value;
        var tf:TextFormat = _txtLabel.getTextFormat();
        tf.align = _textAlign;
        _txtLabel.defaultTextFormat = tf;
        _txtLabel.text = _label;
        
        if (_txtLabelOver != null)
        {
            var tfOver:TextFormat = _txtLabelOver.getTextFormat();
            tfOver.align = _textAlign;
            _txtLabelOver.defaultTextFormat = tfOver;
            _txtLabelOver.text = _label;
        }
        draw();
        return value;
    }
    
    
    public function setDefaultTextFormat(value:TextFormat, applyBoth:Bool = false):Void
    {
        if (_txtLabel == null)
        {
            return;
        }
        
        _txtLabel.defaultTextFormat = value;
        _txtLabel.text = _label;
        
        if (_txtLabelOver != null && applyBoth)
        {
            _txtLabelOver.defaultTextFormat = value;
            _txtLabelOver.text = _label;
        }
        
        draw();
    }
    public function setDefaultTextFormatOver(value:TextFormat):Void
    {
        if (_txtLabelOver == null)
        {
            return;
        }
        
        _txtLabelOver.defaultTextFormat = value;
        _txtLabelOver.text = _label;
        
        draw();
    }
    public function setTextFormat(value:TextFormat, beginIndex:Int = -1, endIndex:Int = -1, applyBoth:Bool = false):Void
    {
        if (_txtLabel == null)
        {
            return;
        }
        
        _txtLabel.setTextFormat(value, beginIndex, endIndex);
        
        if (_txtLabelOver != null && applyBoth)
        {
            _txtLabelOver.setTextFormat(value, beginIndex, endIndex);
        }
        
        draw();
    }
    public function setTextFormatOver(value:TextFormat, beginIndex:Int = -1, endIndex:Int = -1):Void
    {
        if (_txtLabelOver == null)
        {
            return;
        }
        
        _txtLabelOver.setTextFormat(value, beginIndex, endIndex);
        
        draw();
    }
    public function getTextFormat(beginIndex:Int = -1, endIndex:Int = -1):TextFormat
    {
        return _txtLabel.getTextFormat(beginIndex, endIndex);
    }
    public function getTextFormatOver(beginIndex:Int = -1, endIndex:Int = -1):TextFormat
    {
        return _txtLabelOver.getTextFormat(beginIndex, endIndex);
    }
    
    private function set_backgroundColor(value:Int):Int
    {
        if (_background == null)
        {
            return value;
        }
        _backgroundColor = value;
        drawBackground(_background, _backgroundColor);
        return value;
    }
    private function set_backgroundColorOver(value:Int):Int
    {
        if (_backgroundOver == null)
        {
            return value;
        }
        _backgroundColorOver = value;
        drawBackground(_backgroundOver, _backgroundColorOver);
        return value;
    }
    
    private function rollOverHandler(e:MouseEvent):Void
    {
        if (_background != null && _backgroundOver != null)
        {
            Actuate.tween(_background, 0.5, {
                        alpha:0
                    });
        }
        if (_border != null && _borderOver != null)
        {
            Actuate.tween(_border, 0.5, {
                        alpha:0
                    });
        }
        if (_txtLabel != null && _txtLabelOver != null)
        {
            Actuate.tween(_txtLabel, 0.5, {
                        alpha:0
                    });
        }
        if (_background != null && _backgroundOver != null)
        {
            Actuate.tween(_backgroundOver, 0.5, {
                        alpha:1
                    });
        }
        if (_border != null && _borderOver != null)
        {
            Actuate.tween(_borderOver, 0.5, {
                        alpha:1
                    });
        }
        if (_txtLabel != null && _txtLabelOver != null)
        {
            Actuate.tween(_txtLabelOver, 0.5, {
                        alpha:1
                    });
        }
        if (_toolTipContent != null)
        {
            ToolTip.show(_toolTipContent);
        }
    }
    
    private function rollOutHandler(e:MouseEvent):Void
    {
        if (_background != null && _backgroundOver != null)
        {
            Actuate.tween(_background, 0.5, {
                        alpha:1
                    });
        }
        if (_border != null && _borderOver != null)
        {
            Actuate.tween(_border, 0.5, {
                        alpha:1
                    });
        }
        if (_txtLabel != null && _txtLabelOver != null)
        {
            Actuate.tween(_txtLabel, 0.5, {
                        alpha:1
                    });
        }
        if (_background != null && _backgroundOver != null)
        {
            Actuate.tween(_backgroundOver, 0.5, {
                        alpha:0
                    });
        }
        if (_border != null && _borderOver != null)
        {
            Actuate.tween(_borderOver, 0.5, {
                        alpha:0
                    });
        }
        if (_txtLabel != null && _txtLabelOver != null)
        {
            Actuate.tween(_txtLabelOver, 0.5, {
                        alpha:0
                    });
        }
        if (_toolTipContent != null)
        {
            ToolTip.hide();
        }
    }
}

