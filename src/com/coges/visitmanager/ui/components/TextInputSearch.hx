package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.fonts.Fonts;
import nbigot.ui.control.BaseButton;
import nbigot.ui.control.RoundRectSprite;
import nbigot.ui.control.TextInput;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.TextEvent;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class TextInputSearch extends TextInput
{
    private var _btErase:BaseButton;
    
    public function new()
    {
		super( 100, 30, new TextFormat( Fonts.OPEN_SANS, 14, Colors.BLACK,  null, false ), Locale.get("LBL_SEARCH_TEXT_INPUT"), TextInputBackground.CUSTOM( new RoundRectSprite( 20, 20, 6, 6, Colors.WHITE, 1, Colors.GREY1), 5 ) );
		placeholderFormat = new TextFormat( Fonts.OPEN_SANS, 14, Colors.GREY4, null, true );		
		
		
		//BUG : Event.CHANGE is not fired with Dom renderer
		//FIX : while waiting for an update, we add TextEvent.TEXT_INPUT as a fallback
        _txtInput.addEventListener(Event.CHANGE, _textChangeHandler);
        _txtInput.addEventListener(TextEvent.TEXT_INPUT, _textChangeHandler);
		
		_btErase = new BaseButton(null, null, Icons.getIcon( Icon.CLEAR_TEXTINPUT ) );
		_btErase.borderEnabled = false;
        _btErase.visible = false;
        _btErase.addEventListener(MouseEvent.CLICK, _clickEraseHandler);
		addChild(_btErase );
    }
    
    override private function _init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, _init);
    }
	
	override private function _draw()
	{
		super._draw();
		
		// prevent error on the first first super constructor's call, when _btErase is not instanciated yet
		if ( _btErase != null )
		{
			_btErase.x = _width -  _btErase.width - 5;
			_btErase.y = ( _height  - _btErase.height ) * 0.5;
			_txtInput.width -= _btErase.width + 5;
		}
	}
    
    private function _textChangeHandler(e:Event = null):Void
    {
		_btErase.visible = (_txtInput.length > 0 && _txtInput.text != _placeholder);
    }
    
    private function _clickEraseHandler(e:MouseEvent):Void
    {
        _txtInput.text = "";
        _txtInputFocusOUTHandler();
        _textChangeHandler();
    }
    
}

