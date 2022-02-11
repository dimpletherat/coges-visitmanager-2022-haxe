package com.coges.visitmanager.ui.components;

import openfl.display.Sprite;
import openfl.events.Event;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ButtonBackground extends Sprite
{
    //public var ghost:Sprite;
    public var center:Sprite;
    public var left:Sprite;
    public var right:Sprite;
    
    public function new()
    {
        super();
        addEventListener(Event.ADDED_TO_STAGE, init);
    }
    
    private function init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        //ghost.visible = false;
        var w:Float =   /*ghost.*/  width;
        scaleX = 1;
        scaleY = 1;
        center.x = left.width;
        center.width = w - left.width - right.width;
        right.x = w - right.width;
    }
}

