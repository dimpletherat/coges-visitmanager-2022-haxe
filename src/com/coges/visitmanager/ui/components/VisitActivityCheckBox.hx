package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Icons;
import nbigot.ui.control.CheckBox;
import nbigot.ui.control.ToolTip;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class VisitActivityCheckBox extends CheckBox
{
    public var toolTipContent:String;
    
    public function new()
    {
		super();
		toolTipContent = "";
		icon = Icons.getIcon( Icon.CHECK_SOLID_GREY3 );
		iconSelected = Icons.getIcon( Icon.CHECK_SOLID_GREY3_SELECTED );
		addEventListener(MouseEvent.ROLL_OVER, _rollOverHandler);
		addEventListener(MouseEvent.ROLL_OUT, _rollOutHandler);
    }
    
    private function _rollOverHandler(e:MouseEvent):Void
    {
		if ( toolTipContent.length > 0 )
			ToolTip.show(toolTipContent);
    }
    
    private function _rollOutHandler(e:MouseEvent):Void
    {
        ToolTip.hide();
    }
}

