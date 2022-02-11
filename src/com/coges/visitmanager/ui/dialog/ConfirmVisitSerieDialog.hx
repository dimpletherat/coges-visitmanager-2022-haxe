package com.coges.visitmanager.ui.dialog;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.core.VisitSaveHelper.VisitSerieProcess;
import com.coges.visitmanager.ui.dialog.VMConfirmDialog;
import nbigot.ui.control.BaseButton;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.DialogSkin;
import nbigot.ui.dialog.DialogValue;
import nbigot.utils.SpriteUtils;
import openfl.display.DisplayObject;
import openfl.events.MouseEvent;
import openfl.geom.Point;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ConfirmVisitSerieDialog extends VMConfirmDialog
{
    private var _btConfirmAll:BaseButton;
    
    
    public function new(title:String, message:String, ?icon:DisplayObject)
    {
        super(title, message, icon);
    }
	
    override public function init(skin:DialogSkin):Void
    {
		super.init(skin);
		
		_btConfirm.setLabel( Locale.get("BT_VALID_SERIE_SINGLE_LABEL") );
        
        _btConfirmAll = new BaseButton( Locale.get("BT_VALID_SERIE_ALL_LABEL"), _skin.confirmButtonFormat, SpriteUtils.createRoundSquare( 140, 30, 6, 6, Colors.GREEN2 ));
		_btConfirmAll.setIcon( Icons.getIcon(Icon.VALID), new Point( 50, 30) );
		_btConfirmAll.borderEnabled = false;
        _btConfirmAll.addEventListener(MouseEvent.CLICK, _clickConfirmAllHandler);
		addChild( _btConfirmAll );
    }
	
	
    override public function draw( parentSize:Point ) : Void
    {
		super.draw(parentSize);
		
		_btConfirmAll.x = _btConfirm.x;
		_btConfirmAll.y = _btConfirm.y;
		
        _btConfirm.x -= _btConfirmAll.width + _skin.contentMargin;
    }
    
	
    override private function _clickConfirmHandler(e:MouseEvent) : Void
    {
        DialogManager.instance.close(DialogValue.DATA(VisitSerieProcess.SINGLE));
    }
    private function _clickConfirmAllHandler(e:MouseEvent) : Void
    {
        DialogManager.instance.close(DialogValue.DATA(VisitSerieProcess.ALL));
    }
	
        
    
}

