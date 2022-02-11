package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.fonts.Fonts;
import nbigot.utils.Collection;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ComboListVM extends Sprite
{
    public var isOpen(get, never):Bool;
    public var datas(get, set):Collection<Dynamic>;
    public var selectedData(get, set):Dynamic;
    public var selectedIndex(get, set):Int;
    public var labelField(get, set):String;
    public var label(get, set):String;
    public var enabled(get, set):Bool;

    private var _isOpen:Bool = false;
    private function get_isOpen():Bool
    {
        return _isOpen;
    }
    
    private var _datas:Collection<Dynamic>;
    private function get_datas():Collection<Dynamic>
    {
        return _datas;
    }
    private function set_datas(value:Collection<Dynamic>):Collection<Dynamic>
    {
        _datas = value;
        return value;
    }
    private var _list:ScrollList;
    
    
    
    private var _selectedData:Dynamic;
    private function get_selectedData():Dynamic
    {
        return _selectedData;
    }
    private function set_selectedData(value:Dynamic):Dynamic
    {
        if (_datas == null)
        {
            return value;
        }
        
        _selectedData = value;
        _selectedIndex = _datas.indexOf(value);
        label = Reflect.field(_selectedData, Std.string(_labelField));
        
        if (_list != null)
        {
            _list.selectedData = value;
        }
        return value;
    }
    
    private var _selectedIndex:Int;
    private function get_selectedIndex():Int
    {
        return _selectedIndex;
    }
    private function set_selectedIndex(value:Int):Int
    {
        if (_datas == null)
        {
            return value;
        }
        
        _selectedIndex = value;
        _selectedData = _datas.getItemAt(value);
        label = Reflect.field(_selectedData, Std.string(_labelField));
        
        if (_list != null)
        {
            _list.selectedIndex = value;
        }
        return value;
    }
    
    private var _labelField:String;
    private function get_labelField():String
    {
        return _labelField;
    }
    private function set_labelField(value:String):String
    {
        _labelField = value;
        return value;
    }
    
    private var _label:String;
    private var _scrollListItemClass:Class<Dynamic>;
    private function get_label():String
    {
        return _label;
    }
    private function set_label(value:String):String
    {
        _label = value;
        btCombo.label = value;
        return value;
    }
    
    private var _enabled:Bool;
    private function get_enabled():Bool
    {
        return _enabled;
    }
    private function set_enabled(value:Bool):Bool
    {
        _enabled = value;
        mouseChildren = _enabled;
        mouseEnabled = _enabled;
        alpha = ((_enabled)) ? 1:0.6;
        return value;
    }
    
    
    
    
    
    public var btCombo:VMButton;
    
    public function new(datas:Collection<Dynamic> = null, labelField:String = "label", scrollListItemClass:Class<Dynamic> = null)
    {
        super();
        _scrollListItemClass = ScrollListItem;
        if (scrollListItemClass != null)
        {
            var testObj:Dynamic = Type.createInstance(scrollListItemClass, []);
            if (Std.isOfType(testObj, IScrollListItem))
            {
                _scrollListItemClass = scrollListItemClass;
            }
        }
        
        _labelField = labelField;
        _datas = datas;
        btCombo.addEventListener(MouseEvent.CLICK, clickButtonHandler);
        btCombo.textFont = Fonts.OPEN_SANS;
        btCombo.textColor = 0x000000;
        btCombo.textSize = 12;
        btCombo.textBold = false;
        addEventListener(Event.ADDED_TO_STAGE, init);
    }
    
    private function init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);
    }
    
    private function clickButtonHandler(e:MouseEvent):Void
    {
        if (_datas == null)
        {
            return;
        }
        if (_list == null)
        {
            open();
        }
        else
        {
            close();
        }
    }
    
    public function open():Void
    {
        _list = try cast(stage.addChild(new ScrollList(_datas, Std.int(width), 180, _labelField, _scrollListItemClass)), ScrollList) catch(e:Dynamic) null;
        
        var rect:Rectangle = btCombo.getBounds(stage);
        var p:Point = new Point(rect.x, rect.y + rect.height);
        if (p.y < 0)
        {
            p.y = 0;
        }
        if (p.y + _list.height > stage.stageHeight)
        {
            p.y = rect.y - _list.height;
        }
        if (p.x < 0)
        {
            p.x = 0;
        }
        
        _list.x = p.x;
        _list.y = p.y;
        _list.addEventListener(Event.SELECT, selectItemHandler);
        if (_selectedData != null)
        {
            _list.selectedData = _selectedData;
            label = Reflect.field(_selectedData, _labelField);
        }
        _isOpen = true;
        stage.addEventListener(MouseEvent.MOUSE_UP, clickStageHandler);
    }
    
    public function close():Void
    {
        stage.removeEventListener(MouseEvent.MOUSE_UP, clickStageHandler);
        _list.removeEventListener(Event.SELECT, selectItemHandler);
        stage.removeChild(_list);
        _list = null;
        _isOpen = false;
    }
    private function clickStageHandler(e:MouseEvent):Void
    {
        var isOutList:Bool = !_list.hitTestPoint(stage.mouseX, stage.mouseY, true) && !btCombo.hitTestPoint(stage.mouseX, stage.mouseY, true);
        if (isOutList)
        {
            close();
        }
    }
    
    private function selectItemHandler(e:Event):Void
    {
        e.stopImmediatePropagation();
        _selectedData = _list.selectedData;
        _selectedIndex = _list.selectedIndex;
        label = Reflect.field(_selectedData, _labelField);
        close();
        dispatchEvent(new Event(Event.SELECT));
    }
}

