package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.vo.DOStatus;
import nbigot.ui.list.BaseScrollItem;
import openfl.display.DisplayObject;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ScrollItemDOStatus extends BaseScrollItem<DOStatus>
{
    
    public function new(data:DOStatus = null, index:Int = -1, width:Float = 120, labelField:String = "label")
    {
        super(data, index, width, labelField);
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
	
	
	
	
        _txtLabel = _drawLabel();
        _txtLabel.mouseEnabled = false;
        _txtLabel.x = 4;
		var icon:DisplayObject = _data.icon;
		if (icon != null)
		{
			addChild(icon);
			icon.x = 10;
			icon.y = (ITEM_HEIGHT - icon.height) / 2;
			_txtLabel.x = 50;// icon.x + icon.width + 8;
		}
        _txtLabel.text = _data.label;
        _txtLabel.y = (ITEM_HEIGHT - _txtLabel.height) / 2;
        _txtLabel.width = _width;
        addChild(_txtLabel);
    }
}

