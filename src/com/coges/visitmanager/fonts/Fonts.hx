package com.coges.visitmanager.fonts;
import openfl.Assets;


/**
	 * ...
	 * @author Nicolas Bigot
	 */
class Fonts
{
    public static var OPEN_SANS(default, null):String;
    public static var OPEN_SANS_I(default, null):String;
    public static var OPEN_SANS_B(default, null):String;
    public static var OPEN_SANS_BI(default, null):String;
	/*
    public static var CAMBRIA(default, null):String;
    public static var CAMBRIA_I(default, null):String;
    public static var CAMBRIA_B(default, null):String;
    public static var CAMBRIA_BI(default, null):String;*/
	
	public static function initialize():Void 
	{
        OPEN_SANS = Assets.getFont("assets/fonts/OpenSans-Regular.ttf").fontName;
        OPEN_SANS_I = Assets.getFont("assets/fonts/OpenSans-Italic.ttf").fontName;
        OPEN_SANS_B = Assets.getFont("assets/fonts/OpenSans-Bold.ttf").fontName;
        OPEN_SANS_BI = Assets.getFont("assets/fonts/OpenSans-BoldItalic.ttf").fontName;
		/*
        CAMBRIA = Assets.getFont("assets/fonts/cambria.ttf").fontName;
        CAMBRIA_I = Assets.getFont("assets/fonts/cambriai.ttf").fontName;
        CAMBRIA_B = Assets.getFont("assets/fonts/cambriab.ttf").fontName;
        CAMBRIA_BI = Assets.getFont("assets/fonts/cambriaz.ttf").fontName;
		*/
		/*
    #if js
        ACUMIN = Assets.getFont("fonts/Acumin-RPro.otf").fontName;
        ACUMIN_I = Assets.getFont("fonts/Acumin-ItPro.otf").fontName;
        ACUMIN_B = Assets.getFont("fonts/Acumin-BdPro.otf").fontName;
        ACUMIN_BI = Assets.getFont("fonts/Acumin-BdItPro.otf").fontName;
        CAMBRIA = Assets.getFont("fonts/cambria.ttf").fontName;
        CAMBRIA_I = Assets.getFont("fonts/cambriai.ttf").fontName;
        CAMBRIA_B = Assets.getFont("fonts/cambriab.ttf").fontName;
        CAMBRIA_BI = Assets.getFont("fonts/cambriaz.ttf").fontName;
    #else
        Font.registerFont(Acumin);
        Font.registerFont(AcuminItalic);
        Font.registerFont(AcuminBold);
        Font.registerFont(AcuminBoldItalic);
        Font.registerFont(Cambria);
        Font.registerFont(CambriaItalic);
        Font.registerFont(CambriaBold);
        Font.registerFont(CambriaBoldItalic);
        ACUMIN = (new Acumin()).fontName;
        ACUMIN_I = (new AcuminItalic()).fontName;
        ACUMIN_B = (new AcuminBold()).fontName;
        ACUMIN_BI = (new AcuminItalic()).fontName;
        CAMBRIA = (new Cambria()).fontName;
        CAMBRIA_I = (new CambriaItalic()).fontName;
        CAMBRIA_B = (new CambriaBold()).fontName;
        CAMBRIA_BI = (new CambriaBoldItalic()).fontName;
    #end*/
    }

    private function new()
    {
    }
	
}

