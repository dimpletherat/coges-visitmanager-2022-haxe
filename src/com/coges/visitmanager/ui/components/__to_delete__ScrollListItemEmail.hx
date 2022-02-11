package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.vo.Icon;
import nbigot.utils.ImageUtils;
import openfl.geom.Rectangle;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ScrollListItemEmail extends ScrollListItem
{
    
    public function new(data:Dynamic = null, index:Int = -1, width:Float = 120, labelField:String = "label")
    {
        super(data, index, width, labelField);
        NORMAL_COLOR = 0xdddddd;
        OVER_COLOR = 0x91CDF7;
        LABEL_COLOR = 0x000000;
        BORDER_COLOR = 0x666666;
        ITEM_HEIGHT = 28;
    }
    
    
    override private function draw():Void
    {
        _txtLabel = drawLabel();
        //_txtLabel.border = true;
        _txtLabel.x = 4;
        //_txtLabel.autoSize = TextFieldAutoSize.NONE;
        _txtLabel.wordWrap = true;
        
        _txtLabel.htmlText = _data;
        _txtLabel.width = _width - 40;
        
        var icoMinus = Icons.getIcon(Icon.MINUS);
        if (icoMinus)
        {
            addChild(icoMinus);
            ImageUtils.center(icoMinus, new Rectangle(_width - 30, 0, icoMinus.width, ITEM_HEIGHT));
        }
        
        ITEM_HEIGHT = as3hx.Compat.parseInt(height + 2);
        
        _txtLabel.y = 2;  //( ITEM_HEIGHT - _txtLabel.height ) / 2;  ;
    }
}

