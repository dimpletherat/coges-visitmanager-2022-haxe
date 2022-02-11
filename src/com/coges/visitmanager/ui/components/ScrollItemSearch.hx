package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.vo.Country;
import nbigot.ui.list.BaseScrollItem;
import openfl.display.DisplayObject;
import openfl.display.Shape;
/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ScrollItemSearch<T> extends BaseScrollItem<T>
{
    
    public function new(data:T = null, index:Int = -1, width:Float = 120, labelField:String = "label")
    {
        super(data, index, width, labelField);
    }
    
    override private function _draw():Void
    {	
		ITEM_HEIGHT = 30;
		LABEL_COLOR = Colors.GREY2;
		BACKGROUND_COLOR = Colors.DARK_BLUE1;
		BACKGROUND_OVER_COLOR = Colors.DARK_BLUE2;
		BACKGROUND_SELECTED_COLOR = Colors.DARK_BLUE2;
		BORDER_COLOR = Colors.BLUE2;
		BORDER_OVER_COLOR = Colors.BLUE2;
		BORDER_SELECTED_COLOR = Colors.BLUE2;
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

