package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.vo.DOStatus;
import nbigot.ui.IconPosition;
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
class ComboListDOStatus extends ComboList<DOStatus>
{
    
    public function new(datas:Collection<DOStatus> = null)
    {
		var b:VMButton = new VMButton("", new TextFormat( Fonts.OPEN_SANS, 14, Colors.GREY1), SpriteUtils.createSquare(280, 40, Colors.DARK_BLUE2) );
		b.borderEnabled = false;
		var arrow:DisplayObject = Icons.getIcon( Icon.COMBOLIST_ARROW_GREY1 );
		
        super(datas, 0, 200, "label", ScrollItemDOStatus, b, arrow);
    }
    
    
    override private function set_label(value:String):String
    {
        super.label = value;
        btCombo.setIcon( _selectedData.icon, new Point(50,40), IconPosition.LEFT);
        return value;
    }
}

