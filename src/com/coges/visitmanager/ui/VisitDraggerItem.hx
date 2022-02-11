package com.coges.visitmanager.ui;

import com.coges.visitmanager.core.IDraggerItem;
import com.coges.visitmanager.ui.VisitDisplay;
import com.coges.visitmanager.vo.Visit;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;

/**
	 * ...
	 * @author Nicolas Bigot
	 */

class VisitDraggerItem extends Sprite implements IDraggerItem
{
    public var data(default, null):Visit;
    public var originalItem(default, null):VisitItem;
    
    private var _width:Float;
    private var _height:Float;
	
	private var tmp:Bitmap;
    
    public function new(originalItem:VisitItem, width:Float, height:Float)
    {
        super();
        this.originalItem = originalItem;
        this.data = originalItem.data;
        _height = height;
        _width = width;
		
        addChild( new VisitDisplay( data, _width, _height ) );
		
        addEventListener(Event.ADDED_TO_STAGE, _init);
    }
    
    private function _init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, _init);
        
        //filters = [new DropShadowFilter(2, 90, 0, 0.4, 4, 4, 1, 2)];
    }
}

