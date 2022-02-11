package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.vo.Planning;
import nbigot.ui.control.RoundRectSprite;
import nbigot.ui.control.Scrollbar.GripStyle;
import nbigot.ui.list.ComboList;
import nbigot.utils.Collection;
import openfl.display.DisplayObject;
import openfl.geom.Point;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ComboListPlanning extends ComboList<Planning>
{
	var tfTravail:TextFormat;
	var tfVersion:TextFormat;
	
    public function new(datas:Collection<Planning> = null)
    {
		tfTravail = new TextFormat( Fonts.OPEN_SANS, 13, Colors.GREY1);
		tfVersion = new TextFormat( Fonts.OPEN_SANS, 11, Colors.GREY1);
		
		var b:VMButton = new VMButton("", new TextFormat( Fonts.OPEN_SANS, 13, Colors.GREY1), new RoundRectSprite( 230,30,6,6, Colors.BLUE1) );
		b.setIcon( Icons.getIcon( Icon.PLANNING_VERSION ), new Point( 40, 30 ) );
		b.borderEnabled = false;
		var arrow:DisplayObject = Icons.getIcon( Icon.COMBOLIST_ARROW_GREY1 );
		
        super(datas, 0, 200, "label", ScrollItemPlanning, b, arrow);
		
		scrollbarOptions.gripStyle = GripStyle.LINE;
		scrollbarOptions.gripColor = Colors.GREY2;
		scrollbarOptions.backgroundColor = Colors.BLUE2;
    }
    
    
    override private function set_label(value:String):String
    {
        if (_selectedData.version > 0)
        {
			btCombo.setLabel( _selectedData.labelAndDate, tfVersion );
        }
        else
        {
            btCombo.setLabel( _selectedData.label, tfTravail );
        }
        return value;
    }
}
