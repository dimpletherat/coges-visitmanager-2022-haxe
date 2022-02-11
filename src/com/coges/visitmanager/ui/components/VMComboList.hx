package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.fonts.Fonts;
import nbigot.ui.control.RoundRectSprite;
import nbigot.ui.control.Scrollbar.GripStyle;
import nbigot.ui.list.ComboList;
import nbigot.utils.Collection;
import openfl.display.DisplayObject;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class VMComboList<T> extends ComboList<T>
{
    public function new(datas:Collection<T> = null)
    {		
		var b:VMButton = new VMButton("", new TextFormat( Fonts.OPEN_SANS, 13, Colors.GREY1), new RoundRectSprite( 230,30,6,6, Colors.GREY3) );
		b.borderEnabled = false;
		var arrow:DisplayObject = Icons.getIcon( Icon.COMBOLIST_ARROW_GREY1 );
		
        super(datas, 0, 200, "label", VMScrollItem, b, arrow);
		
		scrollbarOptions.gripStyle = GripStyle.LINE;
		scrollbarOptions.gripColor = Colors.GREY2;
		scrollbarOptions.backgroundColor = Colors.GREY4;
    }
    
    /*
    override private function set_label(value:String):String
    {
		btCombo.setIcon( Icons.getIcon( Icon.PLANNING_VERSION ), new Point( 40, 30 ) );
        if (_selectedData.version > 0)
        {
			btCombo.setLabel( _selectedData.labelAndDate );
        }
        else
        {
            btCombo.setLabel( _selectedData.label );
        }
        return value;
    }*/
}
