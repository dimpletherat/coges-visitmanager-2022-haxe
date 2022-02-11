package com.coges.visitmanager.ui.components;


/**
	 * ...
	 * @author Nicolas Bigot
	 */
interface IScrollListItem
{

    function getIndex():Int
    ;
    function getData():Dynamic
    ;
    function setSelected(value:Bool):Void
    ;
    function getSelected():Bool
    ;
}

