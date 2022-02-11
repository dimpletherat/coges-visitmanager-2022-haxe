package com.coges.visitmanager.vo;

import com.coges.visitmanager.vo.Visit;


import nbigot.utils.Collection;

/**
	 * ...
	 * @author ...
	 */
class PendingVisit
{
    public var name(default, null):String;
    public var relatedVisit(default, null):Visit;
    
    public function new( json:VisitJSON)
    {
        relatedVisit = new Visit(json);
        name = relatedVisit.name;
    }
    
    public static var list(get, null):Collection<PendingVisit>;
    private static function get_list():Collection<PendingVisit>
    {
        if (list == null)
        {
            list = new Collection<PendingVisit>();
        }
        return list;
    }
    
    
    public static var selected(default, default):PendingVisit;
}

