package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Colors;
import nbigot.ui.list.BaseScrollItem;
/**
	 * ...
	 * @author Nicolas Bigot
	 */

class VMScrollItem<T> extends BaseScrollItem<T>
{
    
    public function new(data:T = null, index:Int = -1, width:Float = 120, labelField:String = "label")
    {
        super(data, index, width, labelField);
    }
    
    override private function _draw():Void
    {	
		ITEM_HEIGHT = 30;
		LABEL_COLOR = Colors.GREY1;
		BACKGROUND_COLOR = Colors.GREY3;
		BACKGROUND_OVER_COLOR = Colors.GREY4;
		BACKGROUND_SELECTED_COLOR = Colors.GREY4;
		BORDER_COLOR = Colors.GREY4;
		BORDER_OVER_COLOR = Colors.GREY4;
		BORDER_SELECTED_COLOR = Colors.GREY4;
		BORDER_SIZE = 1;
	
	
	
        _txtLabel = _drawLabel();
        _txtLabel.mouseEnabled = false;
        _txtLabel.x = 4;
        _txtLabel.text = Reflect.getProperty(_data, "label");
        _txtLabel.y = (ITEM_HEIGHT - _txtLabel.height) / 2;
        _txtLabel.width = _width;		
        addChild(_txtLabel);		
    }
}

