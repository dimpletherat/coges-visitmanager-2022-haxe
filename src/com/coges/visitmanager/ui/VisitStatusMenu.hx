package com.coges.visitmanager.ui;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.ui.components.VMButton;
import com.coges.visitmanager.vo.VisitStatusID;
import nbigot.ui.IconPosition;
import nbigot.ui.control.ButtonState;
import nbigot.utils.SpriteUtils;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class VisitStatusMenu extends Sprite
{
/*
    public static final HEIGHT:Int = 30;
    
    private var _width:Float;
    private var _value:String;*/
    public var value(default, null):VisitStatusID;
    /*private function get_value():String
    {
        return _value;
    }*/
    
    private var _background:Sprite;
    private var _btAccept:VMButton;
    private var _btCancel:VMButton;
    
    
    
    
    public function new(/*width:Float, value:String*/)
    {
        super();
        /*_width = width;
        _value = value;*/
		
		
		
		_background = SpriteUtils.createRoundSquare( 78, 30, 4, 4, Colors.GREY2 );
		addChild( _background );
		
		_btAccept = new VMButton( "", null, SpriteUtils.createRoundSquare( 38, 30, 4, 4, Colors.GREY1 ) );
		_btAccept.setBackground( SpriteUtils.createRoundSquare( 38, 30, 4, 4, Colors.GREY2 ), ButtonState.HOVER  );
		_btAccept.borderEnabled = false;
		_btAccept.setIcon( Icons.getIcon( Icon.VISIT_STATUS_ACCEPTED), null,IconPosition.CENTER );
		_btAccept.toolTipContent = Locale.get("TOOLTIP_BT_ACCEPT_VISIT");
        _btAccept.addEventListener(MouseEvent.CLICK, _btAcceptClickHandler);
		_btAccept.x = 40;
		addChild( _btAccept );
		
		_btCancel = new VMButton( "", null, SpriteUtils.createRoundSquare( 38, 30, 4, 4, Colors.GREY1 ) );
		_btCancel.setBackground( SpriteUtils.createRoundSquare( 38, 30, 4, 4, Colors.GREY2 ), ButtonState.HOVER  );
		_btCancel.borderEnabled = false;
		_btCancel.setIcon( Icons.getIcon( Icon.VISIT_STATUS_CANCELED), null,IconPosition.CENTER );
		_btCancel.toolTipContent = Locale.get("TOOLTIP_BT_CANCEL_VISIT");
        _btCancel.addEventListener(MouseEvent.CLICK, _btCancelClickHandler);
		addChild( _btCancel );
		
		
		
		
        addEventListener(Event.ADDED_TO_STAGE, init);
    }
    
    private function init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        
		
		/*
        // new width policy
        // no need to fit with the parent VisitItem any more.
        _width = btAccept.width + btCancel.width + 4 + 20 + 4;
        
        background.width = _width;
        background.height = HEIGHT;
        background.alpha = 0;
        
        // Gradient
        //var bounds:Rectangle = getBounds( this );
        var gradient:Shape = try cast(addChild(new Shape()), Shape) catch(e:Dynamic) null;
        var m:Matrix = new Matrix();
        m.createGradientBox(_width, HEIGHT, Math.PI / 2, 0, 0);
        //m.translate( bounds.x, bounds.y );
        gradient.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF], [0.8, 1], [0, 0xFF], m);
        gradient.graphics.drawRect(0, 0, _width, HEIGHT  );
        gradient.graphics.endFill();
        
        var icoAccept:DisplayObject = VisitStatus.getVisitStatusByID(VisitStatusID.ACCEPTED).icon;
        if (icoAccept != null)
        {
            btAccept.icon = icoAccept;
        }
        var icoCancel:DisplayObject = VisitStatus.getVisitStatusByID(VisitStatusID.CANCELED).icon;
        if (icoCancel != null)
        {
            btCancel.icon = icoCancel;
        }
		*/
    }
    
    private function _btAcceptClickHandler(e:MouseEvent):Void
    {
        //_value = VisitStatusID.ACCEPTED;
        value = VisitStatusID.ACCEPTED;
        dispatchEvent(new Event(Event.CHANGE));
    }
    
    private function _btCancelClickHandler(e:MouseEvent):Void
    {
        //_value = VisitStatusID.CANCELED;
        value = VisitStatusID.CANCELED;
        dispatchEvent(new Event(Event.CHANGE));
    }
}

