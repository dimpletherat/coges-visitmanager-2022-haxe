package com.coges.visitmanager.vo;

import nbigot.utils.Collection;




typedef ExhibitorGroupJSON = 
{	
    var id:Int;
    var label:String;
}

/**
	 * ...
	 * @author ...
	 */
class ExhibitorGroup
{
    public var id(default, null):Int;
    public var label(default, null):String;	
	
    public function new(json:ExhibitorGroupJSON)
    {
        id = json.id;
        label = (json.label == null ) ? "" : json.label;
    }
    
    
    public static var list(get, null):Collection<ExhibitorGroup>;
    private static function get_list():Collection<ExhibitorGroup>
    {
        if (list == null)
        {
            list = new Collection<ExhibitorGroup>();
        }
        return list;
    }
    
    public static function getExhibitorGroupById(id:Int):ExhibitorGroup
    {
        return list.getItemBy("id", id);
    }
    public static function getExhibitorGroupByLabel(label:String):ExhibitorGroup
    {
        return list.getItemBy("label", label, false);
    }
	
	public function toString():String{
		return '[ExhibitorGroup] $id, $label';
	}
}

