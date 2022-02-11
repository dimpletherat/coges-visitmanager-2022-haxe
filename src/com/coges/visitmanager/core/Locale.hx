package com.coges.visitmanager.core;
import haxe.ds.Map;

/**
 * ...
 * @author Nicolas Bigot
 */


class Locale 
{
	public static final EN:String = "en";
	public static final ES:String = "es";
	public static final FR:String = "fr";
	
	
	
	
	static private var _currentLanguage:String;
	static private var _content:Map<String,Map<String,String>>;

	static public function initialize( content:Xml, ?setLanguage:String):Void
	{
		if ( setLanguage != null )
			_currentLanguage = setLanguage;
			
		var value:String;
		var nodeName:String;			
		_content = new Map<String, Map<String,String>>();
		for ( item in content.firstElement().elements() )
		{
			for (trans in item.elements() )
			{
				nodeName = trans.nodeName;
				
				if ( !_content.exists(nodeName) )
					_content.set( nodeName, new Map<String,String>() );
				value = trans.firstChild().nodeValue;
				value = StringTools.replace( value, "<br>", "\n" );
				_content[nodeName].set( item.get("id"), value );
			}
		}
	}	
	

	static public function setLanguage( language:String):Void
	{
		_currentLanguage = language;
	}
	
	
	/**
	 * Retrieve the translation of the given id in the given language (or the global language if the param is omitted)
 	 * @param	id
	 * @param	language
	 * @return	the wanted translation or an empty string if an error occurs
	 */
	static public function get( id:String, ?language:String):String
	{
		if ( _content == null ) return "";
		if ( language == null )
		{
			if (_currentLanguage == null) return "";
			language = _currentLanguage;
		}
		return _content[language][id];
	}
}