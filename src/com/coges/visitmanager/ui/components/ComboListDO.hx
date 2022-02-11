package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.fonts.Fonts;
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
class ComboListDO extends ComboList<DO>
{
    
    public function new(datas:Collection<DO> = null)
    {
		var b:VMButton = new VMButton("", new TextFormat( Fonts.OPEN_SANS, 14, Colors.GREY1, true, null,null,null,null,null,null,null,null,0), SpriteUtils.createSquare(800, 40, Colors.DARK_BLUE2) );
		b.borderEnabled = false;
		var arrow:DisplayObject = Icons.getIcon( Icon.COMBOLIST_ARROW_GREY1 );
		
        super(datas, 0, 400, "labelFullForButton", ScrollItemDO, b, arrow);
        /*
        btCombo.textColor = 0xFFFFFF;
        btCombo.textSize = 14;
        btCombo.textBold = true;*/
		scrollbarOptions.gripStyle = GripStyle.LINE;
		scrollbarOptions.gripColor = Colors.BLUE2;
		scrollbarOptions.backgroundColor = Colors.DARK_BLUE2;
    }
    
    
    override private function set_label(value:String):String
    {
        super.label = value;
		
		//TODO :: check why format is not applied
        var index:Int = value.indexOf("\n");
        if (index != -1)
        {
            var tf:TextFormat = cast(btCombo,VMButton).getTextFormat();
            tf.italic = true;
            tf.size = 10;
            tf.bold = false;
            cast(btCombo,VMButton).setTextFormat(tf, index + 1, value.length);
        }       
        
        if (_selectedData.country != null)
        {
			btCombo.setIcon( _selectedData.country.flag32, new Point(50,50), IconPosition.LEFT);
        }
        else
        {
            btCombo.setIcon(null);
        }
        return value;
    }
}

