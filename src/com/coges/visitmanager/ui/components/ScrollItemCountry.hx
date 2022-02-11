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
class ScrollItemCountry extends BaseScrollItem<Country>
{
    
    public function new(data:Country = null, index:Int = -1, width:Float = 120, labelField:String = "label")
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
	
        if ( _data.id <= 0)
        {
			LABEL_COLOR = Colors.GREY2;
			//TODO: find colors for non-country entries
            /*NORMAL_COLOR = Colors.GREY4;
            OVER_COLOR = 0xFFFFFF;*/
        }
	
	
	
        _txtLabel = _drawLabel();
        _txtLabel.mouseEnabled = false;
        _txtLabel.x = 4;
		
        if (_data.id > 0)
        {
            var flagIcon:DisplayObject = _data.flag16;
            if (flagIcon != null)
            {
                addChild(flagIcon);
                flagIcon.x = 4;
                flagIcon.y = (ITEM_HEIGHT - flagIcon.height) / 2;
                _txtLabel.x += flagIcon.width + 4;
            }
        }
        _txtLabel.text = _data.label;
        _txtLabel.y = (ITEM_HEIGHT - _txtLabel.height) / 2;
        _txtLabel.width = _width;		
        addChild(_txtLabel);
		
		
        var bar:Shape;
        if (_data.id == -1)
        {
            bar = new Shape();
            bar.graphics.beginFill(0x999999);
            bar.graphics.drawRect(0, 0, _width, 4);
            bar.graphics.endFill();
            addChild(bar);
        }
        if (_data.id == -2)
        {
            bar = new Shape();
            bar.graphics.beginFill(0x999999);
            bar.graphics.drawRect(0, ITEM_HEIGHT - 4, _width, 4);
            bar.graphics.endFill();
            addChild(bar);
        }
		
    }
}

