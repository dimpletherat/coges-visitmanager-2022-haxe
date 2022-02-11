package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Icons;
import nbigot.ui.list.BaseScrollItem;
import nbigot.utils.ImageUtils;
import openfl.display.DisplayObject;
import openfl.geom.Rectangle;
/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ScrollItemEmail extends BaseScrollItem<String>
{
	var _icoMinus:DisplayObject;
    
    public function new(data:String = null, index:Int = -1, width:Float = 120, labelField:String = "label")
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
        _txtLabel.text = _data;
        addChild(_txtLabel);	
		
		
        _icoMinus = Icons.getIcon(Icon.MINUS);
		addChild(_icoMinus);
		
		width = _width;
    }
	
	
    override private function _drawNormalState():Void
    {
		super._drawNormalState();
		
		_icoMinus.visible = false;
    }
    override private function _drawOverState():Void
    {
		super._drawOverState();
		
		_icoMinus.visible = true;
    }
	override public function set_width(value:Float):Float 
	{
		//super.set_width( value);
		
		_width = value;
		
        _txtLabel.x = 4;
		_txtLabel.width = _width - 40;
        _txtLabel.y = (ITEM_HEIGHT - _txtLabel.height) / 2;
		
		ImageUtils.fitIn(_icoMinus, new Rectangle(_width - _icoMinus.width - 12, 8, _icoMinus.width, 14));
		
		
		if ( _isSelected )
			_drawSelectedState();
		else
			_drawNormalState();
		
		return value;
	}
}

