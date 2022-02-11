package com.coges.visitmanager.ui;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.events.VisitSaveEvent;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.core.Utils;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.ui.components.VMButton;
import com.coges.visitmanager.ui.dialog.VMConfirmDialog;
import com.coges.visitmanager.vo.Country;
import com.coges.visitmanager.vo.Planning;
import com.coges.visitmanager.vo.User;
import com.coges.visitmanager.vo.Visit;
import com.coges.visitmanager.vo.VisitStatus;
import com.coges.visitmanager.vo.VisitStatusID;
import nbigot.ui.IconPosition;
import nbigot.ui.dialog.DialogEvent;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.DialogValue;
import com.coges.visitmanager.core.Locale;
import nbigot.utils.ColorUtils;
import nbigot.utils.SpriteUtils;
import nbigot.utils.TextFieldUtils;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class VisitItem extends Sprite
{
    public var data(default, null):Visit;
    public var flaggedForRemove(default, null):Bool;

    private var _btRemove:VMButton;
    //private var _background:Sprite;
    private var _display:VisitDisplay;
	
    private var _width:Float;
    private var _height:Float;
    private var _pendingListMode:Bool;
    
    public function new(data:Visit, width:Float, height:Float, pendingListMode:Bool = false)
    {
        super();
        this.data = data;
        _pendingListMode = pendingListMode;
        _height = height;
        _width = width;
		
		_display = new VisitDisplay( this.data, _width, _height, 20 );
		addChild(_display);
		
		var btBG = SpriteUtils.createRoundSquare( 18, 18, 4, 4 );
		btBG.alpha = 0;
		_btRemove = new VMButton( "", null, btBG );
		_btRemove.borderEnabled = false;
		_btRemove.setIcon( Icons.getIcon( Icon.VISIT_DELETE ), null, IconPosition.CENTER );
		//TODO: see how all these clicks behave
		//_btRemove.addEventListener
		addChild( _btRemove );
		
        
        buttonMode = true;
        
        _draw();
        
        if (_pendingListMode)
        {
			addEventListener(MouseEvent.MOUSE_DOWN, _mouseDownHandler);
        }else{
            addEventListener(MouseEvent.ROLL_OVER, _rolloverHandler);
            addEventListener(MouseEvent.ROLL_OUT, _rolloutHandler);			
		}
		
        addEventListener(MouseEvent.CLICK, _clickHandler);		
        addEventListener(Event.ADDED_TO_STAGE, init);
    }
    
    private function init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);
		
    }
	
	private function _draw()
	{		
		_btRemove.x = _width - _btRemove.width;
		
		_display.setSize( _width, _height );
	}
    
    
    private function _rolloverHandler(e:MouseEvent):Void
    {
        var border:Shape = new Shape();
        border.name = "border";
        border.graphics.lineStyle(2, Colors.BLACK, 1, true);
        border.graphics.drawRoundRect(0, 0, _width, _height, 4, 4);
        addChild(border);
    }
    
    private function _rolloutHandler(e:MouseEvent):Void
    {
        removeChild(getChildByName("border"));
    }
    
	//only if _pendingListMode is true
    private function _mouseDownHandler(e:MouseEvent):Void
    {
		flaggedForRemove = (e.target == _btRemove );
    }
    
    
    private function _clickHandler(e:MouseEvent):Void
    {
		if ( !_pendingListMode )
		{
			//trace( "VisitItem._clickHandler > target : " + e.target );
			//trace( "VisitItem._clickHandler > currentTarget : " + e.currentTarget );
			//TODO:check target or currentTarget
			if (e.target == _btRemove)
			{
				askForRemoveVisit();
				return;
			}
			else
			{
				dispatchEvent(new Event(Event.SELECT));
			}
		}
    }
    
    public function askForRemoveVisit():Void
    {
        if (data.isLocked || Planning.selected.isLocked || !User.instance.isAuthorized)
        {
            return;
        }
        
        var message:String;
        if (data.isSpecialVisit)
        {
            message = Locale.get("CONFIRM_REMOVE_VISIT");
        }
        else if (data.idStatus == VisitStatusID.CANCELED)
        {
            message = Locale.get("CONFIRM_REMOVE_VISIT_CANCELED");
        }
        else
        {
            message = Locale.get("CONFIRM_REMOVE_VISIT_PENDING");
        }
        
        //PopupManager.instance.addEventListener(DialogEvent.CLOSE, closePopupHandler);
        //PopupManager.instance.openPopup(PopupType.CONFIRM, "", message, null, null, true);
        DialogManager.instance.addEventListener(DialogEvent.CLOSE, closePopupHandler);
        DialogManager.instance.open( new VMConfirmDialog( "Confirm Dialog title", message ) );
    }
    
    private function closePopupHandler(e:DialogEvent):Void
    {
        //PopupManager.instance.removeEventListener(DialogEvent.CLOSE, closePopupHandler);
        DialogManager.instance.removeEventListener(DialogEvent.CLOSE, closePopupHandler);
        if (e.value == DialogValue.CONFIRM)
        {
            dispatchEvent(new VisitSaveEvent(VisitSaveEvent.REMOVE));
        }
    }
	/*
    private function _drawLabel():TextField
    {
        var t:TextField = new TextField();
        var tf:TextFormat = new TextFormat();
        tf.font = Fonts.OPEN_SANS;
        tf.bold = true;
        tf.color = Colors.BLACK;
        //tf.color = 0xFF0000;
        tf.size = 9;
        t.selectable = false;
        t.mouseEnabled = false;
        t.embedFonts = true;
        //t.wordWrap = true;
        //t.multiline = true;
        t.antiAliasType = AntiAliasType.ADVANCED;
        //t.autoSize = TextFieldAutoSize.LEFT;
        t.defaultTextFormat = tf;
        
        //t.borderColor = 0xff0000;
        //t.border = true;
        addChild(t);
        return t;
    }*/
    
    
    override private function get_height():Float
    {
        return _height;
    }
	
	
	
	
	public function setRect( rect:Rectangle ):Void
	{		
		if ( rect.x != x || rect.y != y )
		{
			x = rect.x;
			y = rect.y;
		}
		
		if ( rect.width != _width || rect.height != _height )
		{
			_width = rect.width;
			_height = rect.height;
			
			_draw();
		}
	}
}

