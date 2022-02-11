package com.coges.visitmanager.ui;

import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.fonts.FontName;
import com.coges.visitmanager.core.Locale;
import motion.Actuate;
import motion.easing.Linear;
import openfl.display.Bitmap;
import openfl.display.MovieClip;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class WaitItem extends MovieClip
{
    private var _desiredWidth:Float;
    private var _desiredHeight:Float;
    private var _message:String;
    public var txtMessage:TextField;
    public var background:Sprite;
    public var waitIcon:MovieClip;
	private var _waitIcon:Sprite;
    
    public function new(width:Float = 200, height:Float = 500, message:String = "Veuillez patienter...")
    {
		trace( "WaitItem.new > width : " + width + ", height : " + height + ", message : " + message );
        super();
        _desiredWidth = width;
        _desiredHeight = height;
        _message = message;
        //background.addEventListener(MouseEvent.CLICK, _clickHandler);
        addEventListener(Event.ADDED_TO_STAGE, _init);
    }
    
    private function _clickHandler(e:MouseEvent):Void
    {
        e.stopImmediatePropagation();
    }
    
    private function _init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, _init);
		
		_waitIcon = new Sprite();
		
		var bd = cast(Icons.getIcon(Icon.WAIT_WHEEL), Bitmap) ;
		bd.x = - bd.width * 0.5;
		bd.y = - bd.height * 0.5;
		addChild( _waitIcon );
		_waitIcon.addChild( bd);
		
		
		Actuate.tween( _waitIcon, 1, {rotation:357} ).ease(Linear.easeNone).repeat();
		
        /*
        background.width = _desiredWidth;
        background.height = _desiredHeight;
        
        waitIcon.x = _desiredWidth * 0.5;
        waitIcon.y = _desiredHeight * 0.4;
        
        txtMessage.embedFonts = true;
        txtMessage.antiAliasType = AntiAliasType.ADVANCED;
        txtMessage.defaultTextFormat = new TextFormat(FontName.ARIAL_B_I_BI, 11, 0xFFFFFF, true);
        txtMessage.text = _message;
        txtMessage.width = _desiredWidth;
        txtMessage.x = 0;
        txtMessage.y = waitIcon.y - waitIcon.height * 0.5 - txtMessage.height - 10;*/
    }
}

