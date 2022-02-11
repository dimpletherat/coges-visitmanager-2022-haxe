package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.vo.DO;
import nbigot.ui.control.Label;
import nbigot.ui.list.BaseScrollItem;
import openfl.display.DisplayObject;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ScrollItemDO extends BaseScrollItem<DO>
{
	private var _lblName:Label;
	private var _lblRepresented:Label;
	private var _flagIcon:DisplayObject;
	
    public function new(data:Dynamic = null, index:Int = -1, width:Float = 120, labelField:String = "label")
    {
        super(data, index, width, "labelFull");
    }
    
    override private function _draw():Void
    {
		ITEM_HEIGHT = 40;
		LABEL_COLOR = Colors.GREY1;
		BACKGROUND_COLOR = Colors.DARK_BLUE1;
		BACKGROUND_OVER_COLOR = Colors.DARK_BLUE2;
		BACKGROUND_SELECTED_COLOR = Colors.DARK_BLUE2;
		BORDER_COLOR = Colors.DARK_BLUE2;
		BORDER_OVER_COLOR = Colors.DARK_BLUE2;
		BORDER_SELECTED_COLOR = Colors.DARK_BLUE2;
		BORDER_SIZE = 1;
		
		
		// BUG: due to OpenfL textfields bugs ( HTML/multiline with AutoResize etc etc)
		// we have to change the display and add two labels...		
		
		var tf:TextFormat = new TextFormat();
        tf.leading = 0;
		tf.font = Fonts.OPEN_SANS;
        //tf.bold = true;
        tf.color = LABEL_COLOR;
        tf.size = 14;
		
		_lblName = new Label(_data.labelWithGuest, tf, TextFieldAutoSize.LEFT);
		//_lblName.border = true;
		addChild( _lblName );
		
		
		if (_data.country != null)
		{
			_flagIcon = _data.country.flag24;
			if (_flagIcon != null)
			{
				addChild(_flagIcon);
			}
		}
		
		if ( _data.isRepresented )
		{
			tf.size = 10;
			tf.italic = true;
			_lblRepresented = new Label(_data.labelRepresented, tf, TextFieldAutoSize.LEFT);
			//_lblRepresented.border = true;
			addChild( _lblRepresented );
			
		}
		
		set_width( _width );
		
		// keep this for reminder...
		// 
	/*
        _txtLabel = _drawLabel();
        _txtLabel.multiline = true;
		//_txtLabel.wordWrap = true;
        _txtLabel.mouseEnabled = false;				
        _txtLabel.border = true;		
        var tf:TextFormat = _txtLabel.getTextFormat();
        tf.leading = 0;
		tf.font = Fonts.OPEN_SANS;
        _txtLabel.defaultTextFormat = tf;
        _txtLabel.x = 4;
        if (_data != null)
        {
            if (_data.country != null)
            {
                var flagIcon:DisplayObject = _data.country.flag24;
                if (flagIcon != null)
                {
                    addChild(flagIcon);
                    flagIcon.x = 4;
                    flagIcon.y = (ITEM_HEIGHT - flagIcon.height) / 2;
                    _txtLabel.x += flagIcon.width + 4;
                }
            }
        }
        _txtLabel.htmlText = _data.labelFull;
		trace( "_data.labelFull : " + _data.labelFull );
        _txtLabel.width = _width;
		var tW:Float = _txtLabel.width;
		var tH:Float = _txtLabel.height;
		
		
        _txtLabel.autoSize = TextFieldAutoSize.NONE;
		_txtLabel.width = tW;
		_txtLabel.height = tH;
        _txtLabel.y = (ITEM_HEIGHT - _txtLabel.height) / 2;
        addChild(_txtLabel);
		
		*/
		
		
		
    }
	override public function set_width(value:Float):Float 
	{
		//super.set_width( value);
		
		_width = value;
		
		var padding = 6;
		var tmpHeight:Float = 0;
		
		
		_lblName.x = padding;
		_lblName.y = padding;
		
		if ( _flagIcon != null )
		{
			_flagIcon.x = padding;
			_flagIcon.y = padding;
			_lblName.x = _flagIcon.width + padding * 2;
		}
		
		_lblName.width = _width - _lblName.x - padding;
		
        tmpHeight = _lblName.height + padding * 2;
		
		if ( _lblRepresented != null )
		{
			_lblRepresented.x = _lblName.x;
			_lblRepresented.y = _lblName.y + _lblName.height;
			_lblRepresented.width = _lblName.width;
			tmpHeight += _lblRepresented.height;
		}
        
		ITEM_HEIGHT = Math.ceil( tmpHeight );
        if ( ITEM_HEIGHT < 40 ) ITEM_HEIGHT = 40;
		
		if ( _isSelected )
			_drawSelectedState();
		else
			_drawNormalState();
		
		return value;
	}
}

