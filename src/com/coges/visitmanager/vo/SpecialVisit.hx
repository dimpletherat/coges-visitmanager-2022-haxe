package com.coges.visitmanager.vo;

import nbigot.utils.Collection;

/**
	 * ...
	 * @author Nicolas Bigot
	 */

	 
typedef SpecialVisitJSON = {
    var id:Int;
    var label:String;	
}
	 
	 
class SpecialVisit
{
    public var id(default, null):Int;
    public var label(default, null):String;

    
    public function new(json:SpecialVisitJSON)
    {
        id = json.id;
        label = json.label;
    }
    
    
    public static var list(get, null):Collection<SpecialVisit>;
    private static function get_list():Collection<SpecialVisit>
    {
        if (list == null)
        {
            list = new Collection<SpecialVisit>();
        }
        return list;
    }
}

