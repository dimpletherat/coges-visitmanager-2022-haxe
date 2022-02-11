package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.vo.Country;
import com.coges.visitmanager.vo.Planning;
import nbigot.ui.list.BaseScrollItem;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */

class ScrollItemPlanning extends BaseScrollItem<Planning>
{
    
    public function new(data:Planning = null, index:Int = -1, width:Float = 120, labelField:String = "label")
    {
        super(data, index, width, labelField);
    }
    
	
    override private function _draw():Void
    {	
		ITEM_HEIGHT = 30;
		LABEL_COLOR = Colors.GREY1;
		BACKGROUND_COLOR = Colors.BLUE1;
		BACKGROUND_OVER_COLOR = Colors.BLUE2;
		BACKGROUND_SELECTED_COLOR = Colors.BLUE2;
		BORDER_COLOR = Colors.BLUE2;
		BORDER_OVER_COLOR = Colors.BLUE2;
		BORDER_SELECTED_COLOR = Colors.BLUE2;
		BORDER_SIZE = 1;
	
	
        _txtLabel = _drawLabel();
		var tf:TextFormat = _txtLabel.defaultTextFormat;
		tf.size = 13;
		_txtLabel.defaultTextFormat = tf;
        _txtLabel.mouseEnabled = false;
        _txtLabel.x = 4;
		
	
        if (_data != null)
        {
            if (_data.version > 0)
            {
                _txtLabel.text = _data.labelAndDate;
            }
            else
            {
                _txtLabel.text = _data.label;
            }
        }
		
        _txtLabel.y = (ITEM_HEIGHT - _txtLabel.height) / 2;
        _txtLabel.width = _width;		
        addChild(_txtLabel);		
    }
}

