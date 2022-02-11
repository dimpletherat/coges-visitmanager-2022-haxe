package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.vo.Country;
import com.coges.visitmanager.vo.DO;
import nbigot.ui.IconPosition;
import nbigot.ui.control.Scrollbar.GripStyle;
import nbigot.ui.list.ComboList;
import nbigot.utils.Collection;
import nbigot.utils.SpriteUtils;
import openfl.display.DisplayObject;
import openfl.geom.Point;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ComboListCountry extends ComboList<Country>
{
    
    public function new(datas:Collection<Country> = null)
    {		
		var b:VMButton = new VMButton("", new TextFormat( Fonts.OPEN_SANS, 14, Colors.GREY2), SpriteUtils.createSquare(300, 30, Colors.DARK_BLUE1) );
		b.borderEnabled = false;
		var arrow:DisplayObject = Icons.getIcon( Icon.COMBOLIST_ARROW_GREY1 );
		
        super(datas, 0, 200, "label", ScrollItemCountry, b, arrow);
		
		scrollbarOptions.gripStyle = GripStyle.LINE;
		scrollbarOptions.gripColor = Colors.BLUE2;
		scrollbarOptions.backgroundColor = Colors.DARK_BLUE2;
    }
    
    
    override private function set_label(value:String):String
    {
        super.label = value;
        if (_selectedData.id > 0)
        {
			btCombo.setIcon( _selectedData.flag24, new Point(50,40), IconPosition.LEFT);
        }
        else
        {
            btCombo.setIcon(null);
        }
        return value;
    }
}

