package com.coges.visitmanager.vo;

import format.SVG;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import nbigot.utils.Collection;
import openfl.Assets;
import openfl.display.DisplayObject;
import openfl.display.Shape;

using com.coges.visitmanager.core.SVGExtender;

typedef CountryJSON = 
{	
    var id:Int;
    var label:String;
    var ISOCode:String;
}



/**
	 * ...
	 * @author Nicolas Bigot
	 */
class Country
{
    public var id(get, never):Int;
    public var label(get, never):String;
    public var ISOCode(get, never):String;
    public var flag16(get, never):DisplayObject;
    public var flag24(get, never):DisplayObject;
    public var flag32(get, never):DisplayObject;
    public static var list(get, never):Collection<Country>;

    private var _id:Int;
    private function get_id():Int
    {
        return _id;
    }
    
    private var _label:String;
    private function get_label():String
    {
        return ((_label != null)) ? _label:"";
    }
    
    private var _ISOCode:String;
    private function get_ISOCode():String
    {
        return _ISOCode;
    }
    
    private function get_flag16():DisplayObject
    {
        return _getFlagIcon(16);
    }
    private function get_flag24():DisplayObject
    {
        return _getFlagIcon(24);
    }
    private function get_flag32():DisplayObject
    {
        return _getFlagIcon(32);
    }
    
    public function new(json:CountryJSON)
    {
        _id = json.id;
        _ISOCode = json.ISOCode;
        _label = json.label;
    }
    
    
    private function _getFlagIcon(size:Int):DisplayObject
    {
		var svg:SVG;
		var flagPath:String = "assets/flags/" + _ISOCode + ".svg";
		if ( Assets.exists(flagPath, AssetType.TEXT) )
		{
			// SVG
			svg = new SVG(Assets.getText(flagPath));
			return svg.renderAsShape( null, size );
		}
		
		// fallback PNG
		flagPath = "assets/flags/" + _ISOCode + "-" + Std.string(size) + ".png";
		if ( Assets.exists(flagPath, AssetType.IMAGE) )
		{
			var bd:BitmapData = Assets.getBitmapData(flagPath);
			return new Bitmap(bd);
		}
		
		// finally NOFLAG	
		flagPath = "assets/flags/_noflag-" + Std.string(size) + ".png";
		var bd:BitmapData = Assets.getBitmapData(flagPath);
		return new Bitmap(bd);
		/*
		var flagPath:String = "assets/flags/_noflag.svg";
		svg = new SVG(Assets.getText(flagPath));
		return svg.renderAsShape( null, size );
		*/
    }
    
    private static var _list:Collection<Country>;
    private static function get_list():Collection<Country>
    {
        if (_list == null)
        {
            _list = new Collection<Country>();
        }
        return _list;
    }
    
    public static function getCountryById(id:Int):Country
    {
        if (_list == null)
        {
            return null;
        }
        return _list.getItemBy("id", id);
    }
	/*
    public static function getCountryByLabel(label:String):Country
    {
        if (_list == null)
        {
            return null;
        }
        return _list.getItemBy("label", label, false);
    }
	*/
	public function toString():String
	{
		return '[Country] $_ISOCode, $_label';
	}
}

