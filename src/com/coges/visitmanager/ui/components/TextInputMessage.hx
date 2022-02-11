package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.fonts.Fonts;
import nbigot.ui.control.TextInput;
import openfl.display.Sprite;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class TextInputMessage extends TextInput
{
    public var backgroundExt:Sprite;
    public var backgroundInt:Sprite;
    
    public function new()
    {
		super( 100, 20, new TextFormat( Fonts.OPEN_SANS, 12, Colors.BLACK,  null, false ), Locale.get("LBL_MESSAGE_TEXT_INPUT"), TextInputBackground.NONE );
		placeholderFormat = new TextFormat( Fonts.OPEN_SANS, 12, Colors.GREY3, null, true );
		
    }
}

