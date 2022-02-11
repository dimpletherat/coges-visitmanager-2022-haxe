package com.coges.visitmanager.ui.dialog;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.datas.ServiceManager;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.ui.dialog.VMConfirmDialog;
import com.coges.visitmanager.vo.User;
import nbigot.ui.control.CheckBox;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.DialogSkin;
import nbigot.ui.dialog.DialogValue;
import nbigot.utils.SpriteUtils;
import openfl.display.DisplayObject;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ConfirmChangeVisitStatusDialog extends VMConfirmDialog
{
    private var _cbDontShowNextTime:CheckBox;
    
    
    public function new(title:String, message:String, ?icon:DisplayObject)
    {
        super(title, message, icon);
    }
	
    override public function init(skin:DialogSkin):Void
    {
		super.init(skin);
        _cbDontShowNextTime = new CheckBox();
		_cbDontShowNextTime.icon = Icons.getIcon( Icon.CHECK_GREY2 );
		_cbDontShowNextTime.iconSelected = Icons.getIcon( Icon.CHECK_GREY2_SELECTED );
		_cbDontShowNextTime.setText( Locale.get("LBL_CB_DONT_SHOW_NEXT_TIME"), new TextFormat( Fonts.OPEN_SANS, 13, Colors.GREY4 ) );
		addChild( _cbDontShowNextTime );
    }
	
	
    override public function draw( parentSize:Point ) : Void
    {
		super.draw(parentSize);
		
        _cbDontShowNextTime.x = _txtMessage.x;
        _cbDontShowNextTime.y = _txtMessage.y + _txtMessage.height + _skin.contentMargin;
        _cbDontShowNextTime.width = _txtMessage.width;		
		
		var additionnalHeight = _cbDontShowNextTime.height + _skin.contentMargin;
		
		
		SpriteUtils.drawRoundSquare( _background, Std.int(_background.width), Std.int(_background.height + additionnalHeight), 8, 8, _skin.contentBackgroundColor );
        
        _btCancel.y += additionnalHeight;
		
        _btConfirm.y += additionnalHeight;
    }
    
	
    override private function _clickConfirmHandler(e : MouseEvent) : Void
    {
        _saveChoice();
        DialogManager.instance.close(DialogValue.CONFIRM);
    }
	
    private function _saveChoice():Void
    {
        if (_cbDontShowNextTime.selected)
        {
            User.instance.showChangeStatusAlert = false;
            ServiceManager.instance.updateUserDatas(User.instance);
        }
    }
	
        
    
}

