package com.coges.visitmanager.ui.vmcalendar;


/**
	 * ...
	 * @author Nicolas Bigot
	 */
class CalendarSkin
{
    public var headerHeight(default, default):Int;
    public var sideWidth(default, default):Int;
    public var mainBackgroundColor(default, default):Int;
    public var headerTextColor(default, default):Int;
    public var headerTextFontName(default, default):String;
    public var headerTextSize(default, default):Int;
    public var headerTextBold(default, default):Bool;
    public var headerBackgroundColor(default, default):Int;
    public var sideTextColor(default, default):Int;
    public var sideTextFontName(default, default):String;
    public var sideTextSize(default, default):Int;
    public var sideTextBold(default, default):Bool;
    public var sideBackgroundColor(default, default):Int;
    public var cornerBackgroundColor(default, default):Int;
    public var gridVThickness(default, default):Int;
    public var gridVColor(default, default):Int;
    public var gridVAlpha(default, default):Float;
    public var gridHThickness(default, default):Int;
    public var gridHColor(default, default):Int;
    public var gridHColorAlt(default, default):Int;
    public var gridHAlpha(default, default):Float;
    
    public function new(
            headerHeight:Int = 30,
            sideWidth:Int = 50,
            mainBackgroundColor:Int = 0xDDDDDD,
            headerTextColor:Int = 0x000000,
            headerTextFontName:String = "Arial",
            headerTextSize:Int = 11,
            headerTextBold:Bool = true,
            headerBackgroundColor:Int = 0xEEEEEE,
            sideTextColor:Int = 0xFFFFFF,
            sideTextFontName:String = "Arial",
            sideTextSize:Int = 11,
            sideTextBold:Bool = true,
            sideBackgroundColor:Int = 0xAAAAAA,
            cornerBackgroundColor:Int = 0x666666,
            gridVThickness:Int = 2,
            gridVColor:Int = 0xFFFFFF,
            gridVAlpha:Float = 1,
            gridHThickness:Int = 1,
            gridHColor:Int = 0x000000,
            gridHColorAlt:Int = 0x000000,
            gridHAlpha:Float = 1)
    {
        this.gridHAlpha = gridHAlpha;
        this.gridHColor = gridHColor;
        this.gridHColorAlt = gridHColorAlt;
        this.gridHThickness = gridHThickness;
        this.gridVAlpha = gridVAlpha;
        this.gridVColor = gridVColor;
        this.gridVThickness = gridVThickness;
        this.cornerBackgroundColor = cornerBackgroundColor;
        this.sideBackgroundColor = sideBackgroundColor;
        this.sideTextBold = sideTextBold;
        this.sideTextSize = sideTextSize;
        this.sideTextFontName = sideTextFontName;
        this.sideTextColor = sideTextColor;
        this.headerBackgroundColor = headerBackgroundColor;
        this.headerTextBold = headerTextBold;
        this.headerTextSize = headerTextSize;
        this.headerTextFontName = headerTextFontName;
        this.headerTextColor = headerTextColor;
        this.mainBackgroundColor = mainBackgroundColor;
        this.sideWidth = sideWidth;
        this.headerHeight = headerHeight;
    }
}

