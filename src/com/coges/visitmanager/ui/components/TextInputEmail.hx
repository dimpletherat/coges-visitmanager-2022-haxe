package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.fonts.Fonts;
import nbigot.ui.control.RoundRectSprite;
import nbigot.ui.control.TextInput;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class TextInputEmail extends TextInput
{
    public function new()
    {
		super( 100, 30, new TextFormat( Fonts.OPEN_SANS, 14, Colors.BLACK,  null, false ), Locale.get("LBL_EMAIL_TEXT_INPUT"), TextInputBackground.CUSTOM( new RoundRectSprite( 20, 20, 6, 6, Colors.WHITE, 1, Colors.GREY4), 5 ) );
		placeholderFormat = new TextFormat( Fonts.OPEN_SANS, 14, Colors.GREY3, null, true );
    }
}

