package com.coges.visitmanager.core;

import nbigot.utils.StringUtils;
import openfl.text.TextField;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class Utils
{
    
    public static function getDateFromDBString(source:String):Date
    {
        if (source == null || source.length == 0)
        {
            return null;
        }
        var arr:Array<Dynamic> = source.split(" ");
        var date:Array<Dynamic> = arr[0].split("-");
        var time:Array<Dynamic> = arr[1].split(":");
        return new Date(date[0], Std.parseInt(date[1]) - 1, date[2], time[0], time[1], time[2]);
    }
    
    public static function getDBStringFromDate(source:Date, initSeconds:Bool = false):String
    {
        if (source == null)
        {
            return null;
        }
        
        var day:Float = source.getDate();
        var dayStr:String = ((day < 10)) ? "0" + Std.string(day):Std.string(day);
        var month:Float = source.getMonth() + 1;
        var monthStr:String = ((month < 10)) ? "0" + Std.string(month):Std.string(month);
        var yearStr:String = Std.string(source.getFullYear());
        
        var h:Float = source.getHours();
        var hStr:String = ((h < 10)) ? "0" + Std.string(h):Std.string(h);
        var m:Float = source.getMinutes();
        var mStr:String = ((m < 10)) ? "0" + Std.string(m):Std.string(m);
        var s:Float = source.getSeconds();
        var sStr:String = ((s < 10)) ? "0" + Std.string(s):Std.string(s);
        if (initSeconds)
        {
            sStr = "00";
        }
        
        return yearStr + "-" + monthStr + "-" + dayStr + " " + hStr + ":" + mStr + ":" + sStr;
    }
    
    public static function getAdaptedLabel(textField:TextField, label:String, isAdapted:Bool = false, cuttedTextTag:String = "..."):String
    {
        textField.text = label;
        if (textField.textWidth + 1 > textField.width)
        {
            return getAdaptedLabel(textField, label.substr(0, label.length - 2), true);
        }
        return ((isAdapted)) ? label.substr(0, label.length - cuttedTextTag.length) + cuttedTextTag:label;
    }
    
    public static function concatString(source:String, args:Array<Dynamic> = null):String
    {
        var i:Int = -1;
        while (++i < args.length)
        {
            source = StringTools.replace(source, "{" + i + "}", args[i]);
			
        }
        return source;
    }

    public function new()
    {
    }
}

